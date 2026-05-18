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
      uni.showToast({
        title: "登录已过期，请重新登录",
        icon: "none",
      });
      return Promise.reject(payload);
    }

    if (code !== 0 && code !== 200) {
      uni.showToast({
        title: message,
        icon: "none",
      });

      return Promise.reject(payload);
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
      uni.showToast({
        title: "登录已过期，请重新登录",
        icon: "none",
      });
      return Promise.reject(error);
    }
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
