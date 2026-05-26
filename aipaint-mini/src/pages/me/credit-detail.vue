<template>
  <view class="min-h-screen bg-[#f9f9f9] text-[#1a1c1c]">
    <scroll-view class="h-screen" scroll-y enhanced :show-scrollbar="false">
      <view class="mx-auto min-h-screen max-w-[750rpx] px-[32rpx] pb-[200rpx] pt-[24rpx]">
        <section class="flex min-h-[196rpx] items-center justify-between rounded-[48rpx] bg-black px-[48rpx] py-[40rpx] text-white shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)]">
          <view class="flex min-w-0 flex-1 flex-col">
            <text class="text-[28rpx] font-semibold leading-[38rpx] text-[rgba(255,255,255,0.7)]">
              当前可用积分
            </text>
            <view class="mt-[8rpx] flex items-end gap-[8rpx]">
              <text class="text-[72rpx] font-bold leading-[72rpx] text-white">
                {{ creditBalanceText }}
              </text>
              <text class="pb-[6rpx] text-[36rpx] font-semibold leading-[44rpx] text-[rgba(255,255,255,0.7)]">
                PTS
              </text>
            </view>
          </view>

          <view class="ml-[40rpx] flex shrink-0 gap-[56rpx]">
            <view class="flex flex-col text-right">
              <text class="text-[26rpx] font-semibold leading-[36rpx] text-[rgba(255,255,255,0.55)]">
                本月消耗
              </text>
              <text class="mt-[12rpx] text-[38rpx] font-bold leading-[46rpx] text-white">
                {{ monthlyConsume }}
              </text>
            </view>
            <view class="flex flex-col text-right">
              <text class="text-[26rpx] font-semibold leading-[36rpx] text-[rgba(255,255,255,0.55)]">
                本月返还
              </text>
              <text class="mt-[12rpx] text-[38rpx] font-bold leading-[46rpx] text-white">
                {{ monthlyIncome }}
              </text>
            </view>
          </view>
        </section>

        <scroll-view
          class="mt-[32rpx] w-full whitespace-nowrap"
          scroll-x
          enhanced
          :show-scrollbar="false"
        >
          <view class="flex gap-[16rpx] py-[16rpx]">
            <button
              v-for="filter in filters"
              :key="filter.value"
              class="inline-flex shrink-0 items-center justify-center rounded-full px-[48rpx] py-[16rpx] text-[28rpx] font-semibold leading-[40rpx] active:scale-95"
              :class="activeFilter === filter.value ? 'bg-black text-white' : 'bg-[rgba(232,232,232,0.5)] text-[#5f5e5e]'"
              @tap="activeFilter = filter.value"
            >
              {{ filter.label }}
            </button>
          </view>
        </scroll-view>

        <view class="mt-[32rpx] flex flex-col gap-[32rpx]">
          <template v-for="group in groupedRecords" :key="group.month">
            <text class="block px-[16rpx] text-[28rpx] font-semibold leading-[40rpx] text-[#5f5e5e]">
              {{ group.month }}
            </text>

            <view class="flex flex-col gap-[24rpx]">
              <view
                v-for="record in group.records"
                :key="record.id"
                class="flex items-center justify-between rounded-[24rpx] border p-[32rpx] shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)] active:scale-[0.98]"
                :class="record.cardClass"
              >
                <view class="flex min-w-0 flex-1 items-center gap-[32rpx]">
                  <view
                    class="flex h-[96rpx] w-[96rpx] shrink-0 items-center justify-center rounded-[24rpx]"
                    :class="record.iconBackgroundClass"
                  >
                    <text class="iconfont text-[44rpx] leading-none" :class="[record.iconClass, record.iconColorClass]" />
                  </view>

                  <view class="min-w-0 flex-1 gap-[2rpx]">
                    <view class="flex min-w-0 items-center gap-[16rpx]">
                      <text class="block min-w-0 truncate text-[28rpx] font-bold leading-[40rpx]" :class="record.titleClass">
                        {{ record.title }}
                      </text>
                      <view class="inline-flex shrink-0 items-center rounded-full px-[16rpx] py-[2rpx]" :class="record.statusPillClass">
                        <text class="text-[20rpx] font-bold leading-[28rpx]">{{ record.statusLabel }}</text>
                      </view>
                    </view>
                    <text class="block truncate text-[24rpx] font-medium leading-[32rpx]" :class="record.metaColorClass">
                      {{ record.meta }}
                    </text>
                    <text class="block text-[20rpx] leading-[28rpx]" :class="record.timeColorClass">
                      {{ record.time }}
                    </text>
                  </view>
                </view>

                <text class="ml-[24rpx] shrink-0 text-[48rpx] font-semibold leading-[64rpx]" :class="record.amountColorClass">
                  {{ record.amount }}
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

type FilterValue = "all" | "generate" | "signin" | "other";

type RecordTone = "success" | "failed" | "processing" | "income" | "expense" | "neutral";

interface CreditRecord {
  id: string;
  type: FilterValue;
  month: string;
  title: string;
  time: string;
  amount: string;
  meta: string;
  iconClass: string;
  cardClass: string;
  iconBackgroundClass: string;
  iconColorClass: string;
  titleClass: string;
  amountColorClass: string;
  metaColorClass: string;
  timeColorClass: string;
  statusLabel: string;
  statusPillClass: string;
}

const filters: Array<{ label: string; value: FilterValue }> = [
  { label: "全部记录", value: "all" },
  { label: "生成相关", value: "generate" },
  { label: "每日签到", value: "signin" },
  { label: "其他变动", value: "other" },
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
  const tone = resolveRecordTone(record, positive);
  return {
    id: String(record.recordId),
    type,
    month: formatMonth(record.createTime),
    title: resolveTitle(record),
    time: record.createTime || "",
    amount: `${positive ? "+" : ""}${amount}`,
    meta: resolveMeta(record),
    iconClass: positive ? "icon-jinbi" : "icon-images",
    cardClass: resolveCardClass(tone),
    iconBackgroundClass: resolveIconBackgroundClass(tone),
    iconColorClass: resolveIconColorClass(tone),
    titleClass: resolveTitleClass(tone),
    amountColorClass: resolveAmountColorClass(tone, positive),
    metaColorClass: resolveMetaColorClass(tone),
    timeColorClass: resolveTimeColorClass(tone),
    statusLabel: resolveStatusLabel(record),
    statusPillClass: resolveStatusPillClass(tone),
  };
}

function resolveFilterType(changeType: string): FilterValue {
  if (changeType === "GENERATION_CONSUME" || changeType === "GENERATION_REFUND") return "generate";
  if (changeType === "SIGNIN") return "signin";
  return "other";
}

function resolveTitle(record: ApiCreditRecord) {
  const changeType = record.changeType;
  if (changeType === "CREDIT_EXPIRE") return record.remark || "积分过期";
  if (changeType === "NEW_USER_GIFT") return "新人礼包";
  if (changeType === "SIGNIN") return "每日签到";
  if (changeType === "GENERATION_CONSUME") return "图片生成";
  if (changeType === "GENERATION_REFUND") return "生成退款";
  if (changeType === "PAYMENT_MEMBERSHIP") return "会员赠送";
  if (changeType === "PAYMENT_ADDON") return "积分加量";
  return "积分变动";
}

function resolveMeta(record: ApiCreditRecord) {
  if (record.changeType === "CREDIT_EXPIRE") return "已过期";
  if (record.changeType === "GENERATION_CONSUME" || record.changeType === "GENERATION_REFUND") {
    const parts = [
      record.taskModel ? formatModel(record.taskModel) : "",
      formatDuration(record.taskDurationSeconds),
    ].filter(Boolean);
    return parts.length > 0 ? parts.join(" · ") : "生成任务";
  }
  return record.remark || record.changeType;
}

function resolveRecordTone(record: ApiCreditRecord, positive: boolean): RecordTone {
  if (record.changeType === "GENERATION_REFUND") return "failed";
  if (record.changeType === "GENERATION_CONSUME") {
    if (record.taskStatus === "success") return "success";
    if (isFailedTaskStatus(record.taskStatus)) return "failed";
    if (record.taskStatus === "pending" || record.taskStatus === "processing") return "processing";
    return "expense";
  }
  if (record.changeType === "CREDIT_EXPIRE") return "failed";
  if (positive) return "income";
  return "expense";
}

function isFailedTaskStatus(status?: string) {
  return status === "failed" || status === "violation";
}

function resolveIconBackgroundClass(_tone: RecordTone) {
  if (_tone === "failed") return "bg-[#eeeeee] opacity-50";
  if (_tone === "income") return "bg-black";
  return "bg-[#eeeeee]";
}

function resolveIconColorClass(_tone: RecordTone) {
  if (_tone === "income") return "text-white";
  return "text-black";
}

function resolveAmountColorClass(tone: RecordTone, positive: boolean) {
  if (tone === "failed") return "text-[rgba(0,0,0,0.3)]";
  return "text-black";
}

function resolveCardClass(tone: RecordTone) {
  if (tone === "failed") return "border-transparent bg-white";
  return "border-transparent bg-white";
}

function resolveTitleClass(tone: RecordTone) {
  if (tone === "failed") return "text-[#5f5e5e]";
  return "text-black";
}

function resolveMetaColorClass(tone: RecordTone) {
  if (tone === "failed") return "text-[rgba(95,94,94,0.5)]";
  return "text-[rgba(95,94,94,0.5)]";
}

function resolveTimeColorClass(tone: RecordTone) {
  if (tone === "failed") return "text-[rgba(126,117,118,0.5)]";
  return "text-[#7e7576]";
}

function resolveStatusLabel(record: ApiCreditRecord) {
  if (record.changeType === "GENERATION_REFUND") return "已退款";
  if (record.changeType === "GENERATION_CONSUME") {
    if (record.taskStatus === "success") return "成功";
    if (isFailedTaskStatus(record.taskStatus)) return "失败";
    if (record.taskStatus === "pending" || record.taskStatus === "processing") return "生成中";
    return "扣费";
  }
  if (record.changeType === "CREDIT_EXPIRE") return "过期";
  if ((record.amount || 0) > 0) return "入账";
  return "扣减";
}

function resolveStatusPillClass(_tone: RecordTone) {
  if (_tone === "failed") return "bg-[#ffdad6] text-[#93000a]";
  return "bg-[#e8e8e8] text-[#4c4546]";
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

function formatModel(value: string) {
  if (value === "gpt-image-2" || value === "g-image-2") return "GPT-image-2";
  if (value === "gpt-image-2-vip") return "GPT-image-2 VIP";
  if (value === "nano-banana-2") return "nano-banana-2";
  if (value === "nano-banana-pro") return "nano-banana-pro";
  if (value === "nano-banana") return "nano-banana";
  return value || "AI";
}

function formatDuration(value?: number) {
  if (typeof value !== "number" || !Number.isFinite(value) || value < 0) {
    return "";
  }
  const seconds = Math.round(value);
  if (seconds < 60) {
    return `耗时 ${seconds}s`;
  }
  const minutes = Math.floor(seconds / 60);
  const remainingSeconds = seconds % 60;
  if (minutes < 60) {
    return remainingSeconds > 0 ? `耗时 ${minutes}分${remainingSeconds}s` : `耗时 ${minutes}分`;
  }
  const hours = Math.floor(minutes / 60);
  const remainingMinutes = minutes % 60;
  return remainingMinutes > 0 ? `耗时 ${hours}小时${remainingMinutes}分` : `耗时 ${hours}小时`;
}
</script>
