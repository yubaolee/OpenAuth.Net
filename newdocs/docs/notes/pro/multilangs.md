---
title: 多语言
createTime: 2025/04/23 23:43:26
permalink: /pro/multilangs/
---

## 多语言配置

![2025-06-25-23-10-11](http://img.openauth.net.cn/2025-06-25-23-10-11.png)

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

3. **vue setup代码中使用**
```javascript
let title = i18n.t('route.dashboard');
```

4. **普通js代码中使用**

如果在普通的js（非vue component）代码中使用，需要使用 `i18n.global.t` 方法。

```javascript
import i18n from '@/i18n'

let title = i18n.global.t('route.dashboard');
```

### 配置说明

界面显示的文本，在 `src\i18n\langs\` 文件夹中配置，目前支持中文、英文。以 `zh-cn.js` 为例：

```javascript
export default {
  login: {
    title: 'OpenAuth.Net Vue3版',
    logIn: '登 录',
    username: '账号',
    password: '密码',
    usernamePlaceholder: '请输入登录账号',
    oauthLoginTip: '接口服务器启用了Oauth认证，请点击这里登录',
    tips: {
      system: '默认System登录后，你可以无法无天',
      admin: 'admin/admin登录后，会少一点权限，资源管理/分类管理的字段会少一点',
      test: 'test/test登录后，权限会更少,资源管理/分类管理的字段会更少'
    }
  },
  tagsView: {
    refresh: '刷新',
    close: '关闭',
    closeOthers: '关闭其它',
    closeAll: '关闭所有'
  },
  common: {
    language: '语言',
    welcome: '欢迎您，',
    ok: '确定',
    cancel: '取消',
  },
  language: {
    zh: '简体中文',
    en: '英文'
  },
  dashboard: {
    siteInfo: '为了大家体验的一致性，数据库每1小时还原一次。不同于其他基于Element框架界面的花里胡哨，各种大按钮大缝隙，我们的原则：美观大方、简洁易用',
    footer: {
      copyright: '最好用的.Net权限工作流框架',
      officialWebsite: '官方网站'
    }
  }
} 
```

### 注意事项

- 使用嵌套对象结构组织翻译项
- 参数化文本使用 `{param}` 语法
