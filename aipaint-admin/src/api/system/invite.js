import request from '@/utils/request'

// 查询邀请记录列表
export function listInviteRecord(query) {
  return request({
    url: '/system/invite/list',
    method: 'get',
    params: query
  })
}

// 导出邀请记录
export function exportInviteRecord(query) {
  return request({
    url: '/system/invite/export',
    method: 'post',
    params: query
  })
}
