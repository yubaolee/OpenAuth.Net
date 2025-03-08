using OpenAuth.Repository.Domain;

namespace OpenAuth.App.Response
{
    public class FlowVerificationResp :FlowInstance
    {
        /// <summary>
        /// 预览表单数据
        /// </summary>
        public string FrmPreviewHtml
        {
            get { return FormUtil.Preview(this); }
        }

        /// <summary>
        /// 预览表单数据表单项包含读写控制权限）
        /// </summary>
        public string FrmHtml
        {
            get
            {
                if (this.FrmType != 0)  //只有开原版动态表单才需要转换
                {
                    return string.Empty;
                }

                return FormUtil.GetHtml(this.FrmContentData, this.FrmContentParse, this.FrmData, "",this.CanWriteFormItemIds);
            }
        }
        
        /// <summary>
        /// 下个节点的执行权限方式
        /// </summary>
        public string NextNodeDesignateType { get; set; }
        
        /// <summary>
        /// 当前节点的可写表单Id
        /// </summary>
        public string[] CanWriteFormItemIds { get; set; }
        
        /// <summary>
        /// 是否可以撤销审核
        ///<param>流程最后一个已审批节点的审批人是当前登录人</param>
        /// </summary>
        public bool CanUndoVerify { get; set; }

        /// <summary>
        /// 是否可以审核
        ///<param>待审批的节点需要当前登录人审批</param>
        /// </summary>
        public bool CanVerify{ get; set; }
    }
}
