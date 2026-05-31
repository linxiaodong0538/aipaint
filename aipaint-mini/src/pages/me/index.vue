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
      :style="{ height: scrollViewHeight }"
    >
      <view
        class="px-[36rpx]"
        :style="{
          paddingTop: `${navLayout.statusBarHeight + 12}px`,
          paddingBottom: bottomSafePadding,
        }"
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
          <view v-if="!userStore.isLogin" class="mt-[18rpx] flex flex-wrap items-center justify-center px-[32rpx]">
            <text class="text-[22rpx] leading-[34rpx] text-[var(--app-on-surface-variant)]">登录即表示同意</text>
            <text class="px-[4rpx] text-[22rpx] font-semibold leading-[34rpx] text-black" @tap.stop="openAgreement">《用户协议》</text>
            <text class="text-[22rpx] leading-[34rpx] text-[var(--app-on-surface-variant)]">和</text>
            <text class="px-[4rpx] text-[22rpx] font-semibold leading-[34rpx] text-black" @tap.stop="openPrivacy">《隐私政策》</text>
          </view>

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
                  {{ creditBalanceText }}
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

          <view
            v-if="showNewUserGiftCard"
            class="mt-[24rpx] flex w-full items-center gap-[22rpx] rounded-[28rpx] border border-[rgba(0,0,0,0.06)] bg-white px-[28rpx] py-[24rpx] shadow-[0_8rpx_28rpx_rgba(0,0,0,0.06)]"
          >
            <view class="flex h-[72rpx] w-[72rpx] shrink-0 items-center justify-center rounded-[22rpx] bg-[#eeeeee]">
              <text class="iconfont icon-jinbi text-[36rpx] leading-none text-black" />
            </view>
            <view class="min-w-0 flex-1">
              <text class="block text-[28rpx] font-bold leading-[38rpx] text-black">
                新人礼包已到账
              </text>
              <text class="mt-[4rpx] block text-[22rpx] leading-[32rpx] text-[var(--app-on-surface-variant)]">
                100积分，7天有效
              </text>
            </view>
          </view>
        </view>

        <view class="mt-[24rpx] grid grid-cols-1 gap-[20rpx]">
          <view
            v-for="task in tasks"
            :key="task.title"
            class="flex min-h-[116rpx] flex-row items-center justify-between rounded-[24rpx] bg-white px-[28rpx] py-[22rpx] text-left shadow-[0_8rpx_28rpx_rgba(0,0,0,0.06)] active:scale-[0.98]"
            @tap="handleTaskTap(task)"
          >
            <view class="flex min-w-0 items-center gap-[22rpx]">
              <view class="flex h-[72rpx] w-[72rpx] shrink-0 items-center justify-center rounded-[22rpx] bg-[#eeeeee]">
                <text
                  class="iconfont leading-none text-[var(--app-primary)]"
                  :class="task.iconClass"
                  :style="{ fontSize: task.fontSize + 'rpx' }"
                />
              </view>
              <view class="min-w-0">
                <text
                  class="block text-[28rpx] font-semibold leading-[38rpx] text-[var(--app-on-surface)]"
                >
                  {{ task.title }}
                </text>
                <text
                  class="mt-[2rpx] block text-[22rpx] leading-[30rpx] text-[var(--app-on-surface-variant)]" v-if="userStore.isLogin"
                >
                  {{ task.desc  }}
                </text>
              </view>
            </view>
                 <text class="text-[32rpx] leading-none text-[#c4c4c4] iconfont icon-jinrujiantou "></text>
          </view>
        </view>

        <view
          class="mt-[24rpx] overflow-hidden rounded-[24rpx] bg-white shadow-[0_8rpx_28rpx_rgba(0,0,0,0.06)]"
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
                class="iconfont w-[40rpx] text-center text-[34rpx] leading-none text-(--app-primary)"
                :class="item.iconClass"
              />
              <text
                class="text-[28rpx] font-semibold leading-[38rpx] text-(--app-on-surface)"
              >
                {{ item.title }}
              </text>
            </view>
            <text class="text-[32rpx] leading-none text-[#c4c4c4] iconfont icon-jinrujiantou "></text>
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
import { computed, ref } from "vue";
import { onShow } from "@dcloudio/uni-app";
import { getNavBarLayout } from "@/utils/nav-bar";
import { useUserStore } from "@/store/modules/user";
import { navigateTo, routes, switchTab } from "@/utils/router";
import { dailySignin } from "@/api/credit";

interface TaskItem {
  title: string;
  desc: string;
  iconClass: string;
  fontSize?: string;
  action: "signin";
}

interface MenuItem {
  title: string;
  iconClass: string;
  action: "credit-detail" | "recharge" | "works" | "invite-reward";
}

const navLayout = getNavBarLayout();
const userStore = useUserStore();
const safeAreaBottom = ref(0);
const windowHeight = ref(0);
const windowWidth = ref(375);
const signingIn = ref(false);

try {
  const info = uni.getSystemInfoSync();
  safeAreaBottom.value = info.safeAreaInsets?.bottom || 0;
  windowHeight.value = info.windowHeight || 0;
  windowWidth.value = info.windowWidth || 375;
} catch {
  safeAreaBottom.value = 0;
  windowHeight.value = 0;
  windowWidth.value = 375;
}

const displayName = computed(() =>
  userStore.isLogin ? userStore.profile?.nickname || "游客用户" : "游客用户",
);
const displayId = computed(() => (userStore.isLogin ? userStore.profile?.id || "-" : "-"));
const avatarSrc = computed(() => userStore.profile?.avatar || "/static/me/avatar.png");
const creditBalanceText = computed(() => formatCredits(userStore.profile?.creditBalance || 0));
const scrollViewHeight = computed(() => (windowHeight.value ? `${windowHeight.value}px` : "100vh"));
const bottomSafePadding = computed(() => {
  const bottomGap = rpxToPx(32);
  return `${safeAreaBottom.value + bottomGap}px`;
});
const showNewUserGiftCard = computed(() => {
  const expireTime = userStore.profile?.newUserGiftExpireTime;
  if (!userStore.profile?.newUserGiftGranted || !expireTime) {
    return false;
  }
  return parseDateTime(expireTime).getTime() > Date.now();
});

const tasks: TaskItem[] = [
  { title: "每日签到", desc: "+10 PTS", iconClass: "icon-qiandao", fontSize: "38", action: "signin" },
];

const menuItems: MenuItem[] = [
  { title: "积分明细", iconClass: "icon-jinbi", action: "credit-detail" },
  { title: "邀请奖励", iconClass: "icon-ewailichengjiangli", action: "invite-reward" },
  { title: "我的作品", iconClass: "icon-images", action: "works" },
];

onShow(() => {
  if (userStore.isLogin) {
    userStore.fetchProfile().catch(() => undefined);
  }
});

function formatCredits(value: number) {
  return String(value).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function parseDateTime(value: string) {
  return new Date(value.replace(/-/g, "/"));
}

function rpxToPx(rpx: number) {
  return (windowWidth.value / 750) * rpx;
}

function handleLogin() {
  userStore.loginWithWechat().catch(() => undefined);
}

function openAgreement() {
  navigateTo(routes.userAgreement);
}

function openPrivacy() {
  navigateTo(routes.privacyPolicy);
}

async function handleTaskTap(task: TaskItem) {
  if (!userStore.isLogin) {
    handleLogin();
    return;
  }

  if (task.action === "signin") {
    await handleSignin();
  }
}

async function handleSignin() {
  if (signingIn.value) {
    return;
  }

  signingIn.value = true;
  try {
    const result = await dailySignin();
    if (userStore.profile) {
      userStore.setProfile({
        ...userStore.profile,
        creditBalance: result.creditBalance,
      });
    } else {
      await userStore.fetchProfile();
    }
    uni.showToast({
      title: result.granted ? "签到成功，+10 PTS" : "今天已签到",
      icon: "none",
    });
  } finally {
    signingIn.value = false;
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

  if (item.action === "invite-reward") {
    navigateTo(routes.inviteReward);
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
