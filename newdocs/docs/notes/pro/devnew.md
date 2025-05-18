---
title: 单表代码生成
createTime: 2025/04/23 23:43:26
permalink: /pro/devnew/
---

本章节视频讲解请参考：[OpenAuth.Net视频合集--使用企业版代码生成器](https://www.bilibili.com/video/BV1JCuyeaEFp/)

## 前言

都什么年代了，还在用代码生成器？有这个想法的人，通常是拿来和低代码平台做对比。那我们就从多维度对比一下：

| 维度 | 低代码平台 | 代码生成器 |
|------|------------|------------|
| 用户群体 | 非专业开发者、业务人员、快速交付团队 | 专业开发者 |
| 技术门槛 | 无需编码能力，强调业务逻辑可视化配置 | 需理解生成代码并手动集成/调试 |
| 灵活性 | 受限于平台提供的组件和逻辑抽象能力 | 生成代码可自由修改，灵活性高 |
| 技术依赖性 | 依赖平台运行时，可能面临厂商锁定风险 | 生成代码脱离工具，技术栈自主可控 |
| 适用场景 | 快速构建标准化应用（如简单报表、问卷调查、信息登记等） | 减少重复编码，提升开发效率 |

从上面对比我们可以看出二者使用场景完全不同：

* 低代码平台：业务人员通过拖拽表单设计器、配置数据源等，直接发布到低代码平台，无需编写代码。
* 代码生成器：**自动创建Entity、Controller、Service层基础代码，开发者手动补充业务逻辑**，一旦代码生成完成，就可以脱离工具，技术自主可控。

于是就有了本节的内容。当然，OpenAuth.Net即将推出低代码平台版本，敬请期待😀


## 术语解释

在使用代码生成器添加新功能之前，需要先了解OpenAuth.Net生成代码时的两个概念：动态头部和固定头部

#### 动态头部

如果启用动态头部，表示前端渲染列表（或表单）时，列表的列定义是从后端返回。通常用于控制前端字段显示权限。配合后端：[权限控制/字段权限](http://doc.openauth.net.cn/pro/datapropertyrule/#%E5%AD%97%E6%AE%B5%E6%9D%83%E9%99%90) 如：常见的前端代码如下：
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

代码生成的时候，按配置生成前端表头，一旦生成完毕，后台就无法通过授权等方式来控制显示的文字等。如下：

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

只能通过修改前端代码或使用[列设置](/pro/columnsetting/)组件来修改。

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

* 使用Visual Studio 以开发模式启动后端。参考：[编译运行webapi](http://doc.openauth.net.cn/core/start/#%E7%BC%96%E8%AF%91%E8%BF%90%E8%A1%8Cwebapi)

* 启动企业版前端。参考：[启动前端](http://doc.openauth.net.cn/pro/#%E5%90%AF%E5%8A%A8%E5%89%8D%E7%AB%AF)

后续操作全部在系统中完成。

## 单表添加

代码生成界面，点击`添加`按钮，输入想添加的模块信息。
![2021923224934](http://img.openauth.net.cn/2021923224934.png)

录入基础信息，点击`确认`保存后，系统会添加一条记录，并自动加载对应的字段信息。

![2021923225040](http://img.openauth.net.cn/2021923225040.png)

这时，编辑字段具体的属性。如是否【可显示】【可编辑】等。

## 生成模块

选中刚刚添加的`Stock`表，依次点击【生成实体】【生成业务代码】【生成vue页面】;

成功后生成的后端.Net代码位置如下：

OpenAuth.Repository\Domain\Stock.cs
OpenAuth.App\StockApp\StockApp.cs
OpenAuth.App\StockApp\Request\AddOrUpdateStockReq.cs
OpenAuth.App\StockApp\Request\QueryStockListReq.cs
OpenAuth.WebApi\Controllers\StocksController.cs

::: warning 注意
以前代码生成器生成基于EF的代码时，会在OpenAuth.Repository\OpenAuthDBContext.cs中自动添加：
```
 public virtual DbSet<Stock> Stocks { get; set; }
```
现在基于SqlSugar的代码生成器，已不需要。如果有其他开发方面需要，可自行手动添加。
:::


前端Vue代码：
src\api\stocks.js
src\views\stocks\index.vue

::: warning 注意
1. 完成以上步骤后，请重启OpenAuth.WebApi，用来重新加载刚刚生成的后台代码

2. 代码生成器生成的应用层XxxxApp.cs里面的编辑功能，只修改部分属性，且按帕斯卡命名。需要根据业务需要调整要编辑的字段。如：
```csharp
 public void Update(AddOrUpdateChildtableReq obj)
    {
        var user = _auth.GetCurrentUser().User;
        Repository.Update(u => new Childtable
        {
            //todo: 根据业务需要调整字段
            Updatetime = DateTime.Now,
            Updateuserid = user.Id,
            Updateusername = user.Name
        },u => u.Id == obj.Id);

    }
```
:::

## 配置模块地址

经过以上步骤，重启系统后，使用System账号重新登录，在【模块管理】中，添加"仓储管理"模块，如下图：

![20211207003212](http://img.openauth.net.cn/20211207003212.png)

这样就可以访问刚刚新加的仓储管理功能，到此就完成了添加一个新模块功能：

![20211208011431](http://img.openauth.net.cn/20211208011431.png)

尝试增加一条记录，看看模块是否能正常运行。

## 代码生成功能字段详解

* 模块名称：**必填** 表示这个生成的模块名称，根据自己需要填写。

* 模块编码：**必填** 表示生成的模块业务类名称，比如`XxxxxApp`。

* 命名空间：**必填** 表示生成的实体类的命名空间。默认`OpenAuth.Repository.Domain`。

* 表名：**必填** 表示数据库中对应的表名。

* 实体类名称：**必填** 表示生成的实体类名称。

* 父表：表示主/从表的父表。如果选择了父表，则当前表为子表，与对应的父表自动形成主/从关系。

* 外键：表示与父表关联的外键。如果选择了父表，则该项必填。

* 外部数据源：如果需要连接其他数据库生成代码，需要选对应的外部数据源，外部数据源在【数据源管理】功能中配置。

* 动态头部：如果选中，表示前端渲染列表（或表单）时，列表的列定义是从后端返回。通常用于控制前端字段显示权限。

* Vue目录: 生成vue代码时，代码存放的目录，一般是vue项目的根目录。比如`D:\openauthvue3`。


## 生成逻辑详解

::: warning 注意
如果不想了解我们代码生成器生成代码的逻辑，可以跳过以下内容。
:::

如果你觉得框架自带的代码生成器没达到你想要的效果，可以自行修改。以下是代码生成器逻辑概述：

当您在代码生成界面选中一个或多个表，并依次点击【生成实体】、【生成业务代码】、【生成vue页面】（及Vue API）时，系统会执行一系列后端操作来创建所需的代码文件。以下是这些操作的详细解析：

### 1. 生成实体

点击【生成实体】后，系统将为选中的数据库表创建对应的C#实体类。

*   **核心方法**: `BuilderTableApp.CreateEntity(CreateEntityReq req)`
*   **主要流程**:
    1.  **数据准备**: 根据请求中的ID加载表定义信息 (`BuilderTable`) 和所有字段定义信息 (`BuilderTableColumn`)。
    2.  **重复性检查**: 调用 `CheckExistsModule` 方法，通过反射检查项目中是否已存在同名或已映射到同名数据库表的实体类，防止重复创建。
    3.  **模型创建 (`CreateEntityModel`)**:
        *   **模板**: 固定使用 `Template\BuildEntity.html`。
        *   **基类选择**:
            *   根据主键的数据库类型 (`ColumnType`) 和是否自增 (`IsIncrement`)，实体类会继承自：
                *   `IntAutoGenEntity`: 若主键为数字类型 (如 `decimal`, `numeric`) 且自增。
                *   `LongEntity`: 若主键为数字类型 (如 `decimal`, `numeric`) 但不自增 (通常用于雪花ID)。
                *   `StringEntity`: 若主键为字符串等其他类型。
        *   **属性生成**:
            *   遍历表中的每个字段（主键除外）。
            *   为字段添加 `/// <summary>` XML注释（源自字段备注）和 `[Description("字段备注")]` 特性。
            *   根据字段是否允许为空 (`IsRequired`) 和其数据类型 (`EntityType`)，正确生成属性类型（例如，值类型若允许为空，则变为可空类型，如 `int?`）。
            *   生成 `public {字段类型} {字段名} { get; set; }`。
        *   **构造函数初始化**:
            *   在实体类的构造函数中，为每个非主键属性赋予初始值 (例如 `string` 类型初始化为 `""`，`DateTime` 初始化为 `DateTime.Now`，`bool` 初始化为 `false` 等)。
        *   **表注解**:
            *   为实体类添加 `/// <summary>` XML注释（源自表备注）。
            *   添加 `[Table("实际数据库表名")]` 特性，将实体类映射到数据库表。
        *   **文件输出**: 生成的实体类代码最终会写入到 `OpenAuth.Repository\Domain\{实体类名}.cs` 文件。

### 2. 生成业务代码

点击【生成业务代码】后，系统会创建应用服务层（App）、相关的请求对象（Request DTOs）以及WebAPI控制器（Controller）。

*   **核心方法**: `BuilderTableApp.CreateBusiness(CreateBusiReq req)`
*   **主要流程**: 此方法会依次调用以下三个内部方法：

    *   **A. `GenerateApp` (生成应用服务类)**
        1.  **路径与检查**: 定位 `.App` 项目路径，并检查模块代码 (`ModuleCode`) 是否已存在。
        2.  **模板选择**:
            *   **主从表判断**: 根据当前表是否有子表 (`ParentTableId`)，区分为单表或主从表生成逻辑。
            *   **动态/固定头部**: 根据表配置的 `IsDynamicHeader` 属性，选择对应的模板。
                *   单表动态头部: `Template\SingleTable\BuildAppWithDynamicHeader.html`
                *   单表固定头部: `Template\SingleTable\BuildApp.html`
                *   主从表动态头部: `Template\MultiTable\BuildAppWithDynamicHeader.html`
                *   主从表固定头部: `Template\MultiTable\BuildApp.html`
        3.  **基类选择**:
            *   应用服务类的基类根据主键类型决定：
                *   `BaseIntAutoGenApp`: 对应 `IntAutoGenEntity`。
                *   `BaseLongApp`: 对应 `LongEntity`。
                *   `BaseStringApp`: 对应 `StringEntity`。
        4.  **代码生成**:
            *   替换模板中的占位符，如 `{ClassName}` (实体类名), `{ModuleCode}` (模块代码), `{ModuleName}` (模块名), `{StartName}` (通常为项目主命名空间前缀如 `OpenAuth`)。
            *   **外键处理**: 如果当前生成的是子表的App服务，会在查询列表中自动加入基于其外键 (`ForeignKey`) 的过滤条件。
            *   **主从表逻辑**: 如果是主表且有关联子表，模板中会包含对子表操作的逻辑，并替换子表相关占位符如 `{SubClassName}`, `{SubForeignKey}`。
        5.  **文件输出**: 生成的应用服务类写入到 `OpenAuth.App\{ModuleCode}\{ModuleCode}.cs`。

    *   **B. `GenerateAppReq` (生成请求DTO)**
        1.  **路径**: 定位 `.App` 项目路径。
        2.  **查询请求对象 (`Query{ClassName}ListReq.cs`)**:
            *   模板: `Template\BuildQueryReq.html`。
            *   内容: 主要包含分页、排序、关键词查询等基础参数。如果当前表是子表，还会自动添加其外键字段作为查询参数。
            *   文件输出: `OpenAuth.App\{ModuleCode}\Request\Query{ClassName}ListReq.cs`。
        3.  **添加/更新请求对象 (`AddOrUpdate{ClassName}Req.cs`)**:
            *   模板: `Template\BuildUpdateReq.html`。
            *   内容:
                *   包含表中所有可编辑字段对应的属性，每个属性都有XML注释。
                *   如果当前是主表且有关联子表，会自动添加一个子表请求对象列表属性，如 `public List<AddOrUpdate{SubClassName}Req> {SubClassName}Reqs { get; set; }`，用于一次性提交主从数据。
            *   文件输出: `OpenAuth.App\{ModuleCode}\Request\AddOrUpdate{ClassName}Req.cs`。

    *   **C. `GenerateWebApi` (生成控制器)**
        1.  **路径与检查**: 定位 `.WebApi` 项目路径，控制器名称通常为 `{ClassName}sController` (如 `StocksController`)，并检查是否已存在。
        2.  **模板**: `Template\BuildControllerApi.html`。
        3.  **主键类型处理**: 控制器中的 `Get(id)`、`Update(id, req)` 等接口的 `id` 参数类型，会根据实体主键的实际类型（`int`, `long`/`decimal`, `string`）进行适配。
        4.  **代码生成**: 替换模板占位符，注入对应的App服务。
        5.  **文件输出**: 生成的控制器写入到 `OpenAuth.WebApi\Controllers\{ClassName}sController.cs`。

### 3. 生成Vue页面与API脚本

点击【生成vue页面】后，系统不仅会为选中的主表创建Vue视图文件，还会为其（以及其子表，如果存在）生成前端调用API的JavaScript文件。

*   **核心方法 (Vue视图)**: `BuilderTableApp.CreateVue(CreateVueReq req)`
*   **核心方法 (Vue API脚本)**: `BuilderTableApp.CreateVueApi(CreateVueReq req)`

*   **A. `CreateVue` (生成 `.vue` 文件)**:
    1.  **路径校验**: 确保提供了Vue项目的根目录 (`req.VueProjRootPath`)。
    2.  **子表跳过**: 如果当前选中的表是子表（即 `ParentTableId` 不为空），则不生成独立的Vue页面，因为子表通常在主表的页面中以内嵌表格形式管理。
    3.  **模板选择**:
        *   **主从表判断**: 区分单表和主从表。
        *   **Vue版本与动态头部**: 根据请求中的Vue版本 (`req.Version`，如 'vue3') 和表的 `IsDynamicHeader` 配置，选择对应的模板：
            *   Vue3单表动态头: `Template\SingleTable\BuildVue3WithDynamicHeader.html`
            *   Vue3单表固定头: `Template\SingleTable\BuildVue3.html`
            *   (Vue2的模板类似，如 `Template\SingleTable\BuildVue.html`)
            *   主从表模板类似 (如 `Template\MultiTable\BuildVue3.html`)
    4.  **表头生成 (`BuilderHeader` 辅助方法)**:
        *   遍历表的字段配置 (`BuilderTableColumn`)。
        *   为每个需要在列表或表单中显示的字段，生成 `new ColumnDefine(...)` 的JavaScript代码。`ColumnDefine` 对象包含了字段的驼峰命名、显示名（备注）、是否可编辑、是否在列表显示、编辑控件类型 (`EditType`)、数据源 (`DataSource`，用于下拉框等)、原始实体类型、数据库列类型等信息。
    5.  **代码生成与占位符替换**:
        *   **单表**: 替换 `{ClassName}` (主表类名), `{TableName}` (主表类名驼峰式), `{HeaderList}` (主表头定义)。
        *   **主从表**: 替换 `{FirstTableName}` (主表名驼峰), `{SecondTableName}` (子表名驼峰), `{FirstHeaderList}` (主表头), `{SecondHeaderList}` (子表头), `{ParentTableId}` (子表外键驼峰式，用于关联主从数据)。
    6.  **文件输出**: 生成的Vue文件写入到 `{Vue项目根路径}\src\views\{主表类名小写}s\index.vue`。

*   **B. `CreateVueApi` (生成 `apiname.js` 文件)**:
    1.  **适用对象**: 无论是主表还是子表，都会为其生成API脚本。
    2.  **模板**: `Template\BuildVueApi.html`。
    3.  **代码生成**: 主要替换 `{TableName}` 占位符为表的类名驼峰式。模板中预设了对后端标准CRUD接口的调用函数 (如 `getList`, `add`, `update`, `del` 等)。
    4.  **文件输出**: 生成的API脚本写入到 `{Vue项目根路径}\src\api\{表类名驼峰式}s.js`。

---

## 其他

当采用动态头部时，如果数据库新加了字段，需要使用【同步结构】功能把新字段同步到代码生成器中。为了防止对已有的配置造成影响，该功能只新增字段，不会对已有字段进行调整。





