<template>
  <view class="min-h-screen bg-[#f9f9f9] font-sans text-[#1a1c1c]">
    <scroll-view :style="{ height: `${scrollViewHeight}px` }" scroll-y enhanced :show-scrollbar="false">
      <view
        class="mx-auto max-w-[750rpx] px-[32rpx] pb-[32rpx] mt-[36rpx]"
      >
        <!-- 参考图片 -->
        <view class="mb-[32rpx]">
          <view class="mb-[16rpx] flex items-end justify-between px-[12rpx]">
            <text class="text-[26rpx] font-semibold leading-[32rpx] tracking-[4rpx] text-[#5f5e5e]">参考图片</text>
            <text class="text-[24rpx] leading-[28rpx] text-[#7e7576]">1张, 5MB以内</text>
          </view>
          <view
            class="flex h-[192rpx] flex-col items-center justify-center gap-[8rpx] overflow-hidden rounded-[48rpx] border-[4rpx] border-dashed border-[#cfc4c5] bg-white active:scale-[0.99]"
            @tap="chooseImage"
          >
            <image v-if="referenceImage" class="h-full w-full" mode="aspectFill" :src="referenceImage" />
            <view v-else class="flex flex-col items-center">
              <view class="relative flex h-[40rpx] w-[40rpx] items-center justify-center">
                <text class="iconfont icon-icon_paizhaoshangchuan leading-none"  style="font-size: 42rpx;"/>
              </view>
              <text class="mt-[8rpx] text-[22rpx] font-medium leading-[32rpx] tracking-[2rpx] text-[#4c4546]">点击上传图片</text>
            </view>
          </view>
        </view>

        <!-- 画面描述 -->
        <view class="mb-[32rpx]">
          <text class="mb-[16rpx] block px-[8rpx] text-[26rpx] font-semibold leading-[32rpx] tracking-[4rpx] text-[#5f5e5e]">
            画面描述
          </text>
          <view class="overflow-hidden rounded-[48rpx] border border-[rgba(255,255,255,0.3)] bg-[rgba(255,255,255,0.8)] p-[24rpx] shadow-[0_20rpx_40rpx_rgba(0,0,0,0.05)] backdrop-blur-[40rpx]">
            <textarea
              v-model="prompt"
              class="box-border h-[200rpx] w-full bg-transparent px-[8rpx] text-[24rpx] font-normal leading-[44rpx] text-black"
              maxlength="1000"
              placeholder="描述你想要的画面..."
              placeholder-class="generate-prompt-placeholder"
            />
            <view class="mt-[16rpx] flex items-center justify-between border-t border-[rgba(207,196,197,0.3)] pt-[16rpx]">
              <button class="flex items-center gap-[12rpx] bg-transparent p-0 active:opacity-70" @tap="useRandomPrompt">
                <text class="iconfont icon-shanshan text-[28rpx] leading-none text-black" />
                <text class="text-[28rpx] font-medium leading-[40rpx] text-black">Prompt</text>
              </button>
              <view class="flex items-center gap-[16rpx]">
                <view class="h-[24rpx] w-[2rpx] bg-[rgba(207,196,197,0.3)]" />
                <text class="text-[22rpx] leading-[28rpx] tracking-[2rpx] text-[#7e7576]">支持中英文</text>
              </view>
            </view>
          </view>
        </view>

        <!-- AI 模型 -->
        <view class="mb-[32rpx]">
          <text class="mb-[16rpx] block px-[8rpx] text-[26rpx] font-semibold leading-[32rpx] tracking-[4rpx] text-[#5f5e5e]">
            AI 模型
          </text>
          <view class="flex flex-col gap-[18rpx]">
            <button
              v-for="item in models"
              :key="item.value"
              class="flex items-center justify-between rounded-[24rpx] border py-[18rpx] px-[16rpx] active:scale-[0.99]"
              :class="
                model === item.value
                  ? 'border-black bg-black text-white shadow-[0_16rpx_32rpx_rgba(0,0,0,0.1)]'
                  : 'border-transparent bg-[#e8e8e8] text-black'
              "
              @tap="model = item.value"
            >
              <view class="flex items-center gap-[24rpx] text-left">
                <view
                  class="flex h-[64rpx] w-[64rpx] shrink-0 items-center justify-center rounded-[16rpx]"
                  :class="model === item.value ? 'bg-[rgba(255,255,255,0.1)]' : 'bg-white shadow-[0_4rpx_12rpx_rgba(0,0,0,0.04)]'"
                >
                  <text
                    class="iconfont text-[36rpx] leading-none"
                    style="font-size: 36rpx;"
                    :class="[item.iconClass, model === item.value ? 'text-white' : 'text-[#5f5e5e]']"
                  />
                </view>
                <view class="grid gap-y-[8rpx]">
                  <text
                    class="block text-[26rpx] font-semibold leading-[32rpx]"
                    :class="model === item.value ? 'text-white' : 'text-black'"
                  >
                    {{ item.label }}
                  </text>
                  <text
                    class="block text-[22rpx] leading-[28rpx]"
                    :class="model === item.value ? 'text-white/70' : 'text-[#7e7576]'"
                  >
                    {{ item.description }}
                  </text>
                </view>
              </view>
              <view
                class="flex h-[36rpx] w-[36rpx] shrink-0 items-center justify-center rounded-full border-[4rpx]"
                :class="
                  model === item.value
                    ? 'border-white bg-transparent'
                    : 'border-[#7e7576] bg-transparent'
                "
              >
                <text
                  v-if="model === item.value"
                  class="text-[22rpx] font-bold leading-none text-white iconfont icon-gou2x"
                  style="font-size: 28rpx;"
                >
                </text>
              </view>
            </button>
          </view>
        </view>

        <!-- 质量 -->
        <view class="mb-[32rpx]">
          <text class="mb-[16rpx] block px-[8rpx] text-[26rpx] font-semibold leading-[32rpx] tracking-[4rpx] text-[#5f5e5e]">
            质量
          </text>
          <view class="flex gap-[16rpx]">
            <button
              v-for="item in qualities"
              :key="item"
              class="h-[60rpx] flex-1 rounded-[16rpx] border text-[24rpx] leading-[60rpx] active:scale-95"
              :class="
                quality === item
                  ? 'border-black bg-black text-white'
                  : 'border-[#d5d0d1] bg-white text-black'
              "
              @tap="quality = item"
            >
              {{ item }}
            </button>
          </view>
        </view>

        <!-- 画面比例 -->
        <view>
          <text class="mb-[16rpx] block px-[8rpx] text-[26rpx] font-semibold leading-[32rpx] tracking-[4rpx] text-[#5f5e5e]">
            画面比例
          </text>
          <view class="grid grid-cols-4 gap-[16rpx]">
            <button
              v-for="item in ratios"
              :key="item.value"
              class="flex aspect-square flex-col items-center justify-center gap-[8rpx] rounded-[24rpx] border active:scale-95"
              :class="
                ratio === item.value
                  ? 'border-[4rpx] border-black bg-[rgba(0,0,0,0.05)]'
                  : 'border-[#cfc4c5] bg-transparent'
              "
              @tap="ratio = item.value"
            >
              <view
                class="rounded-[4rpx] bg-[#c8c4c5]"
                :class="item.iconClass"
              />
              <text class="text-[24rpx] font-bold leading-[24rpx] text-black">{{ item.value }}</text>
            </button>
          </view>
        </view>
      </view>
    </scroll-view>

    <!-- 底部操作栏 -->
    <view
      class="fixed inset-x-0 bottom-0 z-50 bg-[#f9f9f9] p-[32rpx]"
      :style="{ paddingBottom: `calc(32rpx + ${safeAreaBottom}px)` }"
    >
      <view
        class="mx-auto flex max-w-[750rpx] items-center justify-between rounded-[24rpx] border border-[rgba(255,255,255,0.3)] bg-[rgba(255,255,255,0.8)] p-[24rpx] shadow-[0_-30rpx_80rpx_rgba(0,0,0,0.08)] backdrop-blur-[40rpx]"
      >
        <view class="grid flex-col  gap-y-[10rpx]">
          <view class="flex items-center gap-[8rpx]">
            <text class="iconfont icon-Abstract_mofang_cube-two" style="font-size: 42rpx;"/>
            <text class="text-[40rpx] font-bold leading-[48rpx] tracking-[-1rpx] text-black">
              {{ creditCost }}
            </text>
          </view>
          <text class="text-[20rpx] font-medium leading-[28rpx] tracking-[2rpx] text-[#5f5e5e]">预计消耗</text>
        </view>
        <button
          class="flex h-[96rpx] items-center justify-center gap-[12rpx] rounded-[24rpx] bg-black px-[80rpx] shadow-[0_12rpx_28rpx_rgba(0,0,0,0.16)] active:scale-95"
          @tap="handleGenerate"
        >
          <text class="text-[30rpx] font-bold leading-none text-white">立即生成</text>
          <text class="iconfont icon-shanshan text-[32rpx] leading-none text-white" style="font-size: 36rpx;"/>
        </button>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { navigateBack, routes, switchTab } from "@/utils/router";

const prompts = [
  "未来城市中的玻璃花园，清晨柔光，电影感构图，高级灰色调",
  "水墨山谷中的白色建筑，云雾缭绕，留白构图，细腻纸张纹理",
  "赛博街区的雨夜橱窗，霓虹反射，广角摄影，超现实氛围",
];

const models = [
  {
    value: "g-image-2",
    label: "G Image 2",
    description: "极速通用艺术风格",
    iconClass: "icon-tupian",
  },
  {
    value: "pro",
    label: "Pro Model",
    description: "顶级写实，高精度",
    iconClass: "icon-huizhang",
  },
  {
    value: "v2.4",
    label: "V2.4",
    description: "二次元插画专属",
    iconClass: "icon-MaterialSymbolsBrush",
  },
];

const qualities = ["1K", "2K", "4K"] as const;
const counts = [1, 2, 3, 4] as const;
const ratios = [
  { value: "1:1", iconClass: "h-[32rpx] w-[32rpx]" },
  { value: "4:3", iconClass: "h-[28rpx] w-[38rpx]" },
  { value: "3:2", iconClass: "h-[26rpx] w-[40rpx]" },
  { value: "16:9", iconClass: "h-[22rpx] w-[48rpx]" },
] as const;

const statusBarHeight = ref(0);
const safeAreaBottom = ref(0);
const windowHeight = ref(0);
const windowWidth = ref(375);
const headerHeight = computed(() => statusBarHeight.value + rpxToPx(96));

try {
  const info = uni.getSystemInfoSync();
  statusBarHeight.value = info.statusBarHeight || 0;
  safeAreaBottom.value = info.safeAreaInsets?.bottom || 0;
  windowHeight.value = info.windowHeight || 0;
  windowWidth.value = info.windowWidth || 375;
} catch {
  statusBarHeight.value = 0;
  safeAreaBottom.value = 0;
  windowHeight.value = 0;
  windowWidth.value = 375;
}

const prompt = ref("");
const referenceImage = ref("");
const model = ref<(typeof models)[number]["value"]>("pro");
const quality = ref<(typeof qualities)[number]>("2K");
const count = ref<(typeof counts)[number]>(3);
const ratio = ref<(typeof ratios)[number]["value"]>("4:3");

const creditCost = computed(() => {
  const qualityFactor: Record<(typeof qualities)[number], number> = {
    "1K": 1,
    "2K": 2,
    "4K": 4,
  };
  const modelFactor: Record<(typeof models)[number]["value"], number> = {
    "g-image-2": 1,
    pro: 2,
    "v2.4": 1,
  };
  return qualityFactor[quality.value] * modelFactor[model.value] + count.value + 1;
});

const bottomBarHeight = computed(() => rpxToPx(184) + safeAreaBottom.value);
const scrollViewHeight = computed(() => {
  if (!windowHeight.value) return 0;
  return Math.max(0, windowHeight.value - bottomBarHeight.value);
});

function rpxToPx(rpx: number) {
  return (windowWidth.value / 750) * rpx;
}

function useRandomPrompt() {
  const currentIndex = prompts.indexOf(prompt.value);
  prompt.value = prompts[(currentIndex + 1) % prompts.length];
}

function chooseImage() {
  uni.chooseImage({
    count: 1,
    sizeType: ["compressed"],
    sourceType: ["album", "camera"],
    success(result) {
      referenceImage.value = result.tempFilePaths[0] || "";
    },
  });
}

function goHistory() {
  switchTab(routes.works);
}

function handleGenerate() {
  if (!prompt.value.trim()) {
    uni.showToast({ title: "请输入画面描述", icon: "none" });
    return;
  }

  uni.showToast({ title: "生成任务已提交", icon: "none" });
}
</script>

<style>
.generate-prompt-placeholder {
  color: #9ca3af !important;
  font-size: 32rpx !important;
  line-height: 48rpx !important;
}
</style>
