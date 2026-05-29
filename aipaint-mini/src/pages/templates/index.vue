<template>
  <view class="flex h-screen flex-col overflow-hidden bg-(--app-background) font-sans text-[#1a1c1c]">
    <AppNavBar title="灵感">
      <template #left>
        <button
          class="m-0 flex h-[28px] min-w-[28px] max-w-[260rpx] shrink-0 items-center justify-center gap-[10rpx] rounded-full bg-white/16 px-[16rpx] py-0 text-white shadow-[inset_0_0_0_1rpx_rgba(255,255,255,0.08)] active:scale-95 active:bg-white/24"
          hover-class="none"
          aria-label="搜索模板"
          @tap="openSearch"
        >
            <text class="iconfont icon-sousuokuangsousuo"></text>
          <text
            v-if="searchKeyword"
            class="max-w-[150rpx] truncate text-[23rpx] font-semibold leading-[32px] text-white pr-[8rpx]"
          >
            {{ searchKeyword }}
          </text>
        </button>
      </template>
    </AppNavBar>

    <view class="shrink-0 px-[24rpx] pt-[24rpx]">
      <scroll-view class="w-full whitespace-nowrap" scroll-x enhanced :show-scrollbar="false">
        <view class="flex gap-[16rpx] pb-[24rpx]">
          <button
            v-for="chip in chips"
            :key="chip.categoryCode"
            class="inline-flex w-auto min-w-0 shrink-0 items-center justify-center rounded-full px-[24rpx] py-[12rpx] text-[26rpx] font-semibold leading-[34rpx] active:scale-95"
            :class="chip.categoryName === activeChip ? 'bg-black text-white' : 'bg-[#e2e2e2] text-[#1a1c1c]'"
            @tap="handleChipChange(chip)"
          >
            {{ chip.categoryName }}
          </button>
        </view>
      </scroll-view>
    </view>

    <scroll-view class="min-h-0 flex-1" scroll-y enhanced :show-scrollbar="false">
      <view class="px-[16rpx] pb-[224rpx]">
        <view v-if="filteredTemplates.length" class="columns-2 gap-[16rpx] pb-[36rpx]">
          <view
            v-for="template in filteredTemplates"
            :key="template.templateId"
            class="mb-[24rpx] break-inside-avoid overflow-hidden rounded-[12rpx] border border-[rgba(0,0,0,0.04)] bg-white shadow-[0_10rpx_28rpx_rgba(0,0,0,0.04)] active:scale-[0.98]"
            @tap="goDetail(template)"
          >
            <image class="block w-full" mode="widthFix" :src="template.coverUrl" />
            <view class="px-[20rpx] py-[18rpx]">
              <view class="mb-[10rpx] flex items-center gap-[10rpx]">
                <text class="iconfont icon-images text-[22rpx] leading-none text-[#767676]" />
                <text class="text-[24rpx] font-medium leading-[32rpx] text-[#767676]">
                  {{ getTemplateModelName(template) }}
                </text>
              </view>
              <text class="block truncate text-[28rpx] font-semibold leading-[38rpx] text-black">
                {{ template.title }}
              </text>
              <view class="mt-[12rpx] flex flex-wrap gap-[8rpx]">
                <text
                  v-for="tag in getTemplateTags(template)"
                  :key="tag"
                  class="min-h-[44rpx] rounded-full bg-[#f0f0f0] px-[18rpx] py-[7rpx] text-[22rpx] font-semibold leading-[30rpx] text-[#1a1c1c] active:bg-[#dedede]"
                  @tap.stop="searchByTag(tag)"
                >
                  {{ tag }}
                </text>
              </view>
            </view>
          </view>
        </view>

        <view v-else class="flex min-h-[420rpx] flex-col items-center justify-center px-[48rpx] text-center">
          <view class="flex h-[112rpx] w-[112rpx] items-center justify-center rounded-full bg-white shadow-[0_12rpx_36rpx_rgba(0,0,0,0.06)]">
            <text class="iconfont icon-sousuokuangsousuo" style="font-size: 40rpx;"></text>
          </view>
          <text class="mt-[28rpx] text-[30rpx] font-semibold leading-[40rpx] text-black">
            没找到相关模板
          </text>
          <text class="mt-[10rpx] text-[24rpx] leading-[34rpx] text-[#7a7a7a]">
            换个关键词，或看看热门灵感标签
          </text>
          <button
            v-if="searchKeyword"
            class="mt-[28rpx] m-0 rounded-full bg-black px-[34rpx] py-[14rpx] text-[24rpx] font-semibold leading-[32rpx] text-white active:scale-95"
            hover-class="none"
            @tap="clearSearch"
          >
            清除搜索
          </button>
        </view>
      </view>
    </scroll-view>

    <TemplateSearchPanel
      :visible="showSearchPanel"
      :keyword="searchKeyword"
      :recent-searches="recentSearches"
      :suggestions="searchSuggestions"
      :result-count="filteredTemplates.length"
      @close="closeSearch"
      @search="commitSearch"
      @clear-recent="clearRecentSearches"
    />
  </view>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from "vue";
import { navigateTo, routes } from "@/utils/router";
import { getTemplateCategories, getTemplateTags as fetchTemplateTags, listTemplates, type TemplateCategory, type TemplateItem, type TemplateTag } from "@/api/template";
import AppNavBar from "@/components/AppNavBar.vue";
import TemplateSearchPanel from "./components/TemplateSearchPanel.vue";

const chips = ref<TemplateCategory[]>([{ categoryName: "全部", categoryId: 0, categoryCode: "all" }]);
const activeChip = ref("全部");
const allTemplates = ref<TemplateItem[]>([]);
const showSearchPanel = ref(false);
const searchKeyword = ref("");
const recentSearches = ref<string[]>([]);
const templateTags = ref<TemplateTag[]>([]);
const searchSuggestions = computed(() => {
  const suggestions = templateTags.value.map((item) => item.tagName).filter(Boolean);
  return (suggestions.length ? suggestions : defaultSearchSuggestions).slice(0, 8);
});

const defaultSearchSuggestions = ["极简主义", "水墨艺术", "电商主图", "产品摄影"];

const filteredTemplates = computed(() => {
  const keyword = normalizeSearchText(searchKeyword.value);
  const scopedTemplates = activeChip.value === "全部"
    ? allTemplates.value
    : allTemplates.value.filter((item) => item.categoryName === activeChip.value);

  const source = keyword
    ? allTemplates.value
    : scopedTemplates;

  if (!keyword) {
    return source;
  }

  return source.filter((item) => getTemplateSearchText(item).includes(keyword));
});

async function loadCategories() {
  const categories = await getTemplateCategories();
  chips.value = [{ categoryName: "全部", categoryId: 0, categoryCode: "all" }, ...categories];
}

async function loadTags() {
  templateTags.value = await fetchTemplateTags();
}

async function loadTemplates() {
  const result = await listTemplates({ pageNum: 1, pageSize: 1000 });
  allTemplates.value = result.rows || [];
}

function getTemplateModelName(_template: TemplateItem) {
  return "OpenAI · ChatGPT";
}

function getTemplateTags(template: TemplateItem) {
  const tags = (template.tags || []).map((tag) => tag.tagName).filter(Boolean);
  return tags.length ? tags.slice(0, 2) : [template.categoryName || "模板"];
}

function getTemplateSearchText(template: TemplateItem) {
  return normalizeSearchText([
    template.title,
    ...(template.tags || []).map((tag) => tag.tagName),
    template.categoryName,
    template.description,
    template.prompt,
    template.aiEngine,
    template.ratio,
  ].filter(Boolean).join(" "));
}

function normalizeSearchText(value: string) {
  return value.trim().toLowerCase();
}

function goDetail(template: TemplateItem) {
  navigateTo(routes.templateDetail, {
    id: template.templateId,
  });
}

function handleChipChange(chip: TemplateCategory) {
  activeChip.value = chip.categoryName;
  searchKeyword.value = "";
}

function openSearch() {
  showSearchPanel.value = true;
}

function closeSearch() {
  showSearchPanel.value = false;
}

function commitSearch(value: string) {
  const keyword = normalizeSearchText(value);
  searchKeyword.value = keyword;
  if (keyword) {
    activeChip.value = "全部";
    recentSearches.value = [keyword, ...recentSearches.value.filter((item) => item !== keyword)].slice(0, 6);
  }
  showSearchPanel.value = false;
}

function clearSearch() {
  searchKeyword.value = "";
}

function searchByTag(tag: string) {
  searchKeyword.value = normalizeSearchText(tag);
  activeChip.value = "全部";
  recentSearches.value = [tag, ...recentSearches.value.filter((item) => item !== tag)].slice(0, 6);
}

function clearRecentSearches() {
  recentSearches.value = [];
}

onMounted(async () => {
  await Promise.all([loadCategories(), loadTemplates(), loadTags()]);
});
</script>

<style scoped>
.search-mark {
  position: relative;
  width: 32rpx;
  height: 32rpx;
  flex: 0 0 32rpx;
}

.search-mark__ring {
  position: absolute;
  left: 2rpx;
  top: 1rpx;
  width: 22rpx;
  height: 22rpx;
  border: 4rpx solid currentColor;
  border-radius: 9999rpx;
}

.search-mark__handle {
  position: absolute;
  right: 2rpx;
  bottom: 3rpx;
  width: 14rpx;
  height: 4rpx;
  border-radius: 9999rpx;
  background: currentColor;
  transform: rotate(45deg);
  transform-origin: center;
}

.search-mark--nav {
  color: #fff;
  transform: scale(1.08);
}

.search-mark--nav .search-mark__ring {
  border-width: 5rpx;
}

.search-mark--nav .search-mark__handle {
  height: 5rpx;
}

.search-mark--empty {
  color: #111;
  transform: scale(1.18);
}

</style>
