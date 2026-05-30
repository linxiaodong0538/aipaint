package com.ruoyi.web.service;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.function.Consumer;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONException;
import com.alibaba.fastjson2.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.web.service.image.AiImageConfigService;
import com.ruoyi.web.service.image.AiImageProviderConfig;

/**
 * AI 提示词润色服务
 */
@Service
public class AiPromptPolishService
{
    private static final String PROVIDER_DEEPSEEK = "deepseek";

    private static final int MAX_PROMPT_LENGTH = 2000;

    private static final Duration REQUEST_TIMEOUT = Duration.ofSeconds(45);

    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(20))
            .build();

    @Autowired
    private AiImageConfigService aiImageConfigService;

    public String polish(String prompt)
    {
        String normalizedPrompt = StringUtils.trimToEmpty(prompt);
        if (StringUtils.isBlank(normalizedPrompt))
        {
            throw new ServiceException("请输入画面描述");
        }
        if (normalizedPrompt.length() > MAX_PROMPT_LENGTH)
        {
            normalizedPrompt = normalizedPrompt.substring(0, MAX_PROMPT_LENGTH);
        }

        AiImageProviderConfig providerConfig = aiImageConfigService.resolveProviderByCode(PROVIDER_DEEPSEEK);
        try
        {
            JSONObject payload = buildPayload(normalizedPrompt, resolvePolishModel(providerConfig));
            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(URI.create(resolveEndpoint(providerConfig.getBaseUrl(), "/v1/chat/completions")))
                    .version(HttpClient.Version.HTTP_1_1)
                    .timeout(REQUEST_TIMEOUT)
                    .header("Authorization", "Bearer " + providerConfig.getApiKey())
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(payload.toJSONString()))
                    .build();

            HttpResponse<String> response = httpClient.send(httpRequest, HttpResponse.BodyHandlers.ofString());
            JSONObject body = parseResponseBody(response.body());
            if (response.statusCode() < 200 || response.statusCode() >= 300)
            {
                throw new ServiceException("Prompt 润色失败：" + resolveError(body, response.body()));
            }
            return resolvePolishedPrompt(body);
        }
        catch (ServiceException e)
        {
            throw e;
        }
        catch (InterruptedException e)
        {
            Thread.currentThread().interrupt();
            throw new ServiceException("Prompt 润色失败：请求已中断");
        }
        catch (IOException | IllegalArgumentException e)
        {
            throw new ServiceException("Prompt 润色失败：" + e.getMessage());
        }
    }

    public void polishStream(String prompt, Consumer<String> chunkConsumer)
    {
        String normalizedPrompt = normalizePrompt(prompt);
        AiImageProviderConfig providerConfig = aiImageConfigService.resolveProviderByCode(PROVIDER_DEEPSEEK);
        try
        {
            JSONObject payload = buildPayload(normalizedPrompt, resolvePolishModel(providerConfig), true);
            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(URI.create(resolveEndpoint(providerConfig.getBaseUrl(), "/v1/chat/completions")))
                    .version(HttpClient.Version.HTTP_1_1)
                    .timeout(REQUEST_TIMEOUT)
                    .header("Authorization", "Bearer " + providerConfig.getApiKey())
                    .header("Accept", "text/event-stream")
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(payload.toJSONString()))
                    .build();

            HttpResponse<InputStream> response = httpClient.send(httpRequest, HttpResponse.BodyHandlers.ofInputStream());
            if (response.statusCode() < 200 || response.statusCode() >= 300)
            {
                JSONObject body = parseResponseBody(readStreamAsString(response.body()));
                throw new ServiceException("Prompt 润色失败：" + resolveError(body, body.toJSONString()));
            }
            readSseStream(response.body(), chunkConsumer);
        }
        catch (ServiceException e)
        {
            throw e;
        }
        catch (InterruptedException e)
        {
            Thread.currentThread().interrupt();
            throw new ServiceException("Prompt 润色失败：请求已中断");
        }
        catch (IOException | IllegalArgumentException e)
        {
            throw new ServiceException("Prompt 润色失败：" + e.getMessage());
        }
    }

    private String normalizePrompt(String prompt)
    {
        String normalizedPrompt = StringUtils.trimToEmpty(prompt);
        if (StringUtils.isBlank(normalizedPrompt))
        {
            throw new ServiceException("请输入画面描述");
        }
        if (normalizedPrompt.length() > MAX_PROMPT_LENGTH)
        {
            normalizedPrompt = normalizedPrompt.substring(0, MAX_PROMPT_LENGTH);
        }
        return normalizedPrompt;
    }

    private String resolvePolishModel(AiImageProviderConfig providerConfig)
    {
        String model = providerConfig.getModel();
        if (StringUtils.isBlank(model) && providerConfig.getSupportedModels() != null && !providerConfig.getSupportedModels().isEmpty())
        {
            model = providerConfig.getSupportedModels().get(0);
        }
        if (StringUtils.isBlank(model))
        {
            throw new ServiceException("Prompt 润色通道未配置模型");
        }
        return aiImageConfigService.resolveProviderModel(providerConfig, model);
    }

    private JSONObject buildPayload(String prompt, String model)
    {
        return buildPayload(prompt, model, false);
    }

    private JSONObject buildPayload(String prompt, String model, boolean stream)
    {
        JSONObject payload = new JSONObject();
        payload.put("model", model);
        payload.put("stream", Boolean.valueOf(stream));

        JSONArray messages = new JSONArray();
        JSONObject userMessage = new JSONObject();
        userMessage.put("role", "user");
        userMessage.put("content", buildPolishInstruction(prompt));
        messages.add(userMessage);
        payload.put("messages", messages);
        return payload;
    }

    private String buildPolishInstruction(String prompt)
    {
        return "请将下面的画面描述润色为适合 AI 图像生成的高质量提示词。"
                + "要求：保留原意，不添加冲突主体；补充画面细节、构图、光线、风格、质感；"
                + resolveLanguageInstruction(prompt)
                + "输出长度控制在 1000 字符以内，内容精炼但保留关键画面细节；"
                + "只输出润色后的提示词，不要解释、标题或编号。\n"
                + "原始描述：\n" + prompt;
    }

    private String resolveLanguageInstruction(String prompt)
    {
        boolean hasChinese = containsChinese(prompt);
        boolean hasLatin = containsLatin(prompt);
        if (hasChinese && !hasLatin)
        {
            return "必须全程使用中文输出，禁止输出英文单词或英文短语，不要翻译成英文；";
        }
        if (!hasChinese && hasLatin)
        {
            return "Must output in English only. Do not translate the prompt into Chinese or any other language;";
        }
        if (hasChinese && hasLatin)
        {
            return "必须保持原始输入的中英混合方式和主语言比例，不要整体翻译成另一种语言；";
        }
        return "必须使用与原始输入相同的语言输出，不要翻译成另一种语言；";
    }

    private boolean containsChinese(String value)
    {
        return value != null && value.codePoints().anyMatch(codePoint ->
                Character.UnicodeScript.of(codePoint) == Character.UnicodeScript.HAN);
    }

    private boolean containsLatin(String value)
    {
        return value != null && value.codePoints().anyMatch(codePoint ->
                Character.UnicodeScript.of(codePoint) == Character.UnicodeScript.LATIN
                        && Character.isLetter(codePoint));
    }

    private void readSseStream(InputStream inputStream, Consumer<String> chunkConsumer) throws IOException
    {
        if (inputStream == null)
        {
            throw new ServiceException("Prompt 润色失败：返回结果为空");
        }
        StringBuilder eventData = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8)))
        {
            String line;
            while ((line = reader.readLine()) != null)
            {
                if (line.isEmpty())
                {
                    emitSseEvent(eventData.toString(), chunkConsumer);
                    eventData.setLength(0);
                    continue;
                }
                if (line.startsWith("data:"))
                {
                    if (eventData.length() > 0)
                    {
                        eventData.append('\n');
                    }
                    eventData.append(line.substring("data:".length()).trim());
                }
            }
        }
        emitSseEvent(eventData.toString(), chunkConsumer);
    }

    private void emitSseEvent(String data, Consumer<String> chunkConsumer)
    {
        if (StringUtils.isBlank(data) || "[DONE]".equals(data.trim()))
        {
            return;
        }

        JSONObject body;
        try
        {
            body = JSON.parseObject(data);
        }
        catch (JSONException e)
        {
            throw new ServiceException("Prompt 润色失败：流式返回格式异常");
        }

        JSONObject error = body.getJSONObject("error");
        if (error != null)
        {
            throw new ServiceException("Prompt 润色失败：" + resolveError(body, error.toJSONString()));
        }

        String content = resolveDeltaContent(body);
        if (StringUtils.isNotBlank(content))
        {
            chunkConsumer.accept(content);
        }
    }

    private String resolveDeltaContent(JSONObject body)
    {
        JSONArray choices = body.getJSONArray("choices");
        if (choices == null || choices.isEmpty())
        {
            return "";
        }
        JSONObject choice = choices.getJSONObject(0);
        if (choice == null)
        {
            return "";
        }
        JSONObject delta = choice.getJSONObject("delta");
        if (delta != null && StringUtils.isNotBlank(delta.getString("content")))
        {
            return delta.getString("content");
        }
        JSONObject message = choice.getJSONObject("message");
        return message == null ? "" : message.getString("content");
    }

    private JSONObject parseResponseBody(String responseBody)
    {
        if (StringUtils.isBlank(responseBody))
        {
            throw new ServiceException("Prompt 润色失败：返回结果为空");
        }
        try
        {
            return JSON.parseObject(responseBody);
        }
        catch (JSONException e)
        {
            throw new ServiceException("Prompt 润色失败：返回结果格式异常");
        }
    }

    private String resolvePolishedPrompt(JSONObject body)
    {
        JSONArray choices = body.getJSONArray("choices");
        if (choices == null || choices.isEmpty())
        {
            throw new ServiceException("Prompt 润色失败：返回结果缺少内容");
        }
        JSONObject choice = choices.getJSONObject(0);
        JSONObject message = choice == null ? null : choice.getJSONObject("message");
        String content = message == null ? "" : message.getString("content");
        content = normalizeOutput(content);
        if (StringUtils.isBlank(content))
        {
            throw new ServiceException("Prompt 润色失败：返回内容为空");
        }
        return content.length() > MAX_PROMPT_LENGTH ? content.substring(0, MAX_PROMPT_LENGTH) : content;
    }

    private String normalizeOutput(String content)
    {
        String normalized = StringUtils.trimToEmpty(content);
        if (normalized.length() >= 2
                && ((normalized.startsWith("\"") && normalized.endsWith("\""))
                        || (normalized.startsWith("'") && normalized.endsWith("'"))))
        {
            normalized = normalized.substring(1, normalized.length() - 1).trim();
        }
        return normalized;
    }

    private String resolveError(JSONObject body, String fallback)
    {
        if (body != null)
        {
            JSONObject error = body.getJSONObject("error");
            if (error != null)
            {
                return StringUtils.defaultIfBlank(error.getString("message"), error.toJSONString());
            }
            String message = body.getString("message");
            if (StringUtils.isNotBlank(message))
            {
                return message;
            }
        }
        return StringUtils.defaultIfBlank(fallback, "请求失败");
    }

    private String readStreamAsString(InputStream inputStream) throws IOException
    {
        if (inputStream == null)
        {
            return "";
        }
        return new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
    }

    private String resolveEndpoint(String baseUrl, String path)
    {
        String normalizedBaseUrl = trimEnd(baseUrl);
        if (normalizedBaseUrl.endsWith("/v1/chat/completions"))
        {
            normalizedBaseUrl = normalizedBaseUrl.substring(0, normalizedBaseUrl.length() - "/v1/chat/completions".length());
        }
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
