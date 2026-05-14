Component({
  data: {
    selected: 0,
    tabs: [
      {
        pagePath: "/pages/index/index",
        text: "首页",
        normalIcon: "/static/tabbar/home-normal.png",
        activeIcon: "/static/tabbar/home-active.png"
      },
      {
        pagePath: "/pages/templates/index",
        text: "模板",
        normalIcon: "/static/tabbar/templates-normal.png",
        activeIcon: "/static/tabbar/templates-active.png"
      },
      {
        pagePath: "/pages/works/index",
        text: "作品库",
        normalIcon: "/static/tabbar/works-normal.png",
        activeIcon: "/static/tabbar/works-active.png"
      },
      {
        pagePath: "/pages/me/index",
        text: "我的",
        normalIcon: "/static/tabbar/me-normal.png",
        activeIcon: "/static/tabbar/me-active.png"
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
