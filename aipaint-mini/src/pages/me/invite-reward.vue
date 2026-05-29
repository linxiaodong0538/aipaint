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
        <section class="hero-card relative overflow-hidden rounded-[40rpx] px-[38rpx] pb-[34rpx] pt-[36rpx] text-white">
          <view class="hero-grid pointer-events-none absolute inset-0" />
          <view class="hero-glow pointer-events-none absolute right-[-120rpx] top-[-130rpx] h-[320rpx] w-[320rpx] rounded-full" />
          <view class="relative z-10">
            <view class="flex items-center justify-between gap-[20rpx]">
              <view class="inline-flex items-center rounded-full bg-white/10 px-[20rpx] py-[10rpx]">
                <text class="text-[22rpx] font-semibold leading-[28rpx] text-[rgba(255,255,255,0.72)]">
                  邀请奖励
                </text>
              </view>
              <text class="text-[22rpx] font-semibold leading-[28rpx] text-[rgba(255,255,255,0.54)]">
                永久有效积分
              </text>
            </view>

            <view class="mt-[32rpx] flex items-end justify-between gap-[24rpx]">
              <view class="min-w-0 flex-1">
                <text class="block text-[42rpx] font-bold leading-[52rpx] text-white">
                  邀请好友一起创作
                </text>
                <text class="mt-[12rpx] block text-[26rpx] leading-[38rpx] text-[rgba(255,255,255,0.62)]">
                  好友首次微信快捷登录后，你将获得奖励。
                </text>
              </view>
              <view class="reward-badge flex h-[150rpx] w-[150rpx] shrink-0 flex-col items-center justify-center rounded-full bg-white text-black">
                <text class="text-[58rpx] font-bold leading-[60rpx] text-black">50</text>
                <text class="mt-[4rpx] text-[22rpx] font-semibold leading-[28rpx] text-[#555]">积分</text>
              </view>
            </view>

            <view class="flow-strip mt-[34rpx] grid grid-cols-3 overflow-hidden rounded-[28rpx]">
              <view
                v-for="(step, index) in inviteSteps"
                :key="step.title"
                class="flow-step flex min-h-[116rpx] flex-col justify-center px-[20rpx]"
                :class="index > 0 ? 'flow-divider' : ''"
              >
                <text class="text-[20rpx] font-semibold leading-[28rpx] text-[rgba(255,255,255,0.42)]">
                  0{{ index + 1 }}
                </text>
                <text class="mt-[4rpx] text-[24rpx] font-bold leading-[32rpx] text-white">
                  {{ step.title }}
                </text>
                <text class="mt-[2rpx] text-[20rpx] leading-[28rpx] text-[rgba(255,255,255,0.48)]">
                  {{ step.desc }}
                </text>
              </view>
            </view>

            <button
              class="hero-share mt-[32rpx] flex h-[104rpx] w-full items-center justify-center gap-[16rpx] rounded-[30rpx] bg-white text-[28rpx] font-bold leading-none text-black active:opacity-90"
              open-type="share"
            >
              <text class="iconfont icon-a-huaban1fuben37 text-[34rpx] leading-none text-black" style="font-size: 40rpx;"/>
              <text class="whitespace-nowrap">微信邀请</text>
            </button>
          </view>
        </section>

        <section class="stats-card mt-[20rpx] rounded-[30rpx] px-[32rpx] py-[28rpx]">
          <view class="flex items-center justify-between">
            <view class="min-w-0">
              <text class="block text-[24rpx] font-semibold leading-[32rpx] text-[#737980]">
                我的邀请数据
              </text>
              <text class="mt-[4rpx] block text-[22rpx] leading-[30rpx] text-[#9aa1a8]">
                已入账奖励会自动累计
              </text>
            </view>
            <view class="stats-mark flex h-[64rpx] w-[64rpx] shrink-0 items-center justify-center rounded-full">
              <text class="iconfont icon-jinbi text-[32rpx] leading-none text-black" />
            </view>
          </view>

          <view class="mt-[26rpx] grid grid-cols-3 text-center">
            <view
              v-for="(stat, index) in stats"
              :key="stat.label"
              class="flex flex-col gap-[6rpx]"
              :class="index > 0 ? 'stat-divider' : ''"
            >
              <text class="text-[22rpx] font-semibold uppercase leading-[28rpx] tracking-[2rpx] text-[#818891]">
                {{ stat.label }}
              </text>
              <text class="text-[44rpx] font-bold leading-[52rpx] text-black">
                {{ stat.value }}
              </text>
            </view>
          </view>
        </section>

        <section class="rules-panel mt-[20rpx] px-[34rpx] py-[34rpx]">
          <view class="flex items-center justify-between">
            <text class="rules-heading block text-[30rpx] font-bold leading-[38rpx] text-[#20262d]">
              活动细则
            </text>
            <text class="text-[22rpx] font-semibold leading-[30rpx] text-[#9aa1a8]">
              自动结算
            </text>
          </view>
          <view class="mt-[30rpx] flex flex-col gap-[26rpx]">
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

interface InviteStep {
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

const inviteSteps: InviteStep[] = [
  { title: "分享", desc: "发给好友" },
  { title: "登录", desc: "新用户进入" },
  { title: "到账", desc: "奖励入账" },
];

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

.stats-mark {
  background: #eeeeee;
  box-shadow: inset 0 1rpx 0 rgba(255, 255, 255, 0.72);
}

.stat-divider {
  border-left: 1px solid rgba(32, 38, 46, 0.08);
}

.hero-card {
  background:
    radial-gradient(circle at 100% 0%, rgba(255, 255, 255, 0.18), rgba(255, 255, 255, 0) 42%),
    linear-gradient(135deg, #050505 0%, #1f2225 54%, #070707 100%);
  box-shadow:
    inset 0 1rpx 0 rgba(255, 255, 255, 0.12),
    0 26rpx 70rpx rgba(0, 0, 0, 0.18);
}

.hero-glow {
  background: rgba(255, 255, 255, 0.1);
  filter: blur(2rpx);
}

.hero-grid {
  opacity: 0.14;
  background-image:
    linear-gradient(rgba(255, 255, 255, 0.18) 1rpx, transparent 1rpx),
    linear-gradient(90deg, rgba(255, 255, 255, 0.18) 1rpx, transparent 1rpx);
  background-size: 42rpx 42rpx;
}

.reward-badge {
  box-shadow:
    inset 0 -12rpx 18rpx rgba(0, 0, 0, 0.06),
    0 22rpx 42rpx rgba(0, 0, 0, 0.26);
}

.flow-strip {
  border: 1px solid rgba(255, 255, 255, 0.08);
  background: rgba(255, 255, 255, 0.07);
}

.flow-step {
  background: rgba(255, 255, 255, 0.03);
}

.flow-divider {
  border-left: 1px solid rgba(255, 255, 255, 0.08);
}

.hero-share {
  box-shadow:
    inset 0 -4rpx 0 rgba(0, 0, 0, 0.06),
    0 18rpx 34rpx rgba(0, 0, 0, 0.22);
}

.rules-panel {
  border-radius: 32rpx;
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

</style>
