<template>
  <view class="min-h-screen bg-[#f8f8f8] text-[#1a1c1c]">
    <scroll-view class="h-screen" scroll-y enhanced :show-scrollbar="false">
      <view class="mx-auto min-h-screen max-w-[750rpx] px-[32rpx] pb-[200rpx] pt-[24rpx]">
        <section class="mb-[64rpx]">
          <view class="relative overflow-hidden rounded-[48rpx] bg-black px-[64rpx] py-[64rpx] text-white shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)]">
            <view class="pointer-events-none absolute inset-0 bg-[radial-gradient(circle_at_top_right,rgba(255,255,255,0.16),transparent_40%)] opacity-70" />
            <view class="relative z-10">
              <text class="mb-[8rpx] block text-[24rpx] font-medium uppercase tracking-[6rpx] text-white/70">
                当前可用积分
              </text>
              <view class="mb-[48rpx] flex items-end gap-[8rpx]">
                <text class="text-[96rpx] font-bold leading-none tracking-[-2rpx] text-white">
                  {{ creditBalanceText }}
                </text>
                <text class="pb-[10rpx] text-[48rpx] font-semibold leading-[56rpx] text-white/60">
                  PTS
                </text>
              </view>
              <view class="grid grid-cols-2 gap-[16rpx]">
                <view class="rounded-[28rpx] bg-white/10 px-[24rpx] py-[20rpx]">
                  <text class="block text-[22rpx] font-medium leading-[30rpx] text-white/50">本月消耗</text>
                  <text class="mt-[6rpx] block text-[34rpx] font-semibold leading-[42rpx] text-white">{{ monthlyConsume }}</text>
                </view>
                <view class="rounded-[28rpx] bg-white/10 px-[24rpx] py-[20rpx]">
                  <text class="block text-[22rpx] font-medium leading-[30rpx] text-white/50">本月返还</text>
                  <text class="mt-[6rpx] block text-[34rpx] font-semibold leading-[42rpx] text-white">{{ monthlyIncome }}</text>
                </view>
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
import { onShow } from "@dcloudio/uni-app";
import { listCreditRecords, type CreditRecord as ApiCreditRecord } from "@/api/credit";
import { useUserStore } from "@/store/modules/user";

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
const userStore = useUserStore();
const records = ref<CreditRecord[]>([]);

const creditBalanceText = computed(() => formatCredits(userStore.profile?.creditBalance || 0));

const monthlyConsume = computed(() => Math.abs(records.value
  .filter((record) => record.amount.startsWith("-") && isCurrentMonth(record.time))
  .reduce((sum, record) => sum + Number(record.amount), 0)));

const monthlyIncome = computed(() => records.value
  .filter((record) => record.amount.startsWith("+") && isCurrentMonth(record.time))
  .reduce((sum, record) => sum + Number(record.amount), 0));

const groupedRecords = computed(() => {
  const filtered = activeFilter.value === "all"
    ? records.value
    : records.value.filter((record) => record.type === activeFilter.value);

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

onShow(() => {
  userStore.fetchProfile().catch(() => undefined);
  listCreditRecords().then((items) => {
    records.value = items.map(mapCreditRecord);
  }).catch(() => undefined);
});

function mapCreditRecord(record: ApiCreditRecord): CreditRecord {
  const amount = record.amount || 0;
  const positive = amount > 0;
  const type = resolveFilterType(record.changeType);
  return {
    id: String(record.recordId),
    type,
    month: formatMonth(record.createTime),
    title: resolveTitle(record.changeType),
    time: record.createTime || "",
    amount: `${positive ? "+" : ""}${amount}`,
    meta: record.remark || record.changeType,
    iconClass: positive ? "icon-jinbi" : "icon-images",
    iconBackgroundClass: positive ? "bg-[#eeeeee]" : "bg-[#eeeeee]",
    iconColorClass: "text-black",
    metaColorClass: positive ? "text-[#5f5e5e]/50" : "text-[#5f5e5e]/50",
  };
}

function resolveFilterType(changeType: string): FilterValue {
  if (changeType === "GENERATION_CONSUME") return "generate";
  if (changeType === "SIGNIN") return "signin";
  return "reward";
}

function resolveTitle(changeType: string) {
  if (changeType === "NEW_USER_GIFT") return "新人礼包";
  if (changeType === "GENERATION_CONSUME") return "生成图片";
  if (changeType === "GENERATION_REFUND") return "生成失败退款";
  return "积分变动";
}

function formatMonth(value?: string) {
  if (!value) return "未知月份";
  const [date] = value.split(" ");
  const [year, month] = date.split("-");
  return year && month ? `${year}年${Number(month)}月` : "未知月份";
}

function isCurrentMonth(value: string) {
  if (!value) return false;
  const now = new Date();
  const currentMonth = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;
  return value.startsWith(currentMonth);
}

function formatCredits(value: number) {
  return String(value).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
</script>
