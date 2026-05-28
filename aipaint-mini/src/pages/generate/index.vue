<template>
  <view class="min-h-screen bg-[#f9f9f9] font-sans text-[#1a1c1c]">
    <scroll-view :style="{ height: `${scrollViewHeight}px` }" scroll-y enhanced :show-scrollbar="false">
      <view
        class="mx-auto max-w-[750rpx] px-[24rpx] pb-[32rpx] pt-[48rpx]"
      >
        <!-- 参考图片 -->
        <view class="mb-[32rpx]">
          <view class="flex items-end justify-between">
            <text class="model-section-label font-mono">参考图（可选）</text>
            <text class="model-section-label font-mono">{{ referenceImages.length }}/{{ maxReferenceImages }}</text>
          </view>
          <view
            v-if="referenceImages.length === 0"
            class="relative flex h-[192rpx] flex-col items-center justify-center gap-[8rpx] rounded-[48rpx] border-[4rpx] border-dashed border-[#cfc4c5] bg-white active:scale-[0.99]"
            @tap="chooseImage"
          >
            <view class="flex flex-col items-center">
              <view class="relative flex h-[40rpx] w-[40rpx] items-center justify-center">
                <text class="iconfont icon-icon_paizhaoshangchuan leading-none text-black/50"  style="font-size: 42rpx;"/>
              </view>
              <text class="mt-[8rpx] text-[22rpx] font-medium leading-[32rpx] tracking-[2rpx] text-black/50">点击上传图片</text>
            </view>
          </view>

          <view
            v-else
            class="reference-upload-box h-[200rpx] overflow-hidden rounded-[48rpx] border-[4rpx] border-dashed border-[#cfc4c5] bg-white px-[24rpx] py-[20rpx]"
          >
            <scroll-view
              class="h-full whitespace-nowrap"
              scroll-x
              enhanced
              :show-scrollbar="false"
            >
              <view
                v-for="(image, index) in referenceImages"
                :key="`${image}-${index}`"
                class="relative mr-[24rpx] inline-block h-[156rpx] w-[128rpx] rounded-[18rpx] border border-[rgba(0,0,0,0.08)] bg-white p-[10rpx] align-top"
              >
                <image class="h-full w-full rounded-[8rpx]" mode="aspectFill" :src="image" />
                <button
                  class="absolute right-[-16rpx] top-[-16rpx] flex h-[48rpx] w-[48rpx] items-center justify-center rounded-full bg-white p-0 shadow-[0_8rpx_20rpx_rgba(0,0,0,0.12)] active:scale-95"
                  @tap.stop="removeImage(index)"
                >
                  <text class="text-[34rpx] font-light leading-[48rpx] text-black">×</text>
                </button>
              </view>

              <button
                v-if="canAddReferenceImages"
                class="inline-flex h-[156rpx] w-[152rpx] shrink-0 flex-col items-center justify-center rounded-[18rpx] border border-dashed border-[#d5d0d1] bg-white p-0 align-top active:bg-[#f3f3f4]"
                @tap="chooseImage"
              >
                <view class="relative flex h-[44rpx] w-[44rpx] items-center justify-center">
                  <text class="iconfont icon-icon_paizhaoshangchuan leading-none text-[#7e7576]" style="font-size: 40rpx;"/>
                </view>
                <text class="mt-[10rpx] text-[24rpx] font-medium leading-[32rpx] text-[#4c4546]">继续添加</text>
              </button>
            </scroll-view>
          </view>
        </view>

        <!-- 画面描述 -->
        <view class="mb-[32rpx]">
          <text class="model-section-label font-mono">
            画面描述
          </text>
          <view class="glass-card overflow-hidden rounded-[48rpx] p-[24rpx]">
            <textarea
              v-model="prompt"
              class="box-border h-[200rpx] w-full bg-transparent px-[8rpx] text-[24rpx] font-normal leading-[44rpx] text-black"
              maxlength="2000"
              placeholder="描述你想要的画面..."
              placeholder-class="generate-prompt-placeholder"
            />
            <view class="mt-[16rpx] flex items-center justify-between border-t border-[rgba(207,196,197,0.3)] pt-[16rpx]">
              <view
                class="prompt-polish-btn"
                :class="{ 'prompt-polish-btn-loading': polishingPrompt }"
                @tap="handlePolishPrompt"
              >
                <text class="iconfont icon-magic prompt-polish-icon" style="font-size: 26rpx;"/>
                <text class="prompt-polish-text">{{ polishingPrompt ? "润色中" : "润色" }}</text>
                <view v-if="polishingPrompt" class="prompt-polish-dots">
                  <view class="prompt-polish-dot" />
                  <view class="prompt-polish-dot" />
                  <view class="prompt-polish-dot" />
                </view>
              </view>
              <view class="flex items-center gap-[16rpx]">
                <view class="h-[24rpx] w-[2rpx] bg-[rgba(207,196,197,0.3)]" />
                <text class="text-[22rpx] leading-[28rpx] tracking-[2rpx] text-[#7e7576]">支持中英文</text>
              </view>
            </view>
          </view>
        </view>

        <!-- 模型选择 -->
        <view class="mb-[32rpx]">
          <text class="model-section-label font-mono">模型选择</text>
          <scroll-view
            class="model-scroll"
            scroll-x
            enhanced
            :bounces="false"
            :show-scrollbar="false"
          >
            <view class="model-grid">
              <view
                v-for="item in models"
                :key="item.value"
                class="model-card"
                :class="model === item.value ? 'model-card-active' : 'model-card-default'"
                @tap="selectModel(item)"
              >
                <!-- <view
                  class="model-card-icon"
                  :class="model === item.value ? 'model-card-icon-active' : 'model-card-icon-default'"
                >
                  <text
                    class="iconfont leading-none"
                    :class="item.iconClass"
                    :style="{ fontSize: '32rpx', color: model === item.value ? '#ffffff' : '#5f5e5e' }"
                  />
                </view> -->
                <view class="model-card-text" :class="{ 'model-card-text-active': model === item.value }">
                  <view class="model-card-title-row">
                    <text class="model-card-title">{{ item.label }}</text>
                  </view>
                  <text class="model-card-desc pt-[4rpx]">{{ item.description }}</text>
                </view>
                <view
                  v-if="model === item.value"
                  class="model-card-check"
                >
                  <view class="model-card-check-mark" />
                </view>
              </view>
            </view>
          </scroll-view>
        </view>

        <!-- 分辨率 -->
        <view class="mb-[32rpx]">
          <text class="model-section-label font-mono">分辨率</text>
          <view class="segmented-control">
            <button
              v-for="item in availableQualities"
              :key="item"
              class="segmented-item"
              :class="{ active: quality === item }"
              @tap="selectResolution(item)"
            >
              {{ item }}
            </button>
          </view>
        </view>

        <!-- 画面比例 -->
        <view class="mb-[32rpx]">
          <view class="flex items-center justify-between">
            <text class="model-section-label font-mono">画面比例</text>
            <text v-if="shouldShowImageSizeText" class="text-right text-[22rpx] text-black/40">{{ selectedImageSizeText }}</text>
          </view>
          <scroll-view
            class="ratio-scroll"
            scroll-x
            enhanced
            :bounces="false"
            :show-scrollbar="false"
            scroll-with-animation
            :scroll-into-view="ratioScrollIntoView"
          >
            <view class="ratio-scroll-row">
              <view
                v-for="item in visibleRatios"
                :id="`ratio-${item.value}`"
                :key="item.value"
                class="ratio-chip"
                :class="{ active: ratio === item.value }"
                @tap="selectRatio(item.value)"
              >
                <view class="ratio-icon" :class="item.iconClass" />
                <text class="ratio-chip-label">{{ item.label }}</text>
              </view>
              <view
                v-if="moreRatios.length > 0"
                class="ratio-chip ratio-chip-more"
                @tap="openMoreRatios"
              >
                <text class="ratio-more-dot">•••</text>
                <text class="ratio-chip-label">更多</text>
              </view>
            </view>
          </scroll-view>
        </view>

        <!-- 图片生成张数 -->
        <view>
          <text class="model-section-label font-mono">生成数量</text>
          <view class="segmented-control">
            <button
              v-for="item in counts"
              :key="item"
              class="segmented-item"
              :class="{ active: count === item }"
              @tap="count = item"
            >
              {{ item }}
            </button>
          </view>
        </view>

      </view>
    </scroll-view>

    <!-- 底部操作栏 -->
    <view
      class="fixed inset-x-0 bottom-0 z-50 border-t border-[rgba(207,196,197,0.15)] bg-[rgba(249,249,249,0.92)] px-[48rpx] pt-[20rpx] shadow-[0_-20rpx_80rpx_rgba(0,0,0,0.05)] backdrop-blur-[40rpx]"
      :style="{ paddingBottom: `calc(18rpx + ${safeAreaBottom}px)` }"
    >
      <view class="mx-auto max-w-[750rpx]">
        <view
          class="generate-btn"
          :class="{ 'generate-btn-working': generating }"
          @tap="handleGenerate"
        >
          <view v-if="generating" class="generate-working-content">
            <view class="generate-spinner" aria-hidden="true" />
            <text class="generate-working-title">提交中...</text>
          </view>
          <view v-else class="generate-ready-content">
            <text class="iconfont icon-shanshan generate-ready-icon" />
            <text class="generate-ready-text">开始生成 · {{ creditCost }}积分</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 更多比例 -->
    <view v-if="showMoreRatios" class="ratio-drawer-overlay" @tap="closeMoreRatios">
      <view class="ratio-drawer" :style="{ paddingBottom: `calc(40rpx + ${safeAreaBottom}px)` }" @tap.stop>
        <view class="ratio-drawer-handle" />
        <view class="ratio-drawer-header">
          <view class="ratio-drawer-heading">
            <text class="ratio-drawer-title">更多比例</text>
            <text class="ratio-drawer-subtitle">{{ selectedModelOption.label }}</text>
          </view>
          <button class="ratio-drawer-close" @tap="closeMoreRatios">
            <text class="ratio-drawer-close-text">×</text>
          </button>
        </view>

        <view class="ratio-drawer-stage">
          <view class="ratio-drawer-stage-preview">
            <view class="ratio-drawer-stage-frame">
              <view class="ratio-icon ratio-drawer-stage-icon" :class="selectedRatioOption.iconClass" />
            </view>
          </view>
          <view class="ratio-drawer-stage-copy">
            <text class="ratio-drawer-stage-label">{{ selectedRatioOption.label }}</text>
            <text v-if="shouldShowImageSizeText" class="ratio-drawer-stage-size">{{ selectedImageSizeText }}</text>
          </view>
          <view class="ratio-drawer-stage-badge">
            <text>{{ quality }}</text>
          </view>
        </view>

        <scroll-view class="ratio-drawer-list-scroll" scroll-y enhanced :show-scrollbar="false">
          <view class="ratio-drawer-list">
            <view
              v-for="item in moreRatios"
              :key="item.value"
              class="ratio-drawer-option"
              :class="{ active: ratio === item.value }"
              @tap="selectRatioFromDrawer(item.value)"
            >
              <view class="ratio-drawer-option-mark">
                <view class="ratio-icon" :class="item.iconClass" />
              </view>
              <view class="ratio-drawer-option-copy">
                <text class="ratio-drawer-option-label">{{ item.label }}</text>
                <text v-if="shouldShowImageSizeText" class="ratio-drawer-option-size">{{ getRatioSizeText(item.value) }}</text>
              </view>
              <view class="ratio-drawer-option-check">
                <view v-if="ratio === item.value" class="ratio-drawer-check-mark" />
              </view>
            </view>
          </view>
        </scroll-view>
      </view>
    </view>

    <canvas
      canvas-id="reference-compress-canvas"
      id="reference-compress-canvas"
      class="reference-compress-canvas"
      :style="{
        width: `${compressCanvasWidth}px`,
        height: `${compressCanvasHeight}px`,
      }"
    />
  </view>
</template>

<script setup lang="ts">
import { computed, nextTick, ref } from "vue";
import { onLoad } from "@dcloudio/uni-app";
import { navigateTo, routes } from "@/utils/router";
import { createImageGeneration, polishPromptStream, uploadImage } from "@/api/generate";
import type { ApiError } from "@/utils/request";
import { getTemplateDetail, type TemplateItem } from "@/api/template";
import { useUserStore } from "@/store/modules/user";

const REFERENCE_DIRECT_MAX_BYTES = 5 * 1024 * 1024;
const REFERENCE_COMPRESSED_MAX_BYTES = 8 * 1024 * 1024;
const REFERENCE_MAX_EDGE = 2048;
const REFERENCE_COMPRESS_QUALITY = 0.82;
const REFERENCE_COMPRESS_CANVAS_ID = "reference-compress-canvas";

type ModelValue = "gpt-image-2" | "gpt-image-2-vip" | "nano-banana-2" | "nano-banana-pro" | "nano-banana";

const models: Array<{
  value: ModelValue;
  label: string;
  description: string;
  iconClass: string;
  baseCredits: number;
  enabled: boolean;
}> = [
  {
    value: "gpt-image-2",
    label: "GPT-image-2",
    description: "全能艺术创作",
    iconClass: "icon-magic",
    baseCredits: 6,
    enabled: true,
  },
  {
    value: "gpt-image-2-vip",
    label: "GPT-image-2 VIP",
    description: "尺寸增强",
    iconClass: "icon-huizhang",
    baseCredits: 15,
    enabled: true,
  },
  {
    value: "nano-banana",
    label: "nano-banana",
    description: "轻量快速生成",
    iconClass: "icon-images",
    baseCredits: 5,
    enabled: true,
  },
  {
    value: "nano-banana-2",
    label: "nano-banana-2",
    description: "写实摄影风格",
    iconClass: "icon-tupian",
    baseCredits: 12,
    enabled: true,
  },
  {
    value: "nano-banana-pro",
    label: "nano-banana-pro",
    description: "专业细节增强",
    iconClass: "icon-line-medalxunzhang-02",
    baseCredits: 20,
    enabled: true,
  },

];

const qualities = ["1K", "2K", "4K"] as const;
type QualityValue = (typeof qualities)[number];
const counts = [1, 2, 3, 4] as const;
type RatioValue =
  | "auto"
  | "1:1"
  | "16:9"
  | "9:16"
  | "4:3"
  | "3:4"
  | "3:2"
  | "2:3"
  | "5:4"
  | "4:5"
  | "21:9"
  | "9:21"
  | "1:3"
  | "3:1"
  | "2:1"
  | "1:2"
  | "1:4"
  | "4:1"
  | "1:8"
  | "8:1";
type RatioOption = { value: RatioValue; label: string; iconClass: string };
type SizeMap = Partial<Record<RatioValue, Partial<Record<QualityValue, string>>>>;

const ratios: RatioOption[] = [
  { value: "auto", label: "Auto", iconClass: "ratio-icon-square" },
  { value: "1:1", label: "1:1", iconClass: "ratio-icon-square" },
  { value: "16:9", label: "16:9", iconClass: "ratio-icon-wide" },
  { value: "9:16", label: "9:16", iconClass: "ratio-icon-tall" },
  { value: "4:3", label: "4:3", iconClass: "ratio-icon-landscape" },
  { value: "3:4", label: "3:4", iconClass: "ratio-icon-portrait" },
  { value: "3:2", label: "3:2", iconClass: "ratio-icon-landscape" },
  { value: "2:3", label: "2:3", iconClass: "ratio-icon-portrait" },
  { value: "5:4", label: "5:4", iconClass: "ratio-icon-landscape" },
  { value: "4:5", label: "4:5", iconClass: "ratio-icon-portrait" },
  { value: "21:9", label: "21:9", iconClass: "ratio-icon-ultrawide" },
  { value: "9:21", label: "9:21", iconClass: "ratio-icon-tall" },
  { value: "1:3", label: "1:3", iconClass: "ratio-icon-tall" },
  { value: "3:1", label: "3:1", iconClass: "ratio-icon-ultrawide" },
  { value: "2:1", label: "2:1", iconClass: "ratio-icon-ultrawide" },
  { value: "1:2", label: "1:2", iconClass: "ratio-icon-tall" },
  { value: "1:4", label: "1:4", iconClass: "ratio-icon-tall" },
  { value: "4:1", label: "4:1", iconClass: "ratio-icon-ultrawide" },
  { value: "1:8", label: "1:8", iconClass: "ratio-icon-tall" },
  { value: "8:1", label: "8:1", iconClass: "ratio-icon-ultrawide" },
];

const commonRatioValues: RatioValue[] = ["auto", "1:1", "16:9", "9:16", "4:3", "3:4"];

const defaultModelSizeMap: SizeMap = {
  "1:1": {
    "1K": "1024x1024",
    "2K": "2048x2048",
  },
  "4:3": {
    "1K": "1024x768",
    "2K": "2048x1536",
  },
  "3:4": {
    "1K": "768x1024",
    "2K": "1536x2048",
  },
  "16:9": {
    "1K": "1536x864",
    "2K": "2048x1152",
    "4K": "3840x2160",
  },
  "9:16": {
    "1K": "864x1536",
    "2K": "1152x2048",
    "4K": "2160x3840",
  },
  "2:1": {
    "1K": "2048x1024",
    "2K": "2688x1344",
    "4K": "3840x1920",
  },
};

const modelSizeMaps: Partial<Record<ModelValue, SizeMap>> = {
  "gpt-image-2": {
    "1:1": { "1K": "1024x1024" },
    "16:9": { "1K": "1672x941" },
    "9:16": { "1K": "941x1672" },
    "4:3": { "1K": "1443x1090" },
    "3:4": { "1K": "1090x1443" },
    "3:2": { "1K": "1536x1024" },
    "2:3": { "1K": "1024x1536" },
    "5:4": { "1K": "1408x1120" },
    "4:5": { "1K": "1120x1408" },
    "21:9": { "1K": "1920x832" },
    "9:21": { "1K": "832x1920" },
    "1:2": { "1K": "896x1792" },
    "2:1": { "1K": "1792x896" },
  },
  "gpt-image-2-vip": {
    "1:1": { "1K": "1024x1024", "2K": "2048x2048", "4K": "2880x2880" },
    "16:9": { "1K": "1280x720", "2K": "2048x1152", "4K": "3840x2160" },
    "9:16": { "1K": "720x1280", "2K": "1152x2048", "4K": "2160x3840" },
    "4:3": { "1K": "1152x864", "2K": "2304x1728", "4K": "3264x2448" },
    "3:4": { "1K": "864x1152", "2K": "1728x2304", "4K": "2448x3264" },
    "3:2": { "1K": "1536x1024", "2K": "2048x1360", "4K": "3504x2336" },
    "2:3": { "1K": "1024x1536", "2K": "1360x2048", "4K": "2336x3504" },
    "5:4": { "1K": "1120x896", "2K": "2240x1792", "4K": "3200x2560" },
    "4:5": { "1K": "896x1120", "2K": "1792x2240", "4K": "2560x3200" },
    "21:9": { "1K": "1456x624", "2K": "2912x1248", "4K": "3840x1648" },
    "9:21": { "1K": "624x1456", "2K": "1248x2912", "4K": "1648x3840" },
    "1:3": { "2K": "688x2048", "4K": "1280x3840" },
    "3:1": { "2K": "2048x688", "4K": "3840x1280" },
    "2:1": { "1K": "1536x768", "2K": "3072x1536", "4K": "3840x1920" },
    "1:2": { "1K": "768x1536", "2K": "1536x3072", "4K": "1920x3840" },
  },
  "nano-banana": {
    "auto": { "1K": "1024x1024" },
    "1:1": { "1K": "1024x1024" },
    "16:9": { "1K": "1536x864" },
    "9:16": { "1K": "864x1536" },
    "4:3": { "1K": "1024x768" },
    "3:4": { "1K": "768x1024" },
    "3:2": { "1K": "1536x1024" },
    "2:3": { "1K": "1024x1536" },
    "5:4": { "1K": "1280x1024" },
    "4:5": { "1K": "1024x1280" },
    "21:9": { "1K": "1792x768" },
  },
  "nano-banana-2": {
    "1:1": { "1K": "1024x1024", "2K": "2048x2048", "4K": "4096x4096" },
    "16:9": { "1K": "1536x864", "2K": "2048x1152", "4K": "3840x2160" },
    "9:16": { "1K": "864x1536", "2K": "1152x2048", "4K": "2160x3840" },
    "4:3": { "1K": "1024x768", "2K": "2048x1536", "4K": "4096x3072" },
    "3:4": { "1K": "768x1024", "2K": "1536x2048", "4K": "3072x4096" },
    "3:2": { "1K": "1536x1024", "2K": "2048x1365", "4K": "3840x2560" },
    "2:3": { "1K": "1024x1536", "2K": "1365x2048", "4K": "2560x3840" },
    "5:4": { "1K": "1280x1024", "2K": "2048x1638", "4K": "3840x3072" },
    "4:5": { "1K": "1024x1280", "2K": "1638x2048", "4K": "3072x3840" },
    "21:9": { "1K": "1792x768", "2K": "2688x1152", "4K": "3840x1646" },
    "1:4": { "1K": "512x2048", "2K": "1024x4096", "4K": "1024x4096" },
    "4:1": { "1K": "2048x512", "2K": "4096x1024", "4K": "4096x1024" },
    "1:8": { "1K": "256x2048", "2K": "512x4096", "4K": "512x4096" },
    "8:1": { "1K": "2048x256", "2K": "4096x512", "4K": "4096x512" },
  },
  "nano-banana-pro": {
    "1:1": { "1K": "1024x1024", "2K": "2048x2048", "4K": "4096x4096" },
    "16:9": { "1K": "1536x864", "2K": "2048x1152", "4K": "3840x2160" },
    "9:16": { "1K": "864x1536", "2K": "1152x2048", "4K": "2160x3840" },
    "4:3": { "1K": "1024x768", "2K": "2048x1536", "4K": "4096x3072" },
    "3:4": { "1K": "768x1024", "2K": "1536x2048", "4K": "3072x4096" },
    "3:2": { "1K": "1536x1024", "2K": "2048x1365", "4K": "3840x2560" },
    "2:3": { "1K": "1024x1536", "2K": "1365x2048", "4K": "2560x3840" },
    "5:4": { "1K": "1280x1024", "2K": "2048x1638", "4K": "3840x3072" },
    "4:5": { "1K": "1024x1280", "2K": "1638x2048", "4K": "3072x3840" },
    "21:9": { "1K": "1792x768", "2K": "2688x1152", "4K": "3840x1646" },
  },
};

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
const maxReferenceImages = 4;
const referenceImages = ref<string[]>([]);
const canAddReferenceImages = computed(() => referenceImages.value.length < maxReferenceImages);
const model = ref<ModelValue>("gpt-image-2");
const quality = ref<QualityValue>("1K");
const count = ref<(typeof counts)[number]>(1);
const ratio = ref<RatioValue>("1:1");
const generating = ref(false);
const mockGenerating = ref(false);
const polishingPrompt = ref(false);
const showMoreRatios = ref(false);
const userStore = useUserStore();
const selectedTemplateStorageKey = "generate:selectedTemplate";
const retryParamsStorageKey = "generate:retryParams";

interface RetryParams {
  prompt?: string;
  model?: string;
  ratio?: string;
  resolution?: string;
  quality?: string;
  count?: string | number;
}

interface ReferenceSelectedFile {
  path: string;
  size?: number;
}

const creditCost = computed(() => {
  return calculateCreditCost(model.value, quality.value, count.value);
});
const compressCanvasWidth = ref(1);
const compressCanvasHeight = ref(1);

const activeSizeMap = computed(() => getModelSizeMap(model.value));
const availableQualities = computed(() => qualities.filter((item) => hasAnyRatioForQuality(item)));
const availableRatios = computed(() => ratios.filter((item) => Boolean(activeSizeMap.value[item.value]?.[quality.value])));
const visibleRatios = computed(() => {
  const primary = availableRatios.value.filter((item) => commonRatioValues.includes(item.value));
  if (!commonRatioValues.includes(ratio.value)) {
    const selected = availableRatios.value.find((item) => item.value === ratio.value);
    if (selected) {
      return [...primary, selected];
    }
  }
  return primary;
});
const moreRatios = computed(() => availableRatios.value.filter((item) => !commonRatioValues.includes(item.value)));
const ratioScrollIntoView = computed(() => `ratio-${ratio.value}`);
const shouldShowImageSizeText = computed(() => model.value !== "nano-banana");
const selectedImageSizeText = computed(() => getRatioDisplayText(ratio.value));
const selectedRatioOption = computed(() => ratios.find((item) => item.value === ratio.value) || ratios[0]);
const selectedModelOption = computed(() => models.find((item) => item.value === model.value) || models[0]);

const bottomBarHeight = computed(() => rpxToPx(162) + safeAreaBottom.value);
const scrollViewHeight = computed(() => {
  if (!windowHeight.value) return 0;
  return Math.max(0, windowHeight.value - bottomBarHeight.value);
});

function rpxToPx(rpx: number) {
  return (windowWidth.value / 750) * rpx;
}

function getModelSizeMap(modelValue: ModelValue) {
  return modelSizeMaps[modelValue] || defaultModelSizeMap;
}

function hasAnyRatioForQuality(resolutionValue: QualityValue) {
  return ratios.some((item) => Boolean(activeSizeMap.value[item.value]?.[resolutionValue]));
}

onLoad((query) => {
  if (query?.mockGenerating === "1") {
    mockGenerating.value = true;
    generating.value = true;
  }

  if (query?.fromRetry) {
    applyRetryParams();
    return;
  }

  if (query?.fromTemplate || query?.templateId) {
    void applyTemplateFromQuery(query);
  }
});

function applyRetryParams() {
  const params = getRetryParams();
  if (!params) return;

  if (typeof params.prompt === "string") {
    prompt.value = params.prompt;
  }
  model.value = normalizeRetryModel(params.model);
  ratio.value = normalizeRetryRatio(params.ratio);
  quality.value = normalizeRetryResolution(params.resolution, params.quality);
  count.value = normalizeRetryCount(params.count);
  ensureGenerationOptions();
}

function getRetryParams() {
  try {
    const value = uni.getStorageSync(retryParamsStorageKey) as RetryParams | "";
    uni.removeStorageSync(retryParamsStorageKey);
    return value && typeof value === "object" ? value : null;
  } catch {
    return null;
  }
}

async function applyTemplateFromQuery(query: Record<string, string | undefined>) {
  const templateId = query.templateId ? String(query.templateId) : "";
  const cachedTemplate = getCachedTemplate(templateId);

  if (cachedTemplate) {
    applyTemplate(cachedTemplate);
    return;
  }

  if (!templateId) return;

  try {
    const detail = await getTemplateDetail(templateId);
    applyTemplate(detail);
  } catch {
    uni.showToast({ title: "模板信息加载失败", icon: "none" });
  }
}

function getCachedTemplate(templateId: string) {
  try {
    const value = uni.getStorageSync(selectedTemplateStorageKey) as Partial<TemplateItem> | "";
    if (!value || typeof value !== "object") return null;
    if (templateId && String(value.templateId || "") !== templateId) {
      uni.removeStorageSync(selectedTemplateStorageKey);
      return null;
    }
    uni.removeStorageSync(selectedTemplateStorageKey);
    return value;
  } catch {
    return null;
  }
}

function applyTemplate(value: Partial<TemplateItem>) {
  if (value.prompt) {
    prompt.value = value.prompt;
  }
  model.value = normalizeTemplateModel(value.aiEngine);
  ratio.value = normalizeTemplateRatio(value.ratio);
  quality.value = normalizeTemplateQuality(value);
  ensureGenerationOptions();
}

function normalizeTemplateModel(value?: string): ModelValue {
  if (!value) return "gpt-image-2";
  const normalized = value.toLowerCase();
  const matchedModel = models.find((item) => normalized.includes(item.value.toLowerCase()));
  if (matchedModel) {
    return matchedModel.value;
  }
  if (normalized.includes("nano-banana")) {
    return "nano-banana-2";
  }
  if (normalized.includes("g-image") || normalized.includes("gpt-image")) {
    return "gpt-image-2";
  }
  return "gpt-image-2";
}

function normalizeTemplateRatio(value?: string): RatioValue {
  if (!value) return "1:1";
  const normalized = value.replace(/\s/g, "");
  const matched = ratios.find((item) => normalized.includes(item.value));
  return matched?.value || "1:1";
}

function normalizeTemplateQuality(value: Partial<TemplateItem>): QualityValue {
  const source = `${value.ratio || ""} ${value.title || ""} ${value.description || ""}`.toLowerCase();
  if (source.includes("1k")) return "1K";
  if (source.includes("4k") || source.includes("8k")) return "4K";
  if (source.includes("2k")) return "2K";
  return "2K";
}

function normalizeRetryModel(value?: string): ModelValue {
  const matchedModel = models.find((item) => item.value === value);
  return matchedModel?.value || "gpt-image-2";
}

function normalizeRetryRatio(value?: string): RatioValue {
  const matched = ratios.find((item) => item.value === value);
  return matched?.value || "1:1";
}

function normalizeRetryResolution(
  value?: string,
  imageQualityValue?: string,
): QualityValue {
  const matched = qualities.find((item) => item === value);
  if (matched) return matched;
  if (imageQualityValue === "low") return "1K";
  if (imageQualityValue === "high") return "4K";
  return "2K";
}

function normalizeRetryCount(value?: string | number): (typeof counts)[number] {
  const numericValue = Number(value);
  const matched = counts.find((item) => item === numericValue);
  return matched || 1;
}

function chooseImage() {
  const remainingCount = maxReferenceImages - referenceImages.value.length;

  if (remainingCount <= 0) {
    uni.showToast({ title: "最多上传4张参考图", icon: "none" });
    return;
  }

  uni.chooseImage({
    count: remainingCount,
    sizeType: ["compressed"],
    sourceType: ["album", "camera"],
    success(result) {
      const selectedFiles = normalizeSelectedReferenceFiles(result).slice(0, remainingCount);
      void handleSelectedReferenceImages(selectedFiles);
    },
  });
}

function normalizeSelectedReferenceFiles(result: UniApp.ChooseImageSuccessCallbackResult): ReferenceSelectedFile[] {
  const tempFilePaths = Array.isArray(result.tempFilePaths) ? result.tempFilePaths : [result.tempFilePaths].filter(Boolean);
  const tempFiles = (result.tempFiles || []) as Array<{ path?: string; size?: number } | string>;
  if (tempFiles.length > 0) {
    return tempFiles
      .map((file, index) => {
        if (typeof file === "string") {
          return { path: file };
        }
        return {
          path: file.path || tempFilePaths[index],
          size: file.size,
        };
      })
      .filter((file) => Boolean(file.path));
  }

  return tempFilePaths.map((path: string) => ({ path }));
}

async function handleSelectedReferenceImages(files: ReferenceSelectedFile[]) {
  if (!files.length) {
    return;
  }

  const acceptedImages: string[] = [];
  let oversizedCount = 0;

  uni.showLoading({ title: "处理参考图...", mask: true });
  try {
    for (const file of files) {
      if (referenceImages.value.length + acceptedImages.length >= maxReferenceImages) {
        break;
      }

      const processedPath = await processReferenceImage(file);
      if (processedPath) {
        acceptedImages.push(processedPath);
      } else {
        oversizedCount += 1;
      }
    }
  } finally {
    uni.hideLoading();
  }

  if (acceptedImages.length > 0) {
    referenceImages.value = [...referenceImages.value, ...acceptedImages].slice(0, maxReferenceImages);
  }

  if (oversizedCount > 0) {
    uni.showToast({
      title: "图片过大，请更换或裁剪后上传",
      icon: "none",
    });
  }
}

async function processReferenceImage(file: ReferenceSelectedFile) {
  const fileSize = typeof file.size === "number" ? file.size : await getLocalFileSize(file.path).catch(() => 0);
  const imageInfo = await getLocalImageInfo(file.path).catch(() => null);
  if (!imageInfo) {
    return fileSize > REFERENCE_COMPRESSED_MAX_BYTES ? "" : file.path;
  }

  const longestEdge = Math.max(imageInfo.width, imageInfo.height);
  if (fileSize <= REFERENCE_DIRECT_MAX_BYTES && longestEdge <= REFERENCE_MAX_EDGE) {
    return file.path;
  }

  const compressedPath = await compressReferenceImage(file.path, imageInfo.width, imageInfo.height).catch(() => "");
  if (!compressedPath) {
    return fileSize > REFERENCE_COMPRESSED_MAX_BYTES ? "" : file.path;
  }

  const compressedSize = await getLocalFileSize(compressedPath).catch(() => 0);
  if (compressedSize > REFERENCE_COMPRESSED_MAX_BYTES) {
    return "";
  }
  return compressedPath;
}

function getLocalImageInfo(src: string) {
  return new Promise<UniApp.GetImageInfoSuccessData>((resolve, reject) => {
    uni.getImageInfo({
      src,
      success: resolve,
      fail: reject,
    });
  });
}

function getLocalFileSize(filePath: string) {
  return new Promise<number>((resolve, reject) => {
    uni.getFileInfo({
      filePath,
      success(result) {
        resolve(result.size || 0);
      },
      fail: reject,
    });
  });
}

async function compressReferenceImage(filePath: string, width: number, height: number) {
  const scale = Math.min(1, REFERENCE_MAX_EDGE / Math.max(width, height));
  const targetWidth = Math.max(1, Math.round(width * scale));
  const targetHeight = Math.max(1, Math.round(height * scale));

  compressCanvasWidth.value = targetWidth;
  compressCanvasHeight.value = targetHeight;
  await nextTick();

  const context = uni.createCanvasContext(REFERENCE_COMPRESS_CANVAS_ID);
  context.clearRect(0, 0, targetWidth, targetHeight);
  context.drawImage(filePath, 0, 0, targetWidth, targetHeight);
  await drawCanvas(context);

  return new Promise<string>((resolve, reject) => {
    uni.canvasToTempFilePath({
      canvasId: REFERENCE_COMPRESS_CANVAS_ID,
      x: 0,
      y: 0,
      width: targetWidth,
      height: targetHeight,
      destWidth: targetWidth,
      destHeight: targetHeight,
      fileType: "jpg",
      quality: REFERENCE_COMPRESS_QUALITY,
      success(result) {
        resolve(result.tempFilePath);
      },
      fail: reject,
    });
  });
}

function drawCanvas(context: UniApp.CanvasContext) {
  return new Promise<void>((resolve) => {
    context.draw(false, () => {
      resolve();
    });
  });
}

function removeImage(index: number) {
  referenceImages.value = referenceImages.value.filter((_, itemIndex) => itemIndex !== index);
}

function selectModel(item: (typeof models)[number]) {
  if (!item.enabled) {
    uni.showToast({ title: "该模型即将上线", icon: "none" });
    return;
  }
  model.value = item.value;
  ensureGenerationOptions();
}

function selectResolution(value: QualityValue) {
  quality.value = value;
  ensureGenerationOptions();
}

function selectRatio(value: RatioValue) {
  ratio.value = value;
}

function openMoreRatios() {
  showMoreRatios.value = true;
}

function closeMoreRatios() {
  showMoreRatios.value = false;
}

function selectRatioFromDrawer(value: RatioValue) {
  selectRatio(value);
  closeMoreRatios();
}

function ensureGenerationOptions() {
  if (!availableQualities.value.includes(quality.value)) {
    quality.value = availableQualities.value[0] || "1K";
  }

  if (!availableRatios.value.some((item) => item.value === ratio.value)) {
    ratio.value = availableRatios.value[0]?.value || "1:1";
  }
}

function mapResolution(value: QualityValue) {
  const map: Record<QualityValue, "1K" | "2K" | "4K"> = {
    "1K": "1K",
    "2K": "2K",
    "4K": "4K",
  };
  return map[value];
}

function mapImageSize(
  ratioValue: RatioValue,
  resolutionValue: QualityValue,
) {
  const sizeMap = getModelSizeMap(model.value);
  return sizeMap[ratioValue]?.[resolutionValue] || sizeMap["1:1"]?.["1K"] || "1024x1024";
}

function resolveRequestSize(
  ratioValue: RatioValue,
  resolutionValue: QualityValue,
) {
  if (model.value === "nano-banana") {
    return "";
  }
  return mapImageSize(ratioValue, resolutionValue);
}

function getRatioDisplayText(ratioValue: RatioValue) {
  if (model.value === "nano-banana") {
    return ratioValue === "auto" ? "自动比例" : ratioValue;
  }
  return mapImageSize(ratioValue, quality.value).replace("x", " x ");
}

function getRatioSizeText(ratioValue: RatioValue) {
  return getRatioDisplayText(ratioValue);
}

function calculateCreditCost(
  modelValue: ModelValue,
  resolutionValue: QualityValue,
  imageCount: number,
) {
  const selected = models.find((item) => item.value === modelValue);
  const baseCredits = selected?.baseCredits || models[0].baseCredits;
  const multiplierMap: Record<(typeof qualities)[number], number> = {
    "1K": 1,
    "2K": 1.2,
    "4K": 1.5,
  };
  const singleCost = Math.ceil(baseCredits * multiplierMap[resolutionValue]);
  return singleCost * imageCount;
}

async function uploadReferenceImages() {
  if (!referenceImages.value.length) {
    return [];
  }

  uni.showLoading({ title: "上传参考图..." });
  try {
    return await Promise.all(referenceImages.value.map((image) => uploadImage(image)));
  } finally {
    uni.hideLoading();
  }
}

async function handlePolishPrompt() {
  if (!userStore.isLogin) {
    await userStore.loginWithWechat();
    if (!userStore.isLogin) return;
  }

  const rawPrompt = prompt.value.trim();
  if (!rawPrompt) {
    uni.showToast({ title: "请输入画面描述", icon: "none" });
    return;
  }

  if (polishingPrompt.value) return;
  polishingPrompt.value = true;
  try {
    let receivedPrompt = "";
    await polishPromptStream(rawPrompt, {
      onChunk(chunk) {
        receivedPrompt += chunk;
        prompt.value = receivedPrompt;
      },
    });
  } catch (error) {
    prompt.value = rawPrompt;
    const apiError = error as ApiError | undefined;
    if (apiError?.shown) {
      return;
    }
    const message = error instanceof Error ? error.message : (apiError?.data?.msg || apiError?.data?.message || "Prompt 润色失败");
    uni.showToast({ title: message, icon: "none" });
  } finally {
    polishingPrompt.value = false;
  }
}

async function handleGenerate() {
  if (mockGenerating.value) return;

  if (!userStore.isLogin) {
    await userStore.loginWithWechat();
    if (!userStore.isLogin) return;
  }

  if (!prompt.value.trim()) {
    uni.showToast({ title: "请输入画面描述", icon: "none" });
    return;
  }

  if (generating.value) return;

  generating.value = true;

  try {
    const imageUrls = await uploadReferenceImages();
    const result = await createImageGeneration({
      prompt: prompt.value.trim(),
      model: model.value,
      ratio: ratio.value,
      size: resolveRequestSize(ratio.value, quality.value),
      resolution: mapResolution(quality.value),
      n: count.value,
      image_urls: imageUrls,
    });

    await navigateTo(routes.generateResult, { taskId: result.taskId });
  } catch (error) {
    const apiError = error as ApiError | undefined;
    if (apiError?.shown) {
      return;
    }
    const message = error instanceof Error ? error.message : (apiError?.data?.msg || apiError?.data?.message || "图片生成失败");
    uni.showToast({ title: message, icon: "none" });
  } finally {
    generating.value = false;
  }
}
</script>

<style>
.glass-card {
  background: rgba(255, 255, 255, 0.8);
  border: 1px solid rgba(0, 0, 0, 0.05);
  box-shadow: 0 20rpx 40rpx rgba(0, 0, 0, 0.05);
  backdrop-filter: blur(20px);
}

.generate-prompt-placeholder {
  color: #9ca3af !important;
  font-size: 28rpx !important;
  line-height: 48rpx !important;
  letter-spacing: 8rpx !important;
}

.prompt-polish-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8rpx;
  height: 56rpx;
  padding: 0 24rpx;
  border: 1px solid rgba(0, 0, 0, 0.04);
  border-radius: 9999rpx;
  background: #ffffff;
  color: #232424;
  box-shadow: 0 8rpx 22rpx rgba(0, 0, 0, 0.02);
  transition:
    background-color 0.18s ease,
    border-color 0.18s ease,
    box-shadow 0.18s ease,
    opacity 0.18s ease,
    transform 0.18s ease;
}

.prompt-polish-btn:active {
  border-color: rgba(0, 0, 0, 0.16);
  background: #f3f3f4;
  box-shadow: 0 4rpx 14rpx rgba(0, 0, 0, 0.04);
  transform: scale(0.98);
}

.prompt-polish-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28rpx;
  height: 32rpx;
  font-size: 28rpx;
  line-height: 32rpx;
  color: currentColor;
  transform-origin: center;
}

.prompt-polish-text {
  display: flex;
  align-items: center;
  height: 32rpx;
  font-size: 22rpx;
  font-family: serif;
  font-weight: 600;
  line-height: 32rpx;
  color: currentColor;
}

.prompt-polish-btn-loading {
  border-color: transparent;
  background: transparent;
  box-shadow: none;
  color: rgba(0, 0, 0, 0.48);
}

.prompt-polish-btn-loading:active {
  border-color: transparent;
  background: transparent;
  box-shadow: none;
  transform: none;
}

.prompt-polish-btn-loading .prompt-polish-icon {
  animation: prompt-polish-spin 1.1s linear infinite;
}

.prompt-polish-dots {
  display: flex;
  align-items: center;
  gap: 4rpx;
  width: 32rpx;
  height: 20rpx;
}

.prompt-polish-dot {
  width: 5rpx;
  height: 5rpx;
  border-radius: 9999rpx;
  background: rgba(0, 0, 0, 0.48);
  animation: prompt-polish-pulse 0.9s ease-in-out infinite;
}

.prompt-polish-dot:nth-child(2) {
  animation-delay: 0.12s;
}

.prompt-polish-dot:nth-child(3) {
  animation-delay: 0.24s;
}

@keyframes prompt-polish-spin {
  to {
    transform: rotate(360deg);
  }
}

@keyframes prompt-polish-pulse {
  0%,
  100% {
    opacity: 0.28;
    transform: translateY(0);
  }

  50% {
    opacity: 0.86;
    transform: translateY(-3rpx);
  }
}

.reference-upload-box {
  min-height: 204rpx;
}

.reference-compress-canvas {
  position: fixed;
  top: -9999px;
  left: -9999px;
  opacity: 0;
  pointer-events: none;
  z-index: -1;
}

.segmented-control {
  display: flex;
  border-radius: 9999rpx;
  background: #f5f5f5;
  padding: 8rpx;
}

.segmented-item {
  flex: 1;
  height: 72rpx;
  border-radius: 9999rpx;
  color: #1a1c1c;
  font-size: 26rpx;
  font-weight: 600;
  line-height: 72rpx;
  text-align: center;
  transition: all 0.3s ease;
}

.segmented-item.active {
  background: #ffffff;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.08);
}

.ratio-scroll {
  width: 100%;
}

.ratio-scroll-row {
  display: inline-flex;
  flex-direction: row;
  flex-wrap: nowrap;
  gap: 16rpx;
  padding: 8rpx 8rpx 4rpx;
}

.ratio-chip {
  display: inline-flex;
  flex-shrink: 0;
  width: 120rpx;
  height: 96rpx;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8rpx;
  border: 2rpx solid #cfc4c5;
  border-radius: 24rpx;
  color: #1a1c1c;
  box-sizing: border-box;
  transition:
    border-color 0.28s cubic-bezier(0.4, 0, 0.2, 1),
    background-color 0.28s cubic-bezier(0.4, 0, 0.2, 1),
    color 0.28s cubic-bezier(0.4, 0, 0.2, 1),
    box-shadow 0.28s cubic-bezier(0.4, 0, 0.2, 1),
    transform 0.28s cubic-bezier(0.4, 0, 0.2, 1);
}

.ratio-chip-label {
  font-size: 22rpx;
  font-weight: 500;
  line-height: 28rpx;
}

.ratio-chip.active {
  border: 2rpx solid #000000;
  background: #000000;
  color: #ffffff;
  box-shadow: 0 0 0 8rpx rgba(0, 0, 0, 0.1);
}

.ratio-chip-more {
  border-style: dashed;
}

.ratio-more-dot {
  height: 32rpx;
  font-size: 28rpx;
  font-weight: 700;
  line-height: 20rpx;
}

.ratio-icon {
  box-sizing: border-box;
  border: 3rpx solid currentColor;
  border-radius: 4rpx;
  background: transparent;
  opacity: 0.85;
  transition: opacity 0.28s cubic-bezier(0.4, 0, 0.2, 1);
}

.ratio-chip.active .ratio-icon {
  opacity: 1;
}

.ratio-icon-square {
  width: 32rpx;
  height: 32rpx;
}

.ratio-icon-landscape {
  width: 36rpx;
  height: 28rpx;
}

.ratio-icon-portrait {
  width: 28rpx;
  height: 36rpx;
}

.ratio-icon-wide {
  width: 40rpx;
  height: 22rpx;
}

.ratio-icon-tall {
  width: 22rpx;
  height: 40rpx;
}

.ratio-icon-ultrawide {
  width: 42rpx;
  height: 18rpx;
}

.ratio-drawer-overlay {
  position: fixed;
  inset: 0;
  z-index: 60;
  background: rgba(0, 0, 0, 0.42);
  backdrop-filter: blur(6px);
}

.ratio-drawer {
  position: absolute;
  right: 0;
  bottom: 0;
  left: 0;
  box-sizing: border-box;
  max-height: 78vh;
  overflow: hidden;
  padding: 18rpx 24rpx 40rpx;
  border: 3rpx solid #111111;
  border-bottom: 0;
  border-radius: 44rpx 44rpx 0 0;
  background: #ffffff;
  box-shadow:
    0 -28rpx 80rpx rgba(0, 0, 0, 0.18),
    inset 0 -16rpx 0 #f3f3f3;
}

.ratio-drawer-handle {
  width: 84rpx;
  height: 8rpx;
  margin: 0 auto 24rpx;
  border-radius: 9999rpx;
  background: #111111;
}

.ratio-drawer-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20rpx;
  margin-bottom: 20rpx;
  padding: 0 4rpx 20rpx;
  border-bottom: 3rpx solid #111111;
}

.ratio-drawer-heading {
  display: flex;
  min-width: 0;
  flex: 1;
  flex-direction: column;
  gap: 4rpx;
}

.ratio-drawer-title {
  font-size: 34rpx;
  font-weight: 900;
  line-height: 44rpx;
  color: #111111;
}

.ratio-drawer-subtitle {
  max-width: 460rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-size: 20rpx;
  font-weight: 700;
  letter-spacing: 2rpx;
  line-height: 28rpx;
  color: rgba(0, 0, 0, 0.42);
}

.ratio-drawer-close {
  display: flex;
  flex: none;
  align-items: center;
  justify-content: center;
  width: 68rpx;
  height: 68rpx;
  padding: 0;
  border: 3rpx solid #111111;
  border-radius: 18rpx;
  background: #ffffff;
}

.ratio-drawer-close:active {
  background: #111111;
  transform: scale(0.96);
}

.ratio-drawer-close:active .ratio-drawer-close-text {
  color: #ffffff;
}

.ratio-drawer-close-text {
  margin-top: -4rpx;
  font-size: 44rpx;
  font-weight: 300;
  line-height: 64rpx;
  color: #111111;
}

.ratio-drawer-stage {
  position: relative;
  display: flex;
  align-items: center;
  gap: 22rpx;
  min-height: 164rpx;
  margin-bottom: 24rpx;
  padding: 24rpx;
  border: 3rpx solid #111111;
  border-radius: 28rpx;
  background:
    linear-gradient(135deg, rgba(0, 0, 0, 0.035) 25%, transparent 25%) 0 0 / 24rpx 24rpx,
    #ffffff;
}

.ratio-drawer-stage-preview {
  display: flex;
  flex: none;
  width: 156rpx;
  height: 108rpx;
  align-items: center;
  justify-content: center;
  border: 3rpx solid #111111;
  border-radius: 20rpx;
  background: #f7f7f7;
}

.ratio-drawer-stage-frame {
  display: flex;
  width: 96rpx;
  height: 66rpx;
  align-items: center;
  justify-content: center;
  border: 2rpx dashed rgba(0, 0, 0, 0.32);
  border-radius: 12rpx;
  background: #ffffff;
}

.ratio-drawer-stage-icon {
  color: #111111;
  opacity: 1;
}

.ratio-drawer-stage-copy {
  display: flex;
  min-width: 0;
  flex: 1;
  flex-direction: column;
}

.ratio-drawer-stage-label {
  font-size: 44rpx;
  font-weight: 900;
  line-height: 54rpx;
  color: #111111;
}

.ratio-drawer-stage-size {
  margin-top: 8rpx;
  max-width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-size: 24rpx;
  font-weight: 600;
  line-height: 32rpx;
  color: rgba(0, 0, 0, 0.48);
}

.ratio-drawer-stage-badge {
  position: absolute;
  top: -3rpx;
  right: -3rpx;
  display: flex;
  min-width: 72rpx;
  height: 42rpx;
  align-items: center;
  justify-content: center;
  padding: 0 16rpx;
  border: 3rpx solid #111111;
  border-radius: 0 28rpx 0 18rpx;
  background: #111111;
  color: #ffffff;
  font-size: 20rpx;
  font-weight: 900;
  line-height: 42rpx;
}

.ratio-drawer-list-scroll {
  max-height: 42vh;
}

.ratio-drawer-list {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14rpx;
  padding-bottom: 8rpx;
}

.ratio-drawer-option {
  display: flex;
  min-width: 0;
  min-height: 92rpx;
  box-sizing: border-box;
  align-items: center;
  gap: 16rpx;
  padding: 24rpx;
  border: 3rpx solid rgba(0, 0, 0, 0.1);
  border-radius: 22rpx;
  background: #ffffff;
  color: #111111;
  transition:
    background-color 0.18s ease,
    border-color 0.18s ease,
    color 0.18s ease,
    transform 0.18s ease;
}

.ratio-drawer-option:active {
  transform: scale(0.98);
}

.ratio-drawer-option.active {
  border-color: #111111;
  background: #111111;
  color: #ffffff;
}

.ratio-drawer-option-mark {
  display: flex;
  flex: none;
  width: 54rpx;
  height: 54rpx;
  align-items: center;
  justify-content: center;
  border: 2rpx solid currentColor;
  border-radius: 14rpx;
}

.ratio-drawer-option-copy {
  display: flex;
  min-width: 0;
  flex: 1;
  flex-direction: column;
  gap: 2rpx;
}

.ratio-drawer-option-label {
  font-size: 26rpx;
  font-weight: 900;
  line-height: 32rpx;
  color: currentColor;
}

.ratio-drawer-option-size {
  max-width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-size: 18rpx;
  font-weight: 600;
  line-height: 26rpx;
  color: rgba(0, 0, 0, 0.45);
}

.ratio-drawer-option.active .ratio-drawer-option-size {
  color: rgba(255, 255, 255, 0.68);
}

.ratio-drawer-option-check {
  display: flex;
  flex: none;
  width: 28rpx;
  height: 28rpx;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
  border: 2rpx solid currentColor;
  border-radius: 9999rpx;
  color: currentColor;
}

.ratio-drawer-check-mark {
  width: 7rpx;
  height: 12rpx;
  margin-top: -3rpx;
  border-right: 3rpx solid currentColor;
  border-bottom: 3rpx solid currentColor;
  transform: rotate(45deg);
  transform-origin: center;
}

.generate-btn {
  position: relative;
  display: flex;
  width: 100%;
  height: 112rpx;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  box-sizing: border-box;
  padding: 0 40rpx;
  border: 0;
  border-radius: 9999rpx;
  background: #0b0b0b;
  box-shadow: 0 24rpx 46rpx rgba(0, 0, 0, 0.18);
  color: #ffffff;
  cursor: pointer;
  user-select: none;
  -webkit-tap-highlight-color: transparent;
  outline: none;
  touch-action: manipulation;
  transition:
    transform 0.22s ease,
    box-shadow 0.22s ease,
    background 0.22s ease;
}

.generate-btn * {
  -webkit-tap-highlight-color: transparent;
}

.generate-btn::after {
  position: absolute;
  inset: 2rpx;
  border-radius: inherit;
  pointer-events: none;
  content: "";
  border: 1rpx solid rgba(255, 255, 255, 0.16);
}

.generate-btn:active {
  transform: scale(0.96);
}

.generate-btn-working {
  background: #1b1b1b;
  box-shadow: 0 18rpx 36rpx rgba(0, 0, 0, 0.14);
}

.generate-ready-content,
.generate-working-content {
  position: relative;
  z-index: 1;
  display: flex;
  width: 100%;
  align-items: center;
  justify-content: center;
}

.generate-ready-content {
  gap: 14rpx;
}

.generate-ready-icon {
  font-size: 36rpx;
  line-height: 1;
  color: #ffffff;
}

.generate-ready-text {
  font-size: 28rpx;
  font-weight: 600;
  line-height: 34rpx;
  color: #ffffff;
}

.generate-working-content {
  gap: 14rpx;
}

.generate-working-title {
  font-size: 28rpx;
  font-weight: 600;
  line-height: 34rpx;
  color: #ffffff;
}

.generate-spinner {
  flex: none;
  width: 30rpx;
  height: 30rpx;
  border: 3rpx solid rgba(255, 255, 255, 0.28);
  border-top-color: #ffffff;
  border-radius: 9999rpx;
  animation: generate-spinner-spin 0.8s linear infinite;
}

@keyframes generate-spinner-spin {
  to {
    transform: rotate(360deg);
  }
}

.model-section-label {
  display: block;
  padding: 16rpx;
  font-size: 24rpx;
  font-weight: 500;
  line-height: 32rpx;
  letter-spacing: 1rpx;
  color: #777;
}

.model-scroll {
  width: 100%;
}

.model-grid {
  display: inline-flex;
  flex-direction: row;
  flex-wrap: nowrap;
  gap: 16rpx;
  padding: 0 8rpx 8rpx;
}

.model-card {
  display: flex;
  box-sizing: border-box;
  flex: none;
  width: 260rpx;
  align-items: center;
  gap: 16rpx;
  padding: 12rpx 24rpx;
  border-radius: 24rpx;
}

.model-card-default {
  border: 2rpx solid #cfc4c5;
  background: #ffffff;
  color: #1a1c1c;
}

.model-card-active {
  border: 4rpx solid #000000;
  background: #1b1b1b;
  color: #ffffff;
}

.model-card-icon {
  display: flex;
  flex-shrink: 0;
  align-items: center;
  justify-content: center;
  width: 64rpx;
  height: 64rpx;
  border-radius: 16rpx;
}

.model-card-icon-default {
  background: #eeeeee;
}

.model-card-icon-active {
  background: rgba(255, 255, 255, 0.1);
}

.model-card-text {
  display: flex;
  flex: 1;
  flex-direction: column;
  justify-content: center;
  min-width: 0;
  color: #1a1c1c;
}

.model-card-text-active {
  color: #ffffff;
}

.model-card-title-row {
  display: flex;
  align-items: center;
  gap: 8rpx;
  min-height: 36rpx;
}

.model-card-title {
  flex: 1;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-size: 26rpx;
  font-weight: 600;
  line-height: 36rpx;
}

.model-card-check {
  display: flex;
  flex: none;
  align-items: center;
  justify-content: center;
  width: 30rpx;
  height: 30rpx;
  box-sizing: border-box;
  border: 4rpx solid currentColor;
  border-radius: 50%;
  color: #ffffff;
}

.model-card-check-mark {
  width: 8rpx;
  height: 14rpx;
  margin-top: -4rpx;
  border-right: 4rpx solid currentColor;
  border-bottom: 4rpx solid currentColor;
  transform: rotate(45deg);
  transform-origin: center;
}

.model-card-desc {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-size: 20rpx;
  line-height: 28rpx;
  opacity: 0.7;
}

.model-card-text-active .model-card-desc {
  color: #ffffff;
  opacity: 0.7;
}

</style>
