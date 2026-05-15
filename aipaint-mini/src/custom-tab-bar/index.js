Component({
  data: {
    selected: 0,
    tabs: [
      {
        pagePath: "/pages/index/index",
        route: "pages/index/index",
        text: "首页",
        normalIcon: "/static/tabbar/home-normal.png",
        activeIcon: "/static/tabbar/home-active.png"
      },
      {
        pagePath: "/pages/templates/index",
        route: "pages/templates/index",
        text: "模板",
        normalIcon: "/static/tabbar/templates-normal.png",
        activeIcon: "/static/tabbar/templates-active.png"
      },
      {
        pagePath: "/pages/works/index",
        route: "pages/works/index",
        text: "作品库",
        normalIcon: "/static/tabbar/works-normal.png",
        activeIcon: "/static/tabbar/works-active.png"
      },
      {
        pagePath: "/pages/me/index",
        route: "pages/me/index",
        text: "我的",
        normalIcon: "/static/tabbar/me-normal.png",
        activeIcon: "/static/tabbar/me-active.png"
      }
    ]
  },
  lifetimes: {
    attached() {
      this.syncSelected();
    }
  },
  pageLifetimes: {
    show() {
      this.syncSelected();
    }
  },
  methods: {
    syncSelected() {
      const pages = getCurrentPages();
      const currentPage = pages[pages.length - 1];
      const route = currentPage && currentPage.route;
      const selected = this.data.tabs.findIndex((item) => item.route === route);

      if (selected >= 0 && selected !== this.data.selected) {
        this.setData({ selected });
      }
    },
    switchTab(event) {
      const index = event.currentTarget.dataset.index;
      const item = this.data.tabs[index];

      if (!item || this.data.selected === index) return;

      wx.switchTab({
        url: item.pagePath
      });
    }
  }
});
