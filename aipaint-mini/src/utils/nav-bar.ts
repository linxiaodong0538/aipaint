const NAV_CONTENT_HEIGHT = 44;

export function getNavBarLayout() {
  const windowInfo = uni.getWindowInfo();
  const { statusBarHeight = 0, windowWidth = 375 } = windowInfo;
  const menuButtonRect = getMenuButtonRect();
  const menuButtonHeight = menuButtonRect?.height || 32;
  const menuButtonTop = menuButtonRect?.top ?? statusBarHeight + Math.max(0, (NAV_CONTENT_HEIGHT - menuButtonHeight) / 2);
  const navContentHeight = menuButtonRect
    ? (menuButtonTop - statusBarHeight) * 2 + menuButtonHeight
    : NAV_CONTENT_HEIGHT;
  const menuButtonRight = menuButtonRect ? windowWidth - menuButtonRect.left : 0;
  const menuButtonGap = menuButtonRect ? Math.max(8, menuButtonRect.left - 12) : 0;
  const totalHeight = statusBarHeight + navContentHeight;

  return {
    statusBarHeight,
    navContentHeight,
    menuButtonHeight,
    menuButtonTop,
    menuButtonRight,
    menuButtonGap,
    totalHeight,
  };
}

function getMenuButtonRect() {
  try {
    if (typeof uni.getMenuButtonBoundingClientRect !== "function") {
      return undefined;
    }

    return uni.getMenuButtonBoundingClientRect();
  } catch {
    return undefined;
  }
}
