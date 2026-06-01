import { request } from "@/utils/request";
import { baseUrl } from "@/config/env";

function resolveFileUrl(url?: string) {
  if (!url) return "";
  if (/^(https?:)?\/\//i.test(url) || url.startsWith("data:")) return url;
  if (url.startsWith("/")) return `${baseUrl}${url}`;
  return `${baseUrl}/${url}`;
}

export interface TemplateItem {
  templateId: number;
  title: string;
  categoryId: number;
  categoryName: string;
  description?: string;
  coverUrl: string;
  prompt: string;
  aiEngine?: string;
  ratio?: string;
  sort?: number;
  status?: string;
  createTime?: string;
  updateTime?: string;
  remark?: string;
  tags?: TemplateTag[];
}

export interface TemplateListParams {
  categoryId?: string;
  pageNum?: number;
  pageSize?: number;
}

export interface TemplateListResult {
  rows: TemplateItem[];
  total: number;
}

export interface TemplateFavoriteStatus {
  favorited: boolean;
}

export function getTemplateCategories() {
  return request<TemplateCategory[]>({
    url: "/mini/templates/categories",
    method: "GET",
  });
}

export function getTemplateTags() {
  return request<TemplateTag[]>({
    url: "/mini/templates/tags",
    method: "GET",
  });
}

export function listTemplates(params?: TemplateListParams) {
  return request<TemplateListResult>({
    url: "/mini/templates/list",
    method: "GET",
    params,
  }).then((result) => ({
    ...result,
    rows: (result.rows || []).map((item) => ({ ...item, coverUrl: resolveFileUrl(item.coverUrl) })),
  }));
}

export function getTemplateDetail(templateId: number | string) {
  return request<TemplateItem>({
    url: `/mini/templates/${templateId}`,
    method: "GET",
  }).then((item) => ({ ...item, coverUrl: resolveFileUrl(item.coverUrl) }));
}

export function getTemplateFavoriteStatus(templateId: number | string) {
  return request<TemplateFavoriteStatus>({
    url: `/mini/template-favorites/status/${templateId}`,
    method: "GET",
  });
}

export function favoriteTemplate(templateId: number | string) {
  return request<TemplateFavoriteStatus>({
    url: `/mini/template-favorites/${templateId}`,
    method: "POST",
  });
}

export function unfavoriteTemplate(templateId: number | string) {
  return request<TemplateFavoriteStatus>({
    url: `/mini/template-favorites/${templateId}`,
    method: "DELETE",
  });
}

export function listFavoriteTemplates(params?: Pick<TemplateListParams, "pageNum" | "pageSize">) {
  return request<TemplateListResult>({
    url: "/mini/template-favorites/list",
    method: "GET",
    params,
  }).then((result) => ({
    ...result,
    rows: (result.rows || []).map((item) => ({ ...item, coverUrl: resolveFileUrl(item.coverUrl) })),
  }));
}

export interface TemplateCategory {
  categoryId: number;
  categoryName: string;
  categoryCode: string;
  sort?: number;
  status?: string;
}

export interface TemplateTag {
  tagId: number;
  tagName: string;
  groupCode: "style" | "use" | "subject" | "element" | string;
  sort?: number;
  status?: string;
}
