public class UndoVerificationReq
{
    /// <summary>
    /// 流程实例ID
    /// </summary>
    public string FlowInstanceId { get; set; }

    /// <summary>
    /// 撤销的节点ID
    /// </summary>
    public string NodeId { get; set; }
    
    /// <summary>
    /// 撤销说明
    /// </summary>
    public string Description { get; set; }
} 