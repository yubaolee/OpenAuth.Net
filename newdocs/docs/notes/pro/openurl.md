---
title: 打开指定URL
createTime: 2025/04/23 23:43:26
permalink: /pro/openurl/
---

上一章节通过添加模块或直接在路由表中添加固定路由实现路由控制。在有些场景下，需要代码中直接打开一个外部指定URL的地址（不通过系统的【模块管理】功能添加到导航栏），如下图：

![2025-04-10-10-34-19](http://img.openauth.net.cn/2025-04-10-10-34-19.png)

可以直接使用下面代码实现：

```javascript
const openUrl = () => {
  const routes = router.getRoutes()
    routes.forEach(route => {
      if (route.path === '/redirect/iframe') {
        route.meta.title = 'OpenAuth.Net官网'  // 设置标题
      }
    })
  router.push({
      path: '/redirect/iframe', 
      query: { 
        url: encodeURIComponent(`http://www.openauth.net.cn`)  // 设置URL
      }
    })
}
```





