import { request } from "@/utils/request";

export interface InviteStats {
  totalInvites: number;
  totalRewardCredits: number;
  todayInvites: number;
}

export function getInviteStats() {
  return request<InviteStats>({
    url: "/mini/invite/stats",
    method: "GET",
  });
}
