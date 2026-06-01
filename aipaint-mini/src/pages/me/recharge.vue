<template>
  <view class="min-h-screen bg-[#f8f8f8] text-[#1a1c1c]">
    <scroll-view class="h-screen" scroll-y enhanced :show-scrollbar="false">
      <view class="mx-auto min-h-screen max-w-[750rpx] px-[32rpx] pb-[200rpx] pt-[32rpx]">
        <section class="mb-[32rpx]">
          <view class="relative overflow-hidden rounded-[48rpx] bg-black px-[48rpx] py-[48rpx] text-white shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)]">
            <view class="pointer-events-none absolute inset-0 bg-[radial-gradient(circle_at_top_right,rgba(255,255,255,0.16),transparent_42%)] opacity-80" />
            <view class="relative z-10">
              <text class="block text-[24rpx] font-medium uppercase tracking-[6rpx] text-white/60">
                当前可用积分
              </text>
              <view class="mt-[14rpx] flex items-end">
                <text class="text-[84rpx] font-bold leading-none text-white">
                  {{ creditBalanceText }}
                </text>
                <text class="ml-[12rpx] pb-[8rpx] text-[28rpx] font-semibold leading-[36rpx] text-white/60">
                  PTS
                </text>
              </view>
              <view class="mt-[34rpx] rounded-[30rpx] border border-white/10 bg-white/[0.07] px-[28rpx] py-[24rpx] shadow-[inset_0_1rpx_0_rgba(255,255,255,0.10)]">
                <view class="flex items-center justify-between gap-[24rpx]">
                  <view class="flex min-w-0 items-center gap-[18rpx]">
                    <view class="flex h-[58rpx] w-[58rpx] shrink-0 items-center justify-center rounded-full bg-white">
                      <text class="vip-gold-letter">V</text>
                    </view>
                    <view class="min-w-0">
                      <text class="block text-[28rpx] font-bold leading-[36rpx] text-white">
                        {{ activeTier.label }}
                      </text>
                      <text class="mt-[4rpx] block text-[20rpx] leading-[28rpx] text-white/48">
                        {{ memberExpireText }}
                      </text>
                    </view>
                  </view>
                  <text class="shrink-0 text-[20rpx] font-medium leading-[28rpx] text-white/42">
                    {{ memberStatusText }}
                  </text>
                </view>
              </view>
            </view>
          </view>
        </section>

        <section class="mb-[36rpx]">
          <view class="grid grid-cols-2 rounded-full bg-[#eeeeee] p-[6rpx]">
            <button
              v-for="mode in modes"
              :key="mode.value"
              class="flex h-[72rpx] items-center justify-center rounded-full text-[26rpx] font-semibold leading-none active:scale-[0.98]"
              :class="activeMode === mode.value ? 'bg-black text-white shadow-[0_12rpx_28rpx_rgba(0,0,0,0.12)]' : 'bg-transparent text-[#5f5e5e]'"
              @tap="activeMode = mode.value"
            >
              {{ mode.label }}
            </button>
          </view>
        </section>

        <section v-if="activeMode === 'membership'" class="mb-[40rpx]">
          <view class="mb-[22rpx] flex items-end justify-between">
            <text class="text-[34rpx] font-bold leading-[44rpx] text-black">会员套餐</text>
            <text class="text-[22rpx] font-medium leading-[32rpx] text-[#777]">每月送积分</text>
          </view>

          <view class="flex flex-col gap-[18rpx]">
            <button
              v-for="plan in membershipPlans"
              :key="plan.id"
              class="relative flex min-h-[204rpx] flex-col items-stretch rounded-[32rpx] border bg-white p-[28rpx] text-left active:scale-[0.99]"
              :class="plan.recommended ? 'border-black shadow-[0_18rpx_44rpx_rgba(0,0,0,0.08)]' : 'border-[rgba(0,0,0,0.06)]'"
              @tap="handleBuyMembership(plan)"
            >
              <view class="flex items-start justify-between gap-[24rpx]">
                <view class="min-w-0">
                  <view class="flex items-center gap-[12rpx]">
                    <text class="text-[32rpx] font-bold leading-[42rpx] text-black">{{ plan.name }}</text>
                    <text
                      v-if="plan.recommended"
                      class="rounded-full bg-black px-[14rpx] py-[4rpx] text-[18rpx] font-semibold leading-[24rpx] text-white"
                    >
                      推荐
                    </text>
                  </view>
                  <text class="mt-[10rpx] block text-[24rpx] leading-[34rpx] text-[#777]">
                    {{ plan.desc }}
                  </text>
                </view>
                <view class="shrink-0 text-right">
                  <text class="block text-[38rpx] font-bold leading-[48rpx] text-black">¥{{ plan.price }}</text>
                  <text class="mt-[2rpx] block text-[20rpx] leading-[28rpx] text-[#777]">/ 月</text>
                </view>
              </view>

              <view class="mt-[28rpx] grid grid-cols-3 gap-[12rpx]">
                <view class="rounded-[24rpx] bg-[#f4f4f4] px-[18rpx] py-[16rpx]">
                  <text class="block text-[20rpx] leading-[28rpx] text-[#777]">每月积分</text>
                  <text class="mt-[4rpx] block text-[26rpx] font-bold leading-[34rpx] text-black">{{ formatCredits(plan.monthlyCredits) }}</text>
                </view>
                <view class="rounded-[24rpx] bg-[#f4f4f4] px-[18rpx] py-[16rpx]">
                  <text class="block text-[20rpx] leading-[28rpx] text-[#777]">加量优惠</text>
                  <text class="mt-[4rpx] block text-[26rpx] font-bold leading-[34rpx] text-black">+{{ plan.addonBonus }}%</text>
                </view>
                <view class="rounded-[24rpx] bg-[#f4f4f4] px-[18rpx] py-[16rpx]">
                  <text class="block text-[20rpx] leading-[28rpx] text-[#777]">约出图</text>
                  <text class="mt-[4rpx] block text-[26rpx] font-bold leading-[34rpx] text-black">{{ formatImageCount(plan.monthlyCredits) }}张</text>
                </view>
              </view>
              <!-- <text class="mt-[18rpx] whitespace-nowrap block text-[22rpx] leading-[32rpx] text-[#777]">
                按 nano-banana 单张 {{ NANO_BANANA_REFERENCE_COST }} 积分估算，不同模型和清晰度扣费不同
              </text> -->
            </button>
          </view>
        </section>

        <section v-else class="mb-[40rpx]">
          <view class="mb-[22rpx] flex items-end justify-between">
            <text class="text-[34rpx] font-bold leading-[44rpx] text-black">积分加量</text>
            <text class="text-[22rpx] font-medium leading-[32rpx] text-[#777]">仅会员可买</text>
          </view>

          <view
            v-if="!isMember"
            class="mb-[18rpx] rounded-[32rpx] bg-black px-[32rpx] py-[28rpx] text-white"
          >
            <text class="block text-[28rpx] font-bold leading-[38rpx] text-white">开通会员后可购买积分加量包</text>
            <text class="mt-[8rpx] block text-[24rpx] leading-[36rpx] text-white/60">
              积分加量用于临时补充额度，长期有效。
            </text>
            <button
              class="mt-[24rpx] flex h-[72rpx] w-full items-center justify-center rounded-full bg-white text-[26rpx] font-semibold leading-none text-black active:scale-[0.98]"
              @tap="activeMode = 'membership'"
            >
              去开通会员
            </button>
          </view>

          <view class="grid grid-cols-2 gap-[16rpx]">
            <button
              v-for="item in addonCards"
              :key="item.id"
              class="relative flex min-h-[252rpx] flex-col items-stretch justify-between rounded-[32rpx] border bg-white p-[24rpx] text-left active:scale-[0.98]"
              :class="[
                item.recommended ? 'border-black shadow-[0_18rpx_44rpx_rgba(0,0,0,0.08)]' : 'border-[rgba(0,0,0,0.06)]',
                !isMember ? 'opacity-45' : '',
              ]"
              @tap="handleBuyAddon(item)"
            >
              <view>
                <view class="flex items-start justify-between gap-[12rpx]">
                  <text class="text-[24rpx] font-semibold leading-[32rpx] text-[#5f5e5e]">
                    {{ item.tag }}
                  </text>
                  <text
                    v-if="item.recommended"
                    class="shrink-0 rounded-full bg-black px-[14rpx] py-[4rpx] text-[18rpx] font-semibold leading-[24rpx] text-white"
                  >
                    推荐
                  </text>
                </view>
                <text class="mt-[18rpx] block text-[42rpx] font-bold leading-[52rpx] text-black">
                  {{ formatCredits(item.finalCredits) }}
                </text>
                <text class="mt-[4rpx] block text-[22rpx] font-medium leading-[30rpx] text-[#777]">
                  到账积分
                </text>
                <text class="mt-[16rpx] block text-[22rpx] leading-[30rpx] text-[#9a8f90]">
                  基础 {{ formatCredits(item.baseCredits) }}
                  <template v-if="item.bonusCredits > 0"> + 加赠 {{ formatCredits(item.bonusCredits) }}</template>
                </text>
                <text class="mt-[4rpx] block text-[22rpx] leading-[30rpx] text-[#9a8f90]">
                  当前会员 {{ activeTier.addonBonus }}% 加赠
                </text>
                <text class="mt-[4rpx] block text-[22rpx] leading-[30rpx] text-[#9a8f90]">
                  约出图 {{ formatImageCount(item.finalCredits) }} 张
                </text>
              </view>

              <view class="mt-[24rpx] flex h-[64rpx] items-center justify-center rounded-full bg-black px-[20rpx]">
                <text class="text-[26rpx] font-semibold leading-none text-white">¥{{ item.price }}</text>
              </view>
            </button>
          </view>
        </section>

        <section>
          <view class="rounded-[32rpx] bg-[#eeeeee] px-[32rpx] py-[28rpx]">
            <text class="block text-[26rpx] font-semibold leading-[36rpx] text-black">规则说明</text>
            <text class="mt-[12rpx] block text-[24rpx] leading-[38rpx] text-[#5f5e5e]">
              图片生成按模型基础价和清晰度计费，生成多张图按张数相乘。会员套餐按月赠送积分；积分加量包只面向已开通会员的用户，用于临时补充额度。购买积分长期有效，会员每月赠送积分按会员规则有效。扣费时优先消耗即将过期的积分批次，再消耗长期有效的购买积分。
            </text>
          </view>
        </section>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";
import { onShow } from "@dcloudio/uni-app";
import { useUserStore } from "@/store/modules/user";
import { createPaymentOrder, getPaymentOrder, type PaymentParams } from "@/api/payment";

type RechargeMode = "membership" | "addon";
type MemberTierValue = "none" | "monthly" | "pro" | "studio";

interface MemberTier {
  value: MemberTierValue;
  label: string;
  badge: string;
  addonBonus: number;
  desc: string;
}

interface MembershipPlan {
  id: MemberTierValue;
  name: string;
  price: string;
  monthlyCredits: number;
  addonBonus: number;
  desc: string;
  recommended?: boolean;
}

interface AddonPackage {
  id: string;
  price: string;
  baseCredits: number;
  tag: string;
  recommended?: boolean;
}

const activeMode = ref<RechargeMode>("membership");
const paying = ref(false);
const NANO_BANANA_REFERENCE_COST = 5;
const userStore = useUserStore();

const modes: Array<{ label: string; value: RechargeMode }> = [
  { label: "会员套餐", value: "membership" },
  { label: "积分加量", value: "addon" },
];

const memberTiers: MemberTier[] = [
  { value: "none", label: "普通用户", badge: "未开通", addonBonus: 0, desc: "可开通会员套餐" },
  { value: "monthly", label: "月卡会员", badge: "+10%", addonBonus: 10, desc: "会员权益已生效" },
  { value: "pro", label: "Pro 会员", badge: "+20%", addonBonus: 20, desc: "适合稳定创作" },
  { value: "studio", label: "Studio 会员", badge: "+30%", addonBonus: 30, desc: "高频创作加赠最高" },
];

const membershipPlans: MembershipPlan[] = [
  {
    id: "monthly",
    name: "月卡会员",
    price: "29.9",
    monthlyCredits: 660,
    addonBonus: 10,
    desc: "适合轻量创作，每月赠送基础积分。",
  },
  {
    id: "pro",
    name: "Pro 会员",
    price: "59.9",
    monthlyCredits: 1500,
    addonBonus: 20,
    desc: "适合日常稳定出图，加量包加赠更高。",
    recommended: true,
  },
  {
    id: "studio",
    name: "Studio 会员",
    price: "99",
    monthlyCredits: 2800,
    addonBonus: 30,
    desc: "适合高频创作，享受最高加量加赠。",
  },
];

const addonPackages: AddonPackage[] = [
  { id: "addon-2990", price: "29.9", baseCredits: 660, tag: "轻量补充" },
  { id: "addon-5990", price: "59.9", baseCredits: 1500, tag: "日常加量", recommended: true },
  { id: "addon-9900", price: "99", baseCredits: 2800, tag: "高频备用" },
  { id: "addon-19900", price: "199", baseCredits: 6200, tag: "团队加量" },
];

const activeTier = computed(() => memberTiers.find((tier) => tier.value === currentTier.value) || memberTiers[0]);
const currentTier = computed<MemberTierValue>(() => userStore.profile?.memberTier || "none");
const isMember = computed(() => currentTier.value !== "none");
const creditBalanceText = computed(() => formatCredits(userStore.profile?.creditBalance || 0));
const memberExpireText = computed(() => {
  if (!isMember.value) {
    return activeTier.value.desc;
  }
  if (!userStore.profile?.memberExpireTime) {
    return "会员权益已生效";
  }
  return `有效期至 ${formatDateText(userStore.profile.memberExpireTime)}`;
});
const memberStatusText = computed(() => (isMember.value ? "已开通" : "未开通"));

const addonCards = computed(() => {
  const bonusRate = activeTier.value.addonBonus / 100;
  return addonPackages.map((item) => {
    const bonusCredits = Math.floor(item.baseCredits * bonusRate);
    return {
      ...item,
      bonusCredits,
      finalCredits: item.baseCredits + bonusCredits,
    };
  });
});

function formatCredits(value: number) {
  return String(value).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function formatImageCount(credits: number) {
  return formatCredits(Math.floor(Math.max(0, credits) / NANO_BANANA_REFERENCE_COST));
}

function formatDateText(value: string) {
  return value.slice(0, 10).replace(/-/g, ".");
}

onShow(() => {
  if (userStore.isLogin) {
    userStore.fetchProfile().catch(() => undefined);
  }
});

async function handleBuyMembership(plan: MembershipPlan) {
  await startWechatPay(plan.id, `${plan.name}开通成功，积分到账处理中`);
}

async function handleBuyAddon(item: AddonPackage & { finalCredits: number }) {
  if (!isMember.value) {
    uni.showToast({ title: "请先开通会员套餐", icon: "none" });
    return;
  }

  await startWechatPay(item.id, `${formatCredits(item.finalCredits)}积分到账处理中`);
}

async function startWechatPay(productId: string, successTitle: string) {
  if (!userStore.isLogin) {
    await userStore.loginWithWechat();
  }

  if (paying.value) {
    return;
  }

  paying.value = true;
  uni.showLoading({ title: "创建订单..." });
  try {
    const result = await createPaymentOrder(productId);
    uni.hideLoading();
    await requestWechatPayment(result.paymentParams);
    uni.showLoading({ title: "确认到账..." });
    await waitOrderPaid(result.order.outTradeNo);
    await userStore.fetchProfile();
    uni.hideLoading();
    uni.showToast({ title: successTitle, icon: "none" });
  } catch (error) {
    uni.hideLoading();
    if (!isPaymentCancel(error)) {
      const message = error instanceof Error ? error.message : "支付未完成";
      uni.showToast({ title: message, icon: "none" });
    }
  } finally {
    paying.value = false;
  }
}

async function waitOrderPaid(outTradeNo: string) {
  for (let index = 0; index < 8; index += 1) {
    const order = await getPaymentOrder(outTradeNo);
    if (order.status === "PAID") {
      return;
    }
    await sleep(1500);
  }
  throw new Error("支付已完成，到账确认稍有延迟，请稍后刷新");
}

function sleep(duration: number) {
  return new Promise<void>((resolve) => {
    setTimeout(resolve, duration);
  });
}

function requestWechatPayment(params: PaymentParams) {
  return new Promise<void>((resolve, reject) => {
    uni.requestPayment({
      provider: "wxpay",
      timeStamp: params.timeStamp,
      nonceStr: params.nonceStr,
      package: params.package,
      signType: params.signType,
      paySign: params.paySign,
      success: () => resolve(),
      fail: (error) => reject(error),
    });
  });
}

function isPaymentCancel(error: unknown) {
  const message = typeof error === "object" && error !== null && "errMsg" in error
    ? String((error as { errMsg?: string }).errMsg || "")
    : "";
  return message.includes("cancel");
}
</script>

<style scoped>
.vip-gold-letter {
  color: #d6a64c;
  font-size: 28rpx;
  font-weight: 800;
  line-height: 1;
  text-shadow: 0 2rpx 6rpx rgba(214, 166, 76, 0.25);
}
</style>
