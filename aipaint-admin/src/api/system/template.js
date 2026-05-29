import request from '@/utils/request'

// 查询模板列表
export function listTemplate(query) {
  return request({
    url: '/system/template/list',
    method: 'get',
    params: query
  })
}

// 查询模板分类列表
export function listTemplateCategory(query) {
  return request({
    url: '/system/template/category/list',
    method: 'get',
    params: query
  })
}

// 查询模板分类详细
export function getTemplateCategory(categoryId) {
  return request({
    url: '/system/template/category/' + categoryId,
    method: 'get'
  })
}

// 新增模板分类
export function addTemplateCategory(data) {
  return request({
    url: '/system/template/category',
    method: 'post',
    data: data
  })
}

// 修改模板分类
export function updateTemplateCategory(data) {
  return request({
    url: '/system/template/category',
    method: 'put',
    data: data
  })
}

// 删除模板分类
export function delTemplateCategory(categoryId) {
  return request({
    url: '/system/template/category/' + categoryId,
    method: 'delete'
  })
}

// 查询模板分类选择框列表
export function optionselectTemplateCategory() {
  return request({
    url: '/system/template/category/optionselect',
    method: 'get'
  })
}

// 查询模板标签列表
export function listTemplateTag(query) {
  return request({
    url: '/system/template/tag/list',
    method: 'get',
    params: query
  })
}

// 查询模板标签详细
export function getTemplateTag(tagId) {
  return request({
    url: '/system/template/tag/' + tagId,
    method: 'get'
  })
}

// 新增模板标签
export function addTemplateTag(data) {
  return request({
    url: '/system/template/tag',
    method: 'post',
    data: data
  })
}

// 修改模板标签
export function updateTemplateTag(data) {
  return request({
    url: '/system/template/tag',
    method: 'put',
    data: data
  })
}

// 删除模板标签
export function delTemplateTag(tagId) {
  return request({
    url: '/system/template/tag/' + tagId,
    method: 'delete'
  })
}

// 查询模板标签选择框列表
export function optionselectTemplateTag() {
  return request({
    url: '/system/template/tag/optionselect',
    method: 'get'
  })
}

// 模板标签状态修改
export function changeTemplateTagStatus(tagId, status) {
  const data = {
    tagId,
    status
  }
  return request({
    url: '/system/template/tag/changeStatus',
    method: 'put',
    data: data
  })
}

// 查询模板详细
export function getTemplate(templateId) {
  return request({
    url: '/system/template/' + templateId,
    method: 'get'
  })
}

// 新增模板
export function addTemplate(data) {
  return request({
    url: '/system/template',
    method: 'post',
    data: data
  })
}

// 修改模板
export function updateTemplate(data) {
  return request({
    url: '/system/template',
    method: 'put',
    data: data
  })
}

// 删除模板
export function delTemplate(templateId) {
  return request({
    url: '/system/template/' + templateId,
    method: 'delete'
  })
}

// 模板状态修改
export function changeTemplateStatus(templateId, status) {
  const data = {
    templateId,
    status
  }
  return request({
    url: '/system/template/changeStatus',
    method: 'put',
    data: data
  })
}
