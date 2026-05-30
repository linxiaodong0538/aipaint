<template>
  <view class="min-h-screen bg-[#f8f8f8] font-sans text-[#1a1c1c]">
    <scroll-view class="h-screen" scroll-y enhanced :show-scrollbar="false">
      <view class="mx-auto flex max-w-[750rpx] flex-col gap-[24rpx] px-[24rpx] pb-[256rpx] pt-[24rpx]">
        <view v-if="loading" class="flex min-h-[720rpx] flex-col items-center justify-center gap-[24rpx] text-center">
          <view class="h-[72rpx] w-[72rpx] animate-spin rounded-full border-[6rpx] border-[#d9d9d9] border-t-black" />
          <text class="text-[26rpx] font-medium leading-[36rpx] text-[#7e7576]">模板加载中</text>
        </view>

        <view v-else-if="loadFailed" class="flex min-h-[720rpx] flex-col items-center justify-center px-[48rpx] text-center">
          <view class="flex h-[128rpx] w-[128rpx] items-center justify-center rounded-full bg-[#e2e2e2]">
            <text class="text-[64rpx] font-light leading-none text-black">!</text>
          </view>
          <text class="mt-[28rpx] text-[32rpx] font-bold leading-[44rpx] text-black">模板加载失败</text>
          <text class="mt-[12rpx] text-[24rpx] leading-[36rpx] text-[#7e7576]">请返回后重新打开模板</text>
          <button
            class="mt-[36rpx] m-0 rounded-full bg-black px-[46rpx] py-[18rpx] text-[26rpx] font-semibold leading-[34rpx] text-white active:scale-95"
            hover-class="none"
            @tap="goBack"
          >
            返回
          </button>
        </view>

        <template v-else>
          <view class="overflow-hidden rounded-[20rpx] border border-[rgba(0,0,0,0.05)] bg-[#e2e2e2] shadow-[0_24rpx_64rpx_rgba(0,0,0,0.06)]">
            <image
              v-if="displayCover"
              class="block w-full"
              mode="widthFix"
              :src="displayCover"
              @tap="previewCoverImage"
            />
            <view v-else class="flex aspect-square w-full items-center justify-center bg-[#e2e2e2]">
              <text class="text-[26rpx] font-medium leading-[36rpx] text-[#7e7576]">暂无封面</text>
            </view>
          </view>

          <view class="flex flex-col gap-[18rpx] rounded-[20rpx] bg-white px-[28rpx] py-[28rpx] shadow-[0_16rpx_44rpx_rgba(0,0,0,0.04)]">
            <text class="text-[40rpx] font-extrabold leading-[54rpx] text-black">
              {{ displayTitle }}
            </text>
            <text v-if="displayDescription" class="text-[26rpx] leading-[40rpx] text-[#5f5e5e]">
              {{ displayDescription }}
            </text>

            <view v-if="tagNames.length" class="flex flex-wrap gap-[12rpx] pt-[4rpx]">
              <text
                v-for="tag in tagNames"
                :key="tag"
                class="rounded-full border border-[rgba(0,0,0,0.05)] bg-[#f6f6f6] px-[20rpx] py-[8rpx] text-[22rpx] font-semibold leading-[30rpx] text-[#4c4546]"
              >
                {{ tag }}
              </text>
            </view>
          </view>

          <view class="grid grid-cols-2 gap-[16rpx]">
            <view
              v-for="item in metaItems"
              :key="item.label"
              class="min-h-[112rpx] rounded-[18rpx] bg-white px-[24rpx] py-[18rpx] shadow-[0_14rpx_36rpx_rgba(0,0,0,0.035)]"
              :class="item.wide ? 'col-span-2' : ''"
            >
              <text class="block text-[22rpx] font-semibold leading-[30rpx] text-[#8a8586]">{{ item.label }}</text>
              <text class="mt-[8rpx] block truncate text-[28rpx] font-bold leading-[38rpx] text-black">{{ item.value }}</text>
            </view>
          </view>

          <view
            class="flex flex-col gap-[16rpx] rounded-[20rpx] bg-white p-[28rpx] shadow-[0_16rpx_44rpx_rgba(0,0,0,0.04)]"
          >
            <view class="flex items-center justify-between gap-[24rpx] border-b border-dashed border-[#d8d3d4] pb-[20rpx]">
              <view class="flex items-center gap-[10rpx]">
                <text class="iconfont icon-magic text-[26rpx] leading-none text-[#7e7576]" />
                <text class="text-[24rpx] font-semibold leading-[32rpx] tracking-[2rpx] text-[#7e7576]">提示词</text>
              </view>
              <button
                class="m-0 flex h-[56rpx] items-center justify-center gap-[12rpx] rounded-full border border-[rgba(207,196,197,0.4)] bg-transparent px-[26rpx] active:bg-[#f3f3f4]"
                hover-class="none"
                @tap="copyPrompt"
              >
                <text class="text-[24rpx] font-bold leading-[32rpx] text-[#1a1c1c]">⧉</text>
                <text class="text-[24rpx] font-medium leading-[32rpx] tracking-[2rpx] text-[#1a1c1c]">
                  {{ copyLabel }}
                </text>
              </button>
            </view>

            <text class="whitespace-pre-wrap text-[25rpx] font-normal leading-[42rpx] text-[#1a1c1c]">
              {{ displayPrompt }}
            </text>
          </view>
        </template>
      </view>
    </scroll-view>

    <view
      class="fixed bottom-0 left-0 right-0 z-50 flex h-[160rpx] items-center justify-center border-t border-[rgba(207,196,197,0.2)] bg-[rgba(255,255,255,0.88)] px-[32rpx] backdrop-blur-[24rpx]"
      :style="{ paddingBottom: `${safeAreaBottom}px`, height: `${bottomBarHeight}px` }"
    >
      <button
        class="m-0 flex h-[112rpx] w-full max-w-[750rpx] items-center justify-center rounded-full bg-black text-white shadow-[0_28rpx_64rpx_rgba(0,0,0,0.12)] active:scale-95 disabled:bg-[#bdbdbd]"
        hover-class="none"
        :disabled="loading || loadFailed"
        @tap="useTemplate"
      >
        <text class="text-[34rpx] font-bold leading-[50rpx] text-white">立即使用</text>
      </button>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { onLoad } from "@dcloudio/uni-app";
import { getTemplateDetail, type TemplateItem } from "@/api/template";
import { navigateTo, routes } from "@/utils/router";

const safeAreaBottom = ref(0);
const windowWidth = ref(375);
const copyLabel = ref("复制");
const template = ref<TemplateItem | null>(null);
const templateId = ref<string | number>("");
const loading = ref(false);
const loadFailed = ref(false);
const selectedTemplateStorageKey = "generate:selectedTemplate";

try {
  const info = uni.getSystemInfoSync();
  safeAreaBottom.value = info.safeAreaInsets?.bottom || 0;
  windowWidth.value = info.windowWidth || 375;
} catch {
  safeAreaBottom.value = 0;
  windowWidth.value = 375;
}

const bottomBarHeight = computed(() => safeAreaBottom.value + rpxToPx(160));
const displayCover = computed(() => template.value?.coverUrl || "");
const displayTitle = computed(() => template.value?.title || "模板详情");
const displayCategory = computed(() => template.value?.categoryName || "");
const displayDescription = computed(() => template.value?.description || "");
const displayPrompt = computed(() => template.value?.prompt || "暂无提示词");
const displayEngine = computed(() => formatEngine(template.value?.aiEngine));
const displayRatio = computed(() => template.value?.ratio || "");
const tagNames = computed(() => {
  const names = (template.value?.tags || []).map((tag) => tag.tagName).filter(Boolean);
  return Array.from(new Set(names)).slice(0, 8);
});
const metaItems = computed(() => [
  { label: "推荐模型", value: displayEngine.value },
  { label: "画面比例", value: displayRatio.value || "按模板默认" },
  { label: "分类", value: displayCategory.value || "未分类", wide: true },
]);

function rpxToPx(rpx: number) {
  return (windowWidth.value / 750) * rpx;
}

async function loadTemplate(id: string | number) {
  loading.value = true;
  loadFailed.value = false;
  try {
    template.value = await getTemplateDetail(id);
  } catch {
    loadFailed.value = true;
    template.value = null;
    uni.showToast({ title: "模板加载失败", icon: "none" });
  } finally {
    loading.value = false;
  }
}

function formatEngine(value?: string) {
  if (!value) return "默认模型";
  if (value === "gpt-image-2") return "GPT Image 2";
  if (value === "gpt-image-2-vip") return "GPT Image 2 VIP";
  if (value === "nano-banana") return "Nano Banana";
  if (value === "nano-banana-2") return "Nano Banana 2";
  if (value === "nano-banana-pro") return "Nano Banana Pro";
  return value;
}

function formatDate(value?: string) {
  if (!value) return "";
  return value.slice(0, 10);
}

function copyPrompt() {
  if (!displayPrompt.value || displayPrompt.value === "暂无提示词") return;
  uni.setClipboardData({
    data: displayPrompt.value,
    success() {
      copyLabel.value = "已复制";
      setTimeout(() => {
        copyLabel.value = "复制";
      }, 2000);
    },
  });
}

function previewCoverImage() {
  if (!displayCover.value) return;

  uni.previewImage({
    urls: [displayCover.value],
    current: displayCover.value,
  });
}

function useTemplate() {
  const currentTemplate = template.value;
  if (!currentTemplate) {
    uni.showToast({ title: "模板未加载完成", icon: "none" });
    return;
  }

  uni.setStorageSync(selectedTemplateStorageKey, {
    templateId: currentTemplate.templateId,
    title: currentTemplate.title,
    prompt: currentTemplate.prompt,
    aiEngine: currentTemplate.aiEngine,
    ratio: currentTemplate.ratio,
    description: currentTemplate.description,
    categoryName: currentTemplate.categoryName,
    coverUrl: currentTemplate.coverUrl,
    tags: currentTemplate.tags,
  });

  navigateTo(routes.generate, {
    templateId: templateId.value,
    fromTemplate: true,
  });
}

function goBack() {
  uni.navigateBack();
}

onLoad((query) => {
  const id = query?.id;
  if (!id) {
    loadFailed.value = true;
    return;
  }

  templateId.value = id;
  loadTemplate(id);
});
</script>
