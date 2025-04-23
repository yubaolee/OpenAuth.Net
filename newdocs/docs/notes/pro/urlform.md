---
title: URL表单
createTime: 2025/04/23 23:43:26
permalink: /pro/urlform/
--- 

URL表单本质上不是实际存在的表单，指的是审批的过程中，审批内容是发起流程时传入的一个URL网址，审批人员根据这个URL展示的内容进行审批。

## 实现步骤

#### 添加业务详情页面

参考：src\views\wmsinboundordertbls\detail.vue 开发一个业务详情页面。注意详情页面需要一个id参数，用于获取详情数据。

默认情况下，你不需要调整框架内容。当然如果详情页面参数名称不是id，或有多个参数，可以调整相关的前后端代码进行适配：

```csharp
//OpenAuth.App\FlowInstance\FlowInstanceApp.cs
addFlowInstanceReq.FrmData = scheme.FrmUrlTemplate.Replace("{id}", addFlowInstanceReq.BusinessId);
```

```javascript
    //src\extensions\common.js
    ....
    const createFlowInstance = (flowscheme, obj, customName) => {
      flowinstances.add({
        schemeId: flowscheme.id,
        code: new Date().getTime(),
        customName: customName?? '业务单据' + obj.id + '送审',
        businessId: obj.id,
        //👉可以在这里添加其他参数，如：detailUrl: 'http://localhost:8000/otherapp/detail?id=' + obj.id + ...
      })
      ....
    }
```

#### 添加流程模板

新加一个模板，名称如：订单送审流程。填写基本信息。选择表单时，选：URL表单，并指定URL表单模板。如下图：

![2025-04-09-17-05-48](http://img.openauth.net.cn/2025-04-09-17-05-48.png)

::: warning 注意
这里模板URL地址可以不填，可以在业务系统调用时，直接从前端传业务详情的URL地址。如第一步javascript代码中提到的`detailUrl`，赋值到流程实例的FrmData中。
:::

#### 挂载流程方案

制作完流程模板后，在【模块管理】功能里面，把刚刚流程模板与功能关联。

![2025-04-09-17-20-33](http://img.openauth.net.cn/2025-04-09-17-20-33.png)

#### 业务系统发起【送审】

在【仓储中心/入库单】中，选择一个入库单，点击【送审】，选择刚刚设计的流程模板：

![2025-04-06-22-34-34](http://img.openauth.net.cn/2025-04-06-22-34-34.png)

送审成功后就可以在【流程中心/我的流程】中看到刚刚送审的流程实例，点击进入后，就可以看到审批内容是业务详情的URL地址。

![2025-04-09-17-15-02](http://img.openauth.net.cn/2025-04-09-17-15-02.png)

详情页面：

![URL表单流程](http://img.openauth.net.cn/2025-04-06-22-46-13.png)









