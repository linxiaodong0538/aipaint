<template>
  <view
    class="min-h-screen bg-[var(--app-background)] px-[36rpx] pb-[220rpx] pt-[36rpx] text-[var(--app-on-surface)]"
  >
    <view class="flex flex-wrap gap-[20rpx]">
      <view
        v-for="tab in tabs"
        :key="tab.value"
        class="flex h-[64rpx] items-center justify-center rounded-full px-[28rpx] text-[24rpx] font-semibold leading-none"
        :class="
          activeTab === tab.value
            ? 'bg-black text-white shadow-[0_12rpx_24rpx_rgba(0,0,0,0.12)]'
            : 'bg-[#efefef] text-[#7d7d7d]'
        "
        @tap="activeTab = tab.value"
      >
        {{ tab.label }}
      </view>
    </view>

    <view v-if="showInProgress" class="mt-[48rpx]">
      <view class="mb-[28rpx] flex items-center gap-[12rpx]">
        <text class="w-[24rpx] text-center text-[24rpx] leading-none">🌱</text>
        <text class="text-[24rpx] font-semibold text-[#6c6c6c]">进行中</text>
      </view>

      <view class="flex flex-col gap-[28rpx]">
        <view
          v-for="item in inProgressWorks"
          :key="item.title"
          class="rounded-[28rpx] bg-white px-[24rpx] py-[24rpx] shadow-[0_24rpx_60rpx_rgba(0,0,0,0.08)]"
        >
          <view class="flex items-start justify-between">
            <view class="flex items-center gap-[20rpx]">
              <image
                :src="item.image"
                mode="aspectFill"
                class="h-[96rpx] w-[96rpx] rounded-[20rpx] bg-[#dcdcdc]"
              />
              <view class="pt-[4rpx]">
                <text class="block text-[28rpx] font-semibold leading-[36rpx] text-black">
                  {{ item.title }}
                </text>
                <text class="mt-[4rpx] block text-[22rpx] leading-[30rpx] text-[#8e8e8e]">
                  {{ item.meta }}
                </text>
              </view>
            </view>

            <text class="pt-[4rpx] text-[24rpx] font-semibold leading-[32rpx] text-black">
              {{ item.progress }}%
            </text>
          </view>

          <view class="mt-[22rpx] h-[8rpx] overflow-hidden rounded-full bg-black/10">
            <view
              class="h-full rounded-full bg-black"
              :style="{ width: `${item.progress}%` }"
            />
          </view>
        </view>
      </view>
    </view>

    <view v-if="showCompleted" class="mt-[44rpx]">
      <view class="mb-[28rpx] flex items-center gap-[12rpx]">
        <text class="w-[24rpx] text-center text-[24rpx] leading-none">✨</text>
        <text class="text-[24rpx] font-semibold text-[#6c6c6c]">已完成</text>
      </view>

      <view class="grid grid-cols-2 gap-[36rpx]">
        <view
          v-for="item in completedWorks"
          :key="item.title"
          class="overflow-hidden rounded-[28rpx] bg-white shadow-[0_24rpx_60rpx_rgba(0,0,0,0.08)]"
        >
          <image :src="item.image" mode="aspectFill" class="aspect-square w-full" />
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";

type TabValue = "all" | "generating" | "completed";

interface ProgressWork {
  title: string;
  meta: string;
  progress: number;
  image: string;
}

interface CompletedWork {
  title: string;
  image: string;
}

const tabs: Array<{ label: string; value: TabValue }> = [
  { label: "全部", value: "all" },
  { label: "生成中", value: "generating" },
  { label: "已完成", value: "completed" },
];

const activeTab = ref<TabValue>("all");

const inProgressWorks: ProgressWork[] = [
  {
    title: "未来城市概念图",
    meta: "超现实主义 • 4K",
    progress: 85,
    image: "/static/works/progress-1.jpg",
  },
  {
    title: "极简建筑摄影",
    meta: "包豪斯风格 • 8K",
    progress: 42,
    image: "/static/works/progress-2.jpg",
  },
];

const completedWorks: CompletedWork[] = [
  { title: "无尽之梯", image: "/static/works/completed-1.jpg" },
  { title: "丝绸之舞", image: "/static/works/completed-2.jpg" },
  { title: "静谧", image: "/static/works/completed-3.jpg" },
  { title: "折射", image: "/static/works/completed-4.jpg" },
];

const showInProgress = computed(
  () => activeTab.value === "all" || activeTab.value === "generating",
);

const showCompleted = computed(
  () => activeTab.value === "all" || activeTab.value === "completed",
);
</script>
