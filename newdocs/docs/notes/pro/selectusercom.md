---
title: 选择用户/角色
createTime: 2025/05/24 23:43:26
permalink: /pro/selectusercom/
---

SelectUsersCom是一个用于选择用户或角色的基础组件。如下图：

![2025-05-24-12-15-46](http://img.openauth.net.cn/2025-05-24-12-15-46.png)

一般通过按钮触发弹框进行选择，如下：

```vue
  <el-button @click="selectDialog = true">选择用户</el-button>
  <el-dialog :destroy-on-close="true"  width="850px" title="选择用户" v-model="selectDialog">
    <selectUsersCom v-if="selectDialog" :ignore-auth="ignoreAuth" v-model:show="selectDialog" :loginKey="'loginUser'"
      v-model:users="selectUsers" v-model:userNames="names"></selectUsersCom>
  </el-dialog>

<script setup>
import { ref } from 'vue'
import SelectUsersCom from '@/components/SelectUsersCom/index.vue'

const selectDialog = ref(false)
const selectUsers = ref([])
const names = ref('')
const ignoreAuth = ref(false)

</script>
```

还有一种通过输入框触发弹框进行选择，这时需要回填数据到文本框中。如下：

![2025-05-24-11-44-26](http://img.openauth.net.cn/2025-05-24-11-44-26.png)

```vue
 <el-input @click="selectDialog = true" readonly v-model="names" :placeholder="placeholder"></el-input>
  <el-dialog :destroy-on-close="true"  width="850px" title="选择用户" v-model="selectDialog">
    <selectUsersCom v-if="selectDialog" :ignore-auth="ignoreAuth" v-model:show="selectDialog" :loginKey="'loginUser'"
      v-model:users="selectUsers" v-model:userNames="names"></selectUsersCom>
  </el-dialog>

<script setup>
import { ref } from 'vue'
import SelectUsersCom from '@/components/SelectUsersCom/index.vue'

const selectDialog = ref(false)
const selectUsers = ref([])
const names = ref('')
const ignoreAuth = ref(false)

</script>
```

为了方便使用，我们在`SelectUsersCom`组件的基础上封装了`/components/SelectUsersCom/dialog.vue`组件用于带文本框的场景。使用如下：

```vue
<select-users v-model:userNames="names" :users="users" :ignore-auth="true"></select-users>

<script setup>
import { ref } from 'vue'
import SelectUsersDialog from '@/components/SelectUsersCom/dialog.vue'  

const names = ref('')
const roles = ref([])
</script>
```

## 属性

| 属性名 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| show | Boolean | false | 控制组件显示/隐藏 |
| loginKey | String | - | 选择类型，'loginUser'表示选择用户，其他值表示选择角色 |
| orgId | String | - | 组织ID，如果为空则显示左侧树状结构 |
| ignoreAuth | Boolean | false | 是否忽略登录用户权限，直接获取全部数据，用于可以跨部门选择用户、角色的场景 |
| hiddenFooter | Boolean | false | 是否隐藏底部的确定/取消按钮 |
| userNames | String | - | 已选用户/角色名称，逗号分隔 |
| users | Array | [] | 已选用户/角色ID列表 |

## 事件

| 事件名 | 说明 | 回调参数 |
| --- | --- | --- |
| update:show | 组件显示状态变化时触发 | (show: Boolean) |
| update:userNames | 选择的用户/角色名称变化时触发 | (userNames: String) |
| update:users | 选择的用户/角色ID变化时触发 | (users: Array) |

## 方法

| 方法名 | 说明 | 参数 |
| --- | --- | --- |
| handleSaveUsers | 保存已选中的用户/角色，可通过ref调用 | - |

## 更多示例

### 选择角色

```vue
 <el-input @click="selectDialog = true" readonly v-model="names" :placeholder="placeholder"></el-input>
  <el-dialog :destroy-on-close="true"  width="850px" title="选择角色" v-model="selectDialog">
    <selectUsersCom v-if="selectDialog" :ignore-auth="ignoreAuth" v-model:show="selectDialog" :loginKey="'loginRole'"
      v-model:users="selectRoles" v-model:userNames="names"></selectUsersCom>
  </el-dialog>

<script setup>
import { ref } from 'vue'
import SelectUsersCom from '@/components/SelectUsersCom/index.vue'

const selectDialog = ref(false)
const selectRoles = ref([])
const names = ref('')
const ignoreAuth = ref(false)

</script>
```

为了方便使用，我们在`SelectUsersCom`组件的基础上封装了`SelectRoles`组件用于选择角色。使用如下：

```vue
 <select-roles v-model:userNames="names" :roles="roles" :ignore-auth="true"></select-roles>

<script setup>
import { ref } from 'vue'
import SelectRoles from '@/components/SelectRoles/index.vue'

const names = ref('')
const roles = ref([])
</script>
```

### 不显示底部按钮，通过ref调用方法

```vue
<el-dialog width="80%" draggable :title="'选择用户'" v-model="dialogSelectUser">
    <selectUsersCom ref="selectUserRef" v-if="dialogSelectUser" :hiddenFooter="true" :loginKey="'loginUser'"
        v-model:users="selectUsers"></selectUsersCom>
    <template v-slot:footer>
        <div style="text-align: right">
            <el-button size="small" type="info" @click="dialogSelectUser = false">
                取消
            </el-button>
            <el-button size="small" type="primary" @click="handleSaveUsers">
                确定
            </el-button>
        </div>
    </template>
</el-dialog>

<script setup>
import { ref } from 'vue'
import SelectUsersCom from '@/components/SelectUsersCom/index.vue'

const selectUserRef = ref(null)
const dialogSelectUser = ref(false)
const selectUsers = ref([])

//确定添加的用户
const handleSaveUsers = () => {
    selectUserRef.value.handleSaveUsers()
    dialogSelectUser.value = false
}
</script>
```

## 注意事项

1. 当`ignoreAuth`为`true`时，将调用`loadAll`接口获取所有数据，否则调用`getList`接口获取有权限的数据 