---
title: 项目结构
createTime: 2025/05/29 23:43:26
permalink: /mobile/structure/
---

OpenAuth.Net移动版参考业界标准结构进行划分，如需二次开发，可以在对应的文件夹进行代码修改。结构如下：
```
📦openauthapp
 ┣ 📂mock           //mock数据
 ┣ 📂public        //公共资源
 ┣ 📂src
 ┃ ┣ 📂api          //与后端接口交互
 ┃ ┣ 📂assets         //样式图标等
 ┃ ┣ 📂components     //组件
 ┃ ┣ 📂directive      //指令
 ┃ ┣ 📂extensions    //原有选项式mixins扩展组件
 ┃ ┣ 📂hooks          //自定义hooks
 ┃ ┣ 📂interface      //前端类型约定
 ┃ ┣ 📂layout         //布局
 ┃ ┃ ┣ 📂components     //站点Layout组件
 ┃ ┃ ┃ ┣ 📂Content      //内容
 ┃ ┃ ┃ ┣ 📂Sidebar      //侧边栏
 ┃ ┃ ┃ ┣ 📂Tagsbar      //标签栏
 ┃ ┃ ┃ ┗ 📂Topbar       //顶部栏
 ┃ ┣ 📂lib             //外部引入的公共库
 ┃ ┣ 📂router          //路由
 ┃ ┣ 📂store          //状态管理
 ┃ ┣ 📂stores         //pinia状态管理，主题等
 ┃ ┣ 📂styles         //样式
 ┃ ┣ 📂utils          //通用工具类
 ┃ ┣ 📂views          //视图
 ┃ ┣ 📜App.vue         //主组件
 ┃ ┣ 📜default-settings.js //默认配置
 ┃ ┣ 📜error-log.js     //错误日志
 ┃ ┣ 📜global-components.js //全局组件
 ┃ ┣ 📜main.js          //主入口
 ┃ ┗ 📜permission.js   //权限
 ┣ 📜.env.dev          //开发环境配置
 ┣ 📜.env.production   //生产环境配置
 ┣ 📜.eslintignore     //eslint忽略文件
 ┣ 📜.eslintrc.js      //eslint配置
 ┣ 📜.prettierrc.js    //prettier配置
 ┣ 📜index.html        //入口文件
 ┣ 📜jsconfig.json     //js配置
 ┣ 📜package.json      //项目配置
 ┣ 📜postcss.config.js //postcss配置
 ┣ 📜README.md         //项目说明
 ┗ 📜vite.config.js    //vite配置

 ```
