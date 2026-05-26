package com.ruoyi.web.service.image;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
 * OpenAI 兼容图片接口 Provider
 */
@Component
public class AiImageOpenAiCompatibleProvider implements AiImageProvider
{
    private static final Logger log = LoggerFactory.getLogger(AiImageOpenAiCompatibleProvider.class);

    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(20))
            .build();

    @Override
    public String getAdapterType()
    {
        return AiImageConfigService.ADAPTER_OPENAI_COMPATIBLE;
    }

    @Override
    public String generateAndSave(AiImageGenerateRequest request, AiImageProviderConfig providerConfig)
    {
        try
        {
            JSONObject payload = new JSONObject();
            payload.put("model", StringUtils.defaultIfBlank(request.getModel(), providerConfig.getModel()));
            payload.put("prompt", request.getPrompt());
            payload.put("size", resolvePayloadSize(request, providerConfig));
            payload.put("resolution", request.getResolution());
            payload.put("n", normalizeImageCount(request.getImageCount()));
            payload.put("response_format", "url");
            String outputFormat = normalizeOutputFormat(request.getOutputFormat());
            payload.put("output_format", outputFormat);
            if ("jpeg".equals(outputFormat) && request.getOutputCompression() != null)
            {
                payload.put("output_compression", normalizeOutputCompression(request.getOutputCompression()));
            }
            if (request.getImageUrls() != null && !request.getImageUrls().isEmpty())
            {
                payload.put("image_urls", request.getImageUrls());
            }

            if (shouldUseStreamingResponse(providerConfig))
            {
                return sendStreamingGenerationRequest(payload, providerConfig);
            }
            return sendGenerationRequest(payload, providerConfig);
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

    private String sendGenerationRequest(JSONObject payload, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        int transientFailureCount = 0;
        while (true)
        {
            HttpResponse<String> response;
            try
            {
                HttpRequest request = HttpRequest.newBuilder()
                        .uri(URI.create(trimEnd(providerConfig.getBaseUrl()) + "/images/generations"))
                        .version(HttpClient.Version.HTTP_1_1)
                        .timeout(Duration.ofMinutes(3))
                        .header("Authorization", "Bearer " + providerConfig.getApiKey())
                        .header("Content-Type", "application/json")
                        .POST(HttpRequest.BodyPublishers.ofString(payload.toJSONString()))
                        .build();

                response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            }
            catch (InterruptedException e)
            {
                Thread.currentThread().interrupt();
                throw e;
            }
            catch (IOException e)
            {
                if (isAmbiguousSubmitError(e))
                {
                    log.warn("AI图片生成提交后响应异常，providerCode={}, baseUrl={}, error={}: {}",
                            providerConfig.getProviderCode(),
                            maskBaseUrl(providerConfig.getBaseUrl()),
                            e.getClass().getSimpleName(),
                            e.getMessage(),
                            e);
                    throw new ServiceException("图片生成响应异常，本地未收到生成结果，结果待确认（"
                            + e.getClass().getSimpleName() + "：" + StringUtils.defaultIfBlank(e.getMessage(), "无详细信息")
                            + "）");
                }
                if (!isTransientCreateError(e) || transientFailureCount >= 2)
                {
                    throw e;
                }
                transientFailureCount++;
                sleepBeforeRetry(transientFailureCount);
                continue;
            }

            if (response.statusCode() < 200 || response.statusCode() >= 300)
            {
                throw new ServiceException("图片生成失败：" + response.body());
            }
            return readJsonAndSave(response.body(), providerConfig);
        }
    }

    private String sendStreamingGenerationRequest(JSONObject payload, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        JSONObject streamingPayload = new JSONObject();
        streamingPayload.putAll(payload);
        streamingPayload.put("stream", true);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(trimEnd(providerConfig.getBaseUrl()) + "/images/generations"))
                .version(HttpClient.Version.HTTP_1_1)
                .timeout(Duration.ofMinutes(5))
                .header("Authorization", "Bearer " + providerConfig.getApiKey())
                .header("Accept", "text/event-stream")
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(streamingPayload.toJSONString()))
                .build();

        HttpResponse<InputStream> response;
        try
        {
            response = httpClient.send(request, HttpResponse.BodyHandlers.ofInputStream());
        }
        catch (InterruptedException e)
        {
            Thread.currentThread().interrupt();
            throw e;
        }
        catch (IOException e)
        {
            log.warn("AI图片流式响应连接异常，providerCode={}, baseUrl={}, error={}: {}",
                    providerConfig.getProviderCode(),
                    maskBaseUrl(providerConfig.getBaseUrl()),
                    e.getClass().getSimpleName(),
                    e.getMessage(),
                    e);
            throw new ServiceException("图片生成失败：流式响应连接异常（"
                    + e.getClass().getSimpleName() + "：" + StringUtils.defaultIfBlank(e.getMessage(), "无详细信息")
                    + "），请重试");
        }

        if (response.statusCode() < 200 || response.statusCode() >= 300)
        {
            throw new ServiceException("图片生成失败：" + readStreamAsString(response.body()));
        }
        return readSseAndSave(response.body(), providerConfig, payload.getIntValue("n"));
    }

    private String resolvePayloadSize(AiImageGenerateRequest request, AiImageProviderConfig providerConfig)
    {
        if (isToApisProvider(providerConfig) && isRatioSize(request.getRatio()))
        {
            return request.getRatio();
        }
        return request.getSize();
    }

    private boolean shouldUseStreamingResponse(AiImageProviderConfig providerConfig)
    {
        return providerConfig != null
                && AiImageConfigService.RESPONSE_MODE_STREAM.equals(providerConfig.getResponseMode());
    }

    private boolean isToApisProvider(AiImageProviderConfig providerConfig)
    {
        String baseUrl = providerConfig == null ? "" : StringUtils.defaultString(providerConfig.getBaseUrl()).toLowerCase();
        return baseUrl.contains("toapis.com");
    }

    private boolean isRatioSize(String value)
    {
        return "1:1".equals(value) || "3:2".equals(value) || "2:3".equals(value)
                || "4:3".equals(value) || "3:4".equals(value)
                || "5:4".equals(value) || "4:5".equals(value)
                || "16:9".equals(value) || "9:16".equals(value)
                || "2:1".equals(value) || "1:2".equals(value)
                || "21:9".equals(value) || "9:21".equals(value);
    }

    private int normalizeImageCount(Integer imageCount)
    {
        if (imageCount == null)
        {
            return 1;
        }
        return Math.max(1, Math.min(4, imageCount.intValue()));
    }

    private String normalizeOutputFormat(String outputFormat)
    {
        return "png".equalsIgnoreCase(StringUtils.trimToEmpty(outputFormat)) ? "png" : "jpeg";
    }

    private int normalizeOutputCompression(Integer outputCompression)
    {
        if (outputCompression == null)
        {
            return 90;
        }
        return Math.max(0, Math.min(100, outputCompression.intValue()));
    }

    private String readJsonAndSave(String responseBody, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        if (responseBody == null || responseBody.isBlank())
        {
            throw new ServiceException("图片生成失败：返回结果为空");
        }

        JSONObject body;
        try
        {
            body = JSON.parseObject(responseBody);
        }
        catch (JSONException e)
        {
            if (e.getMessage() != null && e.getMessage().contains("EOF"))
            {
                throw new ServiceException("图片生成失败：返回结果不完整，请重试");
            }
            throw new ServiceException("图片生成失败：返回结果格式异常");
        }

        JSONArray data = body.getJSONArray("data");
        if (data != null && !data.isEmpty())
        {
            return saveImagesFromData(data, providerConfig);
        }

        String taskId = body.getString("id");
        if (StringUtils.isNotBlank(taskId) && "generation.task".equals(body.getString("object")))
        {
            return pollTaskAndSave(taskId, providerConfig);
        }

        throw new ServiceException("图片生成失败：返回结果为空");
    }

    private String readSseAndSave(InputStream inputStream, AiImageProviderConfig providerConfig, int expectedCount) throws IOException, InterruptedException
    {
        String event = "";
        StringBuilder data = new StringBuilder();
        StringBuilder raw = new StringBuilder();
        StringBuilder results = new StringBuilder();
        boolean sseSeen = false;
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8)))
        {
            String line;
            while ((line = reader.readLine()) != null)
            {
                raw.append(line).append('\n');
                if (line.isEmpty())
                {
                    String result = saveCompletedSseEventIfPresent(event, data.toString(), providerConfig);
                    if (StringUtils.isNotBlank(result))
                    {
                        appendResultUrls(results, result);
                        if (countResultUrls(results.toString()) >= expectedCount)
                        {
                            return results.toString();
                        }
                    }
                    event = "";
                    data.setLength(0);
                    continue;
                }
                if (line.startsWith("event:"))
                {
                    sseSeen = true;
                    event = line.substring("event:".length()).trim();
                    continue;
                }
                if (line.startsWith("data:"))
                {
                    sseSeen = true;
                    if (data.length() > 0)
                    {
                        data.append('\n');
                    }
                    data.append(line.substring("data:".length()).trim());
                }
            }
        }

        String result = saveCompletedSseEventIfPresent(event, data.toString(), providerConfig);
        if (StringUtils.isNotBlank(result))
        {
            appendResultUrls(results, result);
        }
        if (StringUtils.isNotBlank(results.toString()))
        {
            return results.toString();
        }
        if (!sseSeen)
        {
            return readJsonAndSave(raw.toString(), providerConfig);
        }
        throw new ServiceException("图片生成失败：流式返回未包含完成图片");
    }

    private String saveCompletedSseEventIfPresent(String event, String data, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        if (StringUtils.isBlank(data) || "[DONE]".equals(data.trim()))
        {
            return null;
        }

        JSONObject body;
        try
        {
            body = JSON.parseObject(data);
        }
        catch (JSONException e)
        {
            throw new ServiceException("图片生成失败：流式返回格式异常");
        }

        JSONObject error = body.getJSONObject("error");
        if (error != null)
        {
            throw new ServiceException("图片生成失败：" + error.toJSONString());
        }

        String type = body.getString("type");
        boolean completed = StringUtils.defaultString(event).endsWith(".completed")
                || StringUtils.defaultString(type).endsWith(".completed");
        if (!completed)
        {
            return null;
        }
        return saveCompletedTaskResult(body, providerConfig);
    }

    private String readStreamAsString(InputStream inputStream) throws IOException
    {
        if (inputStream == null)
        {
            return "";
        }
        return new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
    }

    private String pollTaskAndSave(String taskId, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        long deadline = System.currentTimeMillis() + Duration.ofSeconds(140).toMillis();
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
                if (isTransientQueryError(e))
                {
                    transientFailureCount++;
                    if (transientFailureCount >= 5)
                    {
                        throw new ServiceException("图片生成失败：生成结果获取异常，请稍后到作品中查看或重试");
                    }
                    continue;
                }
                throw e;
            }
            String status = body.getString("status");
            if ("completed".equals(status))
            {
                return saveCompletedTaskResult(body, providerConfig);
            }
            if ("failed".equals(status))
            {
                JSONObject error = body.getJSONObject("error");
                throw new ServiceException("图片生成失败：" + (error == null ? "生成失败" : error.toJSONString()));
            }
        }
        throw new ServiceException("图片生成失败：生成超时，请稍后到作品中查看或重试");
    }

    private boolean isTransientQueryError(Exception e)
    {
        String message = e == null ? "" : StringUtils.defaultString(e.getMessage()).toLowerCase();
        return message.contains("header parser received no bytes")
                || message.contains("eof")
                || message.contains("connection reset")
                || message.contains("connection closed")
                || message.contains("timed out")
                || message.contains("http/1.1 header parser");
    }

    private boolean isTransientCreateError(Exception e)
    {
        return isTransientQueryError(e) && !isAmbiguousSubmitError(e);
    }

    private boolean isAmbiguousSubmitError(Exception e)
    {
        String message = e == null ? "" : StringUtils.defaultString(e.getMessage()).toLowerCase();
        return message.contains("header parser received no bytes")
                || message.contains("http/1.1 header parser")
                || message.contains("no bytes")
                || message.contains("connection closed")
                || message.contains("connection reset")
                || message.contains("timed out")
                || message.contains("timeout")
                || message.contains("eof");
    }

    private void sleepBeforeRetry(int retryCount) throws InterruptedException
    {
        Thread.sleep(Math.min(1500L * retryCount, 3000L));
    }

    private JSONObject queryTask(String taskId, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(trimEnd(providerConfig.getBaseUrl()) + "/images/generations/" + taskId))
                .version(HttpClient.Version.HTTP_1_1)
                .timeout(Duration.ofSeconds(30))
                .header("Authorization", "Bearer " + providerConfig.getApiKey())
                .GET()
                .build();
        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() < 200 || response.statusCode() >= 300)
        {
            throw new ServiceException("图片任务查询失败：" + response.body());
        }
        return JSON.parseObject(response.body());
    }

    private String saveCompletedTaskResult(JSONObject body, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        JSONArray data = body.getJSONArray("data");
        if (data != null && !data.isEmpty())
        {
            return saveImagesFromData(data, providerConfig);
        }

        JSONObject result = body.getJSONObject("result");
        if (result != null)
        {
            JSONArray resultData = result.getJSONArray("data");
            if (resultData != null && !resultData.isEmpty())
            {
                return saveImagesFromData(resultData, providerConfig);
            }

            String resultUrls = saveImagesFromUrlValue(result.get("url"), providerConfig);
            if (StringUtils.isNotBlank(resultUrls))
            {
                return resultUrls;
            }
        }

        String urls = saveImagesFromUrlValue(body.get("urls"), providerConfig);
        if (StringUtils.isNotBlank(urls))
        {
            return urls;
        }

        urls = saveImagesFromUrlValue(body.get("url"), providerConfig);
        if (StringUtils.isNotBlank(urls))
        {
            return urls;
        }

        throw new ServiceException("图片生成失败：完成结果缺少图片数据");
    }

    private String saveImagesFromUrlValue(Object value, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        if (value instanceof JSONArray)
        {
            JSONArray urls = (JSONArray) value;
            StringBuilder savedUrls = new StringBuilder();
            for (int i = 0; i < urls.size(); i++)
            {
                String savedUrl = saveImageFromUrl(urls.getString(i), providerConfig);
                if (StringUtils.isBlank(savedUrl))
                {
                    continue;
                }
                if (savedUrls.length() > 0)
                {
                    savedUrls.append(',');
                }
                savedUrls.append(savedUrl);
            }
            return savedUrls.toString();
        }

        String url = value == null ? "" : String.valueOf(value);
        return StringUtils.isBlank(url) ? null : saveImageFromUrl(url, providerConfig);
    }

    private String saveImagesFromData(JSONArray data, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        StringBuilder urls = new StringBuilder();
        for (int i = 0; i < data.size(); i++)
        {
            String imageUrl = saveImageFromDataItem(data.getJSONObject(i), providerConfig);
            if (StringUtils.isBlank(imageUrl))
            {
                continue;
            }
            if (urls.length() > 0)
            {
                urls.append(',');
            }
            urls.append(imageUrl);
        }
        if (urls.length() == 0)
        {
            throw new ServiceException("图片生成失败：返回结果缺少图片数据");
        }
        return urls.toString();
    }

    private String saveImageFromDataItem(JSONObject item, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        String b64Json = item.getString("b64_json");
        if (StringUtils.isNotBlank(b64Json))
        {
            return saveBase64Image(b64Json);
        }

        String url = item.getString("url");
        if (StringUtils.isNotBlank(url))
        {
            return saveImageFromUrl(url, providerConfig);
        }

        throw new ServiceException("图片生成失败：返回结果缺少图片数据");
    }

    private String saveImageFromUrl(String url, AiImageProviderConfig providerConfig) throws IOException, InterruptedException
    {
        if (StringUtils.startsWithIgnoreCase(StringUtils.trimToEmpty(url), "data:"))
        {
            return saveBase64Image(url);
        }
        return saveRemoteImage(url, providerConfig);
    }

    private void appendResultUrls(StringBuilder results, String urls)
    {
        if (StringUtils.isBlank(urls))
        {
            return;
        }
        if (results.length() > 0)
        {
            results.append(',');
        }
        results.append(urls);
    }

    private int countResultUrls(String urls)
    {
        if (StringUtils.isBlank(urls))
        {
            return 0;
        }
        return StringUtils.split(urls, ',').length;
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
                HttpRequest request = requestBuilder.build();
                HttpResponse<byte[]> response = httpClient.send(request, HttpResponse.BodyHandlers.ofByteArray());
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
                if (isTransientQueryError(e) && transientFailureCount < 3)
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

    private String maskBaseUrl(String baseUrl)
    {
        if (StringUtils.isBlank(baseUrl))
        {
            return "";
        }
        try
        {
            URI uri = URI.create(baseUrl);
            return uri.getScheme() + "://" + uri.getHost() + StringUtils.defaultString(uri.getPath());
        }
        catch (IllegalArgumentException e)
        {
            return trimEnd(baseUrl);
        }
    }
}
