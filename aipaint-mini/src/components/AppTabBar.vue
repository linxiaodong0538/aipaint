<template>
  <view
    class="fixed bottom-0 left-0 right-0 z-50 flex h-[calc(146rpx+env(safe-area-inset-bottom))] items-center bg-white px-[34rpx] pb-[calc(10rpx+env(safe-area-inset-bottom))] pt-[10rpx] shadow-[0_-8rpx_28rpx_rgba(0,0,0,0.06)]"
  >
    <button
      v-for="item in tabs"
      :key="item.key"
      class="flex min-w-0 flex-1 items-center justify-center bg-transparent p-0"
      @tap="selectTab(item)"
    >
      <view
        class="flex h-[116rpx] flex-col items-center justify-center rounded-[32rpx]"
        :class="active === item.key ? 'w-[112rpx] bg-black shadow-[inset_0_1rpx_0_rgba(255,255,255,0.12)]' : 'w-[140rpx]'"
      >
        <image
          class="h-[48rpx] w-[48rpx]"
          mode="aspectFit"
          :src="active === item.key ? item.activeIcon : item.normalIcon"
        />
        <text
          class="mt-[10rpx] text-center text-[26rpx] font-bold leading-[32rpx]"
          :class="active === item.key ? 'text-white' : 'text-[#4c4546]'"
        >
          {{ item.text }}
        </text>
      </view>
    </button>
  </view>
</template>

<script setup lang="ts">
type TabKey = "home" | "templates" | "works" | "me";

type TabItem = {
  key: TabKey;
  text: string;
  pagePath: string;
  normalIcon: string;
  activeIcon: string;
};

defineProps<{
  active: TabKey;
}>();

const tabs: TabItem[] = [
  {
    key: "home",
    pagePath: "/pages/index/index",
    text: "首页",
    normalIcon: "/static/tabbar/home-normal.png",
    activeIcon: "/static/tabbar/home-active.png",
  },
  {
    key: "templates",
    pagePath: "/pages/templates/index",
    text: "模板",
    normalIcon: "/static/tabbar/templates-normal.png",
    activeIcon: "/static/tabbar/templates-active.png",
  },
  {
    key: "works",
    pagePath: "/pages/works/index",
    text: "作品库",
    normalIcon: "/static/tabbar/works-normal.png",
    activeIcon: "/static/tabbar/works-active.png",
  },
  {
    key: "me",
    pagePath: "/pages/me/index",
    text: "我的",
    normalIcon: "/static/tabbar/me-normal.png",
    activeIcon: "/static/tabbar/me-active.png",
  },
];

function selectTab(item: TabItem) {
  uni.redirectTo({
    url: item.pagePath,
  });
}
</script>
