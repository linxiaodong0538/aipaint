import { defineStore } from "pinia";

export interface UserProfile {
  id: string;
  nickname: string;
  avatar: string;
}

interface UserState {
  token: string;
  profile: UserProfile | null;
}

export const useUserStore = defineStore("user", {
  state: (): UserState => ({
    token: uni.getStorageSync("token") || "",
    profile: null,
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
    },
    logout() {
      this.token = "";
      this.profile = null;
      uni.removeStorageSync("token");
    },
  },
});
