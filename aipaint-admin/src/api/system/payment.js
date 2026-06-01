import request from '@/utils/request'

// 查询充值订单列表
export function listPaymentOrder(query) {
  return request({
    url: '/system/payment/list',
    method: 'get',
    params: query
  })
}

// 手动查单同步
export function syncPaymentOrder(outTradeNo) {
  return request({
    url: '/system/payment/sync/' + outTradeNo,
    method: 'post'
  })
}
