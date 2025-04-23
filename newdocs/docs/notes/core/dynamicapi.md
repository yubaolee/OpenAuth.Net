---
title: 动态API
createTime: 2025/04/23 21:03:10
permalink: /core/dynamicapi/
---
# 动态API

加快系统开发速度，框架提供动态API功能，可以实现无代码调整操作数据库。

## 数据库操作
在开发过程中，对于有些简单表的处理，如果每次都编写对应的增删改查，会增加工作量，且代码臃肿。这时我们可以使用动态API来处理。只需要前端按规范调用即可，后端无需做任何工作。OpenAuth.Net的动态API支持以下功能：

- 新增记录 `/api/dynamicapi/add`
- 修改记录 `/api/dynamicapi/update`
- 删除记录 `/api/dynamicapi/delete`
- 查询单条 `/api/dynamicapi/get`
- 查询列表 `/api/dynamicapi/getlist`

具体的参数可以查询对应的接口文档。我们以一个简单的表`noentity`为例，来说明如何使用动态API。
```sql
CREATE TABLE `noentity` (
  `id` varchar(50) NOT NULL, 
  `name` varchar(255) NULL,
  `age` int(11) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```
无需在后端添加任何代码，只需前端按规范调用即可。

#### 新增记录

前端请求方式为`POST`，请求地址为`/api/dynamicapi/add`，请求参数为：

```json
{
  "tableName": "noentity",
  "obj": "{\"name\":\"测试\"}"
}
```

#### 修改记录

前端请求方式为`POST`，请求地址为`/api/dynamicapi/update`，请求参数为：

```json
{
  "tableName": "noentity",
  "obj": "{\"id\":\"1\",\"name\":\"测试新\"}"
}
```
注意修改的时候，必须包含主键Id字段。

#### 删除记录

前端请求方式为`POST`，请求地址为`/api/dynamicapi/delete`，请求参数为：

```json
{
  "tableName": "noentity",
  "ids": ["1"]
}
```

#### 查询单条记录

前端请求方式为`POST`，请求地址为`/api/dynamicapi/get`，请求参数为：

```json
{
  "tableName": "noentity",
  "id": "1"
}
``` 

#### 查询列表

前端请求方式为`POST`，请求地址为`/api/dynamicapi/getlist`，请求参数为：

```json 
{
  "tableName": "noentity",
  "pageIndex": 1,
  "pageSize": 10
}
```


## 调用已有模块

除了数据库操作，系统内置一个接口`/api/dynamic/Invoke`，前端可以直接通过这个接口，调用OpenAuth.App层的方法。
```json
{
  "serviceName": "UserManagerApp",
  "methodName": "Load",
  "parameters": "{\"request\":{\"page\":1,\"limit\":10,\"key\":\"\"}}"
}
```





