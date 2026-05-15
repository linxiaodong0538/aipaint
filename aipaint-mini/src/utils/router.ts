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
  templates: "/pages/templates/index",
  works: "/pages/works/index",
  me: "/pages/me/index",
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
  return uni.redirectTo({
    url: path,
  });
}

export function navigateBack(delta = 1) {
  return uni.navigateBack({
    delta,
  });
}
