<template>
  <view class="min-h-screen bg-slate-50 px-4 pb-28 pt-12">
    <text class="block text-sm font-medium text-emerald-600">Works</text>
    <text class="mt-2 block text-3xl font-bold text-slate-950">作品</text>
    <text class="mt-3 block text-base leading-6 text-slate-600">
      这里可以放置用户生成结果、草稿和历史作品。
    </text>

    <view class="mt-6 grid grid-cols-2 gap-3">
      <view
        v-for="item in works"
        :key="item"
        class="aspect-square rounded-lg bg-white p-3 shadow-sm"
      >
        <view class="h-full rounded-md bg-slate-100" />
        <text class="mt-2 block text-sm font-medium text-slate-700">{{ item }}</text>
      </view>
    </view>
    <AppTabBar active="works" />
  </view>
</template>

<script setup lang="ts">
import AppTabBar from "@/components/AppTabBar.vue";

const works = ["Work 01", "Work 02", "Work 03", "Work 04"];
</script>
