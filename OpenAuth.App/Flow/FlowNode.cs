namespace OpenAuth.App.Flow
{
    /// <summary>
    /// 流程节点
    /// </summary>
    public class FlowNode
    {

        public string id { get; set; }

        public string name { get; set; }

        public string type { get; set; }

        public int left { get; set; }
        public int top { get; set; }

        public int width { get; set; }
        public int height { get; set; }
        public bool alt { get; set; }

        /// <summary>
        /// 节点的附加数据项
        /// </summary>
        public Setinfo setInfo { get; set; }
    }

    public class Setinfo
    {
       
        /// <summary>
        /// 节点执行权限类型
        /// </summary>
        public string NodeDesignate { get; set; }

        public Nodedesignatedata NodeDesignateData { get; set; }
        public string NodeCode { get; set; }
        public string NodeName { get; set; }

        /// <summary>
        ///  流程执行时，三方回调的URL地址
        /// </summary>
        public string ThirdPartyUrl { get; set; }

        /// <summary>
        /// 驳回节点0"前一步"1"第一步"2"某一步" 3"不处理"
        /// </summary>
        public string NodeRejectType { get; set; }

        public int? Taged { get; set; }
        public string UserName { get; set; }
        public string UserId { get; set; }
        public string Description { get; set; }
        public string TagedTime { get; set; }

        //网关审批通过的方式，
        //all/空：默认为全部通过
        //one ：至少有一个通过
        public string NodeConfluenceType { get; set; }

        /// <summary>
        /// 网关通过的个数
        /// </summary>
        public int? ConfluenceOk { get; set; }

        /// <summary>
        /// 网关拒绝的个数
        /// </summary>
        public int? ConfluenceNo { get; set; }
        
        /// <summary>
        /// 可写的表单项ID
        /// </summary>
        public string[] CanWriteFormItemIds { get; set; }
    }

    /// <summary>
    /// 节点执行人
    /// <para>
    /// 用一个类封装，因为datas存的是id,前端需要在类里面加一个Texts字段，用于显示具体的人或角色等
    /// </para>
    /// </summary>
    public class Nodedesignatedata
    {
        public string[] datas { get; set; }
    }

    /// <summary>
    /// 节点执行结果标签
    /// </summary>
    public class Tag
    {
        /// <summary>
        ///  1: 通过
        ///  2：不通过
        ///  3：驳回
        /// </summary>
        public int Taged { get; set; }

        public string UserId { get; set; }
        public string UserName { get; set; }
        public string Description { get; set; }
        public string TagedTime { get; set; }
    }

    /// <summary>
    ///  1: 通过
    ///  2：不通过
    ///  3：驳回
    /// </summary>
    public enum TagState
    {
        Ok = 1,
        No,
        Reject
    }
}