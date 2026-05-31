type RouteParams = Record<string, string | number | boolean | undefined | null>;

function stringifyQuery(params?: RouteParams) {
  if (!params) return "";

  const query = Object.entries(params)
    .filter(([, value]) => value !== undefined && value !== null)
    .map(([key, value]) => `${encodeURIComponent(key)}=${encodeURIComponent(String(value))}`)
    .join("&");

  return query ? `?${query}` : "";
}

function withQuery(path: string, params?: RouteParams) {
  return `${path}${stringifyQuery(params)}`;
}

export const routes = {
  home: "/pages/index/index",
  generate: "/pages/generate/index",
  generateResult: "/pages/generate/result",
  templates: "/pages/templates/index",
  templateDetail: "/pages/templates/detail",
  templateFavorites: "/pages/templates/favorites",
  works: "/pages/works/index",
  me: "/pages/me/index",
  creditDetail: "/pages/me/credit-detail",
  recharge: "/pages/me/recharge",
  inviteReward: "/pages/me/invite-reward",
  userAgreement: "/pages/legal/agreement",
  privacyPolicy: "/pages/legal/privacy",
} as const;

export function navigateTo(path: string, params?: RouteParams) {
  return uni.navigateTo({
    url: withQuery(path, params),
  });
}

export function redirectTo(path: string, params?: RouteParams) {
  return uni.redirectTo({
    url: withQuery(path, params),
  });
}

export function reLaunch(path: string, params?: RouteParams) {
  return uni.reLaunch({
    url: withQuery(path, params),
  });
}

export function switchTab(path: string) {
  return uni.switchTab({
    url: path,
  });
}

export function navigateBack(delta = 1) {
  return uni.navigateBack({
    delta,
  });
}
