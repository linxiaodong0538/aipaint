package com.ruoyi.web.service.image;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Base64;
import org.springframework.stereotype.Component;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONException;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.file.FileUtils;

/**
 * 中转站图片生成客户端
 */
@Component
public class AiImageGatewayClient
{
    private final AiImageProperties properties;

    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(20))
            .build();

    public AiImageGatewayClient(AiImageProperties properties)
    {
        this.properties = properties;
    }

    public String generateAndSave(String prompt, String size, String quality)
    {
        try
        {
            JSONObject payload = new JSONObject();
            payload.put("model", properties.getModel());
            payload.put("prompt", prompt);
            payload.put("size", size);
            payload.put("quality", quality);
            payload.put("n", 1);

            return sendGenerationRequest(payload);
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

    private String sendGenerationRequest(JSONObject payload) throws IOException, InterruptedException
    {
        Exception lastException = null;
        for (int attempt = 0; attempt < 2; attempt++)
        {
            try
            {
                HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(trimEnd(properties.getBaseUrl()) + "/images/generations"))
                    .timeout(Duration.ofMinutes(3))
                    .header("Authorization", "Bearer " + properties.getApiKey())
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(payload.toJSONString()))
                    .build();

                HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
                if (response.statusCode() < 200 || response.statusCode() >= 300)
                {
                    throw new ServiceException("图片生成失败：" + response.body());
                }

                return readJsonAndSave(response.body());
            }
            catch (ServiceException e)
            {
                throw e;
            }
            catch (IOException e)
            {
                lastException = e;
                if (!isRetryableIOException(e) || attempt > 0)
                {
                    throw e;
                }
            }
        }
        throw new ServiceException("图片生成失败：" + (lastException == null ? "请求失败" : lastException.getMessage()));
    }

    private boolean isRetryableIOException(IOException e)
    {
        String message = e.getMessage();
        return message != null && (message.contains("EOF") || message.contains("closed") || message.contains("reset"));
    }

    private String readJsonAndSave(String responseBody) throws IOException, InterruptedException
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
        if (data == null || data.isEmpty())
        {
            throw new ServiceException("图片生成失败：返回结果为空");
        }

        JSONObject first = data.getJSONObject(0);
        String b64Json = first.getString("b64_json");
        if (b64Json != null && !b64Json.isBlank())
        {
            return saveBase64Image(b64Json);
        }

        String url = first.getString("url");
        if (url != null && !url.isBlank())
        {
            return saveRemoteImage(url);
        }

        throw new ServiceException("图片生成失败：返回结果缺少图片数据");
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

    private String saveRemoteImage(String url) throws IOException, InterruptedException
    {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(Duration.ofMinutes(2))
                .GET()
                .build();
        HttpResponse<byte[]> response = httpClient.send(request, HttpResponse.BodyHandlers.ofByteArray());
        if (response.statusCode() < 200 || response.statusCode() >= 300)
        {
            throw new ServiceException("图片下载失败：" + response.statusCode());
        }
        return FileUtils.writeBytes(response.body(), RuoYiConfig.getUploadPath());
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
