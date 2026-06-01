package com.ruoyi.web.service.image;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Base64;
import org.springframework.stereotype.Component;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONException;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.file.FileUtils;

/**
 * Grsai 异步生图接口 Provider
 */
@Component
public class AiImageGrsaiProvider implements AiImageProvider
{
    private static final Duration CREATE_TIMEOUT = Duration.ofSeconds(45);

    private static final Duration QUERY_TIMEOUT = Duration.ofSeconds(30);

    private static final Duration POLL_TIMEOUT = Duration.ofMinutes(5);

    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(20))
            .build();

    @Override
    public String getAdapterType()
    {
        return AiImageConfigService.ADAPTER_GRSAI_ASYNC;
    }

    @Override
    public String generateAndSave(AiImageGenerateRequest request, AiImageProviderConfig providerConfig)
    {
        try
        {
            JSONObject createdTask = createTask(request, providerConfig);
            return waitForResult(createdTask, providerConfig);
        }
        catch (ServiceException e)
        {
            throw e;
        }
        catch (Exception e)
        {
            throw new ServiceException("图片生成失败：" + e.getMessage());
        }
    }

    private JSONObject createTask(AiImageGenerateRequest request, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        String model = StringUtils.defaultIfBlank(request.getProviderModel(),
                StringUtils.defaultIfBlank(request.getModel(), providerConfig.getModel()));
        JSONObject payload = new JSONObject();
        payload.put("model", model);
        payload.put("prompt", request.getPrompt());
        payload.put("images", request.getImageUrls() == null ? new JSONArray() : request.getImageUrls());
        if (usesPixelAspectRatio(model))
        {
            payload.put("aspectRatio", StringUtils.defaultIfBlank(request.getSize(), "1024x1024"));
        }
        else
        {
            payload.put("aspectRatio", StringUtils.defaultIfBlank(request.getRatio(), "1:1"));
            payload.put("imageSize", normalizeImageSize(request.getResolution()));
        }
        payload.put("replyType", "async");
        payload.put("n", normalizeImageCount(request.getImageCount()));

        HttpRequest httpRequest = HttpRequest.newBuilder()
                .uri(URI.create(resolveEndpoint(providerConfig.getBaseUrl(), "/v1/api/generate")))
                .version(HttpClient.Version.HTTP_1_1)
                .timeout(CREATE_TIMEOUT)
                .header("Authorization", "Bearer " + providerConfig.getApiKey())
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(payload.toJSONString()))
                .build();

        HttpResponse<String> response = httpClient.send(httpRequest, HttpResponse.BodyHandlers.ofString());
        JSONObject body = parseResponseBody(response.body());
        if (response.statusCode() < 200 || response.statusCode() >= 300)
        {
            throw new ServiceException("图片生成失败：" + resolveError(body, response.body()));
        }
        ensureNoTerminalFailure(body);
        if (StringUtils.isBlank(body.getString("id")))
        {
            throw new ServiceException("图片生成失败：中转站未返回任务id");
        }
        return body;
    }

    private String waitForResult(JSONObject createdTask, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        String status = createdTask.getString("status");
        if (isSuccessStatus(status))
        {
            return saveCompletedResult(createdTask, providerConfig);
        }
        if (isFailureStatus(status))
        {
            throw new ServiceException("图片生成失败：" + resolveError(createdTask, status));
        }

        String taskId = createdTask.getString("id");
        long deadline = System.currentTimeMillis() + POLL_TIMEOUT.toMillis();
        int transientFailureCount = 0;
        while (System.currentTimeMillis() < deadline)
        {
            Thread.sleep(Duration.ofSeconds(3).toMillis());
            JSONObject body;
            try
            {
                body = queryTask(taskId, providerConfig);
                transientFailureCount = 0;
            }
            catch (Exception e)
            {
                if (isTransientError(e) && transientFailureCount < 5)
                {
                    transientFailureCount++;
                    continue;
                }
                throw e;
            }

            String currentStatus = body.getString("status");
            if (isSuccessStatus(currentStatus))
            {
                return saveCompletedResult(body, providerConfig);
            }
            if (isFailureStatus(currentStatus))
            {
                throw new ServiceException("图片生成失败：" + resolveError(body, currentStatus));
            }
        }
        throw new ServiceException("生成超时，请稍后重试");
    }

    private JSONObject queryTask(String taskId, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        String endpoint = resolveEndpoint(providerConfig.getBaseUrl(), "/v1/api/result")
                + "?id=" + URLEncoder.encode(taskId, StandardCharsets.UTF_8);
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(endpoint))
                .version(HttpClient.Version.HTTP_1_1)
                .timeout(QUERY_TIMEOUT)
                .header("Authorization", "Bearer " + providerConfig.getApiKey())
                .GET()
                .build();
        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        JSONObject body = parseResponseBody(response.body());
        if (response.statusCode() < 200 || response.statusCode() >= 300)
        {
            throw new ServiceException("图片任务查询失败：" + resolveError(body, response.body()));
        }
        ensureNoTerminalFailure(body);
        return body;
    }

    private String saveCompletedResult(JSONObject body, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        JSONArray results = resolveResultArray(body);
        if (results == null || results.isEmpty())
        {
            throw new ServiceException("图片生成失败：完成结果缺少图片数据");
        }

        StringBuilder urls = new StringBuilder();
        for (int i = 0; i < results.size(); i++)
        {
            String url = resolveResultUrl(results.get(i));
            if (StringUtils.isBlank(url))
            {
                continue;
            }
            String savedUrl = saveImageFromUrl(url, providerConfig);
            if (StringUtils.isBlank(savedUrl))
            {
                continue;
            }
            if (urls.length() > 0)
            {
                urls.append(',');
            }
            urls.append(savedUrl);
        }
        if (urls.length() == 0)
        {
            throw new ServiceException("图片生成失败：返回结果缺少图片数据");
        }
        return urls.toString();
    }

    private JSONArray resolveResultArray(JSONObject body)
    {
        if (body == null)
        {
            return null;
        }
        JSONArray results = body.getJSONArray("results");
        if (results != null)
        {
            return results;
        }
        results = body.getJSONArray("data");
        if (results != null)
        {
            return results;
        }
        results = body.getJSONArray("images");
        if (results != null)
        {
            return results;
        }
        String url = resolveResultUrl(body);
        if (StringUtils.isBlank(url))
        {
            return null;
        }
        JSONArray wrapped = new JSONArray();
        wrapped.add(body);
        return wrapped;
    }

    private String resolveResultUrl(Object result)
    {
        if (result == null)
        {
            return "";
        }
        if (result instanceof String)
        {
            return (String) result;
        }
        if (!(result instanceof JSONObject))
        {
            return "";
        }
        JSONObject json = (JSONObject) result;
        String url = json.getString("url");
        if (StringUtils.isNotBlank(url))
        {
            return url;
        }
        url = json.getString("imageUrl");
        if (StringUtils.isNotBlank(url))
        {
            return url;
        }
        url = json.getString("image_url");
        if (StringUtils.isNotBlank(url))
        {
            return url;
        }
        url = json.getString("resultImageUrl");
        if (StringUtils.isNotBlank(url))
        {
            return url;
        }
        url = json.getString("output");
        if (StringUtils.isNotBlank(url))
        {
            return url;
        }
        url = json.getString("b64_json");
        if (StringUtils.isNotBlank(url))
        {
            return "data:image/png;base64," + url;
        }
        return "";
    }

    private void ensureNoTerminalFailure(JSONObject body)
    {
        String status = body == null ? "" : body.getString("status");
        if (isFailureStatus(status))
        {
            throw new ServiceException("图片生成失败：" + resolveError(body, status));
        }
    }

    private boolean isSuccessStatus(String status)
    {
        String normalized = StringUtils.trimToEmpty(status).toLowerCase();
        return "succeeded".equals(normalized)
                || "success".equals(normalized)
                || "completed".equals(normalized)
                || "complete".equals(normalized)
                || "done".equals(normalized);
    }

    private boolean isFailureStatus(String status)
    {
        String normalized = StringUtils.trimToEmpty(status).toLowerCase();
        return "failed".equals(normalized)
                || "failure".equals(normalized)
                || "error".equals(normalized)
                || "violation".equals(normalized)
                || "canceled".equals(normalized)
                || "cancelled".equals(normalized);
    }

    private JSONObject parseResponseBody(String responseBody)
    {
        if (StringUtils.isBlank(responseBody))
        {
            throw new ServiceException("图片生成失败：返回结果为空");
        }
        try
        {
            return JSON.parseObject(responseBody);
        }
        catch (JSONException e)
        {
            throw new ServiceException("图片生成失败：返回结果格式异常");
        }
    }

    private String normalizeImageSize(String imageSize)
    {
        if ("1k".equalsIgnoreCase(imageSize) || "1K".equals(imageSize))
        {
            return "1K";
        }
        if ("4k".equalsIgnoreCase(imageSize) || "4K".equals(imageSize))
        {
            return "4K";
        }
        return "2K";
    }

    private boolean usesPixelAspectRatio(String model)
    {
        return "gpt-image-2".equals(model) || "gpt-image-2-vip".equals(model);
    }

    private int normalizeImageCount(Integer imageCount)
    {
        if (imageCount == null)
        {
            return 1;
        }
        return Math.max(1, Math.min(4, imageCount.intValue()));
    }

    private String resolveError(JSONObject body, String fallback)
    {
        String error = body == null ? "" : body.getString("error");
        return StringUtils.defaultIfBlank(error, StringUtils.defaultIfBlank(fallback, "生成失败"));
    }

    private String saveImageFromUrl(String url, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        if (StringUtils.startsWithIgnoreCase(StringUtils.trimToEmpty(url), "data:"))
        {
            return saveBase64Image(url);
        }
        return url;
    }

    private String saveBase64Image(String b64Json) throws IOException
    {
        String data = b64Json;
        int commaIndex = data.indexOf(',');
        if (commaIndex >= 0)
        {
            data = data.substring(commaIndex + 1);
        }
        byte[] bytes = Base64.getDecoder().decode(data);
        return FileUtils.writeBytes(bytes, RuoYiConfig.getUploadPath());
    }

    private String saveRemoteImage(String url, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        int transientFailureCount = 0;
        while (true)
        {
            try
            {
                URI uri = URI.create(url);
                HttpRequest.Builder requestBuilder = HttpRequest.newBuilder()
                        .uri(uri)
                        .version(HttpClient.Version.HTTP_1_1)
                        .timeout(Duration.ofMinutes(2))
                        .header("Accept", "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8")
                        .header("User-Agent", "ai-zhihui-image-fetcher/1.0")
                        .GET();
                if (isProviderHostedUrl(uri, providerConfig))
                {
                    requestBuilder.header("Authorization", "Bearer " + providerConfig.getApiKey());
                }
                HttpResponse<byte[]> response = httpClient.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofByteArray());
                if (response.statusCode() < 200 || response.statusCode() >= 300)
                {
                    if (isTransientHttpStatus(response.statusCode()) && transientFailureCount < 3)
                    {
                        transientFailureCount++;
                        sleepBeforeRetry(transientFailureCount);
                        continue;
                    }
                    if (isHttpUrl(uri))
                    {
                        return url;
                    }
                    throw new ServiceException("图片下载失败：" + response.statusCode());
                }
                return FileUtils.writeBytes(response.body(), RuoYiConfig.getUploadPath());
            }
            catch (InterruptedException e)
            {
                Thread.currentThread().interrupt();
                throw e;
            }
            catch (IOException e)
            {
                if (isTransientError(e) && transientFailureCount < 3)
                {
                    transientFailureCount++;
                    sleepBeforeRetry(transientFailureCount);
                    continue;
                }
                if (isHttpUrl(url))
                {
                    return url;
                }
                throw e;
            }
        }
    }

    private boolean isTransientHttpStatus(int statusCode)
    {
        return statusCode == 429 || statusCode == 502 || statusCode == 503 || statusCode == 504;
    }

    private boolean isProviderHostedUrl(URI uri, AiImageProviderConfig providerConfig)
    {
        if (uri == null || providerConfig == null || StringUtils.isBlank(providerConfig.getBaseUrl()))
        {
            return false;
        }
        try
        {
            URI baseUri = URI.create(providerConfig.getBaseUrl());
            return StringUtils.equalsIgnoreCase(uri.getHost(), baseUri.getHost());
        }
        catch (IllegalArgumentException e)
        {
            return false;
        }
    }

    private boolean isHttpUrl(URI uri)
    {
        if (uri == null)
        {
            return false;
        }
        return "http".equalsIgnoreCase(uri.getScheme()) || "https".equalsIgnoreCase(uri.getScheme());
    }

    private boolean isHttpUrl(String url)
    {
        try
        {
            return isHttpUrl(URI.create(url));
        }
        catch (IllegalArgumentException e)
        {
            return false;
        }
    }

    private boolean isTransientError(Exception e)
    {
        String message = e == null ? "" : StringUtils.defaultString(e.getMessage()).toLowerCase();
        return message.contains("header parser received no bytes")
                || message.contains("eof")
                || message.contains("connection reset")
                || message.contains("connection closed")
                || message.contains("timed out")
                || message.contains("timeout")
                || message.contains("http/1.1 header parser");
    }

    private void sleepBeforeRetry(int retryCount) throws InterruptedException
    {
        Thread.sleep(Math.min(1500L * retryCount, 3000L));
    }

    private String resolveEndpoint(String baseUrl, String path)
    {
        String normalizedBaseUrl = trimEnd(baseUrl);
        if (normalizedBaseUrl.endsWith("/v1/api/generate"))
        {
            normalizedBaseUrl = normalizedBaseUrl.substring(0, normalizedBaseUrl.length() - "/v1/api/generate".length());
        }
        if (normalizedBaseUrl.endsWith("/v1/api/result"))
        {
            normalizedBaseUrl = normalizedBaseUrl.substring(0, normalizedBaseUrl.length() - "/v1/api/result".length());
        }
        if (normalizedBaseUrl.endsWith("/v1/api"))
        {
            normalizedBaseUrl = normalizedBaseUrl.substring(0, normalizedBaseUrl.length() - "/v1/api".length());
        }
        if (normalizedBaseUrl.endsWith("/v1"))
        {
            normalizedBaseUrl = normalizedBaseUrl.substring(0, normalizedBaseUrl.length() - "/v1".length());
        }
        return trimEnd(normalizedBaseUrl) + path;
    }

    private String trimEnd(String value)
    {
        if (value == null || value.isBlank())
        {
            return "";
        }
        while (value.endsWith("/"))
        {
            value = value.substring(0, value.length() - 1);
        }
        return value;
    }
}
