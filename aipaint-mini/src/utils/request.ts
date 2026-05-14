import ajax, {
  type AjaxRequestConfig,
  type AjaxResponse,
} from "@/uni_modules/u-ajax/js_sdk";

import { useUserStore } from "@/store/modules/user";

export interface ApiResponse<T = unknown> {
  code: number;
  message: string;
  data: T;
}

const BASE_URL = import.meta.env.VITE_API_BASE_URL || "https://example.com/api";

const service = ajax.create({
  baseURL: BASE_URL,
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

    if (payload && typeof payload.code === "number" && payload.code !== 0) {
      uni.showToast({
        title: payload.message || "请求失败",
        icon: "none",
      });

      return Promise.reject(payload);
    }

    return payload?.data ?? (response.data as T);
  },
  (error) => {
    uni.showToast({
      title: error?.errMsg || "网络异常，请稍后再试",
      icon: "none",
    });

    return Promise.reject(error);
  },
);

export function request<T = unknown>(config: AjaxRequestConfig): Promise<T> {
  return service<T, T>(config);
}

export default service;
