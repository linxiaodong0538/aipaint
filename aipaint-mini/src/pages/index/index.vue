<template>
  <view class="min-h-screen bg-slate-50 px-4 pb-28 pt-12">
    <view class="mb-6">
      <text class="block text-sm font-medium text-emerald-600">uni-app starter</text>
      <text class="mt-2 block text-3xl font-bold leading-tight text-slate-950">
        Vue3 + Pinia + TailwindCSS
      </text>
      <text class="mt-3 block text-base leading-6 text-slate-600">
        面向微信小程序的 Vite 工程模板，已完成 Tailwind 小程序适配和基础业务封装。
      </text>
    </view>

    <AppCard>
      <view class="flex items-center justify-between">
        <view>
          <text class="block text-sm text-slate-500">登录状态</text>
          <text class="mt-1 block text-xl font-semibold text-slate-950">
            {{ userStore.isLogin ? "已登录" : "未登录" }}
          </text>
        </view>
        <view
          class="h-12 w-12 rounded-full bg-emerald-100 text-center text-xl font-bold leading-[48px] text-emerald-700"
        >
          {{ avatarText }}
        </view>
      </view>

      <view class="mt-4 rounded-md bg-slate-100 p-3">
        <text class="block text-sm leading-5 text-slate-600">
          当前 token：{{ userStore.token || "暂无" }}
        </text>
      </view>

      <view class="mt-4 flex gap-3">
        <button
          class="h-11 flex-1 rounded-md bg-[red] text-sm font-semibold leading-[44px] text-white"
          @tap="mockLogin"
        >
          模拟登录
        </button>
        <button
          class="h-11 flex-1 rounded-md border border-slate-300 bg-white text-sm font-semibold leading-[42px] text-slate-700"
          @tap="userStore.logout"
        >
          退出
        </button>
      </view>
    </AppCard>

    <view class="mt-4 grid grid-cols-2 gap-3">
      <AppCard v-for="item in features" :key="item.title">
        <text class="block text-2xl">{{ item.icon }}</text>
        <text class="mt-3 block text-base font-semibold text-slate-950">{{ item.title }}</text>
        <text class="mt-1 block text-sm leading-5 text-slate-500">{{ item.desc }}</text>
      </AppCard>
    </view>

    <button
      class="mt-4 h-11 w-full rounded-md bg-emerald-600 text-sm font-semibold leading-[44px] text-white"
      @tap="goTemplates"
    >
      测试路由封装
    </button>
  </view>
</template>

<script setup lang="ts">
import { computed } from "vue";
import { onShow } from "@dcloudio/uni-app";
import AppCard from "@/components/AppCard.vue";
import { routes, switchTab } from "@/utils/router";
import { setCustomTabBarIndex } from "@/utils/tabbar";
import { useUserStore } from "@/store/modules/user";

const userStore = useUserStore();

const features = [
  {
    icon: "V3",
    title: "Vue3 setup",
    desc: "使用 Composition API 编写页面逻辑。",
  },
  {
    icon: "TW",
    title: "TailwindCSS",
    desc: "通过 weapp-tailwindcss 适配小程序。",
  },
  {
    icon: "PX",
    title: "Pinia",
    desc: "已封装用户 token 和资料状态。",
  },
  {
    icon: "API",
    title: "u-ajax",
    desc: "统一 request、拦截器和错误提示。",
  },
];

const avatarText = computed(() => userStore.profile?.nickname?.slice(0, 1) || "U");

function mockLogin() {
  userStore.setToken("mock-token-20260514");
  userStore.setProfile({
    id: "1",
    nickname: "Demo User",
    avatar: "",
  });
}

function goTemplates() {
  switchTab(routes.templates);
}

onShow(() => {
  setCustomTabBarIndex(0);
});
</script>
