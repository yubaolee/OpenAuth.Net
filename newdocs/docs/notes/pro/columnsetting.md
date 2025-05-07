---
title: 列设置
createTime: 2025/05/07 20:24:28
permalink: /pro/columnsetting/
---

## 功能简介

`ColumnSetting` 是一个用于表格列显示与顺序自定义的弹窗组件，支持列的拖拽排序、显示/隐藏切换，并将用户设置持久化到本地存储。用于配合框架el-table及[通用表格组件](./table.md)的列设置。

![2025-05-07-20-24-28](http://img.openauth.net.cn/2025-05-07-20-24-28.png)

## 主要功能
- 支持列的拖拽排序
- 支持列的显示/隐藏切换
- 支持本地持久化（localStorage）
- 支持重置为默认列设置

## 属性（Props）
| 属性名         | 类型    | 必填 | 说明                         | 默认值                  |
| -------------- | ------- | ---- | ---------------------------- | ----------------------- |
| storageName    | String  | 是   | 存储在localStorage的键名     | -                       |
| columns        | Array   | 是   | 列数据，需包含唯一标识等字段 | -                       |
| title          | String  | 否   | 对话框标题                   | 设置列是否显示及显示顺序 |
| itemKey        | String  | 否   | 列的唯一标识字段             | columnName              |
| labelKey       | String  | 否   | 列的显示名称字段             | remark                  |
| showKey        | String  | 否   | 控制列是否显示的字段         | isList                  |

## 事件（Emits）
| 事件名           | 说明                         | 回调参数           |
| ---------------- | ---------------------------- | ------------------ |
| update:columns   | 列设置变更时通知父组件       | 新的列数组/null    |


## 使用示例
```vue
<template>
  <el-table :columns="columns" />
  <ColumnSetting
    :storageName="'user-table-columns'"
    :columns="columns"
    @update:columns="onColumnsUpdate"
  />
</template>

<script setup>
import { ref } from 'vue'
import ColumnSetting from '@/components/ColumnSetting'

// 表格列定义，为一个`ColumnDefine`的数组。典型的值如下：
const columns = ref([
  new ColumnDefine('id', 'id', false, false, 'text', '', 'string', 'varchar', ''),
  new ColumnDefine('tableName', '表名', true, true, 'text', '', 'string', 'varchar', ''),
  new ColumnDefine('parentTableId', '父表', true, true, 'selectDynamic', '/BuilderTables/AllMain', 'string', 'varchar', '')
])

function onColumnsUpdate(newColumns) {
  if (newColumns) {
    columns.value = newColumns
  } else {
    // 重新加载默认列
  }
}
</script>
```

## 常见问题

### 1. 如何自定义列的唯一标识、显示名、显示控制字段？
通过 `itemKey`、`labelKey`、`showKey` 属性自定义。

### 2. 如何重置为默认列？
点击弹窗底部"重置"按钮即可。

### 4. 如何与表格联动？
监听 `update:columns` 事件，更新表格的列配置。
