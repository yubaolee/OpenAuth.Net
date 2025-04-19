# Vue3代码生成器

本章节视频讲解请参考：[OpenAuth.Net视频合集--使用企业版代码生成器](https://www.bilibili.com/video/BV1JCuyeaEFp/)

## 前言

都什么年代了，还在用代码生成器？有这个想法的人，通常是拿来和低代码平台做对比。那我们就从多维度对比一下：

| 维度 | 低代码平台 | 代码生成器 |
|------|------------|------------|
| 用户群体 | 非专业开发者、业务人员、快速交付团队 | 专业开发者 |
| 技术门槛 | 无需编码能力，强调业务逻辑可视化配置 | 需理解生成代码并手动集成/调试 |
| 灵活性 | 受限于平台提供的组件和逻辑抽象能力 | 生成代码可自由修改，灵活性高 |
| 技术依赖性 | 依赖平台运行时，可能面临厂商锁定风险 | 生成代码脱离工具，技术栈自主可控 |
| 适用场景 | 快速构建标准化应用（如内部工具、MVP） | 减少重复编码，提升开发效率 |

从上面对比我们可以看出二者使用场景完全不同：

* 低代码平台：业务人员通过拖拽表单设计器、配置数据源等，直接发布到低代码平台，无需编写代码。
* 代码生成器：**自动创建Entity、Controller、Service层基础代码，开发者手动补充业务逻辑**，一旦代码生成完成，就可以脱离工具，技术自主可控。

于是就有了本节的内容。当然，OpenAuth.Net即将推出低代码平台版本，敬请期待😀


## 术语解释

在使用代码生成器添加新功能之前，需要先了解OpenAuth.Net生成代码时的两个概念：动态头部和固定头部

#### 动态头部

如果启用动态头部，表示前端渲染列表（或表单）时，列表的列定义是从后端返回。通常用于控制前端字段显示权限。配合后端：[权限控制/字段权限](http://doc.openauth.net.cn/pro/datapropertyrule.html#%E5%AD%97%E6%AE%B5%E6%9D%83%E9%99%90) 如：常见的前端代码如下：
```html
  <auth-table  ref="mainTable" :table-fields="headerList"></auth-table>
```
```javascript
getList() {
      resources.getList(this.listQuery).then((response) => {
        ...
        this.headerList = response.columnFields
        ...
      })
    },

```

#### 固定头部

如果不是上面的情况，则生成的前端列为固定的头部。如下：

```html

  <auth-table  ref="mainTable" :table-fields="headerList"></auth-table>

```
```javascript
initCfg() {
      this.headerList = [
        new ColumnDefine('id', 'id', false, false, 'text', '', 'string', 'varchar', ''),
        new ColumnDefine('tableName', '表名', true, true, 'text', '', 'string', 'varchar', ''),
        new ColumnDefine('moduleName', '模块名称', true, true, 'text', '', 'string', 'varchar', ''),
        new ColumnDefine('parentTableId', '父表', true, true, 'selectDynamic', '/BuilderTables/AllMain', 'string', 'varchar', ''),
        new ColumnDefine('foreignKey', '外键', true, true, 'text', '', 'string', 'varchar', ''),
      ]

```

## 准备工作

* 数据库OpenAuthPro中添加仓储表【Stock】，本文以该数据表为例。参考表结构如下：
```SQL
-- mysql示例
create table stock
(
    Id       varchar(50)    not null comment '数据ID'
        primary key,
    Name     text           not null comment '产品名称',
    Number   int            not null comment '产品数量',
    Price    decimal(10, 1) not null comment '产品单价',
    Status   int            not null comment '出库/入库',
    Viewable varchar(50)    not null comment '可见范围',
    User     varchar(50)    not null comment '操作人',
    Time     datetime       not null comment '操作时间',
    OrgId    varchar(50)    null comment '组织ID'
)
    comment '出入库信息表' charset = utf8
                           row_format = COMPACT;



```

* 使用Visual Studio 以开发模式启动后端。参考：[编译运行webapi](http://doc.openauth.net.cn/core/start.html#%E7%BC%96%E8%AF%91%E8%BF%90%E8%A1%8Cwebapi)

* 启动企业版前端。参考：[启动前端](http://doc.openauth.net.cn/pro/#%E5%90%AF%E5%8A%A8%E5%89%8D%E7%AB%AF)

后续操作全部在系统中完成。

## 单表添加

代码生成界面，点击`添加`按钮，输入想添加的模块信息。
![2021923224934](http://img.openauth.net.cn/2021923224934.png)

录入基础信息，点击`确认`保存后，系统会添加一条记录，并自动加载对应的字段信息。

![2021923225040](http://img.openauth.net.cn/2021923225040.png)

这时，编辑字段具体的属性。如是否【可显示】【可编辑】等。


## 子表添加

::: warning 注意
如果只生成单表结构，可以跳过本节
:::

如果需要添加主/从（父/子）结构，需要先添加子表信息。代码生成界面，点击`添加`按钮，输入想添加的模块信息。

![20211208001551](http://img.openauth.net.cn/20211208001551.png)

::: warning 注意
子表的`动态头部`属性务必与父表保持一致，否则会造成生成的代码不能正常运行
:::

## 生成模块

选中刚刚添加的`Stock`表，依次点击【生成实体】【生成业务代码】【生成vue页面】;

如果存在子表，也进行相同的操作。即选中刚刚添加的`StockDetail`表，依次点击【生成实体】【生成业务代码】【生成vue页面】;

成功后生成的后端.Net代码位置如下：

OpenAuth.Repository\Domain\Stock.cs
OpenAuth.App\StockApp\StockApp.cs
OpenAuth.App\StockApp\Request\AddOrUpdateStockReq.cs
OpenAuth.App\StockApp\Request\QueryStockListReq.cs
OpenAuth.WebApi\Controllers\StocksController.cs

并且会在OpenAuth.Repository\OpenAuthDBContext.cs中自动添加：

```
 public virtual DbSet<Stock> Stocks { get; set; }
```


前端Vue代码：
src\api\stocks.js
src\views\stocks\index.vue

::: warning 注意
完成以上步骤后，请重启OpenAuth.WebApi，用来重新加载刚刚生成的后台代码

子表不需要添加模块
:::

## 配置模块地址

经过以上步骤，重启系统后，使用System账号重新登录，在【模块管理】中，添加"仓储管理"模块，如下图：

![20211207003212](http://img.openauth.net.cn/20211207003212.png)

这样就可以访问刚刚新加的仓储管理功能，到此就完成了添加一个新模块功能：

![20211208011431](http://img.openauth.net.cn/20211208011431.png)

## 代码生成功能字段详解

* 模块名称：表示这个生成的模块名称，根据自己需要填写。

* 表名：**必填** 表示数据库中对应的表名。

* 父表：表示主/从（父/子）表的父表。如果该项不选，则生成的是单表结构的代码，如果选择了父表，则生成主/从（父/子）表的代码。

* 外键：表示与父表关联的外键。如果选择了父表，则该项必填。

* 外部数据源：如果需要连接其他数据库生成代码，需要选对应的外部数据源，外部数据源在【数据源管理】功能中配置。

* 动态头部：如果选中，表示前端渲染列表（或表单）时，列表的列定义是从后端返回。通常用于控制前端字段显示权限。

* 实体类名称：**必填** 表示生成的实体类名称。

* 命名空间：**必填** 表示生成的实体类的命名空间。默认`OpenAuth.Repository.Domain`。

* 模块编码：**必填** 表示生成的模块业务类名称，比如`XxxxxApp`。

* Vue目录: 生成vue代码时，代码存放的目录。比如`D:\openauthvue3`。

## 其他

当采用动态头部时，如果数据库新加了字段，需要使用【同步结构】功能把新字段同步到代码生成器中。为了防止对已有的配置造成影响，该功能只新增字段，不会对已有字段进行调整。





