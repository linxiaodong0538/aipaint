const NAV_CONTENT_HEIGHT = 44;

export function getNavBarLayout() {
  const windowInfo = uni.getWindowInfo();
  const { statusBarHeight = 0, windowWidth = 375 } = windowInfo;

  // #ifdef H5
  return createNavBarLayout({
    statusBarHeight: getH5SafeAreaTop(statusBarHeight),
    navContentHeight: NAV_CONTENT_HEIGHT,
    windowWidth,
  });
  // #endif

  const menuButtonRect = getMenuButtonRect();
  const menuButtonHeight = menuButtonRect?.height || 32;
  const menuButtonTop = menuButtonRect?.top ?? statusBarHeight + Math.max(0, (NAV_CONTENT_HEIGHT - menuButtonHeight) / 2);
  const navContentHeight = menuButtonRect
    ? (menuButtonTop - statusBarHeight) * 2 + menuButtonHeight
    : NAV_CONTENT_HEIGHT;

  return createNavBarLayout({
    statusBarHeight,
    navContentHeight,
    menuButtonHeight,
    menuButtonTop,
    windowWidth,
    menuButtonLeft: menuButtonRect?.left,
  });
}

interface NavBarLayoutOptions {
  statusBarHeight: number;
  navContentHeight: number;
  windowWidth: number;
  menuButtonHeight?: number;
  menuButtonTop?: number;
  menuButtonLeft?: number;
}

function createNavBarLayout(options: NavBarLayoutOptions) {
  const {
    statusBarHeight,
    navContentHeight,
    windowWidth,
    menuButtonHeight = 0,
    menuButtonTop = statusBarHeight,
    menuButtonLeft,
  } = options;
  const hasMenuButton = typeof menuButtonLeft === "number";
  const menuButtonRight = hasMenuButton ? windowWidth - menuButtonLeft : 0;
  const menuButtonGap = hasMenuButton ? 12 : 0;

  return {
    statusBarHeight,
    navContentHeight,
    menuButtonHeight,
    menuButtonTop,
    menuButtonRight,
    menuButtonGap,
    totalHeight: statusBarHeight + navContentHeight,
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

function getH5SafeAreaTop(fallback: number) {
  if (typeof document === "undefined" || !document.body) {
    return fallback;
  }

  const probe = document.createElement("div");
  probe.style.cssText = "position:fixed;top:0;height:env(safe-area-inset-top);visibility:hidden;pointer-events:none;";
  document.body.appendChild(probe);
  const safeAreaTop = Number.parseFloat(getComputedStyle(probe).height);
  document.body.removeChild(probe);

  return Number.isFinite(safeAreaTop) ? safeAreaTop : fallback;
}
