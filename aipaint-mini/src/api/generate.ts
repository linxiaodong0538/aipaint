import { request } from "@/utils/request";
import { baseUrl } from "@/config/env";
import { useUserStore } from "@/store/modules/user";

export type GenerationStatus = "pending" | "processing" | "success" | "failed";

export interface CreateImageGenerationRequest {
  prompt: string;
  model: "gpt-image-2" | "gpt-image-2-vip" | "nano-banana-2" | "nano-banana-pro" | "nano-banana";
  ratio: "auto" | "1:1" | "16:9" | "9:16" | "4:3" | "3:4" | "3:2" | "2:3" | "5:4" | "4:5" | "21:9" | "9:21" | "1:3" | "3:1" | "2:1" | "1:2" | "1:4" | "4:1" | "1:8" | "8:1";
  size: string;
  resolution: "1K" | "2K" | "4K";
  n: 1 | 2 | 3 | 4;
  image_urls: string[];
}

export interface CreateImageGenerationResponse {
  taskId: number;
}

export interface PolishPromptResponse {
  prompt: string;
}

export interface PolishPromptStreamOptions {
  onChunk: (chunk: string) => void;
}

type ChunkedRequestTask = UniApp.RequestTask & {
  onChunkReceived?: (callback: (result: { data: ArrayBuffer }) => void) => void;
};

export interface GenerationTaskListParams {
  status?: GenerationStatus | "visible" | "generating";
  pageNum?: number;
  pageSize?: number;
}

export interface GenerationTaskListResult {
  rows: GenerationTask[];
  total: number;
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

export function polishPrompt(prompt: string) {
  return request<PolishPromptResponse>({
    url: "/mini/generate/prompt/polish",
    method: "POST",
    timeout: 60000,
    data: { prompt },
  });
}

export function polishPromptStream(prompt: string, options: PolishPromptStreamOptions) {
  const userStore = useUserStore();
  let completed = false;
  let streamSupported = false;
  let fallbackStarted = false;
  let receivedChunk = false;

  return new Promise<string>((resolve, reject) => {
    const tokenQuery = userStore.token ? `?token=${encodeURIComponent(userStore.token)}` : "";
    let pendingSse = "";
    let fullText = "";
    const decoder = createUtf8Decoder();
    const consumeSseText = (text: string) => {
      if (!text) return;
      pendingSse += text;
      const events = pendingSse.split(/\r?\n\r?\n/);
      pendingSse = events.pop() || "";
      events.forEach((eventText) => {
        const event = parseSseEvent(eventText);
        if (!event || completed) return;
        if (event.event === "done") {
          completed = true;
          resolve(fullText);
          return;
        }
        if (event.event === "error") {
          completed = true;
          reject(new Error(event.content || "Prompt 润色失败"));
          return;
        }
        if (event.content) {
          fullText += event.content;
          options.onChunk(event.content);
        }
      });
    };
    const startFallback = () => {
      if (fallbackStarted || completed) return;
      fallbackStarted = true;
      polishPrompt(prompt)
        .then((result) => {
          const polishedPrompt = result.prompt || "";
          if (polishedPrompt) {
            options.onChunk(polishedPrompt);
          }
          resolve(polishedPrompt);
        })
        .catch(reject);
    };

    let requestTask: ChunkedRequestTask | null = null;
    requestTask = uni.request({
      url: `${baseUrl}/mini/generate/prompt/polish/stream${tokenQuery}`,
      method: "POST",
      timeout: 60000,
      enableChunked: true,
      responseType: "arraybuffer",
      header: {
        "Content-Type": "application/json",
        Accept: "*/*",
        ...(userStore.token ? { Authorization: `Bearer ${userStore.token}` } : {}),
      },
      data: JSON.stringify({ prompt }),
      success(result) {
        if (completed) return;
        if (!streamSupported) {
          startFallback();
          return;
        }
        if (result.statusCode < 200 || result.statusCode >= 300) {
          if (result.statusCode === 401) {
            userStore.logout();
          }
          reject(new Error(resolveRequestErrorMessage(result.data, result.statusCode)));
          return;
        }
        if (!receivedChunk && result.data instanceof ArrayBuffer) {
          consumeSseText(decoder(result.data));
        }
        if (!completed) {
          if (fullText) {
            completed = true;
            resolve(fullText);
            return;
          }
          if (result.statusCode === 401) {
            userStore.logout();
          }
          reject(new Error(resolveRequestErrorMessage(result.data, result.statusCode)));
        }
      },
      fail(error) {
        if (completed) return;
        if (!streamSupported) {
          startFallback();
          return;
        }
        reject(new Error(error.errMsg || "Prompt 润色失败"));
      },
    }) as ChunkedRequestTask;

    if (typeof requestTask.onChunkReceived !== "function") {
      requestTask.abort();
      startFallback();
      return;
    }

    streamSupported = true;

    requestTask.onChunkReceived((result) => {
      receivedChunk = true;
      consumeSseText(decoder(result.data));
    });
  });
}

function createUtf8Decoder() {
  if (typeof TextDecoder !== "undefined") {
    const decoder = new TextDecoder("utf-8");
    return (data: ArrayBuffer) => decoder.decode(data, { stream: true });
  }
  let pendingBytes: number[] = [];
  return (data: ArrayBuffer) => {
    const bytes = [...pendingBytes, ...Array.from(new Uint8Array(data))];
    const splitIndex = findCompleteUtf8Length(bytes);
    pendingBytes = bytes.slice(splitIndex);
    return decodeUtf8Bytes(bytes.slice(0, splitIndex));
  };
}

function findCompleteUtf8Length(bytes: number[]) {
  if (bytes.length === 0) return 0;
  let start = bytes.length - 1;
  while (start >= 0 && (bytes[start] & 0xc0) === 0x80) {
    start -= 1;
  }
  if (start < 0) return 0;

  const first = bytes[start];
  const expectedLength = first < 0x80
    ? 1
    : (first & 0xe0) === 0xc0
      ? 2
      : (first & 0xf0) === 0xe0
        ? 3
        : (first & 0xf8) === 0xf0
          ? 4
          : 1;
  return bytes.length - start < expectedLength ? start : bytes.length;
}

function decodeUtf8Bytes(bytes: number[]) {
  if (bytes.length === 0) return "";
  const escaped = bytes.map((byte) => `%${byte.toString(16).padStart(2, "0")}`).join("");
  try {
    return decodeURIComponent(escaped);
  } catch {
    return bytes.map((byte) => String.fromCharCode(byte)).join("");
  }
}

function resolveRequestErrorMessage(data: string | Record<string, unknown> | ArrayBuffer, statusCode?: number): string {
  const fallback = statusCode === 401 ? "登录已过期，请重新登录" : "Prompt 润色失败";
  if (data instanceof ArrayBuffer) {
    const text = createUtf8Decoder()(data);
    return resolveRequestErrorMessage(text, statusCode);
  }
  if (typeof data === "string") {
    try {
      return resolveRequestErrorMessage(JSON.parse(data) as Record<string, unknown>, statusCode);
    } catch {
      return data.trim() || fallback;
    }
  }
  const message = data.message || data.msg;
  return typeof message === "string" && message ? message : fallback;
}

function parseSseEvent(value: string) {
  const lines = value.split(/\r?\n/);
  let event = "message";
  const dataLines: string[] = [];
  lines.forEach((line) => {
    if (line.startsWith("event:")) {
      event = line.slice("event:".length).trim();
    }
    if (line.startsWith("data:")) {
      dataLines.push(line.slice("data:".length).trim());
    }
  });
  if (dataLines.length === 0) return null;
  try {
    const payload = JSON.parse(dataLines.join("\n")) as { content?: string };
    return {
      event,
      content: payload.content || "",
    };
  } catch {
    return {
      event,
      content: dataLines.join("\n"),
    };
  }
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

export function listGenerationTasks(params?: GenerationTaskListParams) {
  return request<GenerationTaskListResult>({
    url: "/mini/generate/tasks",
    method: "GET",
    params,
  }).then((result) => ({
    ...result,
    rows: (result.rows || []).map(normalizeTaskImageUrls),
    total: result.total || 0,
  }));
}

export function deleteGenerationTask(taskId: number) {
  return request<void>({
    url: `/mini/generate/tasks/${taskId}`,
    method: "DELETE",
  });
}
