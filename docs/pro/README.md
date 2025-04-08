::: warning 注意事项
如何你使用的是vue2版本，请参考：[OpenAuth.Pro Vue2版本](/vue2/)
:::

OpenAuth.Pro Vue3版本基于vue3 + element-plus。它使用开源版OpenAuth.Net的API接口（即：OpenAuth.WebApi）提供数据服务。二者的关系如下：

![系统架构](http://img.openauth.net.cn/系统架构.png)

vue3版源代码获取方式：[http://old.openauth.net.cn/question/detail.html?id=a2be2d61-7fcb-4df8-8be2-9f296c22a89c](http://old.openauth.net.cn/question/detail.html?id=a2be2d61-7fcb-4df8-8be2-9f296c22a89c)

演示地址： [http://demo.openauth.net.cn:1805/](http://demo.openauth.net.cn:1805/)

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

下载最新版的vs code，或Cursor、Windsurf、Trae等工具用来作为OpenAuth.Pro Vue3版的开发工具。

## 源码下载

根据授权文件的下载指示，下载Vue3源码。注意：一定要使用下图中的数据库脚本：

![2025-04-08-20-53-49](http://img.openauth.net.cn/2025-04-08-20-53-49.png)

## 创建数据库

* 新建一个空数据库：OpenAuthPro。使用上一步下载的【sql脚本】文件夹，根据你的数据库类型，选择运行你需要的脚本：`Sql Server脚本.sql`或`mysql脚本.sql`

## 启动后端

启动后端请参考：[快速开始](/core/start.html)

## 启动前端

使用Vs Code（或个人喜欢的工具）打开openauthvue3文件夹，修改配置文件`.env.dev`对应的后端接口地址，调整为自己的接口地址：

```javascript
VITE_BASE_API = http://localhost:52789/api
VITE_BASE_IMG_URL = http://localhost:52789
```

::: warning 注意事项
如果是发布打包，调整的文件为`.env.production`
:::

使用`npm install`命令安装程序运行所需的第三方包。再用`npm run dev`命令运行。如下图：

![2025-04-08-20-57-34](http://img.openauth.net.cn/2025-04-08-20-57-34.png)

启动成功后，使用浏览器访问[http://localhost:1803/](http://localhost:1803/) 即可打开vue3版界面：

![2025-04-08-21-03-19](http://img.openauth.net.cn/2025-04-08-21-03-19.png)






