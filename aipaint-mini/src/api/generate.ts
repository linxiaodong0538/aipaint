import { request } from "@/utils/request";
import { baseUrl } from "@/config/env";
import { useUserStore } from "@/store/modules/user";

export type GenerationStatus = "pending" | "processing" | "success" | "failed";

export interface CreateImageGenerationRequest {
  prompt: string;
  model: "gpt-image-2" | "gpt-image-2-vip" | "nano-banana-2" | "nano-banana-pro" | "nano-banana";
  ratio: "1:1" | "16:9" | "9:16" | "4:3" | "3:4" | "3:2" | "2:3" | "5:4" | "4:5" | "21:9" | "9:21" | "1:3" | "3:1" | "2:1" | "1:2";
  size: string;
  resolution: "1K" | "2K" | "4K";
  n: 1 | 2 | 3 | 4;
  image_urls: string[];
}

export interface CreateImageGenerationResponse {
  taskId: number;
}

export interface GenerationTask {
  taskId: number;
  prompt: string;
  model: string;
  quality: string;
  ratio: string;
  size: string;
  resolution?: string;
  imageUrls?: string;
  imageCount?: number;
  status: GenerationStatus;
  progress?: number;
  resultImageUrl?: string;
  resultImageUrls?: string[];
  previewImageUrl?: string;
  errorMessage?: string;
  creditCost?: number;
  runStartTime?: string;
  createTime?: string;
  updateTime?: string;
  finishTime?: string;
}

function resolveFileUrl(url?: string) {
  if (!url) return "";
  if (/^(https?:)?\/\//i.test(url) || url.startsWith("data:")) return url;
  if (url.startsWith("/")) return `${baseUrl}${url}`;
  return `${baseUrl}/${url}`;
}

function resolveResultImageUrls(urls?: string) {
  return (urls || "")
    .split(",")
    .map((url) => resolveFileUrl(url.trim()))
    .filter(Boolean);
}

function normalizeTaskImageUrls(task: GenerationTask) {
  const resultImageUrls = resolveResultImageUrls(task.resultImageUrl);
  return {
    ...task,
    resultImageUrl: resultImageUrls[0] || "",
    resultImageUrls,
    previewImageUrl: resolveFileUrl(task.previewImageUrl),
  };
}

export function createImageGeneration(data: CreateImageGenerationRequest) {
  return request<CreateImageGenerationResponse>({
    url: "/mini/generate/image",
    method: "POST",
    data,
  });
}

export function uploadImage(filePath: string) {
  const userStore = useUserStore();

  return new Promise<string>((resolve, reject) => {
    uni.uploadFile({
      url: `${baseUrl}/common/upload`,
      filePath,
      name: "file",
      header: userStore.token ? { Authorization: `Bearer ${userStore.token}` } : undefined,
      success(result) {
        try {
          const payload = JSON.parse(result.data || "{}") as { code?: number; msg?: string; url?: string };
          if (payload.code !== 200 || !payload.url) {
            reject(new Error(payload.msg || "图片上传失败"));
            return;
          }
          resolve(payload.url);
        } catch {
          reject(new Error("图片上传结果解析失败"));
        }
      },
      fail(error) {
        reject(new Error(error.errMsg || "图片上传失败"));
      },
    });
  });
}

export function getGenerationTask(taskId: number) {
  return request<GenerationTask>({
    url: `/mini/generate/tasks/${taskId}`,
    method: "GET",
  }).then(normalizeTaskImageUrls);
}

export function listGenerationTasks() {
  return request<GenerationTask[]>({
    url: "/mini/generate/tasks",
    method: "GET",
  }).then((tasks) => tasks.map(normalizeTaskImageUrls));
}

export function deleteGenerationTask(taskId: number) {
  return request<void>({
    url: `/mini/generate/tasks/${taskId}`,
    method: "DELETE",
  });
}
