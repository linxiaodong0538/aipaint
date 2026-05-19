<template>
  <view class="min-h-screen bg-[#fafafa] font-sans text-[#1a1c1c]">
    <scroll-view :style="{ height: `${scrollViewHeight}px` }" scroll-y enhanced :show-scrollbar="false">
      <view
        class="mx-auto max-w-[750rpx] px-[30rpx] pt-[24rpx] pb-[32rpx]"
      >
        <!-- 参考图片 -->
        <view class="mb-[36rpx]">
          <view class="mb-[16rpx] flex items-center justify-between px-[2rpx]">
            <text class="text-[28rpx] font-normal leading-[38rpx] text-[#5f5e5e]">参考图片</text>
            <text class="text-[22rpx] leading-[30rpx] text-[#9a9495]">1张, 5MB以内</text>
          </view>
          <view
            class="flex h-[264rpx] flex-col items-center justify-center overflow-hidden rounded-[34rpx] border-[3rpx] border-dashed border-[#d8cccc] bg-white active:scale-[0.99]"
            @tap="chooseImage"
          >
            <image v-if="referenceImage" class="h-full w-full" mode="aspectFill" :src="referenceImage" />
            <view v-else class="flex flex-col items-center">
              <view class="relative flex h-[58rpx] w-[58rpx] items-center justify-center">
                <text class="iconfont icon-images text-[42rpx] leading-none text-[#8a8485]" />
                <view
                  class="absolute -right-[2rpx] -top-[2rpx] flex h-[22rpx] w-[22rpx] items-center justify-center rounded-full bg-white"
                >
                  <text class="text-[22rpx] font-bold leading-none text-[#8a8485]">+</text>
                </view>
              </view>
              <text class="mt-[12rpx] text-[24rpx] font-medium leading-[32rpx] text-[#4c4546]">点击上传图片</text>
            </view>
          </view>
        </view>

        <!-- 画面描述 -->
        <view class="mb-[34rpx]">
          <text class="mb-[18rpx] block px-[2rpx] text-[28rpx] font-normal leading-[38rpx] text-[#5f5e5e]">
            画面描述
          </text>
          <view class="overflow-hidden rounded-[38rpx] bg-white shadow-[0_28rpx_56rpx_rgba(0,0,0,0.05)]">
            <textarea
              v-model="prompt"
              class="box-border min-h-[224rpx] w-full px-[28rpx] pt-[30rpx] pb-[18rpx] text-[32rpx] font-semibold leading-[46rpx] text-black"
              maxlength="1000"
              placeholder="描述你想要的画面..."
              placeholder-class="text-[#b5b0b1]"
            />
            <view class="mx-[28rpx] flex items-center justify-between border-t border-[#ebe6e7] py-[20rpx]">
              <button class="flex items-center gap-[10rpx] bg-transparent p-0 active:opacity-70" @tap="useRandomPrompt">
                <text class="iconfont icon-shanshan text-[28rpx] leading-none text-black" />
                <text class="text-[30rpx] font-bold leading-[38rpx] text-black">Prompt</text>
              </button>
              <view class="flex items-center gap-[18rpx]">
                <view class="h-[34rpx] w-[2rpx] bg-[#f0eeee]" />
                <text class="text-[22rpx] font-semibold leading-[30rpx] text-[#aaa4a5]">支持中英文</text>
              </view>
            </view>
          </view>
        </view>

        <!-- AI 模型 -->
        <view class="mb-[34rpx]">
          <text class="mb-[16rpx] block px-[2rpx] text-[28rpx] font-normal leading-[38rpx] text-[#5f5e5e]">
            AI 模型
          </text>
          <view class="flex flex-col gap-[14rpx]">
            <button
              v-for="item in models"
              :key="item.value"
              class="flex h-[104rpx] items-center justify-between rounded-[24rpx] border px-[20rpx] active:scale-[0.99]"
              :class="
                model === item.value
                  ? 'border-black bg-black shadow-[0_12rpx_28rpx_rgba(0,0,0,0.14)]'
                  : 'border-[#f1eeee] bg-[#f5f5f5]'
              "
              @tap="model = item.value"
            >
              <view class="flex items-center gap-[20rpx] text-left">
                <view
                  class="flex h-[72rpx] w-[72rpx] shrink-0 items-center justify-center rounded-[18rpx]"
                  :class="model === item.value ? 'bg-[rgba(255,255,255,0.14)]' : 'bg-white'"
                >
                  <text
                    class="iconfont text-[36rpx] leading-none"
                    :class="[item.iconClass, model === item.value ? 'text-white' : 'text-black']"
                  />
                </view>
                <view>
                  <text
                    class="block text-[28rpx] font-bold leading-[34rpx]"
                    :class="model === item.value ? 'text-white' : 'text-black'"
                  >
                    {{ item.label }}
                  </text>
                  <text
                    class="mt-[4rpx] block text-[24rpx] leading-[30rpx]"
                    :class="model === item.value ? 'text-white/65' : 'text-[#9a9495]'"
                  >
                    {{ item.description }}
                  </text>
                </view>
              </view>
              <view
                class="flex h-[40rpx] w-[40rpx] shrink-0 items-center justify-center rounded-full border-[3rpx]"
                :class="
                  model === item.value
                    ? 'border-white bg-white'
                    : 'border-[#d5d0d1] bg-transparent'
                "
              >
                <text
                  v-if="model === item.value"
                  class="text-[22rpx] font-bold leading-none text-black"
                >
                  ✓
                </text>
              </view>
            </button>
          </view>
        </view>

        <!-- 质量 -->
        <view class="mb-[34rpx]">
          <text class="mb-[16rpx] block px-[2rpx] text-[28rpx] font-normal leading-[38rpx] text-[#5f5e5e]">
            质量
          </text>
          <view class="flex gap-[16rpx]">
            <button
              v-for="item in qualities"
              :key="item"
              class="h-[64rpx] flex-1 rounded-[14rpx] border text-[26rpx] font-normal leading-[64rpx] active:scale-95"
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

        <!-- 生成数量 -->
        <view class="mb-[34rpx]">
          <text class="mb-[16rpx] block px-[2rpx] text-[28rpx] font-normal leading-[38rpx] text-[#5f5e5e]">
            生成数量
          </text>
          <view class="flex gap-[8rpx] rounded-[20rpx] bg-[#e8e8e8] p-[8rpx]">
            <button
              v-for="item in counts"
              :key="item"
              class="h-[52rpx] flex-1 rounded-[14rpx] text-[26rpx] font-normal leading-[52rpx] active:scale-95"
              :class="
                count === item
                  ? 'bg-white text-black shadow-[0_4rpx_12rpx_rgba(0,0,0,0.1)]'
                  : 'text-[#4c4546]'
              "
              @tap="count = item"
            >
              {{ item }}
            </button>
          </view>
        </view>

        <!-- 画面比例 -->
        <view>
          <text class="mb-[18rpx] block px-[2rpx] text-[28rpx] font-normal leading-[38rpx] text-[#5f5e5e]">
            画面比例
          </text>
          <view class="grid grid-cols-4 gap-[18rpx]">
            <button
              v-for="item in ratios"
              :key="item.value"
              class="flex aspect-square flex-col items-center justify-center gap-[12rpx] rounded-[22rpx] border-[2rpx] active:scale-95"
              :class="
                ratio === item.value
                  ? 'border-[4rpx] border-black bg-[rgba(0,0,0,0.04)]'
                  : 'border-[#d5d0d1] bg-white'
              "
              @tap="ratio = item.value"
            >
              <view
                class="rounded-[4rpx] bg-[#c8c4c5]"
                :class="item.iconClass"
              />
              <text class="text-[20rpx] font-bold leading-[26rpx] text-black">{{ item.value }}</text>
            </button>
          </view>
        </view>
      </view>
    </scroll-view>

    <!-- 底部操作栏 -->
    <view
      class="fixed inset-x-0 bottom-0 z-50 bg-[#fafafa] px-[30rpx] pt-[22rpx]"
      :style="{ paddingBottom: `calc(28rpx + ${safeAreaBottom}px)` }"
    >
      <view
        class="mx-auto flex max-w-[750rpx] items-center justify-between rounded-[34rpx] bg-white px-[28rpx] py-[24rpx] shadow-[0_-8rpx_40rpx_rgba(0,0,0,0.08)]"
      >
        <view class="flex flex-col">
          <view class="flex items-center gap-[8rpx]">
            <text class="iconfont icon-wodejifen text-[32rpx] leading-none text-black" />
            <text class="text-[44rpx] font-bold leading-[52rpx] tracking-[-1rpx] text-black">
              {{ creditCost }}
            </text>
          </view>
          <text class="mt-[2rpx] text-[22rpx] font-medium leading-[30rpx] text-[#5f5e5e]">预计消耗</text>
        </view>
        <button
          class="flex h-[96rpx] items-center justify-center gap-[12rpx] rounded-[24rpx] bg-black px-[72rpx] active:scale-95"
          @tap="handleGenerate"
        >
          <text class="text-[32rpx] font-bold leading-none text-white">立即生成</text>
          <text class="iconfont icon-shanshan text-[28rpx] leading-none text-white" />
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
    iconClass: "icon-images",
  },
  {
    value: "pro",
    label: "Pro Model",
    description: "顶级写实，高精度",
    iconClass: "icon-ewailichengjiangli",
  },
  {
    value: "v2.4",
    label: "V2.4",
    description: "二次元插画专属",
    iconClass: "icon-shanshan",
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

const bottomBarHeight = computed(() => rpxToPx(194) + safeAreaBottom.value);
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
