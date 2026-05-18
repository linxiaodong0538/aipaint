import { defineStore } from "pinia";
import { getUserProfile, login } from "@/api/user";

export interface UserProfile {
  id: string;
  nickname: string;
  avatar: string;
}

interface UserState {
  token: string;
  profile: UserProfile | null;
  loggingIn: boolean;
}

export const useUserStore = defineStore("user", {
  state: (): UserState => ({
    token: uni.getStorageSync("token") || "",
    profile: uni.getStorageSync("profile") || null,
    loggingIn: false,
  }),
  getters: {
    isLogin: (state) => Boolean(state.token),
  },
  actions: {
    setToken(token: string) {
      this.token = token;
      uni.setStorageSync("token", token);
    },
    setProfile(profile: UserProfile | null) {
      this.profile = profile;
      if (profile) {
        uni.setStorageSync("profile", profile);
      } else {
        uni.removeStorageSync("profile");
      }
    },
    async loginWithWechat() {
      if (this.loggingIn) {
        return;
      }

      this.loggingIn = true;
      try {
        uni.removeStorageSync("token");
        const loginResult = await uni.login({ provider: "weixin" });
        const code = loginResult.code;

        if (!code) {
          throw new Error("微信登录凭证获取失败");
        }

        const result = await login({ code });
        this.setToken(result.token);
        this.setProfile(result.user);
        uni.showToast({ title: "登录成功", icon: "success" });
      } catch (error) {
        const message =
          error instanceof Error ? error.message : "登录失败，请稍后再试";
        uni.showToast({ title: message, icon: "none" });
        throw error;
      } finally {
        this.loggingIn = false;
      }
    },
    async fetchProfile() {
      if (!this.token) {
        return null;
      }

      const profile = await getUserProfile();
      this.setProfile(profile);
      return profile;
    },
    logout() {
      this.token = "";
      this.profile = null;
      uni.removeStorageSync("token");
      uni.removeStorageSync("profile");
    },
  },
});
