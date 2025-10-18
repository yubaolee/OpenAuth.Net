using Infrastructure;
using Newtonsoft.Json.Linq;
using OpenAuth.Repository.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using Castle.Core.Internal;
using Infrastructure.Const;
using Infrastructure.Extensions;
using Infrastructure.Extensions.AutofacManager;
using Infrastructure.Helpers;
using OpenAuth.App.Interface;
using OpenAuth.App.Request;
using SqlSugar;
using Microsoft.Extensions.Configuration;
using Infrastructure.Helpers;

namespace OpenAuth.App.Flow
{
    /// <summary>
    /// 一个正在运行中的流程实例
    /// <para>该类只能通过new实例化，禁止通过容器获取</para>
    /// </summary>
    public class FlowRuntime
    {
        public FlowRuntime(FlowInstance instance)
        {
            flowInstance = instance;
            dynamic schemeContentJson = instance.SchemeContent.ToJson(); //获取工作流模板内容的json对象;

            InitLines(schemeContentJson);
            InitNodes(schemeContentJson);

            currentNodeId = instance.ActivityId == "" ? startNodeId : instance.ActivityId;
            FrmData = instance.FrmData;
            title = schemeContentJson.title;
            initNum = schemeContentJson.initNum ?? 0;
            previousId = instance.PreviousId;
            flowInstanceId = instance.Id;

            //网关开始节点和流程结束节点没有下一步
            if (GetCurrentNodeType() == Define.NODE_TYPE_FORK
            || GetCurrentNodeType() == Define.NODE_TYPE_END)
            {
                nextNodeId = "-1";
            }
            else
            {
                nextNodeId = GetNextNodeId(); //下一个节点
            }
        }

        #region 私有方法

        /// <summary>
        /// 获取工作流节点的字典列表:key节点id
        /// </summary>
        /// <param name="schemeContentJson"></param>
        /// <returns></returns>
        private void InitNodes(dynamic schemeContentJson)
        {
            Nodes = new Dictionary<string, FlowNode>();
            foreach (JObject item in schemeContentJson.nodes)
            {
                var node = item.ToObject<FlowNode>();
                if (!Nodes.ContainsKey(node.id))
                {
                    Nodes.Add(node.id, node);
                }

                if (node.type == Define.NODE_TYPE_START)
                {
                    this.startNodeId = node.id;
                }
            }
        }

        private void InitLines(dynamic schemeContentJson)
        {
            Lines = new List<FlowLine>();
            FromNodeLines = new Dictionary<string, List<FlowLine>>();
            ToNodeLines = new Dictionary<string, List<FlowLine>>();
            foreach (JObject item in schemeContentJson.lines)
            {
                var line = item.ToObject<FlowLine>();
                Lines.Add(line);

                if (!FromNodeLines.ContainsKey(line.from))
                {
                    List<FlowLine> d = new List<FlowLine> { line };
                    FromNodeLines.Add(line.from, d);
                }
                else
                {
                    FromNodeLines[line.from].Add(line);
                }

                if (!ToNodeLines.ContainsKey(line.to))
                {
                    List<FlowLine> d = new List<FlowLine> { line };
                    ToNodeLines.Add(line.to, d);
                }
                else
                {
                    ToNodeLines[line.to].Add(line);
                }
            }
        }

        /// <summary>
        /// 获取下一个节点
        /// </summary>
        private string GetNextNodeId(string nodeId = null)
        {
            var lines = nodeId == null ? FromNodeLines[currentNodeId] : FromNodeLines[nodeId];
            if (lines.Count == 0)
            {
                throw new Exception("无法寻找到下一个节点");
            }

            //URL表单暂时不支持URL表单
            if (flowInstance.FrmType == Define.FORM_TYPE_URL) return lines[0].to;

            if (FrmData == "" || FrmData == "{}") return lines[0].to;

            var frmDataJson = FrmData.ToJObject(); //获取数据内容
            // 将frmDataJson中的所有key转小写
            var properties = frmDataJson.Properties().ToList();
            foreach (var property in properties)
            {
                frmDataJson[property.Name.ToLower()] = property.Value;
                frmDataJson.Remove(property.Name);
            }

            foreach (var l in lines)
            {
                if (!l.Compares.IsNullOrEmpty() && l.Compare(frmDataJson))
                {
                    return l.to;
                }
            }

            return lines[0].to;
        }

        #endregion 私有方法

        #region 共有方法

        /// <summary>
        /// 判断流程是否完成
        /// </summary>
        public bool IsFinish()
        {
            return GetNextNodeType() == Define.NODE_TYPE_END;
        }

        //获取下一个节点
        public FlowNode GetNextNode(string nodeId = null)
        {
            return Nodes[GetNextNodeId(nodeId)];
        }

        /// <summary>
        /// 获取实例接下来运行的节点类型
        /// </summary>
        public string GetNextNodeType()
        {
            if (nextNodeId != "-1")
            {
                return GetNodeType(nextNodeId);
            }
            return Define.NODE_TYPE_END;
        }

        /// <summary>
        /// 获取节点类型
        /// </summary>
        /// <param name="nodeId"></param>
        /// <returns></returns>
        public string GetNodeType(string nodeId)
        {
            return Nodes[nodeId].type;
        }

        /// <summary>
        /// 获取当前节点类型
        /// </summary>
        /// <returns></returns>
        public string GetCurrentNodeType()
        {
            return GetNodeType(currentNodeId);
        }

        /// <summary>
        /// 审批网关开始节点
        /// </summary>
        /// <param name="nodeId">currentNodeId是网关开始节点。这个表示当前正在处理的节点</param>
        /// <param name="tag"></param>
        /// <returns>-1不通过,1等待,其它通过</returns>
        public string VerifyGatewayStart(HttpClient httpClient, Tag tag)
        {
            var user = AutofacContainerModule.GetService<IAuth>().GetCurrentUser().User;
            //审批网关时的【当前节点】一直是网关开始节点
            //TODO: 标记网关节点的状态，这个地方感觉怪怪的
            MakeTagNode(currentNodeId, tag);

            string canCheckId = ""; //寻找当前登录用户可审核的节点Id
            foreach (string fromForkStartNodeId in FromNodeLines[currentNodeId]
                         .Select(u => u.to))
            {
                var fromForkStartNode = Nodes[fromForkStartNodeId]; //与网关开始节点直接连接的节点
                canCheckId = GetOneForkLineCanCheckNodeId(fromForkStartNode, tag);
                if (!string.IsNullOrEmpty(canCheckId)) break;
            }

            if (canCheckId == "")
            {
                throw new Exception("审核异常,找不到审核节点");
            }

            var content =
                $"{user.Account}-{TimeHelper.Now:yyyy-MM-dd HH:mm}审批了【{Nodes[canCheckId].name}】" +
                $"结果：{(tag.Taged == 1 ? "同意" : "不同意")}，备注：{tag.Description}";
            SaveOperationHis(content);

            MakeTagNode(canCheckId, tag); //标记审核节点状态

            var forkNode = Nodes[currentNodeId]; //网关开始节点
            FlowNode nextNode = GetNextNode(canCheckId); //获取当前处理的下一个节点

            int forkNumber = FromNodeLines[currentNodeId].Count; //直接与网关节点连接的点，即网关分支数目
            string gatewayResult = string.Empty; //记录网关审批的的结果,为空表示仍然在网关内部处理
            if (forkNode.setInfo.NodeConfluenceType == "one") //有一个步骤通过即可
            {
                if (tag.Taged == (int)TagState.Ok)
                {
                    if (nextNode.type == Define.NODE_TYPE_JOIN) //下一个节点是网关结束，则该线路结束
                    {
                        gatewayResult = GetNextNodeId(nextNode.id);
                    }
                }
                else if (tag.Taged == (int)TagState.No)
                {
                    if (forkNode.setInfo.ConfluenceNo == null)
                    {
                        forkNode.setInfo.ConfluenceNo = 1;
                    }
                    else if (forkNode.setInfo.ConfluenceNo == (forkNumber - 1))
                    {
                        gatewayResult = TagState.No.ToString("D");
                    }
                    else
                    {
                        bool isFirst = true; //是不是从网关开始到现在第一个
                        var preNode = GetPreNode(canCheckId);
                        while (preNode.id != forkNode.id) //反向一直到网关开始节点
                        {
                            if (preNode.setInfo != null && preNode.setInfo.Taged == (int)TagState.No)
                            {
                                isFirst = false;
                                break;
                            }
                        }

                        if (isFirst)
                        {
                            forkNode.setInfo.ConfluenceNo++;
                        }
                    }
                }
            }
            else //所有步骤通过
            {
                if (tag.Taged == (int)TagState.No) //只要有一个不同意，那么流程就结束
                {
                    gatewayResult = TagState.No.ToString("D");
                }
                else if (tag.Taged == (int)TagState.Ok)
                {
                    if (nextNode.type == Define.NODE_TYPE_JOIN) //这种模式下只有坚持到【网关结束】节点之前才有意义，是否需要判定这条线所有的节点都通过，不然直接执行这个节点？？
                    {
                        if (forkNode.setInfo.ConfluenceOk == null)
                        {
                            forkNode.setInfo.ConfluenceOk = 1;
                        }
                        else if (forkNode.setInfo.ConfluenceOk == (forkNumber - 1)) //网关成功
                        {
                            gatewayResult = GetNextNodeId(nextNode.id);
                        }
                        else
                        {
                            forkNode.setInfo.ConfluenceOk++;
                        }
                    }
                }
            }

            if (gatewayResult == TagState.No.ToString("D"))
            {
                tag.Taged = (int)TagState.No;
                MakeTagNode(nextNode.id, tag);
            }
            else if (!string.IsNullOrEmpty(gatewayResult)) //网关结束，标记合流节点
            {
                tag.Taged = (int)TagState.Ok;
                MakeTagNode(nextNode.id, tag);
                nextNodeId = gatewayResult;
            }
            else
            {
                nextNodeId = nextNode.id;
            }

            if (!string.IsNullOrEmpty(gatewayResult)) //网关结束节点配置了回调，则发起通知
            {
                NotifyThirdParty(httpClient, nextNode, tag);
            }

            return gatewayResult;
        }

        //获取上一个节点
        private FlowNode GetPreNode(string nodeId = null)
        {
            var lines = nodeId == null ? ToNodeLines[currentNodeId] : ToNodeLines[nodeId];
            if (lines.Count == 0)
            {
                throw new Exception("无法找到上一个点");
            }

            return Nodes[lines[0].from];
        }

        /// <summary>
        /// 驳回
        /// </summary>
        /// <returns></returns>
        public void RejectNode(HttpClient client, VerificationReq reqest)
        {
            //默认驳回到指定节点
            string rejectNode = reqest.NodeRejectStep;

            //如果不是指定到节点
            if (string.IsNullOrEmpty(rejectNode))
            {
                string rejectType = reqest.NodeRejectType;
                dynamic node = Nodes[currentNodeId];
                if (node.setInfo != null && string.IsNullOrEmpty(reqest.NodeRejectType))
                {
                    rejectType = node.setInfo.NodeRejectType;
                }

                if (rejectType == "0") //前一步
                {
                    rejectNode = previousId;
                }

                if (rejectType == "1") //第一步
                {
                    rejectNode = GetNextNodeId(startNodeId);
                }
            }

            var user = AutofacContainerModule.GetService<IAuth>().GetCurrentUser().User;
            var tag = new Tag
            {
                Description = reqest.VerificationOpinion,
                Taged = (int)TagState.Reject,
                UserId = user.Id,
                UserName = user.Name
            };

            MakeTagNode(currentNodeId, tag);
            flowInstance.IsFinish = FlowInstanceStatus.Rejected; //4表示驳回（需要申请者重新提交表单）
            if (rejectNode != "")
            {
                flowInstance.PreviousId = flowInstance.ActivityId;
                flowInstance.ActivityId = rejectNode;
                flowInstance.ActivityName = Nodes[rejectNode].name;
                flowInstance.MakerList =
                    GetNodeMarkers(Nodes[rejectNode], flowInstance.CreateUserId);
            }

            flowInstance.SchemeContent = JsonHelper.Instance.Serialize(ToSchemeObj());

            var sugarClient = AutofacContainerModule.GetService<ISqlSugarClient>();
            sugarClient.Updateable(flowInstance).ExecuteCommand();

            SaveOperationHis(
                $"{user.Account}-{TimeHelper.Now.ToString("yyyy-MM-dd HH:mm")}驳回了【{currentNode.name}】");

            NotifyThirdParty(client, currentNode, tag);
        }

        /// <summary>
        /// 撤销流程，清空所有节点
        /// </summary>
        public void ReCall(RecallFlowInstanceReq request)
        {
            foreach (var item in Nodes)
            {
                item.Value.setInfo = null;
            }

            flowInstance.IsFinish = FlowInstanceStatus.Draft;
            flowInstance.PreviousId = flowInstance.ActivityId;
            flowInstance.ActivityId = startNodeId;
            flowInstance.ActivityName = Nodes[startNodeId].name;
            flowInstance.MakerList = GetNodeMarkers(Nodes[startNodeId], flowInstance.CreateUserId);

            var sugarClient = AutofacContainerModule.GetService<ISqlSugarClient>();
            sugarClient.Updateable(flowInstance).ExecuteCommand();

            SaveOperationHis($"【撤回】备注：{request.Description}");

            sugarClient.Ado.CommitTran();
        }

        ///<summary>
        /// 标记节点1通过，-1不通过，0驳回
        /// </summary>
        /// <param name="nodeId"></param>
        public void MakeTagNode(string nodeId, Tag tag)
        {
            foreach (var item in Nodes)
            {
                if (item.Key == nodeId)
                {
                    if (item.Value.setInfo == null)
                    {
                        item.Value.setInfo = new Setinfo();
                    }

                    item.Value.setInfo.Taged = tag.Taged;
                    item.Value.setInfo.UserId = tag.UserId;
                    item.Value.setInfo.UserName = tag.UserName;
                    item.Value.setInfo.Description = tag.Description;
                    item.Value.setInfo.TagedTime = TimeHelper.Now.ToString("yyyy-MM-dd HH:mm");
                    break;
                }
            }
        }

        public object ToSchemeObj()
        {
            return new
            {
                title = this.title,
                initNum = this.initNum,
                lines = Lines,
                nodes = Nodes.Select(u => u.Value),
                areas = new string[0]
            };
        }

        public void SaveOperationHis(string userId, string userName, string opHis)
        {
            FlowInstanceOperationHistory flowInstanceOperationHistory = new FlowInstanceOperationHistory
            {
                InstanceId = flowInstanceId,
                CreateUserId = userId,
                CreateUserName = userName,
                CreateDate = TimeHelper.Now,
                Content = opHis
            }; //操作记录

            var SugarClient = AutofacContainerModule.GetService<ISqlSugarClient>();
            SugarClient.Insertable(flowInstanceOperationHistory).ExecuteCommand();
        }

        /// <summary>
        /// 添加工作流实例操作记录
        /// <para>操作人为当前的登录用户</para>
        /// </summary>
        /// <param name="opHis"></param>
        public void SaveOperationHis(string opHis)
        {
            var user = AutofacContainerModule.GetService<IAuth>().GetCurrentUser().User;
            SaveOperationHis(user.Id, user.Name, opHis);
        }

        /// <summary>
        /// 通知三方系统，节点执行情况
        /// </summary>
        public void NotifyThirdParty(HttpClient client, FlowNode node, Tag tag)
        {
            if (node.setInfo == null || string.IsNullOrEmpty(node.setInfo.ThirdPartyUrl))
            {
                return;
            }

            var postData = new
            {
                flowInstanceId,
                businessId = flowInstance.BusinessId,
                nodeName = node.name,
                nodeId = node.id,
                userId = tag.UserId,
                userName = tag.UserName,
                result = tag.Taged, //1：通过;2：不通过；3驳回
                description = tag.Description,
                execTime = tag.TagedTime,
                isFinish = node.type == Define.NODE_TYPE_END
            };

            var url = node.setInfo.ThirdPartyUrl;
            // 如果是相对路径，需要获取当前应用的基础URL
            if (!url.StartsWith("http://") && !url.StartsWith("https://"))
            {
                var appConfig = AutofacContainerModule.GetService<IConfiguration>();
                var baseUrl = appConfig.GetValue<string>("AppSetting:HttpHost")?.TrimEnd('/');
                if (string.IsNullOrEmpty(baseUrl))
                {
                    return;
                }
                url = $"{baseUrl}/{url.TrimStart('/')}";
            }

            using (HttpContent httpContent = new StringContent(JsonHelper.Instance.Serialize(postData), Encoding.UTF8))
            {
                httpContent.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/json");
                client.PostAsync(url, httpContent);
            }
        }

        /// <summary>
        /// 撤销当前节点的审批
        /// </summary>
        public void UndoVerification()
        {
            // 已结束的流程不能撤销
            if (flowInstance.IsFinish == FlowInstanceStatus.Finished
                || flowInstance.IsFinish == FlowInstanceStatus.Rejected)
            {
                throw new Exception("流程已结束，不能撤销");
            }

            if (Nodes[previousId].type == Define.NODE_TYPE_START)
            {
                throw new Exception("没有任何审批，不能撤销!你可以删除或召回这个流程");
            }

            // 恢复到上一个节点
            currentNodeId = flowInstance.PreviousId;
            flowInstance.ActivityId = currentNodeId;
            flowInstance.ActivityName = Nodes[currentNodeId].name;
            //向前查找ActivityId的前一个结点，即连线指向ActivityId的节点
            flowInstance.PreviousId = GetPreNode().id;
            flowInstance.MakerList = GetNodeMarkers(Nodes[currentNodeId]);

            // 清除当前节点的审批状态
            currentNode.setInfo.Taged = null;
            currentNode.setInfo.UserId = "";
            currentNode.setInfo.UserName = "";
            currentNode.setInfo.Description = "";
            currentNode.setInfo.TagedTime = "";

            //删除当前节点的审批记录(只删除最新的一条)
            var user = AutofacContainerModule.GetService<IAuth>().GetCurrentUser().User;
            var SugarClient = AutofacContainerModule.GetService<ISqlSugarClient>();
            
            var latestRecord = SugarClient.Queryable<FlowInstanceOperationHistory>()
                .Where(u => u.InstanceId == flowInstanceId && u.CreateUserId == user.Id)
                .OrderByDescending(u => u.CreateDate)
                .First();
            if (latestRecord != null)
            {
                SugarClient.Deleteable<FlowInstanceOperationHistory>()
                    .Where(u => u.Id == latestRecord.Id)
                    .ExecuteCommand();
            }
        }

        #endregion 共有方法

        #region 获取节点审批人

        /// <summary>
        /// 寻找下一步的执行人
        /// 一般用于本节点审核完成后，修改流程实例的当前执行人，可以做到通知等功能
        /// </summary>
        /// <returns></returns>
        public string GetNextMakers(NodeDesignateReq request = null)
        {
            string makerList = "";
            if (nextNodeId == "-1")
            {
                throw new Exception("无法寻找到下一个节点");
            }

            //如果request为空，则应该是草稿状态变为启动，或为网关节点，使用nextNode的setInfo
            if (request == null)
            {
                request = new NodeDesignateReq
                {
                    NodeDesignateType = nextNode.setInfo.NodeDesignate,
                    NodeDesignates = nextNode.setInfo.NodeDesignateData.datas
                };
            }

            if (GetNextNodeType() == Define.NODE_TYPE_FORK) //如果是网关节点
            {
                makerList = GetForkNodeMakers(nextNodeId);
            }
            else if (GetNextNodeType() == Define.NODE_TYPE_MULTI_INSTANCE) //如果是多实例、会签节点
            {
                makerList = GetMultiInstanceNodeMakers(nextNodeId);
            }
            else if (nextNode.setInfo.NodeDesignate == Define.RUNTIME_SPECIAL_ROLE)
            {
                //如果是运行时指定角色
                if (nextNode.setInfo.NodeDesignate != request.NodeDesignateType)
                {
                    throw new Exception("前端提交的节点权限类型异常，请检查流程");
                }

                var revelanceApp = AutofacContainerModule.GetService<RevelanceManagerApp>();
                var users = revelanceApp.Get(Define.USERROLE, false, request.NodeDesignates);
                makerList = GenericHelpers.ArrayToString(users, makerList);
            }
            else if (nextNode.setInfo.NodeDesignate == Define.RUNTIME_SPECIAL_USER)
            {
                //如果是运行时指定用户
                if (nextNode.setInfo.NodeDesignate != request.NodeDesignateType)
                {
                    throw new Exception("前端提交的节点权限类型异常，请检查流程");
                }

                makerList = GenericHelpers.ArrayToString(request.NodeDesignates, makerList);
            }
            else if (nextNode.setInfo.NodeDesignate == Define.SPECIAL_SQL)
            {
                //如果是指定SQL
                if (nextNode.setInfo.NodeDesignate != request.NodeDesignateType)
                {
                    throw new Exception("前端提交的节点权限类型异常，请检查流程");
                }

                var sql = ReplaceSql(nextNode.setInfo.NodeDesignateData.datas[0]);
                var sugarClient = AutofacContainerModule.GetService<ISqlSugarClient>();
                var result = sugarClient.Ado.SqlQuery<string>(sql);
                makerList = GenericHelpers.ArrayToString(result, makerList);
            }
            else if (nextNode.setInfo.NodeDesignate == Define.RUNTIME_PARENT
                     || nextNode.setInfo.NodeDesignate == Define.RUNTIME_MANY_PARENTS)
            {
                //如果是上一节点执行人的直属上级或连续多级直属上级
                if (nextNode.setInfo.NodeDesignate != request.NodeDesignateType)
                {
                    throw new Exception("前端提交的节点权限类型异常，请检查流程");
                }

                //当创建流程时，肯定执行的开始节点，登录用户就是创建用户
                //当审批流程时，能进到这里，表明当前登录用户已经有审批当前节点的权限，完全可以直接用登录用户的直接上级
                var userManagerApp = AutofacContainerModule.GetService<UserManagerApp>();
                var user = AutofacContainerModule.GetService<IAuth>().GetCurrentUser().User;
                var parentId = userManagerApp.GetParent(user.Id);
                if (StringExtension.IsNullOrEmpty(parentId))
                {
                    throw new Exception("无法找到当前用户的直属上级");
                }

                makerList = GenericHelpers.ArrayToString(new[] { parentId }, makerList);
            }
            else if (nextNode.setInfo.NodeDesignate == Define.RUNTIME_CHAIRMAN)
            {
                //如果是发起人的部门负责人
                if (nextNode.setInfo.NodeDesignate != request.NodeDesignateType)
                {
                    throw new Exception("前端提交的节点权限类型异常，请检查流程");
                }

                var orgManagerApp = AutofacContainerModule.GetService<OrgManagerApp>();
                var chairmanIds = orgManagerApp.GetChairmanId(nextNode.setInfo.NodeDesignateData.datas);
                makerList = GenericHelpers.ArrayToString(chairmanIds, makerList);
            }
            else
            {
                makerList = GetNodeMarkers(nextNode);
                if (string.IsNullOrEmpty(makerList))
                {
                    throw new Exception("无法寻找到节点的审核者,请查看流程设计是否有问题!");
                }
            }

            return makerList;
        }

        /// <summary>           
        /// 计算多实例、会签节点的执行人
        /// </summary>
        /// <param name="nodeId"></param>
        /// <returns></returns>
        private string GetMultiInstanceNodeMakers(string nodeId)
        {
            if (GetNodeType(nodeId) != Define.NODE_TYPE_MULTI_INSTANCE)
            {
                throw new Exception("当前节点不是会签节点，请联系管理员");
            }

            var node = Nodes[nodeId];
            string[] makerList = Array.Empty<string>(); // 执行人列表
            var sugarClient = AutofacContainerModule.GetService<ISqlSugarClient>();

            if (node.setInfo.NodeDesignate == Define.SPECIAL_USER) //指定用户
            {
                makerList = node.setInfo.NodeDesignateData.datas;
            }
            else if (node.setInfo.NodeDesignate == Define.SPECIAL_ROLE) //指定角色
            {
                var revelanceApp = AutofacContainerModule.GetService<RevelanceManagerApp>();
                makerList = revelanceApp.Get(Define.USERROLE, false, node.setInfo.NodeDesignateData.datas).ToArray();
            }
            else if (node.setInfo.NodeDesignate == Define.SPECIAL_SQL) //指定SQL
            {
                //如果是指定SQL，则需要执行SQL，并返回结果
                var sql = ReplaceSql(node.setInfo.NodeDesignateData.datas[0]);

                makerList = sugarClient.Ado.SqlQuery<string>(sql).ToArray();
            }
            else
            {
                throw new Exception("会签节点，不支持该类型，请重新设计流程模板");
            }

            //将所有的会签人员写入到FlowApprover，后续审批的时候，按加签的逻辑处理
            var users = sugarClient.Queryable<SysUser>()
                .Where(u => makerList.Contains(u.Id))
                .ToList()
                .OrderBy(u => Array.IndexOf(makerList, u.Id))
                .ToList();
            int order = 1;
            foreach (var user in users)
            {
                var flowApprover = new FlowApprover
                {
                    InstanceId = flowInstanceId,
                    ActivityId = nodeId,
                    ApproverId = user.Id,
                    ApproverName = user.Name,
                    OrderNo = order++,
                    ApproveType = node.setInfo.NodeConfluenceType,
                    ReturnToSignNode = false,
                    Reason = "",
                    CreateDate = TimeHelper.Now
                };
                sugarClient.Insertable(flowApprover).ExecuteCommand();
            }
            //如果是顺序执行，取第一个人
            if (node.setInfo.NodeConfluenceType == Define.APPROVE_TYPE_SEQUENTIAL)
            {
                return makerList[0];
            }
            //否则并行且/并行或都是返回所有加签人
            return GenericHelpers.ArrayToString(makerList, "");
        }

        /// <summary>
        /// 这里专门处理由前端选择相关的节点执行人
        /// </summary>
        /// <param name="node"></param>
        /// <returns></returns>
        public string GetNodeMarkers(FlowNode node, string flowinstanceCreateUserId = "")
        {
            string makerList = "";
            if (node.type == Define.NODE_TYPE_START && (!string.IsNullOrEmpty(flowinstanceCreateUserId))) //如果是开始节点，通常情况下是驳回到开始了
            {
                makerList = flowinstanceCreateUserId;
            }
            else if (node.setInfo != null)
            {
                if (string.IsNullOrEmpty(node.setInfo.NodeDesignate) ||
                    node.setInfo.NodeDesignate == Define.ALL_USER) //所有成员
                {
                    makerList = "1";
                }
                else if (node.setInfo.NodeDesignate == Define.SPECIAL_USER) //指定成员
                {
                    makerList = GenericHelpers.ArrayToString(node.setInfo.NodeDesignateData.datas, makerList);
                }
                else if (node.setInfo.NodeDesignate == Define.SPECIAL_ROLE) //指定角色
                {
                    var revelanceApp = AutofacContainerModule.GetService<RevelanceManagerApp>();
                    var users = revelanceApp.Get(Define.USERROLE, false, node.setInfo.NodeDesignateData.datas);
                    makerList = GenericHelpers.ArrayToString(users, makerList);
                }
                else if (node.setInfo.NodeDesignate == Define.SPECIAL_SQL) //指定SQL
                {
                    //如果是指定SQL，则需要执行SQL，并返回结果
                    var sql = ReplaceSql(node.setInfo.NodeDesignateData.datas[0]);
                    var sugarClient = AutofacContainerModule.GetService<ISqlSugarClient>();
                    var result = sugarClient.Ado.SqlQuery<string>(sql);
                    makerList = GenericHelpers.ArrayToString(result, makerList);
                }
                else if (node.setInfo.NodeDesignate == Define.RUNTIME_SPECIAL_ROLE
                         || node.setInfo.NodeDesignate == Define.RUNTIME_SPECIAL_USER)
                {
                    //如果是运行时选定的用户，则暂不处理。由上个节点审批时选定
                }
            }
            else //如果没有设置节点信息，默认所有人都可以审核
            {
                makerList = "1";
            }

            return makerList;
        }

        /// <summary>
        /// 替换SQL中的权限占位符
        /// <para>如当前用户的全部下属：select id from sysuser where parentId = {loginUser}</para>
        /// <para>替换后：select id from sysuser where parentId = '123'</para>
        /// <para>如登录用户同部门的人：select id from sysuser where id in (select firstid from relevance where secondid in ({loginOrg}) and relkey = 'UserOrg')</para>
        /// <para>替换后： select id from sysuser where id in (select firstid from relevance where secondid in ('123','456') and relkey = 'UserOrg')</para>
        /// </summary>
        /// <param name="sql"></param>
        /// <returns></returns>
        private string ReplaceSql(string sql)
        {
            var loginUser = AutofacContainerModule.GetService<IAuth>().GetCurrentUser();
            var res = sql.Replace(Define.DATAPRIVILEGE_LOGINUSER, $"'{loginUser.User.Id}'");
            res = res.Replace(Define.DATAPRIVILEGE_LOGINROLE, string.Join(',', loginUser.Roles.Select(u => $"'{u.Id}'")));
            res = res.Replace(Define.DATAPRIVILEGE_LOGINORG, string.Join(',', loginUser.Orgs.Select(u => $"'{u.Id}'")));
            return res;
        }

        /// <summary>
        /// 网关时，获取一条网关分支上面是否有用户可审核的节点
        /// </summary>
        /// <param name="fromForkStartNode"></param>
        /// <param name="tag"></param>
        /// <returns></returns>
        public string GetOneForkLineCanCheckNodeId(FlowNode fromForkStartNode, Tag tag)
        {
            string canCheckId = "";
            var node = fromForkStartNode;
            do //沿一条分支线路执行，直到遇到网关结束节点
            {
                var makerList = GetNodeMarkers(node);

                if (node.setInfo.Taged == null && !string.IsNullOrEmpty(makerList) &&
                    makerList.Split(',').Any(one => tag.UserId == one))
                {
                    canCheckId = node.id;
                    break;
                }

                node = GetNextNode(node.id);
            } while (node.type != Define.NODE_TYPE_JOIN);

            return canCheckId;
        }

        /// <summary>
        /// 获取网关开始节点的所有可执行者
        /// </summary>
        /// <param name="forkNodeId">网关开始节点</param>
        /// <returns></returns>
        public string GetForkNodeMakers(string forkNodeId)
        {
            string makerList = "";
            foreach (string fromForkStartNodeId in FromNodeLines[forkNodeId].Select(u => u.to))
            {
                var fromForkStartNode = Nodes[fromForkStartNodeId]; //与网关开始节点直接连接的节点
                if (makerList != "")
                {
                    makerList += ",";
                }

                makerList += GetOneForkLineMakers(fromForkStartNode);
            }

            return makerList;
        }

        /// <summary>
        /// 获取网关一条线上的审核者,该审核者应该是已审核过的节点的下一个人
        /// </summary>
        /// <param name="fromForkStartNode">与网关开始节点直接连接的节点</param>
        private string GetOneForkLineMakers(FlowNode fromForkStartNode)
        {
            string markers = "";
            var node = fromForkStartNode;
            do //沿一条分支线路执行，直到遇到第一个没有审核的节点
            {
                if (node.setInfo != null && node.setInfo.Taged != null)
                {
                    if (node.type != Define.NODE_TYPE_FORK && node.setInfo.Taged != (int)TagState.Ok) //如果节点是不同意或驳回，则不用再找了
                    {
                        break;
                    }

                    node = GetNextNode(node.id); //下一个节点
                    continue;
                }

                var marker = GetNodeMarkers(node);
                if (marker == "")
                {
                    throw new Exception($"节点{node.name}没有审核者,请检查!");
                }

                if (marker == "1")
                {
                    throw new Exception($"节点{node.name}是网关节点，不能用所有人,请检查!");
                }

                if (markers != "")
                {
                    markers += ",";
                }

                markers += marker;
                break;
            } while (node.type != Define.NODE_TYPE_JOIN);

            return markers;
        }

        #endregion

        #region 属性

        private FlowInstance flowInstance { get; set; }

        private string title { get; set; }

        private int initNum { get; set; }

        /// <summary>
        /// 运行实例的Id
        /// </summary>
        private string flowInstanceId { get; set; }

        /// <summary>
        /// 上一个节点
        /// </summary>
        private string previousId { get; set; }

        /// <summary>
        /// 实例节点集合
        /// </summary>
        private Dictionary<string, FlowNode> Nodes { get; set; }

        /// <summary>
        /// 流程实例中所有的线段
        /// </summary>
        private List<FlowLine> Lines { get; set; }

        /// <summary>
        /// 从节点发出的线段集合
        /// </summary>
        private Dictionary<string, List<FlowLine>> FromNodeLines { get; set; }

        /// <summary>
        /// 到达节点的线段集合
        /// </summary>
        private Dictionary<string, List<FlowLine>> ToNodeLines { get; set; }

        /// <summary>
        /// 表单数据
        /// </summary>
        private string FrmData { get; set; }

        /// <summary>
        /// 开始节点的ID
        /// </summary>
        private string startNodeId { get; set; }

        /// <summary>
        /// 当前节点的ID
        /// </summary>
        public string currentNodeId { get; set; }

        /// <summary>
        /// 当前节点的对象
        /// </summary>
        public FlowNode currentNode => Nodes[currentNodeId];

        /// <summary>
        /// 下一个节点
        /// </summary>
        public string nextNodeId { get; set; }

        /// <summary>
        /// 下一个节点对象
        /// </summary>
        public FlowNode nextNode => nextNodeId != "-1" ? Nodes[nextNodeId] : null;

        #endregion 属性
    }
}