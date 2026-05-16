import { request } from "@/utils/request";
import type { UserProfile } from "@/store/modules/user";

export interface LoginParams {
  code: string;
}

export interface LoginResult {
  token: string;
  user: UserProfile;
}

export function login(params: LoginParams) {
  return request<LoginResult>({
    url: "/auth/wechat-login",
    method: "POST",
    data: params,
  });
}

export function getUserProfile() {
  return request<UserProfile>({
    url: "/auth/profile",
    method: "GET",
  });
}
