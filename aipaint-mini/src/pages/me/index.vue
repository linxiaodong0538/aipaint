<template>
  <view
    class="relative min-h-screen overflow-hidden bg-[var(--app-background)] pb-[220rpx] text-[var(--app-on-surface)]"
  >
    <view class="pointer-events-none absolute inset-x-0 top-0 h-[520rpx] overflow-hidden">
      <image
        src="/static/me/header-bg.png"
        mode="aspectFill"
        class="h-full w-full"
      />
      <view class="absolute inset-0 bg-gradient-to-b from-transparent via-[rgba(249,249,249,0.16)] to-[var(--app-background)]" />
    </view>

    <view class="relative px-[36rpx] pt-[112rpx]">
      <view class="flex flex-col items-center">
        <view class="relative">
          <image
            src="/static/me/avatar.jpg"
            mode="aspectFill"
            class="h-[128rpx] w-[128rpx] overflow-hidden rounded-full border-[4rpx] border-[rgba(255,255,255,0.55)] bg-[var(--app-surface-container-high)] grayscale shadow-[0_24rpx_48rpx_rgba(0,0,0,0.2)]"
          />
          <view
            class="absolute bottom-0 right-0 flex h-[42rpx] w-[42rpx] items-center justify-center rounded-full border-[4rpx] border-[var(--app-background)] bg-[var(--app-primary)]"
          >
            <text class="text-[18rpx] leading-none text-[var(--app-on-primary)]">✓</text>
          </view>
        </view>

        <text class="mt-[28rpx] text-[40rpx] font-bold leading-[48rpx] text-[var(--app-primary)]">
          {{ displayName }}
        </text>
        <view
          class="mt-[18rpx] flex h-[144rpx] w-full flex-col items-center justify-center rounded-[24rpx] bg-[var(--app-primary)] px-[24rpx] text-[var(--app-on-primary)] shadow-[0_24rpx_56rpx_rgba(0,0,0,0.18)]"
        >
          <text
            class="text-[18rpx] font-semibold uppercase leading-[24rpx] tracking-[6rpx] text-[rgba(255,255,255,0.62)]"
          >
            当前积分
          </text>
          <text class="mt-[8rpx] text-[46rpx] font-bold leading-[52rpx] text-[var(--app-on-primary)]">
            12,850
          </text>
          <text
            class="mt-[2rpx] text-[18rpx] font-semibold leading-[24rpx] text-[rgba(255,255,255,0.72)]"
          >
            PTS
          </text>
        </view>
      </view>

      <view class="mt-[34rpx]">
        <text class="block text-[28rpx] font-bold leading-[38rpx] text-[var(--app-primary)]">
          每日任务
        </text>

        <view class="mt-[18rpx] grid grid-cols-3 gap-[18rpx]">
          <view
            v-for="task in tasks"
            :key="task.title"
            class="flex min-h-[156rpx] flex-col items-center justify-center rounded-[20rpx] border border-[rgba(207,196,197,0.35)] bg-[var(--app-surface-container-low)] px-[12rpx] py-[18rpx] text-center"
          >
            <text class="text-[42rpx] leading-none text-[var(--app-primary)]">
              {{ task.icon }}
            </text>
            <text
              class="mt-[14rpx] block text-[22rpx] font-semibold leading-[30rpx] text-[var(--app-on-surface)]"
            >
              {{ task.title }}
            </text>
            <text
              class="mt-[4rpx] block text-[18rpx] leading-[24rpx] text-[var(--app-on-surface-variant)]"
            >
              {{ task.desc }}
            </text>
          </view>
        </view>
      </view>

      <view class="mt-[34rpx] grid grid-cols-2 gap-[18rpx]">
        <view
          v-for="item in gridServices"
          :key="item.title"
          class="flex h-[164rpx] flex-col justify-between rounded-[24rpx] border border-[rgba(207,196,197,0.22)] bg-[var(--app-surface-container-low)] px-[22rpx] py-[20rpx]"
        >
          <text class="text-[30rpx] leading-none text-[var(--app-primary)]">{{ item.icon }}</text>
          <view>
            <text class="block text-[24rpx] font-semibold leading-[32rpx] text-[var(--app-on-surface)]">
              {{ item.title }}
            </text>
            <text class="mt-[2rpx] block text-[18rpx] leading-[24rpx] text-[var(--app-on-surface-variant)]">
              {{ item.desc }}
            </text>
          </view>
        </view>
      </view>

      <view class="mt-[34rpx]">
        <text class="block text-[28rpx] font-bold leading-[38rpx] text-[var(--app-primary)]">
          账户设置
        </text>
        <view
          class="mt-[18rpx] overflow-hidden rounded-[24rpx] border border-[rgba(207,196,197,0.3)] bg-[var(--app-surface-container-lowest)] shadow-[0_8rpx_20rpx_rgba(0,0,0,0.03)]"
        >
          <view
            v-for="(item, index) in settings"
            :key="item.title"
            class="flex h-[76rpx] items-center justify-between px-[24rpx]"
            :class="[
              index !== settings.length - 1 ? 'border-b border-[rgba(0,0,0,0.06)]' : '',
              item.danger ? 'text-[var(--app-error)]' : 'text-[var(--app-on-surface)]',
            ]"
          >
            <view class="flex items-center gap-[18rpx]">
              <text class="w-[28rpx] text-center text-[22rpx] leading-none">{{ item.icon }}</text>
              <text class="text-[22rpx] font-semibold leading-[30rpx]">{{ item.title }}</text>
            </view>
            <text
              v-if="!item.danger"
              class="text-[28rpx] leading-none text-[var(--app-on-surface-variant)]"
            >
              ›
            </text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed } from "vue";
import { useUserStore } from "@/store/modules/user";

interface TaskItem {
  title: string;
  desc: string;
  icon: string;
}

interface ServiceItem {
  title: string;
  desc: string;
  icon: string;
}

interface SettingItem {
  title: string;
  icon: string;
  danger?: boolean;
}

const userStore = useUserStore();

const displayName = computed(() => userStore.profile?.nickname || "未来探索者");

const tasks: TaskItem[] = [
  { title: "每日签到", desc: "+50 PTS", icon: "📅" },
  { title: "观看视频", desc: "+20 PTS", icon: "▶️" },
  { title: "分享作品", desc: "+100 PTS", icon: "📤" },
];

const gridServices: ServiceItem[] = [
  { title: "我的作品", desc: "128 件作品", icon: "🖼️" },
  { title: "自定义模板", desc: "15 个可用", icon: "🖌️" },
  { title: "邀请好友", desc: "邀请得好礼", icon: "👥" },
  { title: "联系客服", desc: "24/7 在线", icon: "🎧" },
];

const settings: SettingItem[] = [
  { title: "个人资料", icon: "👤" },
  { title: "隐私与安全", icon: "🔒" },
  { title: "支付与订阅", icon: "💳" },
  { title: "退出登录", icon: "↩", danger: true },
];
</script>
