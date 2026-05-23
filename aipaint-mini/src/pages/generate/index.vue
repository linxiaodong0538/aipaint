<template>
  <view class="min-h-screen bg-[#f9f9f9] font-sans text-[#1a1c1c]">
    <scroll-view :style="{ height: `${scrollViewHeight}px` }" scroll-y enhanced :show-scrollbar="false">
      <view
        class="mx-auto max-w-[750rpx] px-[24rpx] pb-[32rpx] pt-[48rpx]"
      >
        <!-- 参考图片 -->
        <view class="mb-[32rpx]">
          <view class="flex items-end justify-between">
            <text class="model-section-label font-mono">参考图</text>
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
              <button class="flex items-center gap-[8rpx] bg-transparent p-0 active:opacity-70" @tap="useRandomPrompt">
                <text class="iconfont icon-shanshan leading-none text-black/50" style="font-size: 28rpx"/>
                <text class="text-[24rpx] font-serif leading-[40rpx] text-black/50">Prompt</text>
              </button>
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
          <view class="model-grid">
            <view
              v-for="item in models"
              :key="item.value"
              class="model-card"
              :class="model === item.value ? 'model-card-active' : 'model-card-default'"
              @tap="selectModel(item)"
            >
              <view
                class="model-card-icon"
                :class="model === item.value ? 'model-card-icon-active' : 'model-card-icon-default'"
              >
                <text
                  class="iconfont leading-none"
                  :class="item.iconClass"
                  :style="{ fontSize: '40rpx', color: model === item.value ? '#ffffff' : '#5f5e5e' }"
                />
              </view>
              <view class="model-card-text" :class="{ 'model-card-text-active': model === item.value }">
                <view class="model-card-title-row">
                  <text class="model-card-title">{{ item.label }}</text>
                  <text
                    v-if="model === item.value"
                    class="iconfont icon-gou2x model-card-check"
                  />
                </view>
                <text class="model-card-desc">{{ item.description }}</text>
              </view>
            </view>
          </view>
        </view>

        <!-- 分辨率 -->
        <view class="mb-[32rpx]">
          <text class="model-section-label font-mono">分辨率</text>
          <view class="segmented-control">
            <button
              v-for="item in qualities"
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
          <text class="model-section-label font-mono">画面比例</text>
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
                @tap="ratio = item.value"
              >
                <view class="ratio-icon" :class="item.iconClass" />
                <text class="ratio-chip-label">{{ item.label }}</text>
              </view>
            </view>
          </scroll-view>
        </view>

        <!-- 画质选择 -->
        <view class="mb-[32rpx]">
          <text class="model-section-label font-mono">画质选择</text>
          <view class="segmented-control">
            <button
              v-for="item in imageQualities"
              :key="item.value"
              class="segmented-item"
              :class="{ active: imageQuality === item.value }"
              @tap="selectImageQuality(item.value)"
            >
              {{ item.label }}
            </button>
          </view>
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
        <button
          class="generate-btn flex h-[112rpx] w-full items-center justify-center gap-[14rpx] rounded-full bg-black px-[40rpx] shadow-[0_24rpx_46rpx_rgba(0,0,0,0.18)] active:scale-[0.96]"
          :loading="generating"
          :disabled="generating"
          @tap="handleGenerate"
        >
          <text class="iconfont icon-shanshan leading-none text-white" style="font-size: 36rpx;"/>
          <text class="text-[28rpx] font-semibold leading-none text-white">{{ generating ? "提交中" : "开始生成" }}</text>
        </button>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { onLoad } from "@dcloudio/uni-app";
import { navigateTo, routes } from "@/utils/router";
import { createImageGeneration, uploadImage } from "@/api/generate";
import { getTemplateDetail, type TemplateItem } from "@/api/template";
import { useUserStore } from "@/store/modules/user";

const prompts = [
  "未来城市中的玻璃花园，清晨柔光，电影感构图，高级灰色调",
  "水墨山谷中的白色建筑，云雾缭绕，留白构图，细腻纸张纹理",
  "赛博街区的雨夜橱窗，霓虹反射，广角摄影，超现实氛围",
];

type ModelValue = "gpt-image-2" | "xx";

const models: Array<{
  value: ModelValue;
  label: string;
  description: string;
  iconClass: string;
  enabled: boolean;
}> = [
{
    value: "gpt-image-2",
    label: "GPT-image-2",
    description: "全能艺术创作",
    iconClass: "icon-magic",
    enabled: true,
  },
  {
    value: "xx",
    label: "暂定",
    description: "写实摄影风格",
    iconClass: "icon-tupian",
    enabled: false,
  }

];

const qualities = ["1K", "2K", "4K"] as const;
const counts = [1, 2, 3, 4] as const;
const ratios = [
  { value: "1:1", label: "1:1", iconClass: "ratio-icon-square" },
  { value: "4:3", label: "4:3", iconClass: "ratio-icon-landscape" },
  { value: "3:4", label: "3:4", iconClass: "ratio-icon-portrait" },
  { value: "16:9", label: "16:9", iconClass: "ratio-icon-wide" },
  { value: "9:16", label: "9:16", iconClass: "ratio-icon-tall" },
  { value: "2:1", label: "2:1", iconClass: "ratio-icon-ultrawide" },
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
const maxReferenceImages = 4;
const referenceImages = ref<string[]>([]);
const canAddReferenceImages = computed(() => referenceImages.value.length < maxReferenceImages);
const model = ref<ModelValue>("gpt-image-2");
const quality = ref<(typeof qualities)[number]>("2K");
const imageQualities = [
  { value: "low", label: "低" },
  { value: "medium", label: "中" },
  { value: "high", label: "高" },
] as const;
const imageQuality = ref<(typeof imageQualities)[number]["value"]>("high");
const count = ref<(typeof counts)[number]>(1);
const ratio = ref<(typeof ratios)[number]["value"]>("1:1");
const generating = ref(false);
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

const creditCost = computed(() => {
  const qualityFactor: Record<(typeof qualities)[number], number> = {
    "1K": 1,
    "2K": 2,
    "4K": 4,
  };
  const modelFactor: Record<ModelValue, number> = {
    "gpt-image-2": 1,
    xx: 1,
  };
  return qualityFactor[quality.value] * modelFactor[model.value] + count.value + 1;
});

const hiddenRatiosFor4K = ["1:1", "4:3", "3:4"] as const;
const visibleRatios = computed(() => (
  quality.value === "4K"
    ? ratios.filter((item) => !hiddenRatiosFor4K.includes(item.value as (typeof hiddenRatiosFor4K)[number]))
    : ratios
));

const ratioScrollIntoView = computed(() => `ratio-${ratio.value}`);

const bottomBarHeight = computed(() => rpxToPx(162) + safeAreaBottom.value);
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

onLoad((query) => {
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
  imageQuality.value = normalizeRetryImageQuality(params.quality, quality.value);
  count.value = normalizeRetryCount(params.count);
  ensureRatioForResolution(quality.value);
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
  imageQuality.value = mapQuality(quality.value);
  ensureRatioForResolution(quality.value);
}

function normalizeTemplateModel(value?: string): ModelValue {
  if (!value) return "gpt-image-2";
  const normalized = value.toLowerCase();
  if (normalized.includes("g-image") || normalized.includes("gpt-image")) {
    return "gpt-image-2";
  }
  return "gpt-image-2";
}

function normalizeTemplateRatio(value?: string): (typeof ratios)[number]["value"] {
  if (!value) return "1:1";
  const normalized = value.replace(/\s/g, "");
  const matched = ratios.find((item) => normalized.includes(item.value));
  return matched?.value || "1:1";
}

function normalizeTemplateQuality(value: Partial<TemplateItem>): (typeof qualities)[number] {
  const source = `${value.ratio || ""} ${value.title || ""} ${value.description || ""}`.toLowerCase();
  if (source.includes("1k")) return "1K";
  if (source.includes("4k") || source.includes("8k")) return "4K";
  if (source.includes("2k")) return "2K";
  return "2K";
}

function normalizeRetryModel(value?: string): ModelValue {
  return value === "gpt-image-2" || value === "xx" ? value : "gpt-image-2";
}

function normalizeRetryRatio(value?: string): (typeof ratios)[number]["value"] {
  const matched = ratios.find((item) => item.value === value);
  return matched?.value || "1:1";
}

function normalizeRetryResolution(
  value?: string,
  imageQualityValue?: string,
): (typeof qualities)[number] {
  const matched = qualities.find((item) => item === value);
  if (matched) return matched;
  if (imageQualityValue === "low") return "1K";
  if (imageQualityValue === "high") return "4K";
  return "2K";
}

function normalizeRetryImageQuality(
  value: string | undefined,
  resolutionValue: (typeof qualities)[number],
): (typeof imageQualities)[number]["value"] {
  const matched = imageQualities.find((item) => item.value === value);
  return matched?.value || mapQuality(resolutionValue);
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
      referenceImages.value = [...referenceImages.value, ...result.tempFilePaths].slice(0, maxReferenceImages);
    },
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
}

function selectResolution(value: (typeof qualities)[number]) {
  quality.value = value;
  ensureRatioForResolution(value);
}

function selectImageQuality(value: (typeof imageQualities)[number]["value"]) {
  imageQuality.value = value;
}

function ensureRatioForResolution(value: (typeof qualities)[number]) {
  if (value !== "4K") {
    return;
  }
  if (hiddenRatiosFor4K.includes(ratio.value as (typeof hiddenRatiosFor4K)[number])) {
    ratio.value = "9:16";
  }
}

function mapQuality(value: (typeof qualities)[number]) {
  const map: Record<(typeof qualities)[number], "low" | "medium" | "high"> = {
    "1K": "low",
    "2K": "medium",
    "4K": "high",
  };
  return map[value];
}

function mapResolution(value: (typeof qualities)[number]) {
  const map: Record<(typeof qualities)[number], "1K" | "2K" | "4K"> = {
    "1K": "1K",
    "2K": "2K",
    "4K": "4K",
  };
  return map[value];
}

function mapImageSize(
  ratioValue: (typeof ratios)[number]["value"],
  resolutionValue: (typeof qualities)[number],
) {
  const sizeMap: Record<(typeof ratios)[number]["value"], Partial<Record<(typeof qualities)[number], string>>> = {
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

  const mapped = sizeMap[ratioValue][resolutionValue];
  return mapped || sizeMap["1:1"]["1K"] || "1024x1024";
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

async function handleGenerate() {
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
      model: model.value === "gpt-image-2" ? model.value : "gpt-image-2",
      ratio: ratio.value,
      size: mapImageSize(ratio.value, quality.value),
      resolution: mapResolution(quality.value),
      quality: imageQuality.value,
      n: count.value,
      image_urls: imageUrls,
    });

    await navigateTo(routes.generateResult, { taskId: result.taskId });
  } catch (error) {
    const message = error instanceof Error ? error.message : "图片生成失败";
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

.reference-upload-box {
  min-height: 204rpx;
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

.ratio-icon {
  box-sizing: border-box;
  border: 3rpx solid currentColor;
  border-radius: 6rpx;
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

.generate-btn {
  transition: transform 0.2s ease, opacity 0.2s ease;
}

.model-section-label {
  display: block;
  margin-bottom: 16rpx;
  padding: 0 16rpx;
  font-size: 24rpx;
  font-weight: 500;
  line-height: 32rpx;
  letter-spacing: 1rpx;
  color: #777;
}

.model-grid {
  display: flex;
  flex-direction: row;
  flex-wrap: nowrap;
  gap: 24rpx;
  padding: 0 8rpx;
}

.model-card {
  display: flex;
  box-sizing: border-box;
  flex: 1;
  min-width: 0;
  align-items: center;
  gap: 16rpx;
  padding: 24rpx;
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
  font-size: 28rpx;
  line-height: 1;
  color: #ffffff;
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
