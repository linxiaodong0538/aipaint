Component({
  data: {
    selected: 0,
    tabs: [
      {
        pagePath: "/pages/index/index",
        text: "Home",
        normalIcon: "/static/tabbar/home-normal.svg",
        activeIcon: "/static/tabbar/home-active.svg"
      },
      {
        pagePath: "/pages/templates/index",
        text: "Templates",
        normalIcon: "/static/tabbar/templates-normal.svg",
        activeIcon: "/static/tabbar/templates-active.svg"
      },
      {
        pagePath: "/pages/works/index",
        text: "Works",
        normalIcon: "/static/tabbar/works-normal.svg",
        activeIcon: "/static/tabbar/works-active.svg"
      },
      {
        pagePath: "/pages/me/index",
        text: "Me",
        normalIcon: "/static/tabbar/me-normal.svg",
        activeIcon: "/static/tabbar/me-active.svg"
      }
    ]
  },
  methods: {
    switchTab(event) {
      const index = event.currentTarget.dataset.index;
      const item = this.data.tabs[index];

      if (!item || this.data.selected === index) return;

      this.setData({
        selected: index
      });

      wx.switchTab({
        url: item.pagePath
      });
    }
  }
});
