---
title: 路由
createTime: 2025/04/23 23:43:26
permalink: /pro/router/
---

OpenAuth.Net采用的是标准vue router来管理页面跳转，基础知识请参考[https://router.vuejs.org/zh/](https://router.vuejs.org/zh/)。如果需要添加页面，可以通过以下两种方式：

## 模块管理添加页面

直接使用【基础配置】->【模块管理】功能添加自己想访问的页面。如图：

![20211211002313](http://img.openauth.net.cn/20211211002313.png)

::: tip 提示
如果添加的url里面带有`http`，系统会自动使用iframe加载一个三方的站点，无需特殊处理。如系统自带的【接口文档】模块
:::

## 不通过模块管理添加页面


在有些场景下，不想通过系统的【模块管理】功能添加页面，如登录、注册、帮助中心、站点介绍等，可以在路由表中直接添加。
打开`src\router\modules\home.js`添加自己的路由信息：

```javascript
 {
    path: '/redirect',
    component: Layout,
    name: 'redirect',
    hidden: true,  //是否在左侧导航栏隐藏
    meta: {
      title: '外部页面',
    },
    children: [
      {
        path: 'iframe',
        hidden: true,
        name: 'iframe',
        component: IframeView,
        meta: {
          title: '外部页面',
          id: 'iframe',
        },
      },
    ],
  },

```

上面会添加一个带有layout的页面（即有顶部、左侧导航栏、面包屑等区域），如果不想使用layout，可以参考：

```javascript
{
    path: '/wmsinboundordertbls/detail/:id',
    component: DetailWmsInboundOrderTbls,
    name: 'wmsinboundordertbls',
    hidden: true,
    meta: {
      notauth: true,
          title: '入库单详情',
          noCache: true,
          icon: 'list',
    }
}
```
这种页面没有顶部、左侧导航栏、面包屑等区域，方便作为组件嵌入到其他页面中。

部分页面访问的时候，可能没有登录的用户信息，比如：用户注册页面等。会被系统的权限体系拦截从而跳转到登录页面。需要添加到白名单中。
打开`src\permission.js`,在`whiteList`中加入刚刚的路由信息：

```javascript
const whiteList = ['/regster', ...] // 不重定向白名单

```



