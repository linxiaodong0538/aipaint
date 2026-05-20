package com.ruoyi.web.service.image;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Base64;
import java.util.function.Consumer;
import org.springframework.stereotype.Component;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
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
        return generateAndSave(prompt, size, quality, null);
    }

    public String generateAndSave(String prompt, String size, String quality, Consumer<String> previewConsumer)
    {
        try
        {
            JSONObject payload = new JSONObject();
            payload.put("model", properties.getModel());
            payload.put("prompt", prompt);
            payload.put("size", size);
            payload.put("quality", quality);
            payload.put("n", 1);
            payload.put("stream", true);
            payload.put("partial_images", normalizePartialImages());

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(trimEnd(properties.getBaseUrl()) + "/images/generations"))
                    .timeout(Duration.ofMinutes(3))
                    .header("Authorization", "Bearer " + properties.getApiKey())
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(payload.toJSONString()))
                    .build();

            HttpResponse<java.io.InputStream> response = httpClient.send(request, HttpResponse.BodyHandlers.ofInputStream());
            if (response.statusCode() < 200 || response.statusCode() >= 300)
            {
                throw new ServiceException("图片生成失败：" + readBody(response.body()));
            }

            String contentType = response.headers().firstValue("content-type").orElse("");
            if (contentType.contains("text/event-stream"))
            {
                return readStreamAndSave(response.body(), previewConsumer);
            }

            return readJsonAndSave(readBody(response.body()));
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

    private String readStreamAndSave(java.io.InputStream inputStream, Consumer<String> previewConsumer) throws IOException
    {
        String resultImageUrl = null;
        try (java.io.BufferedReader reader = new java.io.BufferedReader(new java.io.InputStreamReader(inputStream, java.nio.charset.StandardCharsets.UTF_8)))
        {
            String line;
            while ((line = reader.readLine()) != null)
            {
                String eventData = normalizeEventData(line);
                if (eventData == null)
                {
                    continue;
                }

                JSONObject event = JSON.parseObject(eventData);
                JSONObject error = event.getJSONObject("error");
                if (error != null)
                {
                    throw new ServiceException("图片生成失败：" + error.getString("message"));
                }

                String type = event.getString("type");
                String b64Json = event.getString("b64_json");
                if (b64Json == null || b64Json.isBlank())
                {
                    continue;
                }

                String imageUrl = saveBase64Image(b64Json);
                if ("image_generation.partial_image".equals(type))
                {
                    if (previewConsumer != null)
                    {
                        previewConsumer.accept(imageUrl);
                    }
                }
                else if ("image_generation.completed".equals(type))
                {
                    resultImageUrl = imageUrl;
                    if (previewConsumer != null)
                    {
                        previewConsumer.accept(imageUrl);
                    }
                }
            }
        }

        if (resultImageUrl == null)
        {
            throw new ServiceException("图片生成失败：流式返回缺少最终图片");
        }
        return resultImageUrl;
    }

    private int normalizePartialImages()
    {
        Integer partialImages = properties.getPartialImages();
        if (partialImages == null)
        {
            return 1;
        }
        return Math.max(0, Math.min(3, partialImages));
    }

    private String normalizeEventData(String line)
    {
        if (line == null)
        {
            return null;
        }
        String value = line.trim();
        if (value.isEmpty() || value.startsWith(":"))
        {
            return null;
        }
        if (value.startsWith("data:"))
        {
            value = value.substring(5).trim();
        }
        else if (!value.startsWith("{"))
        {
            return null;
        }
        if ("[DONE]".equals(value) || value.isEmpty())
        {
            return null;
        }
        return value;
    }

    private String readJsonAndSave(String responseBody) throws IOException, InterruptedException
    {
        JSONObject body = JSON.parseObject(responseBody);
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

    private String readBody(java.io.InputStream inputStream) throws IOException
    {
        return new String(inputStream.readAllBytes(), java.nio.charset.StandardCharsets.UTF_8);
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
