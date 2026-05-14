export function setCustomTabBarIndex(selected: number) {
  // #ifdef MP-WEIXIN
  const pages = getCurrentPages();
  const currentPage = pages[pages.length - 1] as {
    getTabBar?: () => {
      setData: (data: { selected: number }) => void;
    };
  };
  const tabBar = currentPage?.getTabBar?.();

  if (tabBar) {
    tabBar.setData({ selected });
  }
  // #endif
}
