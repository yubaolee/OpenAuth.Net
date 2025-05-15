---
title: 流程相关的代码
createTime: 2025/04/23 21:03:10
permalink: /core/flowinstancedev/
---

## 流程审批逻辑

当最终用户在【待处理流程】中审批一个流程实例时，流程实例会经过下面步骤进行处理：

@startuml
skinparam handwritten true
skinparam backgroundColor #EEEBDC

start
if (当前活动节点类型为会签) then (yes)
  :标识当前节点状态;
  :从所有的分支中找到一个用户可以审批的节点canCheckId;
  if (没找到?) then (yes)
    stop
  endif
  :标识canCheckId节点状态;
  #HotPink:进行会签,结果为res;
  if(res == TagState.No) then (yes)
    :修改流程最终状态为不同意;
  else if(res != string.Empty) then (yes)
    stop
  else (no)
    :修改流程最终状态，修改活动节点，修改可执行人;
    :添加扭转记录;
  endif

else (no)
  :标识当前节点状态;
  if (同意) then (yes)
    :修改流程最终状态，修改活动节点，修改可执行人;
    :添加扭转记录;
  else
    :修改流程最终状态为不同意;
  endif
  :操作记录;
endif
stop

@enduml

## 流程模板

流程模板指流程的定义。数据存放在FlowScheme表中，该表核心字段如下：

### FrmId：流程模版关联的表单id

### FrmType：表单类型

### SchemeContent：流程实例的具体内容

该字段存储的是一个JSON对象，具体内容如下所示：

```javascript
{
    "nodes": [
        {
            "type": "node",  //节点类型，开始，普通，网关，会签等
            "name": "任务节点", //节点名称
            "icon": "iconfont icon-jiaoseguanli", //节点图标
            "belongto": "commonNodes", //节点样式类型：普通四边形节点，菱形网关
            "id": "node-011c37dd1db34596b9cbd6812971b8a6", //节点id
            "setInfo": {
                "NodeRejectType": 0, //节点驳回类型：
                "NodeConfluenceType": "", //节点会签/网关类型
                "NodeDesignate": "SPECIAL_ROLE",//执行权限类型：指定角色、指定用户等
                "ThirdPartyUrl": "",//执行完成后回调地址
                "NodeDesignateData": {  //根据NodeDesignate不同，表示不同的权限数据：角色、用户等
                    "datas": [
                        "77e6d0c3-f9e1-4933-92c3-c1c6eef75593"
                    ],
                    "Texts": "神"
                },
                "CanWriteFormItemIds":  //可写表单项id
                [
                    "radio113860", 
                    "radio74071"
                ]
            }
        }
    ],
    "lines": [
        {
            "type": "sl",  //原有gooflow里面的值："sl":直线, "lr":中段可左右移动型折线, "tb":中段可上下移动型折线
            "id": "link-6351c01fd31d4e6d85d476be6e0b0ae2",
            "from": "start-3fcaf7e8577644ff8b52fabaf975437e",
            "to": "node-011c37dd1db34596b9cbd6812971b8a6",
            "label": "值>3",  //连线上面显示的文字
            "cls": {
                "linkType": "Flowchart",
                "linkColor": "#2a2929",
                "linkThickness": 1
            },
            "Compares": [{  //连线条件
                "FieldName": "Age", //表单项id
                "Operation": ">", //条件类型
                "Value": "3" //条件值
            }]
        }, 
        {
            "type": "sl",
            "id": "link-785f8823a60e4472884f482b16c16f26",
            "from": "node-011c37dd1db34596b9cbd6812971b8a6",
            "to": "end-a749ef5b89bb49d588009b71f53316f5",
            "label": "",
            "cls": {
                "linkType": "Flowchart",
                "linkColor": "#2a2929",
                "linkThickness": 1
            }
        }
    ]
}

```
其中：nodes为流程实例的所有节点。lines为流程实例的所有连线。节点属性如下：

### 节点属性

#### 基础属性

| 属性名 | 类型 | 说明 | 可选值 |
|--------|------|------|---------|
| type | 字符串 | 节点类型 | start：开始节点<br>node：普通节点<br>fork：分支节点<br>join：合并节点<br>end：结束节点 |
| name | 字符串 | 节点名称 | - |
| icon | 字符串 | 节点图标 | - |
| belongto | 字符串 | 节点样式类型 | - |
| id | 字符串 | 节点id | - |

#### 配置信息(setInfo)

##### 节点驳回配置

| 属性名 | 类型 | 说明 | 可选值 |
|--------|------|------|---------|
| NodeRejectType | 数字 | 节点驳回类型 | 0：前一步<br>1：第一步<br>2：指定节点 |
| NodeRejectStep | 字符串 | 驳回节点id | 当NodeRejectType=2时使用 |

##### 节点会签/网关配置

| 属性名 | 类型 | 说明 | 可选值 |
|--------|------|------|---------|
| NodeConfluenceType | 字符串 | 节点会签/网关类型 | sequential：顺序<br>all：全部通过<br>one：至少一个通过 |

##### 执行权限配置

| 属性名 | 类型 | 说明 | 可选值 |
|--------|------|------|---------|
| NodeDesignate | 字符串 | 执行权限类型 | SPECIAL_ROLE：指定角色<br>SPECIAL_USER：指定用户<br>SPECIAL_SQL：指定SQL<br>RUNTIME_SPECIAL_ROLE：运行时指定角色<br>RUNTIME_SPECIAL_USER：运行时指定用户 |
| NodeDesignateData | 对象 | 执行权限数据 | - |
| NodeDesignateData.datas | 数组 | 执行权限数据 | - |
| NodeDesignateData.Texts | 字符串 | 执行权限数据 | - |

##### 其他配置

| 属性名 | 类型 | 说明 |
|--------|------|------|
| ThirdPartyUrl | 字符串 | 执行完成后回调地址 |
| CanWriteFormItemIds | 数组 | 可写表单项id |


## 流程实例

流程实例指正在运行的一个流程。数据存放在FlowInstance表中，该表核心字段如下：

### IsFinish：流程的当前状态

- -1 草稿/召回：流程发起人主动召回流程；

- 0 正在运行；

- 1 完成：流程结束，同时所有的审批都通过；

- 3 不同意：即流程结束，同时审批人员没有通过；

- 4 驳回：流程结束，可能发起的流程内容有问题，要求被驳回重新提交；


### ActivityId: 当前活动节点，即待审批的节点

与流程实例密切相关的还有：流程实例的操作记录FlowInstanceOperationHistory。

## 操作记录FlowInstanceOperationHistory
该表记录了流程实例的所有操作记录，包括流程的创建、撤回、驳回、同意、不同意等操作。
