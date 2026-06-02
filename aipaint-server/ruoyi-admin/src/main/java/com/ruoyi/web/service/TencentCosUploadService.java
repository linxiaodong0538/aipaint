package com.ruoyi.web.service;

import java.io.IOException;
import java.io.InputStream;
import java.io.ByteArrayInputStream;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import com.qcloud.cos.COSClient;
import com.qcloud.cos.ClientConfig;
import com.qcloud.cos.auth.BasicCOSCredentials;
import com.qcloud.cos.auth.COSCredentials;
import com.qcloud.cos.model.ObjectMetadata;
import com.qcloud.cos.model.PutObjectRequest;
import com.qcloud.cos.region.Region;
import com.ruoyi.common.exception.file.InvalidExtensionException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.file.FileUploadUtils;
import com.ruoyi.common.utils.file.FileTypeUtils;
import com.ruoyi.common.utils.file.MimeTypeUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.web.config.TencentCosProperties;

/**
 * 腾讯云 COS 上传服务。
 */
@Service
public class TencentCosUploadService
{
    private final TencentCosProperties properties;

    public TencentCosUploadService(TencentCosProperties properties)
    {
        this.properties = properties;
    }

    public boolean isConfigured()
    {
        return properties.isConfigured();
    }

    public CosUploadResult upload(MultipartFile file) throws IOException, InvalidExtensionException
    {
        if (!isConfigured())
        {
            throw new IllegalStateException("腾讯云 COS 未配置");
        }

        FileUploadUtils.assertAllowed(file, MimeTypeUtils.DEFAULT_ALLOWED_EXTENSION);
        String extension = FileUploadUtils.getExtension(file);
        String objectKey = StringUtils.format("upload/{}/{}.{}", DateUtils.datePath(), IdUtils.fastSimpleUUID(), extension);
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(file.getSize());
        if (StringUtils.isNotBlank(file.getContentType()))
        {
            metadata.setContentType(file.getContentType());
        }

        COSClient cosClient = createClient();
        try (InputStream inputStream = file.getInputStream())
        {
            PutObjectRequest request = new PutObjectRequest(properties.getBucketName(), objectKey, inputStream, metadata);
            cosClient.putObject(request);
        }
        finally
        {
            cosClient.shutdown();
        }

        String url = properties.getBaseUrl().replaceAll("/+$", "") + "/" + objectKey;
        return new CosUploadResult(url, "/" + objectKey, objectKey.substring(objectKey.lastIndexOf("/") + 1));
    }

    public CosUploadResult uploadBytes(byte[] data, String contentType) throws IOException
    {
        if (!isConfigured())
        {
            throw new IllegalStateException("腾讯云 COS 未配置");
        }
        if (data == null || data.length == 0)
        {
            throw new IllegalArgumentException("上传内容不能为空");
        }

        String extension = resolveExtension(data, contentType);
        String objectKey = StringUtils.format("upload/{}/{}.{}", DateUtils.datePath(), IdUtils.fastSimpleUUID(), extension);
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(data.length);
        if (StringUtils.isNotBlank(contentType))
        {
            metadata.setContentType(contentType);
        }

        COSClient cosClient = createClient();
        try (InputStream inputStream = new ByteArrayInputStream(data))
        {
            PutObjectRequest request = new PutObjectRequest(properties.getBucketName(), objectKey, inputStream, metadata);
            cosClient.putObject(request);
        }
        finally
        {
            cosClient.shutdown();
        }

        String url = properties.getBaseUrl().replaceAll("/+$", "") + "/" + objectKey;
        return new CosUploadResult(url, "/" + objectKey, objectKey.substring(objectKey.lastIndexOf("/") + 1));
    }

    private String resolveExtension(byte[] data, String contentType)
    {
        String extension = MimeTypeUtils.getExtension(StringUtils.defaultString(contentType));
        if (StringUtils.isNotBlank(extension))
        {
            return extension;
        }
        return StringUtils.defaultIfBlank(FileTypeUtils.getFileExtendName(data), "jpg").toLowerCase();
    }

    private COSClient createClient()
    {
        COSCredentials credentials = new BasicCOSCredentials(properties.getSecretId(), properties.getSecretKey());
        ClientConfig clientConfig = new ClientConfig(new Region(properties.getRegion()));
        return new COSClient(credentials, clientConfig);
    }

    public static class CosUploadResult
    {
        private final String url;

        private final String fileName;

        private final String newFileName;

        public CosUploadResult(String url, String fileName, String newFileName)
        {
            this.url = url;
            this.fileName = fileName;
            this.newFileName = newFileName;
        }

        public String getUrl()
        {
            return url;
        }

        public String getFileName()
        {
            return fileName;
        }

        public String getNewFileName()
        {
            return newFileName;
        }
    }
}
