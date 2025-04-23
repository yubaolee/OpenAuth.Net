---
title: vue2版本介绍
createTime: 2025/04/23 23:43:26
permalink: /vue2/
---
::: warning 注意事项
如果你使用的是vue3版本，请参考：[OpenAuth.Pro Vue3版本](/pro/)
:::

OpenAuth.Pro Vue2版本基于vue2 + element-ui。它使用开源版OpenAuth.Net的API接口（即：OpenAuth.WebApi）提供数据服务。二者的关系如下：

![系统架构](http://img.openauth.net.cn/系统架构.png)

vue2版源代码获取方式：[http://old.openauth.net.cn/question/detail.html?id=a2be2d61-7fcb-4df8-8be2-9f296c22a89c](http://old.openauth.net.cn/question/detail.html?id=a2be2d61-7fcb-4df8-8be2-9f296c22a89c)

演示地址： [http://demo.openauth.net.cn:1803/](http://demo.openauth.net.cn:1803/)

## OpenAuth.Net系列教学视频

[OpenAuth.Net视频合集--系统结构及代码下载](https://www.bilibili.com/video/BV1Z1421q7xU/)

[OpenAuth.Net视频合集--企业版代码启动](https://www.bilibili.com/video/BV1KSuQebEek/)

[OpenAuth.Net视频合集--使用企业版代码生成器](https://www.bilibili.com/video/BV1JCuyeaEFp/)

[OpenAuth.Net视频合集--权限管理介绍](https://www.bilibili.com/video/BV1M9KeejENf/)

[OpenAuth.Net视频合集--表单设计](https://www.bilibili.com/video/BV1dagEeFEVA/)


## 工具准备

#### NodeJs

前端环境为NodeJs，下载地址：[http://nodejs.cn/download/current/](http://nodejs.cn/download/current/)

#### visual studio code

下载最新版的vs code，或Cursor、Windsurf、Trae等工具用来作为OpenAuth.Pro Vue2版的开发工具。


## 创建数据库

* 使用下载的OpenAuth.Pro前端源码文件夹【sql脚本】中，运行`Sql Server脚本.sql`（或mysql脚本）

## 启动后端

启动后端请参考：[快速开始](/core/start.html)

## 启动前端

使用Vs Code（或个人喜欢的工具）打开OpenAuth.Pro/Client文件夹，如下图：

![20211214232057](http://img.openauth.net.cn/20211214232057.png)


安装程序运行所需的第三方包。使用npm install 命令经行安装，如下图：
![20211214232207](http://img.openauth.net.cn/20211214232207.png)

::: warning 注意事项
4.6.4及以后的版本默认Node 18进行编译，如果使用的是Node 18以前的版本，请尝试把package.json中scripts改为下面内容：

```javascript
"scripts": {
    "serve": "vue-cli-service serve  --mode dev",
    "dev": "vue-cli-service serve --mode dev",
    "build": "vue-cli-service build --mode prod",
    "lint": "vue-cli-service lint"
  },
```

:::

修改配置文件`.env.dev`对应的后端接口地址，调整为自己的接口地址：

```javascript
VUE_APP_BASE_API = http://localhost:52789/api
VUE_APP_BASE_IMG_URL = http://localhost:52789
```

::: warning 注意事项
如果是发布打包，调整的文件为`.env.prod`
:::

使用npm run dev 命令运行。如下图：
![20211214232229](http://img.openauth.net.cn/20211214232229.png)

启动成功后，使用浏览器访问[http://localhost:1803/](http://localhost:1803/) 即可打开企业版界面






