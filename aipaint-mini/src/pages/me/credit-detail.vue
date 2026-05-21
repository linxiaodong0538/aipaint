<template>
  <view class="min-h-screen bg-[#f9f9f9] text-[#1a1c1c]">
    <scroll-view class="h-screen" scroll-y enhanced :show-scrollbar="false">
      <view class="mx-auto min-h-screen max-w-[750rpx] px-[48rpx] pb-[200rpx] pt-[24rpx]">
        <section class="mb-[64rpx]">
          <view class="relative overflow-hidden rounded-[48rpx] bg-black px-[64rpx] py-[64rpx] text-white shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)]">
            <view class="pointer-events-none absolute inset-0 bg-[radial-gradient(circle_at_top_right,rgba(255,255,255,0.16),transparent_40%)] opacity-70" />
            <view class="relative z-10">
              <text class="mb-[8rpx] block text-[24rpx] font-medium uppercase tracking-[6rpx] text-white/70">
                当前可用积分
              </text>
              <view class="mb-[48rpx] flex items-end gap-[8rpx]">
                <text class="text-[96rpx] font-bold leading-none tracking-[-2rpx] text-white">
                  1,240
                </text>
                <text class="pb-[10rpx] text-[48rpx] font-semibold leading-[56rpx] text-white/60">
                  .50
                </text>
              </view>
              <view class="flex gap-[24rpx]">
                <button
                  class="flex h-[84rpx] min-w-[212rpx] items-center justify-center rounded-full bg-white px-[48rpx] text-[28rpx] font-semibold leading-none text-black active:scale-95"
                  @tap="handleRecharge"
                >
                  立即充值
                </button>
                <button
                  class="flex h-[84rpx] min-w-[212rpx] items-center justify-center rounded-full border border-white/20 bg-transparent px-[48rpx] text-[28rpx] font-semibold leading-none text-white active:scale-95"
                  @tap="handleRedeem"
                >
                  积分兑换
                </button>
              </view>
            </view>
          </view>
        </section>

        <scroll-view class="mb-[32rpx] whitespace-nowrap" scroll-x enhanced :show-scrollbar="false">
          <view class="flex gap-[24rpx] pb-[8rpx]">
            <button
              v-for="filter in filters"
              :key="filter.value"
              class="inline-flex h-[72rpx] min-w-0 shrink-0 items-center justify-center rounded-full px-[32rpx] text-[24rpx] font-medium leading-[32rpx] active:scale-95"
              :class="activeFilter === filter.value ? 'bg-black text-white' : 'bg-[#eeeeee] text-[#4c4546]'"
              @tap="activeFilter = filter.value"
            >
              {{ filter.label }}
            </button>
          </view>
        </scroll-view>

        <view class="flex flex-col gap-[16rpx]">
          <template v-for="group in groupedRecords" :key="group.month">
            <view class="pt-[32rpx] pb-[8rpx]">
              <text class="text-[24rpx] font-medium uppercase tracking-[6rpx] text-[#5f5e5e]">
                {{ group.month }}
              </text>
            </view>

            <view
              v-for="record in group.records"
              :key="record.id"
              class="flex items-center justify-between rounded-[40rpx] border border-[rgba(0,0,0,0.03)] bg-white px-[32rpx] py-[32rpx] shadow-[0_8rpx_24rpx_rgba(0,0,0,0.04)] active:scale-[0.99]"
            >
              <view class="flex min-w-0 items-center gap-[32rpx]">
                <view
                  class="flex h-[96rpx] w-[96rpx] shrink-0 items-center justify-center rounded-[24rpx]"
                  :class="record.iconBackgroundClass"
                >
                  <text class="iconfont text-[44rpx] leading-none" :class="[record.iconClass, record.iconColorClass]" />
                </view>
                <view class="min-w-0">
                  <text class="block truncate text-[28rpx] font-semibold leading-[40rpx] text-black">
                    {{ record.title }}
                  </text>
                  <text class="mt-[4rpx] block text-[22rpx] font-medium leading-[32rpx] text-[#5f5e5e]">
                    {{ record.time }}
                  </text>
                </view>
              </view>

              <view class="ml-[24rpx] shrink-0 text-right">
                <text class="block text-[36rpx] font-semibold leading-[48rpx] text-black">
                  {{ record.amount }}
                </text>
                <text
                  class="mt-[4rpx] block text-[20rpx] leading-[28rpx]"
                  :class="record.metaColorClass"
                >
                  {{ record.meta }}
                </text>
              </view>
            </view>
          </template>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from "vue";

type FilterValue = "all" | "generate" | "signin" | "reward";

interface CreditRecord {
  id: string;
  type: FilterValue;
  month: string;
  title: string;
  time: string;
  amount: string;
  meta: string;
  iconClass: string;
  iconBackgroundClass: string;
  iconColorClass: string;
  metaColorClass: string;
}

const filters: Array<{ label: string; value: FilterValue }> = [
  { label: "全部记录", value: "all" },
  { label: "图片生成", value: "generate" },
  { label: "每日签到", value: "signin" },
  { label: "任务奖励", value: "reward" },
];

const activeFilter = ref<FilterValue>("all");

const records: CreditRecord[] = [
  {
    id: "generate-1",
    type: "generate",
    month: "2026年5月",
    title: "生成图片",
    time: "2026-05-21 14:32:05",
    amount: "-1.94",
    meta: "GPT-Image-2",
    iconClass: "icon-images",
    iconBackgroundClass: "bg-[#eeeeee]",
    iconColorClass: "text-black",
    metaColorClass: "text-[#5f5e5e]/50",
  },
  {
    id: "signin-1",
    type: "signin",
    month: "2026年5月",
    title: "每日签到",
    time: "2026-05-21 08:00:12",
    amount: "+5.00",
    meta: "奖励",
    iconClass: "icon-qiandao",
    iconBackgroundClass: "bg-[#eeeeee]",
    iconColorClass: "text-black",
    metaColorClass: "text-[#5f5e5e]/50",
  },
  {
    id: "generate-2",
    type: "generate",
    month: "2026年5月",
    title: "高级扩图",
    time: "2026-05-20 22:15:44",
    amount: "-10.00",
    meta: "Ultra-Extend",
    iconClass: "icon-MaterialSymbolsBrush",
    iconBackgroundClass: "bg-[#eeeeee]",
    iconColorClass: "text-black",
    metaColorClass: "text-[#5f5e5e]/50",
  },
  {
    id: "refund-1",
    type: "reward",
    month: "2026年5月",
    title: "生成失败退款",
    time: "2026-05-20 19:40:22",
    amount: "+1.31",
    meta: "超时自动退回",
    iconClass: "icon-shanshan",
    iconBackgroundClass: "bg-[#ffdad6]/60",
    iconColorClass: "text-[#ba1a1a]",
    metaColorClass: "text-[#ba1a1a]",
  },
  {
    id: "invite-1",
    type: "reward",
    month: "2026年5月",
    title: "邀请好友奖励",
    time: "2026-05-19 11:10:05",
    amount: "+50.00",
    meta: "邀请码: AI_992x",
    iconClass: "icon-jinbi",
    iconBackgroundClass: "bg-[#eeeeee]",
    iconColorClass: "text-black",
    metaColorClass: "text-[#5f5e5e]/50",
  },
];

const groupedRecords = computed(() => {
  const filtered = activeFilter.value === "all"
    ? records
    : records.filter((record) => record.type === activeFilter.value);

  const groups = filtered.reduce<Array<{ month: string; records: CreditRecord[] }>>((result, record) => {
    const existing = result.find((group) => group.month === record.month);
    if (existing) {
      existing.records.push(record);
      return result;
    }
    result.push({ month: record.month, records: [record] });
    return result;
  }, []);

  return groups;
});

function handleRecharge() {
  uni.showToast({ title: "立即充值", icon: "none" });
}

function handleRedeem() {
  uni.showToast({ title: "积分兑换", icon: "none" });
}
</script>
