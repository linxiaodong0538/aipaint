<template>
  <view
    class="flex h-screen flex-col overflow-hidden bg-(--app-background) px-[32rpx] pt-[32rpx] text-(--app-on-surface)"
  >
    <view class="flex shrink-0 flex-wrap gap-[20rpx]">
      <view
        v-for="tab in tabs"
        :key="tab.value"
        class="flex h-[64rpx] items-center justify-center rounded-full px-[28rpx] text-[28rpx] font-semibold leading-none"
        :class="
          activeTab === tab.value
            ? 'bg-black text-white shadow-[0_12rpx_24rpx_rgba(0,0,0,0.12)]'
            : 'bg-[#efefef] text-[#7d7d7d]'
        "
        @tap="activeTab = tab.value"
      >
        {{ tab.label }}
      </view>
    </view>

    <view class="mt-[32rpx] min-h-0 flex-1 w-full">
      <z-paging
        ref="paging"
        v-model="pagingWorks"
        height="100%"
        :fixed="false"
        :default-page-size="pageSize"
        :loading-more-enabled="false"
        :show-scrollbar="false"
        refresher-default-text="下拉刷新"
        refresher-pulling-text="释放刷新"
        refresher-refreshing-text=" "
        refresher-complete-text="刷新成功"
        refresher-threshold="120rpx"
        :refresher-title-style="refresherTitleStyle"
        empty-view-text="暂无作品"
        @query="queryWorks"
      >
        <view class="pb-[220rpx]">
          <view
            v-if="!userStore.isLogin"
            class="mt-[148rpx] flex flex-col items-center px-[12rpx] text-center"
          >
            <view class="relative flex h-[200rpx] w-[200rpx] items-center justify-center">
              <view
                class="absolute h-[176rpx] w-[176rpx] rounded-full bg-[#efefef]/80"
              />
              <view
                class="relative flex h-[152rpx] w-[152rpx] items-center justify-center rounded-[36rpx] border border-[#ebebeb] bg-white shadow-[0_20rpx_48rpx_rgba(0,0,0,0.06)]"
              >
                <text
                  class="iconfont icon-images  leading-none text-[#c8c8c8]"
                  style="font-size: 56rpx"
                />
              </view>
            </view>

            <text
              class="mt-[48rpx] block text-[36rpx] font-bold leading-[50rpx] text-black"
            >
              登录后查看你的作品
            </text>

            <text
              class="mt-[20rpx] block max-w-[600rpx] text-[26rpx] font-normal leading-[40rpx] text-[#8e8e8e]"
            >
              登录后同步你的创作记录与生成状态
            </text>

            <button
              class="mt-[56rpx] flex h-[88rpx] w-full max-w-[520rpx] items-center justify-center rounded-full bg-black px-[48rpx] text-[30rpx] font-bold leading-none text-white"
              :loading="userStore.loggingIn"
              @tap="handleLogin"
            >
              立即登录
            </button>
          </view>

          <view
            v-if="userStore.isLogin && hasVisibleWorks"
            class="grid grid-cols-2 gap-[24rpx]"
          >
            <view
              v-for="item in visibleWorks"
              :key="`${item.kind}-${item.taskId}`"
              class="relative flex flex-col bg-white border border-[#c8c9d2] break-inside-avoid rounded-[24rpx]"
              @tap="goTask(item)"
            >
              <view
                v-if="item.kind === 'processing'"
                class="works-shimmer works-pixel-border relative mb-[24rpx] aspect-square w-full overflow-hidden rounded-[32rpx] bg-[#eeeeee]"
              >
                <view class="absolute inset-0 flex items-center justify-center">
                  <view class="flex flex-col items-center gap-[32rpx]">
                    <view class="works-loader">
                      <view class="works-loader-core" />
                      <view class="works-loader-core works-loader-core-fast" />
                    </view>
                    <text class="text-[20rpx] font-semibold uppercase mleading-[28rpx] tracking-[4rpx] text-black/60 pt-[16rpx]">
                      绘制中...
                    </text>
                  </view>
                </view>
              </view>

              <view
                v-else
                class="relative aspect-square w-full overflow-hidden rounded-t-[24rpx] rounded-b-none active:scale-[0.98]"
              >
                <image
                  :src="item.image"
                  mode="aspectFill"
                  class="absolute inset-0 block h-full w-full"
                  style="width: 100%; height: 100%;"
                />
              </view>

              <view class="p-[16rpx]">
                <template v-if="item.kind === 'processing'">
                  <view class="works-shimmer mb-[16rpx] h-[32rpx] w-3/4 rounded-full" />
                  <view class="works-shimmer h-[24rpx] w-1/2 rounded-full opacity-50" />
                </template>
                <template v-else>
                  <text class="block truncate text-[28rpx] font-semibold leading-[40rpx] text-black">
                    {{ item.title }}
                  </text>
                  <text class="mt-[4rpx] block text-[24rpx] font-medium leading-[32rpx] text-[#4c4546]/60">
                    {{ item.timeText }}
                  </text>
                </template>
              </view>
            </view>
          </view>

          <view
            v-if="userStore.isLogin && loading"
            class="mt-[128rpx] flex flex-col items-center text-center"
          >
            <view class="h-[64rpx] w-[64rpx] animate-spin rounded-full border-[6rpx] border-[#231818] border-t-black" />
            <text class="mt-[28rpx] text-[26rpx] font-medium leading-[36rpx] text-[#7d7d7d]">加载作品中...</text>
          </view>
        </view>
        <template #empty>
          <view
            v-if="userStore.isLogin && !loading"
            class="mt-[148rpx] flex flex-col items-center px-[12rpx] py-[64rpx] text-center"
          >
            <view class="mb-[48rpx] flex h-[192rpx] w-[192rpx] items-center justify-center rounded-full bg-[#f3f3f4]">
              <text class="iconfont icon-images leading-none text-black/10"/>
            </view>
            <text class="block text-[40rpx] font-semibold leading-[64rpx] text-black">
              暂无作品
            </text>
            <text class="mt-[16rpx] block max-w-[520rpx] text-[28rpx] font-normal leading-[48rpx] text-[#4c4546]/60">
              您的创意画廊目前还是空的。开始尝试生成您的第一件 AI 艺术作品吧
            </text>
          </view>
        </template>
      </z-paging>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, getCurrentInstance, nextTick, ref, watch } from "vue";
import ZPaging from "z-paging/components/z-paging/z-paging.vue";
import { onHide, onShow } from "@dcloudio/uni-app";
import { listGenerationTasks, type GenerationTask } from "@/api/generate";
import { useUserStore } from "@/store/modules/user";
import { navigateTo, routes } from "@/utils/router";

type TabValue = "all" | "generating" | "completed";

interface ProgressWork {
  taskId: number;
  title: string;
  meta: string;
  progress: number;
  image: string;
}

interface CompletedWork {
  taskId: number;
  title: string;
  image: string;
  timeText: string;
}

type GalleryWork =
  | (ProgressWork & { kind: "processing" })
  | (CompletedWork & { kind: "completed" });

const tabs: Array<{ label: string; value: TabValue }> = [
  { label: "全部", value: "all" },
  { label: "生成中", value: "generating" },
  { label: "已完成", value: "completed" },
];

const activeTab = ref<TabValue>("all");
const userStore = useUserStore();
const loading = ref(false);
const tasks = ref<GenerationTask[]>([]);
const pagingWorks = ref<GalleryWork[]>([]);
const resultDetailStorageKey = "generateResultDetailTask";
const pageSize = 999;
const instance = getCurrentInstance();
const refresherTitleStyle = {
  fontSize: "28rpx",
  lineHeight: "32rpx",
  color: "#7d7d7d",
};

let refreshTimer: ReturnType<typeof setInterval> | null = null;

interface PagingRef {
  complete(data?: GalleryWork[] | false, success?: boolean): Promise<unknown>;
  reload(animate?: boolean): Promise<unknown>;
}

const inProgressWorks = computed<Array<ProgressWork & { kind: "processing" }>>(() => (
  tasks.value
    .filter((task) => task.status === "pending" || task.status === "processing")
    .map((task, index) => ({
      taskId: task.taskId,
      title: resolveTitle(task.prompt),
      meta: `${formatModel(task.model)} • ${formatQuality(task.quality)} • ${task.ratio}`,
      progress: estimateProgress(task),
      image: task.previewImageUrl || `/static/works/progress-${(index % 2) + 1}.jpg`,
      kind: "processing" as const,
    }))
));

const completedWorks = computed<Array<CompletedWork & { kind: "completed" }>>(() => (
  tasks.value
    .filter((task) => task.status === "success" && !!task.resultImageUrl)
    .map((task) => ({
      taskId: task.taskId,
      title: resolveTitle(task.prompt),
      image: task.resultImageUrl || "",
      timeText: formatWorkTime(task.finishTime || task.createTime),
      kind: "completed" as const,
    }))
));

const visibleWorks = computed<GalleryWork[]>(() => {
  if (activeTab.value === "generating") return inProgressWorks.value;
  if (activeTab.value === "completed") return completedWorks.value;

  const inProgressTaskIds = new Set(inProgressWorks.value.map((item) => item.taskId));
  const completedTaskIds = new Set(completedWorks.value.map((item) => item.taskId));

  return tasks.value
    .filter((task) => inProgressTaskIds.has(task.taskId) || completedTaskIds.has(task.taskId))
    .map((task) => (
      inProgressWorks.value.find((item) => item.taskId === task.taskId)
      || completedWorks.value.find((item) => item.taskId === task.taskId)
    ))
    .filter((item): item is GalleryWork => !!item);
});

const hasVisibleWorks = computed(() => visibleWorks.value.length > 0);

function getPaging() {
  return instance?.proxy?.$refs?.paging as PagingRef | undefined;
}

function syncPagingWorks() {
  pagingWorks.value = visibleWorks.value;
}

onShow(() => {
  if (userStore.isLogin) {
    void nextTick(() => getPaging()?.reload());
    startRefreshTimer();
  }
});

onHide(() => {
  stopRefreshTimer();
});

watch(
  () => userStore.isLogin,
  (isLogin) => {
    if (isLogin) {
      void nextTick(() => getPaging()?.reload());
      startRefreshTimer();
      return;
    }
    tasks.value = [];
    pagingWorks.value = [];
    stopRefreshTimer();
  },
);

watch(visibleWorks, syncPagingWorks);

async function loadWorks(silent = false) {
  if (!userStore.isLogin || loading.value) return;

  if (!silent) {
    loading.value = true;
  }
  try {
    tasks.value = await listGenerationTasks();
    syncPagingWorks();
  } catch {
    tasks.value = [];
    pagingWorks.value = [];
  } finally {
    if (!silent) {
      loading.value = false;
    }
  }
}

async function queryWorks() {
  if (!userStore.isLogin) {
    await getPaging()?.complete([], true);
    return;
  }

  try {
    await loadWorks();
    await getPaging()?.complete(pagingWorks.value, true);
  } catch {
    await getPaging()?.complete(false);
  }
}

function handleLogin() {
  userStore.loginWithWechat()
    .then(() => loadWorks())
    .catch(() => undefined);
}

function resolveTitle(prompt: string) {
  const title = prompt.trim();
  if (!title) return "未命名作品";
  return title.length > 18 ? `${title.slice(0, 18)}...` : title;
}

function formatModel(model: string) {
  if (model === "gpt-image-2" || model === "g-image-2") return "G Image 2";
  return model || "AI";
}

function formatQuality(quality: string) {
  const map: Record<string, string> = {
    low: "1K",
    medium: "2K",
    high: "4K",
  };
  return map[quality] || quality || "2K";
}

function estimateProgress(task: GenerationTask) {
  if (task.previewImageUrl) return 88;
  if (task.status === "pending") return 12;

  const createdAt = task.createTime ? new Date(task.createTime.replace(/-/g, "/")).getTime() : Date.now();
  const elapsedSeconds = Math.max(0, Math.floor((Date.now() - createdAt) / 1000));
  return Math.min(86, 24 + Math.floor(elapsedSeconds / 3) * 4);
}

function formatWorkTime(value?: string) {
  if (!value) return "";

  const timestamp = new Date(value.replace(/-/g, "/")).getTime();
  if (!Number.isFinite(timestamp)) return value.slice(0, 16);

  const diffMinutes = Math.max(0, Math.floor((Date.now() - timestamp) / 60000));
  if (diffMinutes < 1) return "刚刚";
  if (diffMinutes < 60) return `${diffMinutes}分钟前`;

  const diffHours = Math.floor(diffMinutes / 60);
  if (diffHours < 24) return `${diffHours}小时前`;

  const date = new Date(timestamp);
  const now = new Date();
  const yesterday = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 1).getTime();
  const dateStart = new Date(date.getFullYear(), date.getMonth(), date.getDate()).getTime();
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");
  if (dateStart === yesterday) return `昨天 ${hours}:${minutes}`;

  return `${date.getMonth() + 1}月${date.getDate()}日 ${hours}:${minutes}`;
}

function goTask(work: GalleryWork) {
  const task = tasks.value.find((item) => item.taskId === work.taskId);

  if (work.kind === "completed" && task) {
    uni.setStorageSync(resultDetailStorageKey, task);
    navigateTo(routes.generateResult, { taskId: work.taskId, from: "works" });
    return;
  }

  navigateTo(routes.generateResult, { taskId: work.taskId });
}

function startRefreshTimer() {
  stopRefreshTimer();
  refreshTimer = setInterval(() => {
    if (userStore.isLogin && inProgressWorks.value.length > 0) {
      void loadWorks(true);
    }
  }, 5000);
}

function stopRefreshTimer() {
  if (refreshTimer) {
    clearInterval(refreshTimer);
    refreshTimer = null;
  }
}
</script>

<style>
.works-pixel-border {
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.05), 0 40rpx 80rpx rgba(0, 0, 0, 0.05);
}

.works-shimmer {
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: works-shimmer 1.5s linear infinite;
}

.works-loader {
  display: grid;
  width: 100rpx;
  height: 87rpx;
  color: #000;
  background:
    linear-gradient(to bottom left, transparent calc(50% - 1px), currentColor 0 calc(50% + 1px), transparent 0) right / 50% 100%,
    linear-gradient(to bottom right, transparent calc(50% - 1px), currentColor 0 calc(50% + 1px), transparent 0) left / 50% 100%,
    linear-gradient(currentColor 0 0) bottom / 100% 2px;
  background-repeat: no-repeat;
  transform-origin: 50% 66%;
  animation: works-loader 8s infinite linear;
}

.works-loader-core {
  grid-area: 1 / 1;
  background: inherit;
  transform-origin: inherit;
  animation: inherit;
}

.works-loader-core-fast {
  animation-duration: 4s;
}

@keyframes works-shimmer {
  0% {
    background-position: -200% 0;
  }

  100% {
    background-position: 200% 0;
  }
}

@keyframes works-loader {
  100% {
    transform: rotate(1turn);
  }
}
</style>
