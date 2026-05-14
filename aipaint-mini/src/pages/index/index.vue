<template>
  <view class="min-h-screen overflow-hidden bg-[#f9f9f9] font-sans text-[#1a1c1c]">
    <scroll-view class="h-screen" scroll-y enhanced :show-scrollbar="false">
      <view class="px-[36rpx] pb-[208rpx] pt-[36rpx]">
        <view
          class="relative h-[480rpx] overflow-hidden rounded-[64rpx] bg-black shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)]"
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
            <text class="mt-[16rpx] text-[64rpx] font-extrabold leading-[76rpx] text-white">
              GPT Image 2
            </text>
            <text class="mt-[8rpx] max-w-[560rpx] text-[30rpx] font-normal leading-[46rpx] text-white/70">
              利用下一代 AI 引擎将您的想象力转化为高分辨率的视觉杰作。体验前所未有的艺术精确度。
            </text>
            <button
              class="mt-[32rpx] flex h-[96rpx] min-w-[212rpx] items-center justify-center gap-[12rpx] rounded-[24rpx] bg-white px-[48rpx] text-[28rpx] font-extrabold leading-[96rpx] text-black"
              @tap="goTemplates"
            >
              <text>开始创作</text>
              <text class="text-[34rpx] font-medium leading-[34rpx]">→</text>
            </button>
          </view>
        </view>

        <view class="mt-[64rpx] flex items-end justify-between">
          <view>
            <text class="block text-[48rpx] font-bold leading-[64rpx] text-black">风格探索</text>
            <text class="mt-[4rpx] block text-[28rpx] leading-[40rpx] text-[#636262]">
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

        <scroll-view
          class="-mx-[48rpx] mt-[48rpx] w-[calc(100%+96rpx)] whitespace-nowrap"
          scroll-x
          enhanced
          :show-scrollbar="false"
        >
          <view class="flex gap-[16rpx] px-[48rpx] pb-[4rpx]">
            <button
              v-for="chip in chips"
              :key="chip"
              class="inline-flex h-[72rpx] items-center justify-center rounded-full border px-[48rpx] text-[28rpx] font-bold leading-[72rpx]"
              :class="
                chip === activeChip
                  ? 'border-black bg-black text-white'
                  : 'border-[rgba(0,0,0,0.1)] bg-white text-[#636262]'
              "
              @tap="activeChip = chip"
            >
              {{ chip }}
            </button>
          </view>
        </scroll-view>

        <view class="mt-[28rpx] grid grid-cols-2 gap-[32rpx]">
          <view
            v-for="item in styles"
            :key="item.title"
            class="relative block h-[454rpx] overflow-hidden rounded-[48rpx] border border-[rgba(0,0,0,0.05)] bg-white p-0 shadow-[0_40rpx_80rpx_rgba(0,0,0,0.05)]"
            @tap="goTemplates"
          >
            <image class="h-full w-full" mode="aspectFill" :src="item.image" />
            <view
              class="absolute bottom-0 left-0 right-0 h-[150rpx] bg-[linear-gradient(180deg,rgba(0,0,0,0),rgba(0,0,0,0.66))]"
            />
            <view class="absolute bottom-[32rpx] left-[32rpx] right-[32rpx] flex items-center justify-between text-white">
              <text class="max-w-[168rpx] text-left text-[28rpx] font-extrabold leading-[38rpx] text-white">
                {{ item.title }}
              </text>
              <text
                class="flex h-[42rpx] w-[42rpx] items-center justify-center rounded-full border border-[rgba(255,255,255,0.56)] text-[22rpx] font-extrabold leading-[42rpx] text-white"
              >
                {{ item.icon }}
              </text>
            </view>
          </view>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { onShow } from "@dcloudio/uni-app";
import { routes, switchTab } from "@/utils/router";
import { setCustomTabBarIndex } from "@/utils/tabbar";

const heroImage =
  "https://lh3.googleusercontent.com/aida-public/AB6AXuAHaLmgTeKMCIq__T1vgUYUp8cJe_0aDfBw6MQL9TtpXg5KWzLrpg99RqTMkr4PJmxCogcnynHzLntk0c-kvnFAZnJT5z_OHH_WTp6vOho3DUtRA7xJipLhatstWi_DEQ6E0Bo4q4MqmMgLeCC0ghaon_d-WOsD4FQbKowY1q246jJBfKyw2QPos_ZhzBb6swUN7EvoxdWHwyN4TAtTpOxOYvYlYA_bROGnn-JDINvon-Z1elz-R2EFuOqEe4Rk2hQM31r69QbOP9BC";

const chips = ["全部", "复古", "插画", "角色", "其他"];
const activeChip = ref("全部");

const styles = [
  {
    title: "人像摄影",
    icon: "面",
    image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuCDqQ81RIrF4DYD6IUhgk5Vd-HiPTFoFCeTMaWVb-9zHZd4K-Uy-hrFd36GNLO1fBIlElhH5f28yVXbYMoY6X3BIKdBlbLRDlhkyu06sNreUu6wR6LjzKHdQHIHJnStkzZfKDej2S5XC8fpYwc9E_ZPtp0C7M1N_LX9hBdNqgDJabPA_FvW983rcC8Jv3ppP-jqZLrCRkf1hdR18Nd9CQUla4c_ZWMaSTWDUbpL-WJ8RGkZ5oNKHPCLkWAoFq8N3_Ujlwi-qkZC0ly9",
  },
  {
    title: "壮丽风景",
    icon: "山",
    image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuBTyCO2I_N97JxY2C3TgX2L5IDL2as-Lg-uSM3tyrJlG_w3IfAu0XiLafx04Sj84OoXSHRVQICE-leVwH2qkCyVsKZllB9aRkAYD7W8YSTZ1Fc1C6BR5EAWE6mC0ZoU6_BeoJumcvIAy5Bb-Q7WihM623FcPZhBsoCNzjOhWwu3jNSefyqhP8pij7nZ_urm9Ni11jSPfMLWf36bHT2lFXRcpOWoOddLfZ1CWXCtexsNRT6zKUB12vBXBwuQdTYkJtgzHJMCMRpdP0Ma",
  },
  {
    title: "二次元",
    icon: "绘",
    image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuDWKltY_tzZNoDkNNHoihAHH2yucH6ItJtGGuYmww1FuDw39xmuV73WVQ2Tft8pQPIH_Mw2dUvLnO4nJwrIknuqBBjJ2Pcm2QgSTkDaCiZ-D_AeF_QRdHExbsxmT_EofojW0qCO8ZI7NA7E3k0QbWhHKEBSlRfL9Yytm8Wvy9F8OHArBp83ddF7WMdBW3jMAFMxcjgtIs2NYLDO7RgPj79lr88ZpHVeKoTwJfbJDdZQQWOVa7LCzV73xe1_AV23koT8FzdclvsiLm-K",
  },
  {
    title: "3D 艺术",
    icon: "立",
    image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuCfS8GbRH19-WMIqfyCUTzFz8SVAxQS2k8nsziQOBvXFE-dtfXLFyh2eAylTfuOePlXtME3MguBsKladcSpyyJY-0xP-RPHUJ_tQo84JsV16PVkrpSTwKmcW0-Jtk7zZ1JaGdu18OvsOHH89Sw8R5em0fQCpqe_zERusg4vnZBNsbXdu2RlwRUVlJxXh2sKxZkZncomPo9VfaqD1MYWRC-Jdt_iMF4RQjSlOIz01Cx-Q8KrME0BMa8uF7CKY8I16NNEP2M2UKgqLVQy",
  },
];

function goTemplates() {
  switchTab(routes.templates);
}

onShow(() => {
  setCustomTabBarIndex(0);
});
</script>
