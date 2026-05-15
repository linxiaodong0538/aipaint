<template>
  <view class="min-h-screen bg-slate-50 px-4 pb-28 pt-12">
    <text class="block text-sm font-medium text-emerald-600">Me</text>
    <text class="mt-2 block text-3xl font-bold text-slate-950">我的</text>

    <AppCard class="mt-6">
      <view class="flex items-center gap-4">
        <view class="h-14 w-14 rounded-full bg-slate-950 text-center text-xl font-bold leading-[56px] text-white">
          {{ userStore.profile?.nickname?.slice(0, 1) || "U" }}
        </view>
        <view>
          <text class="block text-lg font-semibold text-slate-950">
            {{ userStore.profile?.nickname || "未登录用户" }}
          </text>
          <text class="mt-1 block text-sm text-slate-500">
            {{ userStore.isLogin ? "账号已登录" : "点击首页模拟登录" }}
          </text>
        </view>
      </view>
    </AppCard>
  </view>
</template>

<script setup lang="ts">
import AppCard from "@/components/AppCard.vue";
import { useUserStore } from "@/store/modules/user";

const userStore = useUserStore();
</script>
