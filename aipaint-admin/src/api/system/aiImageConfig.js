import request from '@/utils/request'

export function getAiImageConfig() {
  return request({
    url: '/system/ai-image-config',
    method: 'get'
  })
}

export function updateAiImageConfig(data) {
  return request({
    url: '/system/ai-image-config',
    method: 'put',
    data
  })
}
