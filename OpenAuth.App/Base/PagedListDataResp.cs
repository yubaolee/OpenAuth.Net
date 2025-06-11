using System.Collections.Generic;
using Infrastructure;

namespace OpenAuth.App.Response
{
    /// <summary>
    /// 返回确定类型的表格数据，可以为swagger提供精准的注释
    /// </summary>
    public class PagedListDataResp<T> : Infrastructure.Response
    {
        /// <summary>
        /// 总记录条数
        /// </summary>
        public int Count { get; set; }

        /// <summary>
        /// 数据内容
        /// </summary>
        public List<T> Data { get; set; }
        

        public PagedListDataResp()
        {
            Code = 200;
            Message = "加载成功";
        }
    }
}