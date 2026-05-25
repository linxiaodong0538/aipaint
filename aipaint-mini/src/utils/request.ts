import ajax, {
  type AjaxRequestConfig,
  type AjaxResponse,
} from "@/uni_modules/u-ajax/js_sdk";

import { useUserStore } from "@/store/modules/user";
import { baseUrl } from "@/config/env";

export interface ApiResponse<T = unknown> {
  code: number;
  msg?: string;
  message: string;
  data?: T;
}

export type ApiError<T = unknown> = Error & {
  code?: number;
  data?: ApiResponse<T>;
  shown?: boolean;
};

const service = ajax.create({
  baseURL: baseUrl,
  timeout: 15000,
  header: {
    common: {
      "Content-Type": "application/json",
    },
  },
});

service.interceptors.request.use((config: AjaxRequestConfig) => {
  const userStore = useUserStore();

  if (userStore.token) {
    config.header = {
      ...config.header,
      Authorization: `Bearer ${userStore.token}`,
    };
  }

  return config;
});

service.interceptors.response.use(
  <T>(response: AjaxResponse<ApiResponse<T>>) => {
    const payload = response.data;
    const code = payload && typeof payload.code === "number" ? payload.code : 0;
    const message = payload?.message || (payload as unknown as { msg?: string })?.msg || "请求失败";

    if (code === 401) {
      const userStore = useUserStore();
      userStore.logout();
      const error = new Error("登录已过期，请重新登录") as ApiError<T>;
      error.code = 401;
      error.data = payload;
      error.shown = true;
      uni.showToast({
        title: "登录已过期，请重新登录",
        icon: "none",
      });
      return Promise.reject(error);
    }

    if (code !== 0 && code !== 200) {
      const error = new Error(message) as ApiError<T>;
      error.code = code;
      error.data = payload;
      error.shown = true;
      uni.showToast({
        title: message,
        icon: "none",
      });

      return Promise.reject(error);
    }

    if (payload && typeof payload === "object" && "data" in payload && payload.data !== undefined) {
      return (payload as ApiResponse<T>).data;
    }

    return response.data as T;
  },
  (error) => {
    if (error?.statusCode === 401) {
      const userStore = useUserStore();
      userStore.logout();
      const authError = new Error("登录已过期，请重新登录") as ApiError;
      authError.code = 401;
      authError.shown = true;
      uni.showToast({
        title: "登录已过期，请重新登录",
        icon: "none",
      });
      return Promise.reject(authError);
    }
    const message = error?.message || error?.errMsg || "网络异常，请稍后再试";
    uni.showToast({
      title: message,
      icon: "none",
    });

    if (error instanceof Error) {
      (error as ApiError).shown = true;
      return Promise.reject(error);
    }
    const normalizedError = new Error(message) as ApiError;
    normalizedError.shown = true;
    return Promise.reject(normalizedError);
  },
);

export function request<T = unknown>(config: AjaxRequestConfig): Promise<T> {
  return service<T, T>(config);
}

export default service;
