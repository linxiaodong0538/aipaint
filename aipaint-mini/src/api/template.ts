import { request } from "@/utils/request";

export interface TemplateItem {
  templateId: number;
  title: string;
  category: string;
  description?: string;
  coverUrl: string;
  prompt: string;
  aiEngine?: string;
  ratio?: string;
  sort?: number;
  status?: string;
  createTime?: string;
}

export function getTemplateCategories() {
  return request<string[]>({
    url: "/mini/templates/categories",
    method: "GET",
  });
}

export function listTemplates(params?: Record<string, string>) {
  return request<TemplateItem[]>({
    url: "/mini/templates/list",
    method: "GET",
    params,
  });
}

export function getTemplateDetail(templateId: number | string) {
  return request<TemplateItem>({
    url: `/mini/templates/${templateId}`,
    method: "GET",
  });
}
