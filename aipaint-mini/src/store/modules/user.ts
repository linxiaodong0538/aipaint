import { defineStore } from "pinia";
import { getUserProfile, login } from "@/api/user";

const LOGIN_AGREEMENT_ACCEPTED_KEY = "legal:loginAgreementAccepted";

export interface UserProfile {
  id: string;
  nickname: string;
  avatar: string;
  creditBalance?: number;
  newUserGiftGranted?: boolean;
  newUserGiftExpireTime?: string;
  memberTier?: "monthly" | "pro" | "studio";
  memberAddonBonus?: number;
  memberExpireTime?: string;
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

      const accepted = uni.getStorageSync(LOGIN_AGREEMENT_ACCEPTED_KEY);
      if (!accepted) {
        const confirmResult = await uni.showModal({
          title: "登录前请阅读",
          content: "登录即表示你已阅读并同意《用户协议》和《隐私政策》。",
          cancelText: "暂不同意",
          confirmText: "同意登录",
        });
        if (!confirmResult.confirm) {
          throw new Error("请先同意用户协议和隐私政策");
        }
        uni.setStorageSync(LOGIN_AGREEMENT_ACCEPTED_KEY, "1");
      }

      this.loggingIn = true;
      try {
        uni.removeStorageSync("token");
        const loginResult = await uni.login({ provider: "weixin" });
        const code = loginResult.code;

        if (!code) {
          throw new Error("微信登录凭证获取失败");
        }

        const inviteCode = String(uni.getStorageSync("inviteCode") || "");
        const devOpenid = String(uni.getStorageSync("devOpenid") || "");
        const result = await login({
          code,
          ...(inviteCode ? { inviteCode } : {}),
          ...(devOpenid ? { devOpenid } : {}),
        });
        this.setToken(result.token);
        this.setProfile(result.user);
        if (inviteCode) {
          uni.removeStorageSync("inviteCode");
        }
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
