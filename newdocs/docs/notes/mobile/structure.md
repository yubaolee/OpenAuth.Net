---
title: 项目结构
createTime: 2025/05/29 23:43:26
permalink: /mobile/structure/
---

OpenAuth.Net移动版参考业界标准结构进行划分，如需二次开发，可以在对应的文件夹进行代码修改。结构如下：

::: file-tree

- openauthapp
    - .cursorignore cursor codebase 忽略文件
    - api                     接口
        - login.js        
    - components              组件
        - CreatedFlow
        - SelectRoles
        - SelectUsersCom
    - pages                 页面
        - login
            - index.vue
        - user
            - profile.vue
    - static                静态文件
        - empty-icon.svg
        - logo.png
    - unpackage             打包文件
    - utils                 工具函数
        - common.js
        - request.js
    - App.vue               主组件
    - index.html            入口文件
    - main.js               主文件
    - manifest.json         配置文件
    - pages.json            页面配置文件
    - uni.scss              样式文件
:::
