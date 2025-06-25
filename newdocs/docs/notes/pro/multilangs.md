---
title: 多语言
createTime: 2025/04/23 23:43:26
permalink: /pro/multilangs/
---

## 多语言配置

vue3版本使用 vue-i18n 实现多语言支持，通过 `useI18n()` 钩子访问翻译功能。

### 使用方法

1. **引入 i18n**

```javascript
import { useI18n } from 'vue-i18n'
const i18n = useI18n()
```

2. **模板中使用**
```html
<div>{{ $t('login.title') }}</div>
```

3. **JS代码中使用**
```javascript
i18n.t('login.validation.usernameRequired')
```

### 配置示例

在登录页面可见的多语言项：
- 登录相关：`login.title`, `login.workflowEngine`, `login.usernamePlaceholder`, `login.passwordPlaceholder`
- 验证消息：`login.validation.usernameRequired`, `login.validation.passwordRequired`
- 租户选择：`login.tenants.default`, `login.tenants.notExist`

### 添加新语言

1. 在语言文件中添加新的翻译项
2. 确保所有使用的键都有对应翻译

### 注意事项

- 使用嵌套对象结构组织翻译项
- 参数化文本使用 `{param}` 语法
- 确保所有用户界面文本都使用 i18n
