# 后端开发规范

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

主键id统一使用Domain:PrimaryKey（针对SqlServer数据库，非Sql Server根据需要定义）

状态类,标识类的字段，统一使用bit not null

表示分类的字段，统一使用PrimaryKey。数值从Category中获取。



