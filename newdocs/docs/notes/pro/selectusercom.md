---
title: 选择用户/角色
createTime: 2025/05/24 23:43:26
permalink: /pro/selectusercom/
---

SelectUsersCom是一个用于选择用户或角色的组件，提供了两种使用方式：
1. 对话框模式 (index.vue)
2. 输入框触发模式 (indexwithinput.vue)

![2025-07-24-00-07-13](http://img.openauth.net.cn/2025-07-24-00-07-13.png)

## 基础对话框组件 (index.vue)

### 组件功能
- 支持选择用户或角色
- 支持组织树结构浏览
- 支持搜索功能
- 支持分页显示
- 支持已选项目可视化管理

### 属性说明

| 属性名 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| ignoreAuth | Boolean | false | 是否忽略登录用户权限，直接获取全部数据 |
| selectType | String | 'User' | 选择类型，'User'表示选择用户，'Role'表示选择角色 |
| orgId | String | - | 组织ID，如果为空则显示左边树状结构 |
| userNames | String | - | 用户名称（逗号分隔） |
| users | Object | - | 初始选中项ID列表或对象列表 |
| inType | String | 'id' | 父级传入的是id列表还是对象列表，取值为'id'或'obj' |
| modelValue | Boolean | false | 控制对话框显示 |

### 事件说明

| 事件名 | 说明 |
| --- | --- |
| update:userNames | 更新用户名称 |
| update:users | 更新用户列表 |
| save | 保存选择结果 |
| update:modelValue | 更新对话框显示状态 |

### 使用示例

```vue
<template>
  <el-button @click="showDialog = true">选择用户</el-button>
  
  <SelectUsersCom 
    v-model="showDialog"
    :ignore-auth="true"
    select-type="User"
    v-model:users="selectedUsers"
    v-model:userNames="selectedNames"
    @save="handleSave"
  />
</template>

<script setup>
import { ref } from 'vue'
import SelectUsersCom from '@/components/SelectUsersCom/index.vue'

const showDialog = ref(false)
const selectedUsers = ref([])
const selectedNames = ref('')

const handleSave = () => {
  console.log('已选用户ID:', selectedUsers.value)
  console.log('已选用户名称:', selectedNames.value)
}
</script>
```

## 输入框触发模式 (indexwithinput.vue)

### 组件功能
- 默认显示为输入框
- 点击输入框弹出选择对话框
- 支持根据用户ID自动获取用户姓名
- 支持选择用户并回显名称

### 属性说明

| 属性名 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| users | Array/String | - | 用户ID列表或单个用户ID |
| userNames | String | '' | 用户名称（逗号分隔） |
| placeholder | String | '' | 输入框占位符 |
| ignoreAuth | Boolean | false | 是否忽略权限限制 |

### 事件说明

| 事件名 | 说明 |
| --- | --- |
| users-change | 用户选择变更时触发，参数为('users', 选中的用户ID列表)或('Texts', 选中的用户名称) |

### 使用示例

```vue
<template>
  <SelectUsersComInput
    :users="selectedUserIds"
    :user-names="selectedUserNames"
    placeholder="请选择用户"
    :ignore-auth="true"
    @users-change="handleUsersChange"
  />
</template>

<script setup>
import { ref } from 'vue'
import SelectUsersComInput from '@/components/SelectUsersCom/indexwithinput.vue'

const selectedUserIds = ref(['user1', 'user2'])
const selectedUserNames = ref('张三,李四')

const handleUsersChange = (type, value) => {
  if (type === 'users') {
    selectedUserIds.value = value
  } else if (type === 'Texts') {
    selectedUserNames.value = value
  }
}
</script>
```

## 角色选择输入框 (SelectRoles/indexwithinput.vue)

### 组件功能
- 基于SelectUsersCom实现的角色选择器
- 默认显示为输入框
- 点击输入框弹出选择角色对话框

### 属性说明

| 属性名 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| roles | Array | - | 角色ID列表 |
| userNames | String | - | 角色名称（逗号分隔） |
| placeholder | String | - | 输入框占位符 |
| ignoreAuth | Boolean | false | 是否忽略权限限制 |

### 事件说明

| 事件名 | 说明 |
| --- | --- |
| roles-change | 角色选择变更时触发，参数为('roles', 选中的角色ID列表)或('Texts', 选中的角色名称) |

### 使用示例

```vue
<template>
  <SelectRolesInput
    :roles="selectedRoleIds"
    :user-names="selectedRoleNames"
    placeholder="请选择角色"
    :ignore-auth="true"
    @roles-change="handleRolesChange"
  />
</template>

<script setup>
import { ref } from 'vue'
import SelectRolesInput from '@/components/SelectRoles/indexwithinput.vue'

const selectedRoleIds = ref(['role1', 'role2'])
const selectedRoleNames = ref('管理员,操作员')

const handleRolesChange = (type, value) => {
  if (type === 'roles') {
    selectedRoleIds.value = value
  } else if (type === 'Texts') {
    selectedRoleNames.value = value
  }
}
</script>
```

## 注意事项

1. 使用indexwithinput.vue时，如果在弹出框中使用，建议设置`:destroy-on-close="true"`，避免names记录上一次选中行的值
2. 选择用户时可以通过组织树进行筛选，也可以直接搜索
3. ignoreAuth属性可以控制是否忽略用户权限限制，直接获取全部数据
4. 组件内部会自动处理用户ID和用户名称的映射关系