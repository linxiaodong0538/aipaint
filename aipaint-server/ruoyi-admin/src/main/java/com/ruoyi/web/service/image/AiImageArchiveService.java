package com.ruoyi.web.service.image;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import jakarta.annotation.PreDestroy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.system.service.IAiGenerationTaskService;

/**
 * 异步归档上游图片，用户先看到上游 URL，归档成功后再替换为本地地址。
 */
@Component
public class AiImageArchiveService
{
    private static final Logger log = LoggerFactory.getLogger(AiImageArchiveService.class);

    private final IAiGenerationTaskService taskService;

    private final ExecutorService executorService;

    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(20))
            .build();

    public AiImageArchiveService(IAiGenerationTaskService taskService,
            @Value("${ai.image.archive.pool-size:2}") Integer poolSize)
    {
        this.taskService = taskService;
        this.executorService = Executors.newFixedThreadPool(normalizePoolSize(poolSize));
    }

    public void archiveAsync(Long taskId, String resultImageUrl)
    {
        if (taskId == null || StringUtils.isBlank(resultImageUrl) || !containsRemoteHttpUrl(resultImageUrl))
        {
            return;
        }
        executorService.submit(() -> archive(taskId, resultImageUrl));
    }

    private void archive(Long taskId, String resultImageUrl)
    {
        try
        {
            List<String> archivedUrls = new ArrayList<>();
            boolean changed = false;
            for (String url : parseUrls(resultImageUrl))
            {
                String archivedUrl = archiveUrl(url);
                archivedUrls.add(archivedUrl);
                if (!StringUtils.equals(url, archivedUrl))
                {
                    changed = true;
                }
            }
            if (changed && !archivedUrls.isEmpty())
            {
                taskService.updateArchivedResult(taskId, StringUtils.join(archivedUrls, ","));
            }
        }
        catch (Exception e)
        {
            log.warn("AI图片异步归档失败，taskId={}", taskId, e);
        }
    }

    private String archiveUrl(String url) throws IOException, InterruptedException
    {
        if (!isRemoteHttpUrl(url))
        {
            return url;
        }

        try
        {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .version(HttpClient.Version.HTTP_1_1)
                    .timeout(Duration.ofMinutes(2))
                    .header("Accept", "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8")
                    .header("User-Agent", "ai-zhihui-image-archiver/1.0")
                    .GET()
                    .build();
            HttpResponse<byte[]> response = httpClient.send(request, HttpResponse.BodyHandlers.ofByteArray());
            if (response.statusCode() < 200 || response.statusCode() >= 300)
            {
                return url;
            }
            return FileUtils.writeBytes(response.body(), RuoYiConfig.getUploadPath());
        }
        catch (IllegalArgumentException | IOException e)
        {
            return url;
        }
    }

    private boolean containsRemoteHttpUrl(String urls)
    {
        for (String url : parseUrls(urls))
        {
            if (isRemoteHttpUrl(url))
            {
                return true;
            }
        }
        return false;
    }

    private List<String> parseUrls(String urls)
    {
        List<String> result = new ArrayList<>();
        if (StringUtils.isBlank(urls))
        {
            return result;
        }
        for (String url : StringUtils.split(urls, ','))
        {
            if (StringUtils.isNotBlank(url))
            {
                result.add(url.trim());
            }
        }
        return result;
    }

    private boolean isRemoteHttpUrl(String url)
    {
        String value = StringUtils.trimToEmpty(url);
        return StringUtils.startsWithIgnoreCase(value, "http://")
                || StringUtils.startsWithIgnoreCase(value, "https://");
    }

    private int normalizePoolSize(Integer poolSize)
    {
        if (poolSize == null)
        {
            return 2;
        }
        return Math.max(1, Math.min(8, poolSize.intValue()));
    }

    @PreDestroy
    public void shutdown()
    {
        executorService.shutdown();
    }
}
