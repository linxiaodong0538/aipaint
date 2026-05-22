<template>
  <view class="min-h-screen bg-[#f9f9f9] font-sans text-[#1a1c1c]">
    <scroll-view class="h-screen" scroll-y :show-scrollbar="false">
      <view
        class="mx-auto flex max-w-[750rpx] flex-col gap-[32rpx] px-[24rpx] pb-[256rpx]"
      >
        <view class="relative">
          <view
            class="w-full overflow-hidden border border-[rgba(0,0,0,0.05)] bg-[#e2e2e2] shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)]"
          >
            <image
              class="block w-full"
              mode="widthFix"
              :src="displayCover"
              @tap="previewCoverImage"
            />
          </view>
        </view>

        <view class="flex flex-col gap-[32rpx]">
          <view class="flex items-center justify-between gap-[24rpx]">
            <text class="min-w-0 flex-1 text-[32rpx] font-extrabold leading-[64rpx] text-[#1a1c1c]">
              {{ displayTitle }}
            </text>
            <text
              class="shrink-0 rounded-full bg-black px-[32rpx] py-[12rpx] text-[24rpx] font-medium leading-[32rpx] tracking-[2rpx] text-white"
            >
              {{ displayModel }}
            </text>
          </view>

          <view class="flex flex-wrap gap-[16rpx]">
            <text
              v-for="tag in tags"
              :key="tag"
              class="rounded-full border border-[rgba(0,0,0,0.05)] bg-[#eeeeee] px-[32rpx] py-[8rpx] text-[24rpx] font-medium leading-[32rpx] tracking-[2rpx] text-[#4c4546]"
            >
              {{ tag }}
            </text>
          </view>
        </view>

        <view
          class="flex flex-col gap-[32rpx] rounded-[64rpx] border border-[rgba(0,0,0,0.05)] bg-white p-[24rpx] shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)]"
        >
          <view class="flex items-center justify-between gap-[24rpx] pb-[20rpx] border-b border-dashed border-[#8d8b8863]">
    
            <view class="flex items-center gap-[8rpx]">
              <text class="text-[34rpx] leading-none text-[#7e7576]">✦</text>
              <text class="text-[28rpx] font-semibold uppercase leading-[40rpx] tracking-[4rpx] text-[#7e7576]">
                提示词
              </text>
            </view>
            <button
              class="flex h-[64rpx] items-center justify-center gap-[12rpx] rounded-full border border-[rgba(207,196,197,0.3)] bg-transparent px-[32rpx] active:bg-[#f3f3f4]"
              @tap="copyPrompt"
            >
              <text class="text-[24rpx] font-bold leading-[32rpx] text-[#1a1c1c]">⧉</text>
              <text class="text-[24rpx] font-medium leading-[32rpx] tracking-[2rpx] text-[#1a1c1c]">
                {{ copyLabel }}
              </text>
            </button>
          </view>

          <text class="text-[36rpx] font-normal leading-[56rpx] text-[#1a1c1c]">
            {{ displayPrompt }}
          </text>
        </view>
      </view>
    </scroll-view>

    <view
      class="fixed bottom-0 left-0 right-0 z-50 flex h-[160rpx] items-center justify-center border-t border-[rgba(207,196,197,0.2)] bg-[rgba(255,255,255,0.8)] px-[32rpx] backdrop-blur-[24rpx]"
      :style="{ paddingBottom: `${safeAreaBottom}px`, height: `${bottomBarHeight}px` }"
    >
      <button
        class="flex h-[112rpx] w-full max-w-[750rpx] items-center justify-center gap-[16rpx] rounded-full bg-black text-white shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)] active:scale-95"
        @tap="useTemplate"
      >
        <text class="text-[34rpx] leading-none text-white">⚡</text>
        <text class="text-[36rpx] font-bold leading-[56rpx] text-white">立即使用</text>
      </button>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { onLoad } from "@dcloudio/uni-app";
import { getTemplateDetail, type TemplateItem } from "@/api/template";
import { navigateTo, routes } from "@/utils/router";

const fallbackCover =
  "https://lh3.googleusercontent.com/aida-public/AB6AXuDEH7PpBoOnZDssRQ8C-8bNZPmj75CF3UyNy1c0U8d5Os0Yh1_Bl85x0gd4Z6ngnqKUNxL2DWDgkcm7z0fpun_zxlfnP3wCUYh5hSOVtE-otllsjULHoLy-FdRfXYHRzn7pq7qC9Zw4M1QbNH75MboRVgXriOX99GCSzRqcjTwz03lpG-VOJm9Spjcc02lW_iXxe4-YZ-WqgfRyYrvf8Y8iKWwXVsFxOKMj58Pr6a3ilSE3BHpoLmQvxvcckMlUIQENHFTGrp0v-fJd";
const fallbackPrompt =
  "masterpiece, best quality, cyberpunk city, neon lights, rainy night, reflections, detailed background, solo, standing, futuristic outfit, glowing accents, dark moody atmosphere, 8k resolution, photorealistic";

const safeAreaBottom = ref(0);
const windowWidth = ref(375);
const copyLabel = ref("复制");
const template = ref<TemplateItem | null>(null);
const templateId = ref<string | number>("");
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
const displayCover = computed(() => template.value?.coverUrl || fallbackCover);
const displayTitle = computed(() => template.value?.title || "赛博霓虹之夜");
const displayModel = computed(() => `${template.value?.aiEngine || "V2.4"}`);
const displayPrompt = computed(() => template.value?.prompt || fallbackPrompt);
const tags = computed(() => {
  const category = template.value?.categoryName || "赛博朋克";
  const ratio = template.value?.ratio || "8K 极致";
  return [category, "占位tag", ratio];
});

function rpxToPx(rpx: number) {
  return (windowWidth.value / 750) * rpx;
}

async function loadTemplate(id: string | number) {
  try {
    template.value = await getTemplateDetail(id);
  } catch {
    uni.showToast({ title: "模板加载失败", icon: "none" });
  }
}

function copyPrompt() {
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
  if (currentTemplate) {
    uni.setStorageSync(selectedTemplateStorageKey, {
      templateId: currentTemplate.templateId,
      title: currentTemplate.title,
      prompt: currentTemplate.prompt,
      aiEngine: currentTemplate.aiEngine,
      ratio: currentTemplate.ratio,
      description: currentTemplate.description,
      categoryName: currentTemplate.categoryName,
      coverUrl: currentTemplate.coverUrl,
    });
  }

  navigateTo(routes.generate, {
    templateId: templateId.value,
    fromTemplate: true,
  });
}

onLoad((query) => {
  const id = query?.id;
  if (!id) return;

  templateId.value = id;
  loadTemplate(id);
});
</script>
