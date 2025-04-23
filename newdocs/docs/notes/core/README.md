---
title: 框架简介
createTime: 2025/04/20 21:49:49
permalink: /core/
---
![LOGO](/logocore.png "1.png")

OpenAuth.Net是基于最新版.Net的开源权限工作流快速开发框架。源于Martin Fowler企业级应用开发思想及最新技术组合（SqlSugar、EF、Quartz、AutoFac、WebAPI、Swagger、Mock、NUnit、Vue2/3、Element-ui/plus、IdentityServer等）。核心模块包括：角色授权、代码生成、API鉴权、智能打印、表单设计、工作流、定时任务等。

开源版本演示：[http://demo.openauth.net.cn:1802/](http://demo.openauth.net.cn:1802/)

如果你想了解企业版的内容，请访问：[http://doc.openauth.net.cn/pro](http://doc.openauth.net.cn/pro/)

::: tip 提示

gitee上面两个版本。其中：

* [OpenAuth.Net](https://gitee.com/dotnetchina/OpenAuth.Net) 默认SDK版本为.Net 9.0.100，如果需要切换到.Net其他版本请参考：[切换sdk版本](http://doc.openauth.net.cn/core/changesdk.html)

* [OpenAuth.Core](https://gitee.com/yubaolee/OpenAuth.Core) 的SDK版本为.Net Core 3.1.100，已停止维护，不推荐使用。

.Net目前SDK升级特别方便。请参考：[3分钟的时间把.net core 3.1的升级到.NET 5](https://www.cnblogs.com/yubaolee/p/Net3ToNet5.html)，所以不要纠结SDK版本问题。
:::

## 核心看点

* 支持最新版.Net 9.0.100
  
* 同时支持EntityFramework、SqlSugar两款最流行的ORM框架

* 超强的自定义权限控制功能，请参考：[通用权限设计与实现](https://www.cnblogs.com/yubaolee/p/DataPrivilege.html)

* 完整API鉴权，可以控制角色可访问的API资源，及模块功能字段可见及是否返回，请参考：[按角色授权API资源](http://doc.openauth.net.cn/core/apiauth.html#%E6%8C%89%E8%A7%92%E8%89%B2%E6%8E%88%E6%9D%83api%E8%B5%84%E6%BA%90) 及 [字段权限](http://doc.openauth.net.cn/core/datapropertyrule.html)

* 可拖拽的表单设计。详情：[可拖拽表单](http://doc.openauth.net.cn/pro/dragform.html)

* 可视化流程设计。[可视化流程设计](http://doc.openauth.net.cn/pro/startflow.html)  
  
* 全网最好用的打印解决方案。详情:[智能打印](http://doc.openauth.net.cn/pro/printerplan.html)

* 基于Quartz.Net的定时任务控制,可随时启/停，可视化配置Cron表达式功能，请参考：[定时任务](http://doc.openauth.net.cn/core/job.html)

* 基于CodeSmith的代码生成功能，可快速生成带有头/明细结构的页面

* 支持sqlserver、mysql、Oracle、PostgreSql数据库，理论上支持所有数据库

* 支持同时访问多数据源

* 支持多租户

* 支持搭建自己的IdentityServer服务器，实现基于OAuth2的登录体系，请参考：[登录认证及OAuth集成](http://doc.openauth.net.cn/core/identity.html)

* 建立三方对接规范，已有系统可以无缝对接流程引擎

* 前端采用 vue + layui + element-ui + ztree + gooflow + leipiformdesign

* 后端采用 .net +EF + sqlsugar + autofac + quartz +IdentityServer4 + nunit + swagger

* 设计工具 PowerDesigner +PDManer + Enterprise Architect