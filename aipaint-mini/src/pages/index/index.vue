<template>
  <view class="min-h-screen overflow-hidden bg-[#f9f9f9] font-sans text-[#1a1c1c]">
    <scroll-view
      class="h-screen"
      scroll-y
      enhanced
      :show-scrollbar="false"
      lower-threshold="160"
      @scrolltolower="handleScrollToLower"
    >
      <view class="px-[24rpx] pb-[80rpx] pt-[24rpx]">
        <view
          class="relative h-[420rpx] overflow-hidden rounded-[46rpx] bg-black shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)]"
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
            <text class="mt-[16rpx] text-[56rpx] font-extrabold leading-[76rpx] text-white">
              GPT Image 2
            </text>
            <text class="mt-[8rpx] max-w-[600rpx] text-[30rpx] font-normal leading-[46rpx] text-white/70">
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

        <view class="mt-[40rpx] flex items-end justify-between">
          <view>
            <text class="block text-[36rpx] font-bold leading-[48rpx] text-black">风格探索</text>
            <text class="mt-[16rpx] block text-[28rpx] leading-[40rpx] text-[#636262]">
              选择一个基调开始您的艺术之旅
            </text>
          </view>
          <button
            class="flex h-[44rpx] min-w-[144rpx] items-center justify-end gap-[4rpx] bg-transparent p-0 text-[28rpx] font-bold leading-[44rpx] text-black"
            @tap="goTemplates"
          >
            <text>查看全部</text>
            <text class="text-[34rpx] leading-[38rpx]">›</text>
          </button>
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

        <view class="columns-2 gap-[24rpx]">
          <view
            v-for="item in templates"
            :key="item.templateId"
            class="mb-[24rpx] break-inside-avoid overflow-hidden rounded-[24rpx] border border-[#c8c9d2] bg-white"
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

        <view class="flex items-center justify-center py-[96rpx]">
          <text class="text-[24rpx] leading-[32rpx] text-[#767676]">
            {{ loadingMore ? "加载中..." : loadMoreText }}
          </text>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { onMounted, ref, computed } from "vue";
import { routes, navigateTo, switchTab } from "@/utils/router";
import { getTemplateCategories, listTemplates, type TemplateCategory, type TemplateItem } from "@/api/template";

const heroImage =
  "https://lh3.googleusercontent.com/aida-public/AB6AXuAHaLmgTeKMCIq__T1vgUYUp8cJe_0aDfBw6MQL9TtpXg5KWzLrpg99RqTMkr4PJmxCogcnynHzLntk0c-kvnFAZnJT5z_OHH_WTp6vOho3DUtRA7xJipLhatstWi_DEQ6E0Bo4q4MqmMgLeCC0ghaon_d-WOsD4FQbKowY1q246jJBfKyw2QPos_ZhzBb6swUN7EvoxdWHwyN4TAtTpOxOYvYlYA_bROGnn-JDINvon-Z1elz-R2EFuOqEe4Rk2hQM31r69QbOP9BC";

const chips = ref<TemplateCategory[]>([]);
const activeCategoryId = ref<number | "all">("all");
const templates = ref<TemplateItem[]>([]);
const pageNum = ref(1);
const pageSize = 10;
const total = ref(0);
const loadingTemplates = ref(false);
const loadingMore = ref(false);

const defaultChip: TemplateCategory = {
  categoryId: 0,
  categoryName: "全部",
  categoryCode: "all",
};

const chipList = computed(() => [defaultChip, ...chips.value]);
const hasMore = computed(() => templates.value.length < total.value);
const loadMoreText = computed(() => {
  if (!templates.value.length && !loadingTemplates.value) return "暂无模板";
  if (hasMore.value) return "上滑加载更多";
  return "已经到底了";
});

async function loadCategories() {
  const data = await getTemplateCategories();
  chips.value = data || [];
}

async function loadTemplates() {
  if (loadingTemplates.value) return;

  loadingTemplates.value = true;
  const params: Record<string, string> = {};
  if (activeCategoryId.value !== "all") {
    params.categoryId = String(activeCategoryId.value);
  }

  try {
    const result = await listTemplates({
      ...params,
      pageNum: pageNum.value,
      pageSize,
    });

    total.value = result.total || 0;
    const rows = result.rows || [];
    templates.value = pageNum.value === 1 ? rows : [...templates.value, ...rows];
  } finally {
    loadingTemplates.value = false;
    loadingMore.value = false;
  }
}

async function handleCategoryChange(chip: TemplateCategory) {
  activeCategoryId.value = chip.categoryCode === "all" ? "all" : chip.categoryId;
  pageNum.value = 1;
  total.value = 0;
  templates.value = [];
  await loadTemplates();
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

async function handleScrollToLower() {
  if (loadingTemplates.value || loadingMore.value || !hasMore.value) return;

  loadingMore.value = true;
  pageNum.value += 1;
  await loadTemplates();
}

onMounted(async () => {
  await loadCategories();
  await loadTemplates();
});
</script>
