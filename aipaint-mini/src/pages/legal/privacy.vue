<template>
  <view class="min-h-screen bg-[#f7f7f7] text-[#1a1c1c]">
    <scroll-view class="h-screen" scroll-y enhanced :show-scrollbar="false">
      <view class="mx-auto max-w-[750rpx] px-[32rpx] pb-[80rpx] pt-[36rpx]">
        <view class="mb-[28rpx] rounded-[32rpx] bg-black px-[34rpx] py-[34rpx] text-white">
          <text class="block text-[40rpx] font-bold leading-[52rpx] text-white">隐私政策</text>
          <text class="mt-[10rpx] block text-[22rpx] leading-[32rpx] text-white/55">生效日期：2026年5月31日</text>
        </view>

        <view class="legal-card">
          <text class="legal-p">AI智绘重视你的个人信息保护。本政策说明我们如何收集、使用、存储、共享和保护你的个人信息，以及你如何管理你的个人信息。</text>

          <text class="legal-h">1. 我们收集的信息</text>
          <text class="legal-p">为实现小程序功能，我们可能收集微信登录凭证、OpenID、昵称、头像、用户ID、会员等级、积分余额等账号信息。</text>
          <text class="legal-p">当你使用 AI 生图、提示词润色、模板生成等功能时，我们会处理你输入的提示词、选择的模型、比例、清晰度、生成数量、上传的参考图片、生成任务状态、生成结果图片、失败原因、积分消耗和任务时间。</text>
          <text class="legal-p">当你主动选择上传参考图时，小程序会调用微信提供的图片选择能力。我们只会处理你主动选择的图片，不会主动读取你的相册内容。</text>
          <text class="legal-p">当你购买会员或积分包时，我们会记录订单号、商品名称、商品类型、支付金额、积分数量、订单状态、支付时间、微信支付交易号等信息。支付过程由微信支付提供，我们不会收集银行卡号、支付密码等敏感支付信息。</text>
          <text class="legal-p">当你使用邀请奖励功能时，我们会记录邀请码、邀请关系、邀请人数、奖励积分等信息。</text>
          <text class="legal-p">为保障服务安全和稳定，我们可能收集设备型号、操作系统、网络状态、请求时间、接口日志、错误日志、IP 地址等信息。</text>

          <text class="legal-h">2. 我们如何使用信息</text>
          <text class="legal-p">我们会将收集的信息用于完成登录、账号识别、AI 生图、提示词润色、参考图上传、作品保存、积分扣减、充值支付、会员权益、邀请奖励、内容安全审核、异常排查、反作弊和服务优化。</text>

          <text class="legal-h">3. 我们如何共享信息</text>
          <text class="legal-p">我们不会出售你的个人信息。为实现必要功能，我们可能向微信平台、微信支付、AI 模型服务商或中转服务商、云存储或服务器服务商提供实现功能所必需的信息。</text>
          <text class="legal-p">我们会要求相关服务方仅在实现本政策所述目的范围内处理必要信息。</text>

          <text class="legal-h">4. 信息保存期限</text>
          <text class="legal-p">我们仅在实现本政策所述目的所需的期限内保存你的个人信息。账号信息通常在账号存续期间保存；作品和生成任务通常在你主动删除或账号注销前保存；支付订单和积分记录根据交易、财务、审计和法律要求保存。</text>

          <text class="legal-h">5. 你如何管理个人信息</text>
          <text class="legal-p">你可以在小程序中查看个人资料、积分余额、积分明细、作品记录和订单相关信息。你可以删除作品记录。若你希望访问、更正、删除个人信息，撤回授权，注销账号，或对个人信息处理提出疑问，可通过本政策末尾的联系方式联系我们。</text>

          <text class="legal-h">6. 权限说明</text>
          <text class="legal-p">本小程序可能使用微信登录、选择图片、保存图片到相册、微信支付、分享等能力。相关权限通常会在你使用对应功能时触发，你可以通过微信或系统设置管理授权。</text>

          <text class="legal-h">7. 未成年人保护</text>
          <text class="legal-p">若你为未满十四周岁的儿童，应在监护人同意和指导下使用本服务。监护人如发现儿童个人信息被不当处理，可联系我们处理。</text>

          <text class="legal-h">8. AI 生成内容特别说明</text>
          <text class="legal-p">你提交的提示词、参考图和生成结果可能会被用于完成本次生成、内容安全审核、问题排查和服务改进。未经你的明确授权，我们不会将你的个人身份信息用于公开展示。</text>
          <text class="legal-p">你不得上传涉及他人隐私、肖像、身份证件、敏感信息或未经授权的图片素材。</text>

          <text class="legal-h">9. 政策更新</text>
          <text class="legal-p">我们可能根据法律法规、平台规则或业务变化更新本政策。若更新涉及个人信息处理目的、方式或范围的重大变化，我们会依法重新取得你的同意。</text>

          <text class="legal-h">10. 联系我们</text>
          <text class="legal-p">开发者/运营主体：请补充正式主体名称</text>
          <text class="legal-p">联系方式：请补充客服电话或邮箱</text>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<style scoped>
.legal-card {
  display: flex;
  flex-direction: column;
  gap: 18rpx;
  border-radius: 28rpx;
  background: #ffffff;
  padding: 34rpx;
  box-shadow: 0 12rpx 34rpx rgba(0, 0, 0, 0.05);
}

.legal-h {
  margin-top: 10rpx;
  color: #111111;
  font-size: 30rpx;
  font-weight: 800;
  line-height: 42rpx;
}

.legal-p {
  color: #4f5555;
  font-size: 25rpx;
  line-height: 42rpx;
}
</style>
