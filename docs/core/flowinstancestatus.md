# 流程实例

流程实例指正在运行的一个流程。数据存放在FlowInstance表中，该表核心字段如下：

#### IsFinish：流程的当前状态

- -1 草稿/召回：流程发起人主动召回流程；

- 0 正在运行；

- 1 完成：流程结束，同时所有的审批都通过；

- 3 不同意：即流程结束，同时审批人员没有通过；

- 4 驳回：流程结束，可能发起的流程内容有问题，要求被驳回重新提交；


#### ActivityId: 当前活动节点，即待审批的节点

#### ActivityType：当前节点的类型

- -1 无法运行,

- 0 会签开始,

- 1 会签结束,

- 2 一般节点,

- 3 开始节点，

- 4 流程运行结束

#### SchemeContent：流程实例的具体内容

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
                "NodeRejectType": 0, //节点驳回类型：0-不驳回，1-驳回
                "NodeConfluenceType": "", //节点会签/网关类型：""-不会签，"AND"-与，"OR"-或
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
            "from": "start round mix-3fcaf7e8577644ff8b52fabaf975437e",
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
            "to": "end round-a749ef5b89bb49d588009b71f53316f5",
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
其中：nodes为流程实例的所有节点。lines为流程实例的所有连线。节点的type属性为节点的类型属性，对应上面提到的ActivityType：

- -1：无法运行；

- 0：会签开始，即type为：‘fork’；

- 1：会签结束,即type为：’join’；

- 2：一般节点,即type为：’node’；

- 3：开始节点,即type为：‘start’；

- 4：流程运行结束，即type为’end’；

与流程实例密切相关的还有两个表：流程实例的操作记录FlowInstanceOperationHistory及流转记录FlowInstanceTransitionHistory。它们有不同的作用：

### 操作记录FlowInstanceOperationHistory
该表记录了流程实例的所有操作记录，包括流程的创建、撤回、驳回、同意、不同意等操作。

### 流转记录FlowInstanceTransitionHistory
记录某个流程实例所有已审批的从一个活动节点到下一个活动节点的操作人、操作时间。