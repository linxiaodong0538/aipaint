import { request } from "@/utils/request";

export interface CreditRecord {
  recordId: number;
  userId: number;
  changeType: string;
  amount: number;
  balanceAfter: number;
  relatedType?: string;
  relatedId?: string;
  remark?: string;
  createTime?: string;
}

export function getCreditBalance() {
  return request<number>({
    url: "/mini/credits/balance",
    method: "GET",
  });
}

export function listCreditRecords(limit = 50) {
  return request<CreditRecord[]>({
    url: "/mini/credits/records",
    method: "GET",
    data: { limit },
  });
}
