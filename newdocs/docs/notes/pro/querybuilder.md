---
title: 自定义查询
createTime: 2025/05/07 19:10:57
permalink: /pro/querybuilder/
---

自定义查询组件`QueryBuilder`是一个可复用的高级查询条件构建器组件，支持通过配置 columns 自动生成 SQL 查询条件。用于配合框架el-table及[通用表格组件](./table.md)的复杂筛选的场景，支持条件的增删、类型自动识别、SQL 片段生成与复制、条件本地缓存等功能。

![2025-05-07-19-20-48](http://img.openauth.net.cn/2025-05-07-19-20-48.png)

---

## 组件引入

```js
import QueryBuilder from '@/components/QueryBuilder'
```

---

## 基本用法

### 1. 在父组件 template 中引用

```vue
<template>
  <QueryBuilder
    :columns="headerList"
    :queryOptions="listQuery"
    storageName="model-user-query"
    @search="handleSearch"
  />
</template>
```

### 2. 在父组件 script 中准备参数

```js
import { ref } from 'vue'

//符合ColumnDefine类型的数组，这里一般是headerList
const headerList = ref([
  {
    columnName: 'userName',
    remark: '用户名',
    entityType: 'string',
    isList: true
  },
  {
    columnName: 'createdAt',
    remark: '创建时间',
    entityType: 'datetime',
    isList: true
  },
  // ...更多字段
])

//高级查询条件
const listQuery = reactive({
   page: 1,
  limit: 20,
  key: undefined,
  sqlWhere: ''  //高级查询条件
})

const handleSearch = () => {
  // 这里可以用 queryOptions.value.sqlWhere 作为后端查询条件
   listQuery.page = 1
   getList()
}
```

---

## Props 参数说明

| 参数         | 类型    | 必填 | 说明                                   |
| ------------ | ------- | ---- | -------------------------------------- |
| columns      | Array   | 是   | 字段配置，决定可选字段及类型           |
| queryOptions | Object  | 是   | 查询参数对象，需包含 key、sqlWhere 字段|
| storageName  | String  | 是   | 本地存储条件的唯一 key                 |

### columns 配置示例

每个字段对象支持如下属性：

- `columnName`：字段名（与数据库字段一致）
- `remark`：显示名称
- `entityType`：字段类型（如 string、int、datetime、date、float 等，自动识别输入控件）
- `isList`：是否在查询中显示（可选，默认 true）

---

## 事件说明

| 事件名 | 说明                 | 回调参数 |
| ------ | -------------------- | -------- |
| search | 查询按钮/应用查询时触发 | 无       |

---

## 交互说明

- 顶部输入框支持快速模糊查询（key 字段）。
- 点击"高级查询"按钮弹出条件构建器，可添加/删除多组条件。
- 支持多种操作符（=、!=、LIKE、IN、BETWEEN、IS NULL 等）。
- 根据字段类型自动切换输入控件（文本、数字、日期、时间区间等）。
- 支持 SQL 条件一键复制。
- 查询条件自动本地缓存，关闭弹窗/刷新页面后可恢复。
---

## 后端接口

后端接口需要继承 `SqlSugarBaseApp` 类，并在 `Load` 方法中处理前端生成的sql查询条件。

```csharp
public class XXApp : SqlSugarBaseApp<XX>
{
  public async Task<TableData> Load(QueryXXListReq request)
    {
        //...
        if (!string.IsNullOrEmpty(request.sqlWhere))
        {
            objs = objs.Where(request.sqlWhere);
        }
        //...
    }
}
```

## 常见问题

1. **为什么没有显示某些字段？**
   - 请检查 columns 配置，字段需设置 `isList: true` 或不设置该属性。

2. **如何自定义操作符？**
   - 可在组件内修改 `compareOperators`、`textOperators`、`rangeOperators`、`nullOperators` 数组。

3. **如何清空所有条件？**
   - 点击弹窗底部"重置"按钮即可。

---

