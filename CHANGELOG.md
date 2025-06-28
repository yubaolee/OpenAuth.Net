

## v8.1

* [重磅] 统一后端返回格式response.result调整为response.data
* [重磅] 表格组件增加排序功能
* [优化] 持续优化代码

## v8.0

* [重磅] 开源十周年特别版！
* [重磅] 全面开源原付费vue2版本源码及文档，免费使用。
* [重磅] 删除原有mvc项目，从此以后只有前后端分离。


## v7.6

* [重磅] 分离会签和网关功能，详情请查看工作流中的概念
* [优化] 前后端统一流程节点类型。详情请查看文档流程相关代码-流程模板
* [优化] 修复顺序加签

## v7.5

* [新增] 流程执行节点支持通过Sql配置用户
* [优化] 流程节点设置json对象统一为datas字段
* [优化] 优化layui样式

## v7.4

* [新增] 代码生成加上外部数据源支持；
* [新增] 新增动态API功能；
* [优化] 流程模板调整为sqlsugar；

## v7.3

* [新增] 新增API鉴权功能
* [优化] 优化vue3代码生成；

## v7.2

* [重磅]流程增加任意节点撤回审批功能
* [重磅]全面优化数据库初始脚本，SqlServer采用帕斯卡命名，MySql/pg采用小写命名,Oracle采用大写
* [重磅]优化layui点击行可选中

## v7.1

* [重磅]全面优化对Oracle数据库的支持
* [优化]FIX issue #IBLX2E:目前Oracle工作流列表不能加载 目前Oracle工作流列表不能加载
* [优化]流程实例历史操作记录

## v7.0

- **新特性**

  - [新增] 全面支持.Net 9
  - [新增] 新增Dockerfile支持
  - [新增] 修复vue3代码生成部分bug


## v6.5

- **新特性**

  - [新增] 增加知会功能。详情：[知会](http://doc.openauth.net.cn/core/flowinstance.html#%E7%9F%A5%E4%BC%9A)；
  - [新增] 新增增加签逻辑。详情：[加签](http://doc.openauth.net.cn/core/flowinstance.html#%E5%8A%A0%E7%AD%BE)；
  - [新增] 删除CodeSmith生成WebApi；

- **突破性变化**

  - [新增] 全面调整流程添加逻辑；

- **问题修复**


- **其他更改**


- **不做实现**

---
## v6.1 

- **新特性**

  - [新增] 全网最好用的打印解决方案。详情：[智能打印](http://doc.openauth.net.cn/pro/printerplan.html)；
  - [新增] 全面支持SqlSugar Orm。详情：[sqlsugar访问数据库](http://doc.openauth.net.cn/core/sqlsugar.html)；
  - [新增] 全面更新mvc版本，升级layui版本至最新v2.8.11；
  - [新增] 升级.Net版本6.0，所有三方组件全面更新；

- **突破性变化**

  - [新增] 流程可以选择直接上级和部门负责人；

- **问题修复**


- **其他更改**


- **不做实现**

---

## v5.1 

- **新特性**

  - [新增] 支持同时配置多个类型数据库的连接字符串，详见：http://doc.openauth.me/core/multidbs.html
  - [新增] 新增Oracle数据库驱动;
  - [新增] 新增流程召回功能；
  - [新增] 调整APP层文件结构，按功能划分；

- **突破性变化**

  - [调整] 优化生成实体，在生成实体后自动在OpenAuthDBContext中新增DbSet
  - [调整] 配置文件中可以配置连接字符串对应的数据库类型


- **问题修复**

  - [修复] 修复[#I3BUF5](https://gitee.com/dotnetchina/OpenAuth.Net/issues/I3BUF5)

- **其他更改**

  - [调整] 升级雪花漂移算法到最新版本

- **不做实现**

---

## v5.0.1 

- **新特性**

  - [新增] 缓存增加Redis支持
  - [新增] 增加多租户支持 [#I3ES5E](https://gitee.com/dotnetchina/OpenAuth.Net/issues/I3ES5E)
  - [新增] 增加雪花算法生成实体ID
  - [新增] 增加对数据库自动增加主键的支持

- **突破性变化**

  - [调整] 单元测试直接读取OpenAuth.WebApi的配置文件

- **问题修复**

  - [修复] 修复单元测试异常
  - [修复] 修复定时任务不能正常执行
  - [修复] 修复工作流分支判定

- **其他更改**

  - [改进] 启动时显示当前连接字符串
  - [改进] 调整工程文件`netcoreapp5.0`为`net5.0`
  - [改进] 调整代码生成器相关的代码
- **文档变化**

  - [新增] 增加多租户文档 [http://doc.openauth.me/core/multitenant.html](http://doc.openauth.me/core/multitenant.html)


- **不做实现**


---