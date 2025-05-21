---
title: 通用下拉组件
createTime: 2025/05/12 10:24:28
permalink: /pro/authselect/
---

通用下拉选择`AuthSelect`用于渲染和编辑字典结构和动态列表返回key-valuel格式的数据。该组件与其他组件的关系如下：
![20211230063538](http://img.openauth.net.cn/20211230063538.png)

## 基本用法

下拉选择组件目前支持`静态字典数据`和`动态接口数据`两种模式。

### 字典数据模式
静态字典。根据【字典分类】模块的`分类标识`关键字获取，如：
```vue
<auth-select 
  :isEdit="true" 
  @change="handleChange" 
  :data-source="'SYS_STATUS'" 
  v-model="value">
</auth-select>
```

### 动态接口模式
动态列表。从指定Url获取value/label结构的数据进行渲染，如：
```vue
<auth-select 
  :isEdit="true" 
  @change="handleChange" 
  :type="'dynamic'" 
  :data-source="'/CategoryTypes/Load'" 
  v-model="value">
</auth-select>
```

### 直接传入数组

```vue
<auth-select 
  :isEdit="true" 
  @change="handleChange" 
  :data-source="[{label: '选项1', value: '1'}, {label: '选项2', value: '2'}]" 
  v-model="value">
</auth-select>
```

## API

### Props

| 参数 | 说明 | 类型 | 默认值 |
| --- | --- | --- | --- |
| type | 下拉框类型，`static`表示从数据字典加载，`dynamic`表示从接口获取 | String | `static` |
| dataSource | 数据源，当type=='dynamic'时，该值为一个Url地址，该地址返回一个id/name结构的数组。当type=='static'或空时，该值为【字典分类】模块的`分类标识` | String/Number/Array | - |
| value / v-model | 绑定值 | String/Number | `''` |
| isEdit | 是否为编辑状态，`false`时显示文本 | Boolean | `true` |
| disabled | 是否禁用 | Boolean | `false` |
| size | 输入框尺寸 | String | `default` |
| searchKey | 搜索参数，当`type`为`dynamic`时有效 | Object | `{}` |
| defaultProps | 自定义选项的值和标签字段。如果该值为空，则v-model需要传字段id/name的数组 | Object | `{label: 'label', value: 'value'}` |

### Events

| 事件名称 | 说明 | 回调参数 |
| --- | --- | --- |
| change | 选中值发生变化时触发 | 选中项的值 |
| changeLabel | 选中值发生变化时触发 | 选中项的标签 |
| update:value | 更新v-model值 | 选中项的值 |

## 示例

### 基础用法 - 字典数据

```vue
<template>
  <auth-select 
    :isEdit="isEdit" 
    @change="onChange" 
    :data-source="'SYS_STATUS'" 
    v-model="status">
  </auth-select>
</template>

<script setup>
import { ref } from 'vue'

const isEdit = ref(true)
const status = ref('')

const onChange = (val) => {
  console.log('选中值：', val)
}
</script>
```

### 动态接口数据

```vue
<template>
  <auth-select 
    :isEdit="isEdit" 
    @change="onChange" 
    :type="'dynamic'" 
    :data-source="'/CategoryTypes/Load'" 
    :search-key="searchParams"
    v-model="selectedValue">
  </auth-select>
</template>

<script setup>
import { ref, reactive } from 'vue'

const isEdit = ref(true)
const selectedValue = ref('')
const searchParams = reactive({
  key: 'value',
  otherParam: 'test'
})

const onChange = (val) => {
  console.log('选中值：', val)
}
</script>
```

### 自定义字段名

```vue
<template>
  <auth-select 
    :isEdit="isEdit" 
    :type="'dynamic'" 
    :data-source="'/api/users'" 
    :default-props="{label: 'username', value: 'id'}"
    v-model="userId">
  </auth-select>
</template>

<script setup>
import { ref } from 'vue'

const isEdit = ref(true)
const userId = ref('')
</script>
``` 