import { request } from "@/utils/request";

export interface PaymentOrder {
  orderId: number;
  outTradeNo: string;
  userId: number;
  productId: string;
  productType: "MEMBERSHIP" | "ADDON";
  productName: string;
  amountCent: number;
  credits: number;
  memberTier?: "monthly" | "pro" | "studio";
  memberDays?: number;
  status: "CREATED" | "PAID" | "CLOSED";
  transactionId?: string;
  prepayId?: string;
  paidTime?: string;
  expireTime?: string;
}

export interface PaymentParams {
  timeStamp: string;
  nonceStr: string;
  package: string;
  signType: "RSA";
  paySign: string;
}

export interface CreatePaymentResult {
  order: PaymentOrder;
  paymentParams: PaymentParams;
}

export function createPaymentOrder(productId: string) {
  return request<CreatePaymentResult>({
    url: "/mini/payment/orders",
    method: "POST",
    data: { productId },
  });
}

export function getPaymentOrder(outTradeNo: string) {
  return request<PaymentOrder>({
    url: `/mini/payment/orders/${outTradeNo}`,
    method: "GET",
  });
}
