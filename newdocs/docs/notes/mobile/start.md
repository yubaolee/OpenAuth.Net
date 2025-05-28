---
title: 快速开始
createTime: 2025/05/29 23:43:26
permalink: /mobile/start/
---
## 工具准备
#### HBuilderX
下载最新版的HBuilderX最新版（可以下载Cursor、Windsurf、Trae等工具配合开发效果更佳），用来作为OpenAuth.Net移动版的开发工具。
## 源码下载
根据授权文件的下载指示，下载移动版源码。
![2025-04-08-20-53-49](http://img.openauth.net.cn/2025-04-08-20-53-49.png)
## 创建数据库
* 新建一个空数据库：OpenAuthPro。使用上一步下载的【sql脚本】文件夹，根据你的数据库类型，选择运行你需要的脚本：`Sql Server脚本.sql`或`mysql脚本.sql`
## 启动后端
启动后端请参考：[快速开始](/core/start/)
## 启动前端
使用HBuilderX打开openauthapp文件夹，修改配置文件`config.js`对应的后端接口地址，调整为自己的接口地址：
```javascript
VITE_BASE_API = http://localhost:52789/api
```


启动成功后，使用浏览器访问[http://localhost:5173/](http://localhost:5173/) 即可打开UniApp版界面：

![2025-05-29-00-24-46](http://img.openauth.net.cn/2025-05-29-00-24-46.png)