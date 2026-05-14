<template>
  <view class="min-h-screen bg-slate-50 px-4 pb-28 pt-12">
    <text class="block text-sm font-medium text-emerald-600">Templates</text>
    <text class="mt-2 block text-3xl font-bold text-slate-950">模板中心</text>
    <text class="mt-3 block text-base leading-6 text-slate-600">
      当前 Tab 采用自定义 TabBar，高亮态与截图一致使用黑色圆角胶囊。
    </text>

    <view class="mt-6 grid gap-3">
      <AppCard v-for="item in templates" :key="item.title">
        <view class="flex items-center justify-between">
          <view>
            <text class="block text-base font-semibold text-slate-950">{{ item.title }}</text>
            <text class="mt-1 block text-sm text-slate-500">{{ item.desc }}</text>
          </view>
          <text class="text-sm font-medium text-emerald-600">Use</text>
        </view>
      </AppCard>
    </view>
  </view>
</template>

<script setup lang="ts">
import { onShow } from "@dcloudio/uni-app";
import AppCard from "@/components/AppCard.vue";
import { setCustomTabBarIndex } from "@/utils/tabbar";

const templates = [
  {
    title: "社媒海报",
    desc: "适合生成活动宣传图。",
  },
  {
    title: "商品主图",
    desc: "用于电商图片快速成稿。",
  },
  {
    title: "头像风格",
    desc: "生成统一视觉头像。",
  },
];

onShow(() => {
  setCustomTabBarIndex(1);
});
</script>
