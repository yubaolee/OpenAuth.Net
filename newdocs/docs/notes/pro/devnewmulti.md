---
title: 多表代码生成
createTime: 2025/04/23 23:43:26
permalink: /pro/devnewmulti/
---

本章节视频讲解请参考：[OpenAuth.Net视频合集--多表代码生成](https://www.bilibili.com/video/BV1r4J3zAEsx/)

上节介绍了[单表代码生成](/pro/devnew/)，本节介绍多表代码生成。

## 准备工作

本文以mysql数据库为例，在openauthpro数据库中添加父表parenttable、子表childtable,参考表结构如下：

```SQL
CREATE TABLE `parenttable`  (
  `id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '父表ID',
  `externalno` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自定义编号',
  `status` int(11) NOT NULL COMMENT '状态',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '名称',

  `createtime` datetime NOT NULL COMMENT '创建时间',
  `createuserid` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人ID',
  `createusername` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `updatetime` datetime NULL DEFAULT NULL COMMENT '最后更新时间',
  `updateuserid` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最后更新人ID',
  `updateusername` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最后更新人',
  `orgid` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所属部门',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '父表' ROW_FORMAT = DYNAMIC;

CREATE TABLE `childtable`  (
  `id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '子表ID',
  `parentid` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '父表ID',
  `remark` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '备注',
  `pricenotax` decimal(18, 6) NULL DEFAULT NULL COMMENT '单价',
  `asnstatus` int(11) NOT NULL COMMENT '细单状态',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品名称',
  `goodssku` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品SKU',
  `goodsbatch` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品批号',
  `ordernum` decimal(18, 2) NOT NULL COMMENT '数量',
  `proddate` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产日期',
  `expiredate` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '失效日期',

  `createtime` datetime NOT NULL COMMENT '创建时间',
  `createuserid` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人ID',
  `createusername` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `updatetime` datetime NULL DEFAULT NULL COMMENT '最后更新时间',
  `updateuserid` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最后更新人ID',
  `updateusername` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '子表' ROW_FORMAT = DYNAMIC;
```

* 使用Visual Studio 以开发模式启动后端。参考：[编译运行webapi](http://doc.openauth.net.cn/core/start/#%E7%BC%96%E8%AF%91%E8%BF%90%E8%A1%8Cwebapi)

* 启动企业版前端。参考：[启动前端](http://doc.openauth.net.cn/pro/#%E5%90%AF%E5%8A%A8%E5%89%8D%E7%AB%AF)

后续操作全部在系统中完成。

## 添加父表

代码生成界面，点击`添加`按钮，输入想添加的模块信息。相关字段说明可参考[代码生成功能字段详解](/pro/devnew/#代码生成功能字段详解)
![20250518152210](http://img.openauth.net.cn/20250518152210.png)

录入基础信息，点击右下角`确认`保存后，系统会添加一条记录，并自动加载对应的字段信息。

![20250518152235](http://img.openauth.net.cn/20250518152235.png)

这时，编辑字段具体的属性。如是否【可显示】【可编辑】等。


## 添加子表


同添加父表一样，点击`添加`按钮，输入子模块信息。

![20250518152326](http://img.openauth.net.cn/20250518152326.png)

::: warning 注意
* 子表的`父表`为必填字段，选择刚刚添加的父表。
* 子表的`外键`字段为必填字段，选择子表设计的类似`父表ID`字段，从而可以与父表关联。
* 子表的`动态头部`属性务必与父表保持一致，否则会造成生成的代码不能正常运行
:::

## 生成模块

选中刚刚添加的父表，依次点击【生成实体】【生成业务代码】【生成vue页面】;
子表虽然不需要生成vue页面，但需要生成前端js api;

成功后生成的后端.Net代码位置如下：

OpenAuth.Repository\Domain\Parentable.cs
OpenAuth.App\ParentableApp\ParentableApp.cs
OpenAuth.App\ParentableApp\Request\AddOrUpdateParentableReq.cs
OpenAuth.App\ParentableApp\Request\QueryParentableListReq.cs
OpenAuth.WebApi\Controllers\ParentablesController.cs

OpenAuth.Repository\Domain\Childtable.cs
OpenAuth.App\ChildtableApp\ChildtableApp.cs
OpenAuth.App\ChildtableApp\Request\AddOrUpdateChildtableReq.cs
OpenAuth.App\ChildtableApp\Request\QueryChildtableListReq.cs
OpenAuth.WebApi\Controllers\ChildtablesController.cs

前端Vue代码：
src\api\parentables.js
src\api\childtables.js
src\views\parentables\index.vue

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

经过以上步骤，重启系统后，使用System账号重新登录，在【模块管理】中，添加`测试模块`模块，如下图：

![20250518153337](http://img.openauth.net.cn/20250518153337.png)

这样就可以访问刚刚新加的`测试模块`功能，到此就完成了添加一个新模块功能：

![20250518153406](http://img.openauth.net.cn/20250518153406.png)

尝试增加一条记录，看看模块是否能正常运行。