<template>
  <view class="invite-page relative h-screen overflow-hidden text-[#1a1c1c]">
    <view class="page-sheen pointer-events-none absolute left-0 top-0 h-[320rpx] w-full" />
    <scroll-view
      scroll-y
      enhanced
      :show-scrollbar="false"
      class="relative z-10"
      :style="{ height: scrollViewHeight }"
    >
      <view
        class="mx-auto max-w-[750rpx] px-[32rpx] pt-[28rpx]"
        :style="{ minHeight: scrollViewHeight, paddingBottom: bottomSafePadding }"
      >
        <section class="stats-card rounded-[30rpx] px-[32rpx] py-[24rpx]">
          <view class="grid grid-cols-3 text-center">
            <view
              v-for="(stat, index) in stats"
              :key="stat.label"
              class="flex flex-col gap-[6rpx]"
              :class="index > 0 ? 'stat-divider' : ''"
            >
              <text class="text-[22rpx] font-semibold uppercase leading-[28rpx] tracking-[3rpx] text-[#72787f]">
                {{ stat.label }}
              </text>
              <text class="text-[42rpx] font-bold leading-[50rpx] text-black">
                {{ stat.value }}
              </text>
            </view>
          </view>
        </section>

        <section class="hero-card relative mt-[22rpx] overflow-hidden rounded-[38rpx] px-[40rpx] py-[36rpx] text-white">
          <view class="hero-grid pointer-events-none absolute inset-0" />
          <view class="relative z-10 flex items-center gap-[28rpx]">
            <view class="reward-icon flex h-[132rpx] w-[132rpx] shrink-0 items-center justify-center rounded-[28rpx] bg-white text-black">
              <text class="iconfont icon-shanshan text-[68rpx] leading-none text-black" style="font-size: 68rpx"/>
            </view>
            <view class="min-w-0 flex-1">
              <text class="block text-[42rpx] font-bold leading-[52rpx] text-white" >
                分享 VisionAI 创意
              </text>
              <text class="mt-[10rpx] block text-[26rpx] leading-[38rpx] text-[rgba(255,255,255,0.72)]">
                每成功邀请一位新用户，你可获得
                <text class="font-bold text-white">50 积分</text>。
              </text>
            </view>
          </view>
        </section>

        <section class="mt-[20rpx] grid grid-cols-2 gap-[16rpx]">
          <button
            class="primary-action flex h-[96rpx] w-full items-center justify-center gap-[14rpx] rounded-[28rpx] bg-black text-[26rpx] font-semibold leading-none text-white active:opacity-90"
            open-type="share"
          >
            <text class="iconfont icon-a-huaban1fuben37 text-[32rpx] leading-none text-white" style="font-size: 38rpx;"/>
            <text class="whitespace-nowrap">微信邀请</text>
          </button>
          <button
            class="secondary-action flex h-[96rpx] w-full items-center justify-center gap-[14rpx] rounded-[28rpx] bg-white text-[26rpx] font-semibold leading-none text-black active:bg-[#f3f3f4]"
            @tap="copyInviteLink"
          >
            <view class="copy-icon">
              <view class="copy-icon-back" />
              <view class="copy-icon-front" />
            </view>
            <text class="whitespace-nowrap">复制链接</text>
          </button>
        </section>

        <section class="rules-panel mt-[22rpx] px-[48rpx] py-[38rpx]">
          <text class="rules-heading block border-b border-[rgba(0,0,0,0.07)] pb-[28rpx] text-[28rpx] font-bold leading-[36rpx] text-[#27303a]">
            活动细则
          </text>
          <view class="mt-[36rpx] flex flex-col gap-[36rpx]">
            <view v-for="rule in rules" :key="rule.title" class="flex items-start gap-[24rpx]">
              <view class="rule-index flex h-[56rpx] w-[56rpx] shrink-0 items-center justify-center rounded-full">
                <text class="text-[24rpx] font-bold leading-none text-black">{{ rule.index }}</text>
              </view>
              <view class="min-w-0 flex-1">
                <text class="block text-[28rpx] font-bold leading-[38rpx] text-black">
                  {{ rule.title }}
                </text>
                <text class="mt-[8rpx] block text-[26rpx] leading-[42rpx] text-[#465260]">
                  {{ rule.desc }}
                </text>
              </view>
            </view>
          </view>
        </section>

        <view class="mt-[20rpx] rounded-[28rpx] bg-[rgba(0,0,0,0.04)] px-[28rpx] py-[22rpx]">
          <text class="block text-[22rpx] leading-[34rpx] text-[#69717a]">
            邀请数据可能存在短暂延迟，以系统最终入账记录为准。
          </text>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { onShareAppMessage, onShow } from "@dcloudio/uni-app";
import { useUserStore } from "@/store/modules/user";
import { getInviteStats, type InviteStats } from "@/api/invite";

interface StatItem {
  label: string;
  value: string;
}

interface RuleItem {
  index: number;
  title: string;
  desc: string;
}

const userStore = useUserStore();
const windowHeight = ref(0);
const safeAreaBottom = ref(0);
const inviteStats = ref<InviteStats>({
  totalInvites: 0,
  totalRewardCredits: 0,
  todayInvites: 0,
});

updateWindowMetrics();

onShow(() => {
  updateWindowMetrics();
  loadInviteStats();
});

function updateWindowMetrics() {
  try {
    const info = uni.getSystemInfoSync();
    windowHeight.value = info.windowHeight || 0;
    safeAreaBottom.value = info.safeAreaInsets?.bottom || 0;
  } catch {
    windowHeight.value = 0;
    safeAreaBottom.value = 0;
  }
}

const inviteCode = computed(() => String(userStore.profile?.id || ""));
const inviteLink = computed(() => {
  const query = inviteCode.value ? `?inviteCode=${encodeURIComponent(inviteCode.value)}` : "";
  return `/pages/index/index${query}`;
});
const scrollViewHeight = computed(() => (windowHeight.value ? `${windowHeight.value}px` : "100vh"));
const bottomSafePadding = computed(() => `${safeAreaBottom.value + 28}px`);

const stats = computed<StatItem[]>(() => [
  { label: "累计邀请", value: formatStat(inviteStats.value.totalInvites) },
  { label: "获得积分", value: formatStat(inviteStats.value.totalRewardCredits) },
  { label: "今日邀请", value: formatStat(inviteStats.value.todayInvites) },
]);

const rules: RuleItem[] = [
  {
    index: 1,
    title: "奖励发放",
    desc: "受邀好友首次微信快捷登录后，系统将自动向邀请人发放 50 积分，好友仍可领取新人礼包 100 积分。",
  },
  {
    index: 2,
    title: "新用户定义",
    desc: "指从未在 VisionAI 登录过的微信小程序账号。同一微信账号仅可作为新用户被邀请一次。",
  },
  {
    index: 3,
    title: "防作弊声明",
    desc: "严禁通过模拟器、虚拟号或虚假刷量等不正当手段参与。一经发现，VisionAI 有权冻结账号并收回所有非法所得奖励。",
  },
];

onShareAppMessage(() => ({
  title: "分享 VisionAI 创意，领取 50 积分",
  path: inviteLink.value,
}));

async function loadInviteStats() {
  if (!userStore.isLogin) {
    inviteStats.value = {
      totalInvites: 0,
      totalRewardCredits: 0,
      todayInvites: 0,
    };
    return;
  }

  try {
    inviteStats.value = await getInviteStats();
  } catch {
    inviteStats.value = {
      totalInvites: 0,
      totalRewardCredits: 0,
      todayInvites: 0,
    };
  }
}

function formatStat(value?: number) {
  return String(value || 0);
}

function copyInviteLink() {
  uni.setClipboardData({
    data: inviteLink.value,
    success: () => {
      uni.showToast({ title: "邀请链接已复制", icon: "none" });
    },
  });
}
</script>

<style scoped>
.invite-page {
  background:
    linear-gradient(180deg, #f5f7fa 0%, #f9f9f9 42%, #f2f4f7 100%);
}

.page-sheen {
  background:
    radial-gradient(circle at 20% 0%, rgba(255, 255, 255, 0.96), rgba(255, 255, 255, 0) 52%),
    linear-gradient(180deg, rgba(226, 231, 238, 0.64), rgba(226, 231, 238, 0));
}

.stats-card {
  border: 1px solid rgba(255, 255, 255, 0.88);
  background: rgba(255, 255, 255, 0.84);
  box-shadow:
    inset 0 1rpx 0 rgba(255, 255, 255, 0.92),
    0 18rpx 46rpx rgba(52, 64, 82, 0.08);
}

.stat-divider {
  border-left: 1px solid rgba(32, 38, 46, 0.08);
}

.hero-card {
  background:
    radial-gradient(circle at 100% 0%, rgba(255, 255, 255, 0.2), rgba(255, 255, 255, 0) 42%),
    linear-gradient(135deg, #050505 0%, #191919 48%, #050505 100%);
  box-shadow:
    inset 0 1rpx 0 rgba(255, 255, 255, 0.12),
    0 26rpx 70rpx rgba(0, 0, 0, 0.18);
}

.hero-grid {
  opacity: 0.18;
  background-image:
    linear-gradient(rgba(255, 255, 255, 0.18) 1rpx, transparent 1rpx),
    linear-gradient(90deg, rgba(255, 255, 255, 0.18) 1rpx, transparent 1rpx);
  background-size: 42rpx 42rpx;
}

.reward-icon {
  box-shadow:
    inset 0 -10rpx 18rpx rgba(0, 0, 0, 0.08),
    0 18rpx 34rpx rgba(0, 0, 0, 0.28);
  transform: rotate(3deg);
}

.primary-action {
  box-shadow:
    inset 0 2rpx 0 rgba(255, 255, 255, 0.12),
    0 16rpx 34rpx rgba(0, 0, 0, 0.14);
}

.secondary-action {
  border: 1px solid rgba(25, 30, 36, 0.1);
  box-shadow:
    inset 0 1rpx 0 rgba(255, 255, 255, 0.92),
    0 14rpx 32rpx rgba(52, 64, 82, 0.06);
}

.rules-panel {
  border: 1px solid rgba(255, 255, 255, 0.86);
  background: #ffffff;
  box-shadow:
    inset 0 1rpx 0 rgba(255, 255, 255, 0.9),
    0 26rpx 70rpx rgba(54, 68, 88, 0.08);
}

.rules-heading {
  letter-spacing: 2rpx;
}

.rule-index {
  background: #eeeeee;
  box-shadow: inset 0 1rpx 0 rgba(255, 255, 255, 0.7);
}

.copy-icon {
  position: relative;
  width: 34rpx;
  height: 34rpx;
}

.copy-icon-back,
.copy-icon-front {
  position: absolute;
  width: 24rpx;
  height: 24rpx;
  border: 4rpx solid #000;
  border-radius: 4rpx;
  background: #fff;
}

.copy-icon-back {
  left: 0;
  top: 8rpx;
}

.copy-icon-front {
  right: 0;
  top: 0;
}
</style>
