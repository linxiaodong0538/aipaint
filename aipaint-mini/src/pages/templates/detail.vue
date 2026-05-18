rounded<template>
  <view class="flex min-h-screen flex-col bg-[#f7f7f7] font-sans text-[#1a1c1c]">
    <scroll-view class="min-h-0 flex-1" scroll-y enhanced :show-scrollbar="false">
      <view
        class="mx-auto max-w-[750rpx] px-[24rpx] pt-[8rpx]"
        :style="{ paddingBottom: `calc(200rpx + ${safeAreaBottom}px)` }"
      >
        <view class="relative overflow-hidden rounded-[32rpx] shadow-[0_20rpx_40rpx_rgba(0,0,0,0.05)]">
          <image class="block w-full" mode="widthFix" :src="image" />
        </view>

        <view class="mt-[24rpx] flex flex-col gap-[24rpx]">
          <view class="rounded-[32rpx] bg-white px-[28rpx] py-[28rpx]">
            <text class="block text-[30rpx] font-bold leading-[42rpx] text-black">
              模板详情
            </text>
            <view class="mt-[24rpx] flex flex-col gap-[20rpx]">
              <view
                v-for="row in detailRows"
                :key="row.label"
                class="flex items-center justify-between gap-[24rpx]"
              >
                <text class="shrink-0 text-[26rpx] leading-[36rpx] text-[#9a9a9a]">
                  {{ row.label }}
                </text>
                <text class="text-right text-[26rpx] font-medium leading-[36rpx] text-[#1a1c1c]">
                  {{ row.value }}
                </text>
              </view>
            </view>
          </view>

          <view class="rounded-[32rpx] bg-white px-[28rpx] py-[28rpx]">
            <view class="flex items-center justify-between gap-[16rpx]">
              <text class="text-[30rpx] font-bold leading-[42rpx] text-black">
                提示词
              </text>
              <view
                class="flex shrink-0 items-center gap-[8rpx] active:opacity-70"
                @tap="copyPrompt"
              >
                <text class="text-[24rpx] leading-none text-[#9a9a9a]">⧉</text>
                <text class="text-[24rpx] font-medium leading-[32rpx] text-[#9a9a9a]">
                  复制全文
                </text>
              </view>
            </view>
            <text class="mt-[20rpx] block whitespace-pre-line text-[26rpx] italic leading-[44rpx] text-[#333333]">
              “{{ prompt }}”
            </text>
          </view>
        </view>
      </view>
    </scroll-view>

    <view
      class="fixed inset-x-0 bottom-0 z-20 bg-gradient-to-t from-[#f7f7f7] from-70% to-transparent px-[36rpx] pt-[16rpx]"
      :style="{ paddingBottom: `calc(24rpx + ${safeAreaBottom}px)` }"
    >
      <view
        class="flex h-[104rpx] items-center justify-center gap-[12rpx] rounded-full bg-black shadow-[0_20rpx_48rpx_rgba(0,0,0,0.2)] active:scale-[0.99]"
        @tap="handleUse"
      >
        <text class="iconfont icon-shanshan leading-none text-white" style="font-size: 36rpx" />
        <text class="text-[30rpx] font-bold leading-none text-white">
          立即使用此模板
        </text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { onLoad } from "@dcloudio/uni-app";

const fallbackImage =
  "https://lh3.googleusercontent.com/aida/ADBb0ugTvaISAkWYCVI3CybD5o2emwRxAZqqwi-943erpzpWRCXsQgZC4Es-NXZBD8aeXyfM5y_G0UVThxGztTyTwuwNmzN5rSRge7BhBcHDCcVf6M_QWV1ZseGAYWPKWF-KhSBYdntLcy4eX5zcO5bzpn7aYOTTEAs0c7LQvdvEw2Uw8a2B6A_GTL2S8Bnm1gcUMJ3RKiz9vRsl5azqAD0W66fwLPTMHY582g9SpOLJErz-PT4Zq24vb4HIwmE";

const title = ref("赛博霓虹之夜");
const image = ref(fallbackImage);
const prompt = ref(
  "A cinematic wide shot of a futuristic Tokyo street at night, neon reflections on wet asphalt, deep blacks, high contrast lighting, volumetric fog, cyberpunk architecture, hyper-realistic, 8k resolution, minimalist composition, sharp focus.",
);
const tag = ref("赛博朋克");
const model = ref("V2.4 模型");
const ratio = ref("16:9");

const detailRows = computed(() => [
  { label: "分类", value: tag.value || "未分类" },
  { label: "AI 引擎", value: model.value || "通用" },
  { label: "画幅比例", value: ratio.value },
]);

const safeAreaBottom = ref(0);
try {
  const { safeAreaInsets } = uni.getSystemInfoSync();
  safeAreaBottom.value = safeAreaInsets?.bottom ?? 0;
} catch {
  safeAreaBottom.value = 0;
}

onLoad((options) => {
  if (!options) return;
  if (typeof options.title === "string" && options.title) {
    title.value = decodeURIComponent(options.title);
  }
  if (typeof options.image === "string" && options.image) {
    image.value = decodeURIComponent(options.image);
  }
  if (typeof options.desc === "string" && options.desc) {
    tag.value = decodeURIComponent(options.desc);
  }
});

function copyPrompt() {
  uni.setClipboardData({
    data: prompt.value,
    success() {
      uni.showToast({ title: "已复制", icon: "none" });
    },
  });
}

function handleUse() {
  uni.showToast({ title: "已选中模板", icon: "none" });
}
</script>
