---
title: 常见问题处理
createTime: 2025/04/23 23:43:26
permalink: /pro/faq/
---

## vue3 启动时白屏

在启动vue3版本（不刷新浏览器）时，会出现白屏的现象。并且控制台报异常：

![20230529200341](http://img.openauth.net.cn/20230529200341.png)

如果直接打开URL，也会得到504错误，比如:
https://localhost:1803/app/node_modules/.vite/deps/pusher-js.js?v=601736dc

但是去掉版本信息后，又完全正常:
https://ocalhost:1803/app/node_modules/.vite/deps/pusher-js.js

这时可以使用：

```shell
npm rebuild
```
或者

```shell
node ./node_modules/esbuild/install.js
```
详细原因可以查看：[https://github.com/vitejs/vite/discussions/8146](https://github.com/vitejs/vite/discussions/8146)

## vue运行的时候报错

在启动企业版的时候，如果提示下面错误：

![](/oidcerror.png)

请使用`npm run dev`命令来启动项目

