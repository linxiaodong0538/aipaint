<template>
  <view
    class="relative shrink-0 overflow-hidden bg-black text-white"
    :style="{ height: `${navLayout.totalHeight}px` }"
  >
    <view :style="{ height: `${navLayout.statusBarHeight}px` }" />
    <view
      class="relative flex items-center px-[24rpx]"
      :style="{
        height: `${navLayout.navContentHeight}px`,
        paddingRight: `${navLayout.menuButtonRight + navLayout.menuButtonGap}px`,
      }"
    >
      <view class="relative z-10 flex min-w-0 shrink-0 items-center">
        <slot name="left" />
      </view>

      <text
        class="nav-art-title pointer-events-none absolute left-1/2 top-1/2 max-w-[300rpx] -translate-x-1/2 -translate-y-1/2 truncate"
        :class="{ 'nav-art-title--italic': italic }"
      >
        {{ title }}
      </text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { getNavBarLayout } from "@/utils/nav-bar";

withDefaults(
  defineProps<{
    title: string;
    italic?: boolean;
  }>(),
  {
    italic: false,
  },
);

const navLayout = getNavBarLayout();
</script>

<style scoped>
.nav-art-title {
  color: rgba(255, 255, 255, 0.9);
  /* font-family: Georgia, "Times New Roman", serif; */
  font-size: 14px;
  /* font-weight: 600; */
  line-height: 30px;
  text-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.18);
}

.nav-art-title--italic {
  font-style: italic;
}
</style>
