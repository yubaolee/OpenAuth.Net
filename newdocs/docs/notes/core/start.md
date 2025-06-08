---
title: 快速开始
createTime: 2025/04/23 21:03:10
permalink: /core/start/
---

## 下载代码

OpenAuth.Net源码可以从[https://gitee.com/dotnetchina/OpenAuth.Net](https://gitee.com/dotnetchina/OpenAuth.Net) 下载。下载完成后可以看到文件夹结构如下：

```
📦OpenAuth.Net
 ┣ 📂.cursor              //cursor rules、MCP配置
 ┣ 📂newdocs              //文档
 ┣ 📂Infrastructure       //基础工具类
 ┣ 📂OpenAuth.Repository  //数据库访问相关代码      
 ┣ 📂OpenAuth.App         //应用逻辑代码
 ┣ 📂OpenAuth.Identity    //IdentityServer4服务器，提供OAuth服务
 ┣ 📂OpenAuth.WebApi      //WebApi接口站点
 ┣ 📂Vue2                 //开源Vue2前端项目
 ┣ 📂数据库脚本           //数据库脚本
 ┣ 📜.gitattributes
 ┣ 📜.gitignore
 ┣ 📜LICENSE
 ┣ 📜.cursorignore       //cursor codebase index忽略文件
 ┣ 📜Dockerfile          //docker文件
 ┣ 📜OpenAuth.Net.sln    //解决方案
 ┗ 📜README.md
```

其中调用关系为：

@startuml
hide footbox
skinparam handwritten true


actor 用户
boundary vue2
control XXController
entity OpenAuth.App
entity OpenAuth.Repository
database OpenAuthDB
participant vue2
box "OpenAuth.WebApi" #LightBlue
	
	participant XXController
end box
participant OpenAuth.App
participant OpenAuth.Repository
participant OpenAuthDB 

用户 -> vue2 : 用户浏览页面
vue2 -> XXController : 前端通过ajax调用数据
XXController -> OpenAuth.App : 调用逻辑层
OpenAuth.App -> OpenAuth.Repository : 逻辑层调用仓储进行数据读写
OpenAuth.Repository -> OpenAuthDB : 仓储层进行数据库操作

@enduml

## 安装sdk

OpenAuth.Net目前默认SDK版本为.Net 9.0.100，如果需要切换到.Net其他版本请参考：[切换sdk版本](http://doc.openauth.net.cn/core/changesdk/)。可以到[微软官方](https://dotnet.microsoft.com/download)下载安装。


## 初始化数据库

使用数据库脚本`SqlServer脚本`或`mysql脚本` 文件夹里面的结构脚本和数据脚本初始化数据库

## 打开项目

使用Visual Studio 2022或Rider打开 `OpenAuth.Net.sln`
::: tip 提示
如果开发使用的电脑安装有多个版本的SDK，可以在根目录新建一个`global.json`文件来指定.net版本，文件内容如下：

```
{
  "sdk": {
    "version": "9.0.100"
  }
}
```

:::


## 修改配置

在 `ASP.NET Core` 应用程序启动时默认加载`appsettings.json`作为应用配置。同时还支持不同的运行环境加载对应的配置文件，如：

- 开发环境Development对应 `appsettings.Development.json`

- 部署环境Production对应 `appsettings.Production.json`

::: tip 提示

- 很多用户部署后提示连接数据库失败，很大原因就是没有修改`appsettings.Production.json`里面连接字符串

- 有些用户找不到`appsettings.Production.json`在哪？visual studio中点击`appsettings.json`左边的三角标识即可看到

:::

#### 修改单数据库连接字符串

* 修改OpenAuth.WebApi/appsettings.json连接字符串，如下：
```json
  "ConnectionStrings": {
    "OpenAuthDBContext": "Data Source=.;Initial Catalog=OpenAuthPro;User=sa;Password=000000"
  },
  "AppSetting": {
    "DbTypes": {
        "OpenAuthDBContext":"SqlServer" //数据库类型：SqlServer、MySql、Oracle
    }
```

#### 修改多数据库连接字符串

```json
  "ConnectionStrings": {
    "OpenAuthDBContext": "Data Source=.;Initial Catalog=OpenAuthPro;User=sa;Password=000000"
    "OpenAuthDBContext2": "DATA SOURCE=192.168.0.118:1521/YUBAO;PASSWORD=000000;Validate Connection=true;PERSIST SECURITY INFO=True;USER ID=yubaolee;" //racle
    "OpenAuthDBContext3": "server=127.0.0.1;user id=root;database=openauthpro;password=000000" //my sql
  },
  "AppSetting": {
    "DbTypes": {
        "OpenAuthDBContext":"SqlServer" //数据库类型：SqlServer、MySql、Oracle
       ,"OpenAuthDBContext2":"Oracle"
       ,"OpenAuthDBContext3":"MySql"
    }, 
```

## 编译运行WebApi

使用visualstudio生成解决方案。
`注：首次启动时，visual studio会启动nuget还原第三方依赖包，请保持网络通畅，并等待一段时间`

启动openauth.webapi项目。

![20220102000528](http://img.openauth.net.cn/20220102000528.png)

启动成功后使用浏览器打开[http://localhost:52789/swagger/index.html](http://localhost:52789/swagger/index.html) 即可访问，如下图所示：

![20220101233542](http://img.openauth.net.cn/20220101233542.png)


