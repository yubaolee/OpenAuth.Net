---
title: 后端开发规范
createTime: 2025/04/23 21:03:10
permalink: /core/specialist/
---

## 新增功能文件结构

如果新增功能时，尽量按框架原有文件结构。比如新增仓库功能，实体名Stock，则：
::: file-tree
- OpenAuth.WebApi
    - Controllers
        - StocksController.cs  // WebApi控制器
- OpenAuth.App
    - StockApp.cs  // 应用层
    - Request
        - QueryStockReq.cs  // 请求参数
- OpenAuth.Repository
    - OpenAuthDBContext.cs  // EF数据库上下文
    - Domain
        - Stock.cs  // 实体
:::

## 数据库表及字段命名

SqlServer采用PascalCase命名，Oracle采用全大写命名，其他数据库采用camelCase命名。

::: tip 提示

开源版代码生成时，通过表结尾Dtbl来判断是否是生成明细表代码。因此建议数据库表命名时按：子系统名称+业务名称+表尾，其中表尾名称规则：
- 基础主数据以Mst结尾；
- 普通业务表以Tbl结尾；
- 业务明细表以Dtbl结尾；
如：WMS系统入库订单明细表：WmsInboundOrderDtbl
:::


## 数据库字段类型

### SqlServer

* 主键统一命名为Id,类型为Domain:PrimaryKey，方便统一修改主键类型。

* 状态类,标识类的字段，统一使用bit not null

* 表示分类的字段，统一使用PrimaryKey，数值从Category中获取

### Mysql

* 主键统一命名为id，类型varchar(50)

* 状态类,标识类的字段，统一使用tinyint(4) NOT NULL

### Oracle

* 主键统一命名为ID，类型为varchar2(50)

* 状态类,标识类的字段，统一使用NUMBER(4,0) NOT NULL



## 代码注释

所有的实体属性都会有2个注释:

* summary: 用于编写代码时，IDE提示

* Description: 用于Swagger接口文档

```csharp
    /// <summary>
	/// 应用
	/// </summary>
    [Table("Application")]
    public partial class Application : StringEntity
    {
        /// <summary>
	    /// 应用名称
	    /// </summary>
         [Description("应用名称")]
        public string Name { get; set; }
    }
```



