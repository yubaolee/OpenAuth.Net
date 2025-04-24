---
title: MVC前端
createTime: 2025/04/23 21:03:10
permalink: /core/wwwarchitect/
---

OpenAuth.Mvc前端采用经典mvc结构，如图：

::: file-tree
- OpenAuth.Mvc
    - Views  // MVC的视图文件
        - _ViewStart.cshtml
        - Error
            - Auth.cshtml
        - FlowSchemes
            - Design.cshtml
            - Index.cshtml
            - NodeInfo.cshtml
            - Preview.cshtml
        - Home
            - git.cshtml
            - Index.cshtml
            - Main.cshtml
        - Login
            - Index.cshtml
    - wwwroot
        - css  // 通用的css样式
            - login.css
            - main.css
            - treetable.css
        - js  // 通用的js组件
            - cookie.js
            - droptree.js
            - dtree.js
            - index.js
            - leftNav.js
            - openauth.js
            - utils.js
            - vue.js
            - ztree.js
        - userJs   // 业务相关的js代码
            - assignModule.js
            - assignResource.js
            - assignRole.js
            - changePwd.js
            - flowinstanceDetail.js
            - forms.js
            - login.js
            
:::


* Views: 为静态资源页面，最终会渲染成html（实在不懂，百度Asp.Net Mvc中的View）；

* wwwroot/js: 通用的js组件；

* wwwroot/userJs: 业务相关的js代码。通常一个csthml页面对应一个userJs中的js文件。如`Categories\Index.cshtml`对应`userJs\categories.js`