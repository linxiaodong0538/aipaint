const NAV_CONTENT_HEIGHT = 44;

export function getNavBarLayout() {
  const { statusBarHeight = 0 } = uni.getWindowInfo();
  const totalHeight = statusBarHeight + NAV_CONTENT_HEIGHT;

  return {
    statusBarHeight,
    navContentHeight: NAV_CONTENT_HEIGHT,
    totalHeight,
  };
}
