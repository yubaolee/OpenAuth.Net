---
title: 通用表格
createTime: 2025/05/07 19:10:57
permalink: /pro/table/
---

通用表格组件`AuthTable` 是OpenAuth.Net框架的核心组件之一，支持自定义列模板、单选/多选、可编辑、导出 Excel 等功能。

## 使用示例

```vue
<template>
  <auth-table
    ref="mainTableRef"
    :id="'tableId'"
    :table-fields="tableFields"
    :data="dataList"
    :edit-model="true"
    :v-loading="loading"
    :templates="{'id': idtemplate}"
    select-type="checkbox"
    @row-click="handleRowClick"
    @selection-change="handleSelectionChange"
    @item-change="handleItemChange"
  />
</template>

<script setup>
import { ref } from 'vue'
import AuthTable from '@/components/Base/AuthTable.vue'

// 表单属性定义。为一个`ColumnDefine`的数组。典型的值如下：
const tableFields = ref([
  new ColumnDefine('id', 'id', false, false, 'text', '', 'string', 'varchar', ''),
  new ColumnDefine('tableName', '表名', true, true, 'text', '', 'string', 'varchar', ''),
  new ColumnDefine('parentTableId', '父表', true, true, 'selectDynamic', '/BuilderTables/AllMain', 'string', 'varchar', '')
])

// 表格数据源。为一个数组。典型的值如下：
const dataList = ref([
  { id: 1, tableName: '表1', parentTableId: null },
  { id: 2, tableName: '表2', parentTableId: 1 },
  // ... 其他数据
])
const loading = ref(false)

// 如果需要自定义展示，可以设置。比如：主表id模板,点击跳转详情
const idtemplate = defineComponent({
  props: ['row'],
  methods: {
    itemClick(row) {
      viewDetail(row)
    }
  },
  template: `<span class="link-text" @click.stop='itemClick(row)'>{{row['id']}}</span>`
})

const handleRowClick = row => {
  // 点击行
  mainTable.value.clearSelection()
  mainTable.value.toggleRowSelection(row)

  var val = row.id
  // ...
}

const handleSelectionChange = val => {
  multipleSelection.value = val  //当前选中的所有行
}

const handleItemChange = val => {
  // 单元格值变化事件处理
  xxapp.update(item).then(() => {
    ElNotification.success("更新成功")
  })
}
</script>
```

## 属性说明

| 属性名         | 类型    | 说明                                   | 默认值      |
| -------------- | ------- | -------------------------------------- | ----------- |
| id             | String  | 表格唯一标识，导出 Excel 时必填         | ''          |
| tableFields    | Array   | 表格列定义，详见下方字段说明            | []          |
| data           | Array   | 表格数据源                              | []          |
| selectType     | String  | 选择类型，checkbox（多选）/radio（单选）| 'checkbox'  |
| editModel      | Boolean | 是否可编辑                              | false       |
| vLoading       | Boolean | 加载状态                                | false       |
| templates      | Object  | 自定义列模板，key 为 columnName         | {}          |

### tableFields 字段说明

| 字段名         | 类型    | 说明                                   |
| -------------- | ------- | -------------------------------------- |
| columnName     | String  | 字段名，对应 data 中的 key             |
| remark         | String  | 列显示名称                              |
| isList         | Boolean | 是否在列表中显示                        |
| isEdit         | Boolean | 是否可编辑                              |
| editType       | String  | 编辑类型（select/switch/date/datetime） |
| dataSource     | Array   | 下拉框数据源（editType 为 select 时）   |
| sort           | Number  | 排序字段，越小越靠前                    |

## 事件说明

| 事件名            | 说明                       | 回调参数         |
| ----------------- | -------------------------- | ---------------- |
| row-click         | 行点击事件                 | row（当前行数据）|
| selection-change  | 选择项变化事件             | val（选中项数组）|
| item-change       | 单元格值变化事件           | val（当前行数据）|

## 方法说明

通过 `ref` 可调用以下方法：

| 方法名            | 说明                       | 参数             |
| ----------------- | -------------------------- | ---------------- |
| clearSelection    | 清空所有选中项             | 无               |
| toggleRowSelection| 选中/取消选中指定行         | row（行数据）    |
| exportExcel       | 导出 Excel 文件            | fileName（文件名）|
