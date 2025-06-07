🔥.Net权限管理及快速开发框架、最好用的权限工作流系统。源于Martin Fowler企业级应用开发思想及最新技术组合（SqlSugar、EF、Quartz、AutoFac、WebAPI、Swagger、Mock、NUnit、Vue2/3、Element-ui/plus、IdentityServer等）。核心模块包括：角色授权、代码生成、API鉴权、智能打印、表单设计、工作流、定时任务等。架构易扩展，是中小企业的首选。

<p align="center">
  <img src="https://gitee.com/uploads/images/2018/0425/163228_7077c3fd_362401.png" alt="LOGO" width="300" />
</p>

**logo图标含义** OpenAuth中OA字母的结合体；整体像鱼，授人以渔；你非说像咸鱼，那也是积极向上的咸鱼；中心是个笑脸，微笑面对生活(✿◡‿◡)。

**官方网站** http://www.openauth.net.cn

**官方文档**  http://doc.openauth.net.cn 

![](https://img.shields.io/badge/release-7.0-blue)
![](https://img.shields.io/badge/SqlSugar-5.1.4-blue)
![](https://img.shields.io/badge/IdentityServer4-3.0.1-blue)
![](https://img.shields.io/badge/quartz-3.0.7-blue)
![](https://img.shields.io/badge/Autofac-5.2-blue)
![](https://img.shields.io/badge/NUnit-3.13.1-blue)
![](https://img.shields.io/badge/SwaggerUI-OAS%203.0-blue)
![](https://img.shields.io/badge/Moq-4.13-blue)
![](https://img.shields.io/badge/log4net-2.0.12-blue)

![](https://img.shields.io/badge/vue-2.6.10-brightgreen)
![](https://img.shields.io/badge/vue-3.3.4-brightgreen)
![](https://img.shields.io/badge/vite-4.4.9-brightgreen)
![](https://img.shields.io/badge/element--ui-2.10.1-brightgreen)
![](https://img.shields.io/badge/element--plus-2.3.9-brightgreen)
![](https://img.shields.io/badge/node-%3E%3D4.0-brightgreen)
![](https://img.shields.io/badge/npm-9.7.1-brightgreen)
![](https://img.shields.io/badge/layui-2.8.6-brightgreen)


主分支main默认.Net SDK 9.0.100，如果需要降低sdk版本，请参考[切换sdk版本](http://doc.openauth.net.cn/core/changesdk.html)。使用.Net Core 2.1-3.1的请点[这里](https://gitee.com/yubaolee/OpenAuth.Core) ，已停止维护

## ▶️演示直达

#### 开源版本

* 演示地址： http://demo.openauth.net.cn:1803

#### 付费订阅

* Vue3演示地址： http://demo.openauth.net.cn:1805

* 移动UniApp演示地址：http://demo.openauth.net.cn:1804 

## 📺视频教程

[OpenAuth.Net视频合集--系统结构及代码下载](https://www.bilibili.com/video/BV1Z1421q7xU/)

[OpenAuth.Net视频合集--基于RBAC体系的权限管理介绍](https://www.bilibili.com/video/BV1M9KeejENf/)

[OpenAuth.Net视频合集--企业版代码启动](https://www.bilibili.com/video/BV1KSuQebEek/)

[OpenAuth.Net视频合集--使用企业版代码生成器](https://www.bilibili.com/video/BV1JCuyeaEFp/)

[OpenAuth.Net视频合集--表单设计](https://www.bilibili.com/video/BV1dagEeFEVA/)

[OpenAuth.Net视频合集--多表代码生成](https://www.bilibili.com/video/BV1r4J3zAEsx/)


## 📸效果预览
#### 后端启动效果
![API启动效果图](https://images.gitee.com/uploads/images/2021/0422/012037_ec51b7e6_362401.png "api启动.png")

#### 开源MVC效果
![开源版本效果](snapshot/layui.jpg)

#### 开源Vue2效果
![vue2](snapshot/vue2.png)
![拖拽表单](snapshot/form.png)

#### 付费订阅效果
![主列表](snapshot/maintable.jpg)
![工作流](snapshot/image.png)
![打印方案设计](snapshot/sysprinterplan.png)

## 📞官方QQ交流群  

1. ***618473076*** **付费订阅专属QQ群，第一时间提供开发进度、技术咨询服务等，[如何加入请移步这里](http://old.openauth.net.cn/question/detail.html?id=a2be2d61-7fcb-4df8-8be2-9f296c22a89c)**

1. 484498493【已满】

1. 626433139【已满】

1. 566344079【2K大群】[![快速加群](https://img.shields.io/badge/qq%E7%BE%A4-566344079-blue.svg)](http://shang.qq.com/wpa/qunwpa?idkey=aa850ac69f1f43ab4be39ecddd6030a937e9236d95966a707fcb667491049fdc)


## 💡核心功能
项目深入参考《企业应用架构模式》《重构与模式》《ASP.NET设计模式》等巨著完成每一行代码编写。主要特性：

* 支持最新版.Net 9.0.100
  
* 同时支持EntityFramework、SqlSugar两款最流行的ORM框架

* 超强的自定义权限控制功能，请参考：[通用权限设计与实现](https://www.cnblogs.com/yubaolee/p/DataPrivilege.html)

* 完整API鉴权，可以控制角色可访问的API资源，及模块功能字段可见及是否返回，请参考：[按角色授权API资源](http://doc.openauth.net.cn/core/apiauth.html#%E6%8C%89%E8%A7%92%E8%89%B2%E6%8E%88%E6%9D%83api%E8%B5%84%E6%BA%90) 及 [字段权限](http://doc.openauth.net.cn/core/datapropertyrule/)

* 可拖拽的表单设计。详情：[可拖拽表单](http://doc.openauth.net.cn/pro/dragform/)

* 可视化流程设计。[可视化流程设计](http://doc.openauth.net.cn/pro/startflow/)  
  
* 全网最好用的打印解决方案。详情:[智能打印](http://doc.openauth.net.cn/pro/printerplan/)

* 基于Quartz.Net的定时任务控制,可随时启/停，可视化配置Cron表达式功能，请参考：[定时任务](http://doc.openauth.net.cn/core/job/)

* 零代码动态API接口，详情：[动态API](http://doc.openauth.net.cn/core/dynamicapi/)

* 自带代码生成器，可快速生成带有头/明细结构的页面

* 支持sqlserver、mysql、Oracle、PostgreSql数据库，理论上支持所有数据库

* 支持同时访问多数据源

* 支持多租户

* 支持搭建自己的IdentityServer服务器，实现基于OAuth2的登录体系，请参考：[登录认证及OAuth集成](http://doc.openauth.net.cn/core/identity/)

* 建立三方对接规范，已有系统可以无缝对接流程引擎

* MVC前端采用 layui + ztree + gooflow + leipiformdesign

* vue前端采用 vue + element-ui + vform + hiprinter

* 后端采用 .net +EF + sqlsugar + autofac + quartz +IdentityServer4 + nunit + swagger

* 设计工具 PowerDesigner +PDManer + Enterprise Architect

## 🔜后续
生命不息，更新不止