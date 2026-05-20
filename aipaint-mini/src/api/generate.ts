import { request } from "@/utils/request";
import { baseUrl } from "@/config/env";

export type GenerationStatus = "pending" | "processing" | "success" | "failed";

export interface CreateImageGenerationRequest {
  prompt: string;
  model: "g-image-2";
  quality: "low" | "medium" | "high";
  ratio: "1:1" | "4:3" | "3:2" | "16:9";
  referenceImageUrl?: string;
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
  status: GenerationStatus;
  resultImageUrl?: string;
  previewImageUrl?: string;
  errorMessage?: string;
  creditCost?: number;
  createTime?: string;
  finishTime?: string;
}

function resolveFileUrl(url?: string) {
  if (!url) return "";
  if (/^(https?:)?\/\//i.test(url) || url.startsWith("data:")) return url;
  if (url.startsWith("/")) return `${baseUrl}${url}`;
  return `${baseUrl}/${url}`;
}

export function createImageGeneration(data: CreateImageGenerationRequest) {
  return request<CreateImageGenerationResponse>({
    url: "/mini/generate/image",
    method: "POST",
    data,
  });
}

export function getGenerationTask(taskId: number) {
  return request<GenerationTask>({
    url: `/mini/generate/tasks/${taskId}`,
    method: "GET",
  }).then((task) => ({
    ...task,
    resultImageUrl: resolveFileUrl(task.resultImageUrl),
    previewImageUrl: resolveFileUrl(task.previewImageUrl),
  }));
}
