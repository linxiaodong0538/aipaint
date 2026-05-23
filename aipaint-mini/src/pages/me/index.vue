<template>
  <view
    class="relative min-h-screen overflow-hidden bg-[#f7f7f7] text-(--app-on-surface)"
  >
    <view
      class="pointer-events-none absolute inset-x-0 top-0 h-[520rpx] overflow-hidden"
    >
      <image
        src="/static/me/header-bg.png"
        mode="aspectFill"
        class="h-full w-full"
      />
      <view
        class="absolute inset-0 bg-linear-to-b from-[rgba(247,247,247,0)] via-[rgba(247,247,247,0.35)] to-[#f7f7f7]"
      />
    </view>

    <scroll-view
      class="relative z-10 h-screen"
      scroll-y
      enhanced
      :show-scrollbar="false"
    >
      <view
        class="px-[36rpx]"
        :style="{ paddingTop: `${navLayout.statusBarHeight + 12}px` }"
      >
        <view class="flex flex-col items-center pt-[48rpx]">
          <view class="relative">
            <image
              :src="avatarSrc"
              mode="aspectFill"
              class="h-[176rpx] w-[176rpx] overflow-hidden rounded-full border-[4rpx] border-[rgba(255,255,255,0.72)] bg-white shadow-[0_20rpx_40rpx_rgba(0,0,0,0.14)]"
            />
            <view
              class="absolute bottom-[8rpx] right-[2rpx] flex h-[44rpx] w-[44rpx] items-center justify-center rounded-full border-[4rpx] border-[#f7f7f7] bg-[var(--app-primary)]"
            >
              <text class="text-[20rpx] font-bold leading-none text-white icon-gou2x iconfont" style="font-size: 24rpx;"
                ></text
              >
            </view>
          </view>

          <text
            class="mt-[28rpx] text-center text-[44rpx] font-bold leading-[56rpx] tracking-[-0.5rpx] text-(--app-primary)"
          >
            {{ displayName }}
          </text>
          <text
            class="mt-[8rpx] text-center text-[24rpx] leading-[32rpx] text-(--app-on-surface-variant)"
          >
            ID:{{ displayId }}
          </text>

          <button
            v-if="!userStore.isLogin"
            class="mt-[24rpx] flex h-[72rpx] min-w-[240rpx] items-center justify-center rounded-full bg-black px-[44rpx] text-[28rpx] font-semibold leading-none text-white"
            :loading="userStore.loggingIn"
            @tap="handleLogin"
          >
            一键快捷登录
          </button>

          <view
            v-if="userStore.isLogin"
            class="mt-[36rpx] flex w-full items-center justify-between rounded-[32rpx] bg-black px-[40rpx] py-[36rpx]"
          >
            <view class="flex min-w-0 flex-col">
              <text
                class="text-[28rpx] font-medium leading-[32rpx] text-white/60"
              >
                当前积分
              </text>
              <view class="mt-[8rpx] flex items-baseline">
                <text
                  class="text-[56rpx] font-bold leading-[64rpx] tracking-[-1rpx] text-white"
                >
                  12,850
                </text>
                <text
                  class="ml-[12rpx] text-[28rpx] font-semibold leading-[36rpx] text-white"
                >
                  PTS
                </text>
              </view>
            </view>
            <view
              class="ml-[24rpx] shrink-0 rounded-full bg-white px-[36rpx] py-[16rpx] active:opacity-85"
              @tap="handleRecharge"
            >
              <text
                class="whitespace-nowrap text-[26rpx] font-semibold leading-[34rpx] text-black"
              >
                立即充值
              </text>
            </view>
          </view>
        </view>

        <view class="mt-[36rpx] grid grid-cols-3 gap-[20rpx]">
          <view
            v-for="task in tasks"
            :key="task.title"
            class="flex min-h-[168rpx] flex-col items-center justify-center rounded-[24rpx] bg-white px-[12rpx] py-[20rpx] text-center shadow-[0_8rpx_28rpx_rgba(0,0,0,0.06)] active:scale-[0.98]"
            @tap="handleUserAction"
          >
            <text
              class="iconfont text-[44rpx] leading-none text-[var(--app-primary)]"
              :class="task.iconClass"
              :style="{ fontSize: task.fontSize + 'rpx' }"
            />
            <text
              class="mt-[14rpx] whitespace-nowrap text-[26rpx] font-semibold leading-[34rpx] text-[var(--app-on-surface)]"
            >
              {{ task.title }}
            </text>
            <text
              class="mt-[4rpx] text-[22rpx] leading-[28rpx] text-[var(--app-on-surface-variant)]"
            >
              {{ userStore.isLogin ? task.desc : "登录查看" }}
            </text>
          </view>
        </view>

        <view
          class="mt-[36rpx] overflow-hidden rounded-[24rpx] bg-white shadow-[0_8rpx_28rpx_rgba(0,0,0,0.06)]"
        >
          <view
            v-for="(item, index) in menuItems"
            :key="item.title"
            class="flex h-[96rpx] items-center justify-between px-[28rpx] active:bg-[#fafafa]"
            :class="
              index !== menuItems.length - 1
                ? 'border-b border-[rgba(0,0,0,0.06)]'
                : ''
            "
            @tap="handleMenuClick(item)"
          >
            <view class="flex min-w-0 items-center gap-[22rpx]">
              <text
                class="iconfont w-[40rpx] text-center text-[34rpx] leading-none text-[var(--app-primary)]"
                :class="item.iconClass"
              />
              <text
                class="text-[28rpx] font-semibold leading-[38rpx] text-[var(--app-on-surface)]"
              >
                {{ item.title }}
              </text>
            </view>
            <text class="text-[32rpx] leading-none text-[#c4c4c4]">›</text>
          </view>
        </view>

        <view
          v-if="userStore.isLogin"
          class="mt-[24rpx] flex h-[96rpx] items-center justify-center gap-[14rpx] rounded-[24rpx] bg-white shadow-[0_8rpx_28rpx_rgba(0,0,0,0.06)] active:scale-[0.99]"
          @tap="handleLogout"
        >
          <text
            class="iconfont icon-tuichu text-[34rpx] leading-none"
          />
          <text
            class="text-[28rpx] font-semibold leading-[38rpx]"
            >退出登录</text
          >
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { computed } from "vue";
import { onShow } from "@dcloudio/uni-app";
import { getNavBarLayout } from "@/utils/nav-bar";
import { useUserStore } from "@/store/modules/user";
import { navigateTo, routes, switchTab } from "@/utils/router";

interface TaskItem {
  title: string;
  desc: string;
  iconClass: string;
  fontSize?: string;
}

interface MenuItem {
  title: string;
  iconClass: string;
  action: "credit-detail" | "recharge" | "works";
}

const navLayout = getNavBarLayout();
const userStore = useUserStore();

const displayName = computed(() =>
  userStore.isLogin ? userStore.profile?.nickname || "游客用户" : "游客用户",
);
const displayId = computed(() => (userStore.isLogin ? userStore.profile?.id || "-" : "-"));
const avatarSrc = computed(() => userStore.profile?.avatar || "/static/me/avatar.png");

const tasks: TaskItem[] = [
  { title: "每日签到", desc: "+50 PTS", iconClass: "icon-qiandao" },
  {
    title: "观看视频",
    desc: "+20 PTS",
    iconClass: "icon-bofang",
    fontSize: "42",
  },
  {
    title: "邀请奖励",
    desc: "+100 PTS",
    iconClass: "icon-jinbi",
    fontSize: "38",
  },
];

const menuItems: MenuItem[] = [
  { title: "积分充值", iconClass: "icon-jinbi", action: "recharge" },
  { title: "我的积分", iconClass: "icon-jinbi", action: "credit-detail" },
  { title: "我的作品", iconClass: "icon-images", action: "works" },
];

onShow(() => {
  if (userStore.isLogin && !userStore.profile) {
    userStore.fetchProfile().catch(() => undefined);
  }
});

function handleLogin() {
  userStore.loginWithWechat().catch(() => undefined);
}

function handleUserAction() {
  if (!userStore.isLogin) {
    handleLogin();
  }
}

function handleMenuClick(item: MenuItem) {
  if (!userStore.isLogin) {
    handleLogin();
    return;
  }

  if (item.action === "credit-detail") {
    navigateTo(routes.creditDetail);
    return;
  }

  if (item.action === "recharge") {
    navigateTo(routes.recharge);
    return;
  }

  switchTab(routes.works);
}

function handleRecharge() {
  if (!userStore.isLogin) {
    handleLogin();
    return;
  }
  navigateTo(routes.recharge);
}

function handleLogout() {
  userStore.logout();
  uni.showToast({ title: "已退出登录", icon: "none" });
}
</script>
