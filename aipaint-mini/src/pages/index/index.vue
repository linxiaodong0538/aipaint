<template>
  <view class="flex h-screen flex-col overflow-hidden bg-[#f9f9f9] font-sans text-[#1a1c1c]">
    <AppNavBar title="首页" />

    <z-paging
      ref="paging"
      v-model="templates"
      height="100%"
      class="min-h-0 flex-1"
      :fixed="false"
      :auto="false"
      :default-page-size="pageSize"
      :refresher-enabled="false"
      loading-more-default-text="上滑加载更多"
      loading-more-loading-text="加载中..."
      loading-more-no-more-text="END"
      :loading-more-title-custom-style="{fontSize:'24rpx',heigth:'160rpx'}"
      empty-view-text="暂无模板"
      :show-loading-more-no-more-line="true"
      @query="queryTemplates"
    >
      <view class="px-[16rpx] pt-[16rpx]">
        <view
          class="relative h-[380rpx] overflow-hidden rounded-[32rpx] bg-black shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)]"
        >
          <image class="absolute inset-0 h-full w-full opacity-[0.62]" mode="aspectFill" :src="heroImage" />
          <view
            class="absolute inset-0 bg-[linear-gradient(180deg,rgba(0,0,0,0)_12%,rgba(0,0,0,0.22)_42%,rgba(0,0,0,0.88)_100%)]"
          />
          <view class="absolute bottom-[32rpx] left-[32rpx] right-[32rpx] flex flex-col items-start">
            <text
              class="inline-flex rounded-full border border-[rgba(255,255,255,0.26)] bg-[rgba(255,255,255,0.18)] px-[28rpx] py-[12rpx] text-[20rpx] font-bold leading-[28rpx] tracking-[4rpx] text-white backdrop-blur-[40rpx]"
            >
              NEW RELEASE
            </text>
            <text class="mt-[16rpx] text-[48rpx] font-bold text-white font-serif">
              GPT Image 2
            </text>
            <text class="mt-[8rpx] max-w-[600rpx] text-[26rpx] font-normal leading-[38rpx] text-white/70 font-mono">
              利用下一代 AI 引擎将您的想象力转化为高分辨率的视觉杰作。体验前所未有的艺术精确度
            </text>
            <button
              class="mt-[32rpx] flex h-[80rpx] min-w-[212rpx] items-center justify-center gap-[12rpx] rounded-[24rpx] bg-white px-[48rpx] text-[28rpx] font-extrabold leading-[96rpx] text-black"
              @tap="goGenerate"
            >
              <text>开始创作</text>
              <text class="text-[34rpx] font-medium leading-[34rpx]">→</text>
            </button>
          </view>
        </view>
        <view class="sticky top-0 z-20 mt-[20rpx] overflow-hidden bg-[#f9f9f9] pb-[24rpx] pt-[24rpx]">
          <scroll-view
            class="w-full whitespace-nowrap"
            scroll-x
            enhanced
            :show-scrollbar="false"
          >
            <view class="flex gap-[16rpx] pb-[4rpx]">
              <button
                v-for="chip in chipList"
                :key="chip.categoryId"
                class="inline-flex w-auto min-w-0 shrink-0 items-center justify-center rounded-full px-[24rpx] py-[12rpx] text-[26rpx] font-semibold leading-[34rpx] active:scale-95"
                :class="isActiveChip(chip) ? 'bg-black text-white' : 'bg-[#e2e2e2] text-[#1a1c1c]'"
                @tap="handleCategoryChange(chip)"
              >
                {{ chip.categoryName }}
              </button>
            </view>
          </scroll-view>
        </view>

        <view class="grid grid-cols-2 gap-[16rpx] pb-[48rpx]">
          <view
            v-for="(column, columnIndex) in templateColumns"
            :key="columnIndex"
            class="flex flex-col gap-[16rpx]"
          >
            <view
              v-for="item in column"
              :key="item.templateId"
              class="masonry-item bg-white rounded-[8rpx] overflow-hidden soft-shadow border border-gray-100"
              @tap="goTemplateDetail(item.templateId)"
            >
              <image class="block w-full" mode="widthFix" :src="item.coverUrl" />
              <view class="px-[20rpx] py-[18rpx]">
                <view class="mb-[10rpx] flex items-center gap-[10rpx]">
                  <text class="iconfont icon-images text-[22rpx] leading-none text-[#767676]" />
                  <text class="text-[24rpx] font-medium leading-[32rpx] text-[#767676]">
                    {{ getTemplateModelName(item) }}
                  </text>
                </view>
                <text class="block truncate text-[28rpx] font-semibold leading-[38rpx] text-black">
                  {{ item.title }}
                </text>
                <view class="mt-[12rpx] flex flex-wrap gap-[8rpx]">
                  <text
                    v-for="tag in getTemplateTags(item)"
                    :key="tag"
                    class="rounded-full bg-[#f0f0f0] px-[18rpx] py-[6rpx] text-[22rpx] font-semibold leading-[30rpx] text-[#1a1c1c]"
                  >
                    {{ tag }}
                  </text>
                </view>
              </view>
            </view>
          </view>
        </view>
      </view>

      <template #loadingMoreLoading>
        <view class="flex h-[140rpx] items-center justify-center bg-[#f9f9f9] pt-[8rpx]">
          <view class="flex h-[44rpx] items-center justify-center gap-[10rpx] rounded-full bg-white px-[24rpx]">
            <view class="loading-more-spinner h-[24rpx] w-[24rpx] rounded-full border-[3rpx] border-[#d7d7d7] border-t-black" />
            <text class="text-[24rpx] font-medium leading-[32rpx] text-[#7e7576]">加载中...</text>
          </view>
        </view>
      </template>
    </z-paging>
  </view>
</template>

<script setup lang="ts">
import { computed, getCurrentInstance, nextTick, onMounted, ref } from "vue";
import ZPaging from "z-paging/components/z-paging/z-paging.vue";
import { routes, navigateTo, switchTab } from "@/utils/router";
import { getTemplateCategories, listTemplates, type TemplateCategory, type TemplateItem } from "@/api/template";
import AppNavBar from "@/components/AppNavBar.vue";

const heroImage =
  "https://lh3.googleusercontent.com/aida-public/AB6AXuAHaLmgTeKMCIq__T1vgUYUp8cJe_0aDfBw6MQL9TtpXg5KWzLrpg99RqTMkr4PJmxCogcnynHzLntk0c-kvnFAZnJT5z_OHH_WTp6vOho3DUtRA7xJipLhatstWi_DEQ6E0Bo4q4MqmMgLeCC0ghaon_d-WOsD4FQbKowY1q246jJBfKyw2QPos_ZhzBb6swUN7EvoxdWHwyN4TAtTpOxOYvYlYA_bROGnn-JDINvon-Z1elz-R2EFuOqEe4Rk2hQM31r69QbOP9BC";

interface PagingRef {
  completeByTotal(data: TemplateItem[], total: number): Promise<unknown>;
  completeByError(cause: string): Promise<unknown>;
  reload(animate?: boolean): Promise<unknown>;
}

const instance = getCurrentInstance();
const chips = ref<TemplateCategory[]>([]);
const activeCategoryId = ref<number | "all">("all");
const templates = ref<TemplateItem[]>([]);
const pageSize = 10;

const defaultChip: TemplateCategory = {
  categoryId: 0,
  categoryName: "全部",
  categoryCode: "all",
};

const chipList = computed(() => [defaultChip, ...chips.value]);
const templateColumns = computed(() => [
  templates.value.filter((_, index) => index % 2 === 0),
  templates.value.filter((_, index) => index % 2 === 1),
]);

function getPaging() {
  return instance?.proxy?.$refs?.paging as PagingRef | undefined;
}

async function loadCategories() {
  const data = await getTemplateCategories();
  chips.value = data || [];
}

async function queryTemplates(pageNo: number, pageSize: number) {
  const params: Record<string, string> = {};
  if (activeCategoryId.value !== "all") {
    params.categoryId = String(activeCategoryId.value);
  }

  try {
    const result = await listTemplates({
      ...params,
      pageNum: pageNo,
      pageSize,
    });
    await getPaging()?.completeByTotal(result.rows || [], result.total || 0);
  } catch (error) {
    const message = error instanceof Error ? error.message : "模板加载失败";
    await getPaging()?.completeByError(message);
  }
}

async function handleCategoryChange(chip: TemplateCategory) {
  activeCategoryId.value = chip.categoryCode === "all" ? "all" : chip.categoryId;
  templates.value = [];
  await getPaging()?.reload();
}

function isActiveChip(chip: TemplateCategory) {
  if (chip.categoryCode === "all") {
    return activeCategoryId.value === "all";
  }
  return activeCategoryId.value === chip.categoryId;
}

function getTemplateModelName(_item: TemplateItem) {
  return "OpenAI · ChatGPT";
}

function getTemplateTags(item: TemplateItem) {
  return [item.categoryName || "电影感"];
}

function goTemplateDetail(templateId: number) {
  navigateTo(routes.templateDetail, { id: templateId });
}

function goTemplates() {
  switchTab(routes.templates);
}

function goGenerate() {
  navigateTo(routes.generate);
}

onMounted(async () => {
  await loadCategories();
  await nextTick();
  await getPaging()?.reload();
});
</script>

<style>
.loading-more-spinner {
  animation: loading-more-spin 0.8s linear infinite;
}

@keyframes loading-more-spin {
  from {
    transform: rotate(0deg);
  }

  to {
    transform: rotate(360deg);
  }
}
</style>
