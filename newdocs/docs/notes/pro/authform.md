---
title: 其他组件
createTime: 2025/04/23 23:43:26
permalink: /pro/authform/
---

OpenAuth.Pro封装了一些组件，方便开发使用，组件全部在`src\components`中定义。目前提供的三大核心组件关系如下：

![20211230063538](http://img.openauth.net.cn/20211230063538.png)


## 表单组件 auth-form

根据定义动态渲染表单项，减少表单的开发。用法如下:
```html
<auth-form ref="dataForm" :edit-model="editModel" :form-fields="firstHeaderList" :data="firstTemp" :col-num="3"></auth-form>
```

当父组件需要使用表单里面的数据，进行提交操作时，参考以下代码：

```javascript
submit() {
    // 保存提交
    this.$refs['dataForm'].validate(() => {
    let tempData = Object.assign({}, this.firstTemp)
    api.add(tempData).then((resp) => {
        ...
        this.$notify({
        title: '成功',
        message: '提交成功',
        type: 'success'
        })
    })
    })
}
```

该组件有以下几个参数：

form-fields：表单属性定义。为一个`ColumnDefine`的数组。典型的值如下：

```javascript
    this.firstHeaderList = [
    new ColumnDefine('id', 'id', false, false, 'text', '', 'string', 'varchar', ''),
    new ColumnDefine('tableName', '表名', true, true, 'text', '', 'string', 'varchar', ''),
    new ColumnDefine('parentTableId', '父表', true, true, 'selectDynamic', '/BuilderTables/AllMain', 'string', 'varchar', ''),
    ]
```



