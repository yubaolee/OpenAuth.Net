---
title: 通用表单组件
createTime: 2025/04/23 23:43:26
permalink: /pro/authform/
---

通用表单组件`AuthForm`是一个多表单项聚合组件，可以自动渲染多个表单项。支持多种表单控件类型，具有字段联动功能，能满足大部分表单场景需求。

![2025-05-21-21-23-08](http://img.openauth.net.cn/2025-05-21-21-23-08.png)

## 基本用法

```vue
<auth-form ref="dataForm" :edit-model="editModel" :form-fields="firstHeaderList" :data="firstTemp" :col-num="3"></auth-form>
```

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| editModel | Boolean | false | 是否可编辑 |
| colNum | Number | 1 | 表单列数 |
| data | Object | - | 表单绑定的数据对象 |
| formFields | Array | [] | 表单字段定义 |
| rules | Object | - | 表单验证规则 |
| fieldRelations | Array | [] | 字段联动关系配置 |

## 事件

| 事件名 | 说明 | 回调参数 |
| --- | --- | --- |
| update:data | 表单数据更新时触发 | 更新后的表单数据对象 |
| field-change | 表单字段值变化时触发 | `{ fieldName, value }` |

## 方法

| 方法名 | 说明 | 参数 |
| --- | --- | --- |
| validate | 表单验证 | callback: 验证成功时的回调函数 |
| clearValidate | 清除验证信息 | - |
| applyFieldRelations | 手动应用字段联动关系 | fieldName: 字段名, value: 字段值 |
| handleFieldChange | 手动触发字段值变化 | fieldName: 字段名, value: 字段值 |

## formFields 字段配置

表单属性定义。为一个`ColumnDefine`的数组。

```javascript
{
  columnName: 'fieldName', // 字段名，必填
  remark: '显示名称', // 字段显示名称，必填
  isEdit: true, // 是否在表单中显示，必填
  editType: 'input', // 编辑类型，必填
  sort: 1, // 排序值，越大越靠前
  dataSource: [] // 下拉选项数据源，当editType为select或selectDynamic时必填
}
```

### 支持的编辑类型 (editType)

| 类型 | 说明 |
| --- | --- |
| input | 普通文本输入框 |
| textarea | 多行文本输入框 |
| select | 静态下拉选择框 |
| selectDynamic | 动态下拉选择框 |
| date | 日期选择器 |
| datetime | 日期时间选择器 |
| switch | 开关控件 |
| checkbox | 复选框 |
| radio | 单选框 |
| file | 文件上传 |

## 字段联动配置

fieldRelations 属性用于配置字段间的联动关系，每个联动关系对象结构如下：

```javascript
{
  sourceField: 'fieldName', // 源字段名称
  targetField: 'targetFieldName', // 目标字段名称
  condition: { // 触发条件
    type: 'equals', // 条件类型
    value: 'someValue' // 条件值
  },
  actionType: 'setValue', // 联动动作类型
  value: 'newValue', // 设置的新值
  elseAction: { // 可选，条件不满足时的动作
    actionType: 'setValue',
    value: 'defaultValue'
  }
}
```

### 支持的条件类型

| 类型 | 说明 |
| --- | --- |
| equals | 等于 |
| notEquals | 不等于 |
| contains | 包含 |
| greaterThan | 大于 |
| lessThan | 小于 |
| empty | 为空 |
| notEmpty | 不为空 |
| custom | 自定义条件 |

### 支持的动作类型

| 类型 | 说明 |
| --- | --- |
| setValue | 设置字段值 |
| setLabel | 设置标签值，用于源字段是下拉选择框时，设置目标字段为选择框的标签值 |
| setVisible | 设置字段可见性 |
| setDisabled | 设置字段是否禁用 |
| clearValue | 清空字段值 |
| setDataSource | 设置数据源 |

## 文件上传

组件支持文件上传功能，上传的文件将被发送到 `/Files/Upload` 接口。上传成功后，文件路径会被自动设置到对应的表单字段中。

## 注意事项

1. 字段联动功能依赖于正确配置的fieldRelations属性
2. 文件上传功能需要后端提供正确的接口支持
3. 动态数据源需要配合AuthSelect组件使用
4. 编辑模式(editModel)设置为false时，所有表单项将被禁用 