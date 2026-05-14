<template>
  <view class="home-page">
    <scroll-view class="home-scroll" scroll-y enhanced :show-scrollbar="false">
      <view class="home-content">
        <view class="hero">
          <image class="hero__image" mode="aspectFill" :src="heroImage" />
          <view class="hero__shade" />
          <view class="hero__content">
            <text class="hero__badge">NEW RELEASE</text>
            <text class="hero__title">GPT Image 2</text>
            <text class="hero__desc ">
              利用下一代 AI 引擎将您的想象力转化为高分辨率的视觉杰作。体验前所未有的艺术精确度。
            </text>
            <button class="hero__button" @tap="goTemplates">
              <text>开始创作</text>
              <text class="hero__button-arrow">→</text>
            </button>
          </view>
        </view>

        <view class="section-head">
          <view>
            <text class="section-head__title">风格探索</text>
            <text class="section-head__desc">选择一个基调开始您的艺术之旅</text>
          </view>
          <button class="section-head__link" @tap="goTemplates">
            <text>查看全部</text>
            <text class="section-head__arrow">›</text>
          </button>
        </view>

        <scroll-view class="chips" scroll-x enhanced :show-scrollbar="false">
          <view class="chips__row">
            <button
              v-for="chip in chips"
              :key="chip"
              class="chip"
              :class="{ 'chip--active': chip === activeChip }"
              @tap="activeChip = chip"
            >
              {{ chip }}
            </button>
          </view>
        </scroll-view>

        <view class="style-grid">
          <view
            v-for="item in styles"
            :key="item.title"
            class="style-card"
            @tap="goTemplates"
          >
            <image class="style-card__image" mode="aspectFill" :src="item.image" />
            <view class="style-card__shade" />
            <view class="style-card__meta">
              <text class="style-card__title">{{ item.title }}</text>
              <text class="style-card__icon">{{ item.icon }}</text>
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

<style scoped>
.home-page {
  min-height: 100vh;
  overflow: hidden;
  background: #f9f9f9;
  color: #1a1c1c;
  font-family: "Plus Jakarta Sans", -apple-system, BlinkMacSystemFont, "PingFang SC", "Helvetica Neue", sans-serif;
}

.brand {
  display: flex;
  align-items: center;
  gap: 16rpx;
}

.brand__mark {
  display: flex;
  width: 44rpx;
  height: 44rpx;
  align-items: center;
  justify-content: center;
  color: #000000;
  font-size: 34rpx;
  font-weight: 700;
  line-height: 44rpx;
}

.brand__name {
  color: #000000;
  font-size: 48rpx;
  font-weight: 800;
  letter-spacing: 0;
  line-height: 56rpx;
}

.profile-button {
  display: flex;
  width: 48rpx;
  height: 48rpx;
  align-items: center;
  justify-content: center;
  color: #636262;
  background: transparent;
}

.profile-button__icon {
  font-size: 26rpx;
  font-weight: 700;
  line-height: 48rpx;
}

.home-scroll {
  height: 100vh;
}

.home-content {
  padding: 48rpx 48rpx 208rpx;
}

.hero {
  position: relative;
  height: 480rpx;
  overflow: hidden;
  background: #000000;
  border-radius: 64rpx;
  box-shadow: 0 40rpx 80rpx rgba(0, 0, 0, 0.05);
}

.hero__image {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  opacity: 0.62;
}

.hero__shade {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, 0) 12%, rgba(0, 0, 0, 0.22) 42%, rgba(0, 0, 0, 0.88) 100%);
}

.hero__content {
  position: absolute;
  right: 32rpx;
  bottom: 32rpx;
  left: 32rpx;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.hero__badge {
  display: inline-flex;
  padding: 12rpx 28rpx;
  color: #ffffff;
  background: rgba(255, 255, 255, 0.18);
  border: 1rpx solid rgba(255, 255, 255, 0.26);
  border-radius: 999rpx;
  backdrop-filter: blur(40rpx);
  font-size: 20rpx;
  font-weight: 700;
  letter-spacing: 4rpx;
  line-height: 28rpx;
}

.hero__title {
  margin-top: 16rpx;
  color: #ffffff;
  font-size: 64rpx;
  font-weight: 800;
  letter-spacing: 0;
  line-height: 76rpx;
}

.hero__desc {
  margin-top: 8rpx;
  max-width: 560rpx;
  color: rgba(255, 255, 255, 0.72);
  font-size: 30rpx;
  font-weight: 400;
  line-height: 46rpx;
}

.hero__button {
  display: flex;
  min-width: 212rpx;
  height: 96rpx;
  align-items: center;
  justify-content: center;
  gap: 12rpx;
  margin-top: 32rpx;
  padding: 0 48rpx;
  color: #000000;
  background: #ffffff;
  border-radius: 24rpx;
  font-size: 28rpx;
  font-weight: 800;
  line-height: 96rpx;
}

.hero__button-arrow {
  font-size: 34rpx;
  font-weight: 500;
  line-height: 34rpx;
}

.section-head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  margin-top: 64rpx;
}

.section-head__title {
  display: block;
  color: #000000;
  font-size: 48rpx;
  font-weight: 700;
  line-height: 64rpx;
}

.section-head__desc {
  display: block;
  margin-top: 4rpx;
  color: #636262;
  font-size: 28rpx;
  line-height: 40rpx;
}

.section-head__link {
  display: flex;
  min-width: 144rpx;
  height: 44rpx;
  align-items: center;
  justify-content: flex-end;
  gap: 4rpx;
  padding: 0;
  color: #000000;
  background: transparent;
  font-size: 28rpx;
  font-weight: 700;
  line-height: 44rpx;
}

.section-head__arrow {
  font-size: 34rpx;
  line-height: 38rpx;
}

.chips {
  width: calc(100% + 96rpx);
  margin: 48rpx -48rpx 0;
  white-space: nowrap;
}

.chips__row {
  display: flex;
  gap: 16rpx;
  padding: 0 48rpx 4rpx;
}

.chip {
  display: inline-flex;
  height: 72rpx;
  align-items: center;
  justify-content: center;
  padding: 0 48rpx;
  color: #636262;
  background: #ffffff;
  border: 1rpx solid rgba(0, 0, 0, 0.1);
  border-radius: 999rpx;
  font-size: 28rpx;
  font-weight: 700;
  line-height: 72rpx;
}

.chip--active {
  color: #ffffff;
  background: #000000;
  border-color: #000000;
}

.style-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 32rpx;
  margin-top: 28rpx;
}

.style-card {
  position: relative;
  display: block;
  height: 454rpx;
  overflow: hidden;
  padding: 0;
  background: #ffffff;
  border: 1rpx solid rgba(0, 0, 0, 0.05);
  border-radius: 48rpx;
  box-shadow: 0 40rpx 80rpx rgba(0, 0, 0, 0.05);
}

.style-card__image {
  width: 100%;
  height: 100%;
}

.style-card__shade {
  position: absolute;
  right: 0;
  bottom: 0;
  left: 0;
  height: 150rpx;
  background: linear-gradient(180deg, rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.66));
}

.style-card__meta {
  position: absolute;
  right: 32rpx;
  bottom: 32rpx;
  left: 32rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
  color: #ffffff;
}

.style-card__title {
  max-width: 168rpx;
  color: #ffffff;
  font-size: 28rpx;
  font-weight: 800;
  line-height: 38rpx;
  text-align: left;
}

.style-card__icon {
  display: flex;
  width: 42rpx;
  height: 42rpx;
  align-items: center;
  justify-content: center;
  color: #ffffff;
  border: 1rpx solid rgba(255, 255, 255, 0.56);
  border-radius: 999rpx;
  font-size: 22rpx;
  font-weight: 800;
  line-height: 42rpx;
}
</style>
