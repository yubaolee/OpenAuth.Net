namespace OpenAuth.App.Request
{
    public class PageReq
    {
        /// <summary>
        /// 页码
        /// </summary>
        /// <example>1</example>
        public int page { get; set; }
        /// <summary>
        /// 每页条数
        /// </summary>
        /// <example>10</example>
        public int limit { get; set; }

        public string key { get; set; }

        /// <summary>
        /// 排序字段
        /// </summary>
        /// <example>sort=id,asc</example>
        public string sort { get; set; }

        /// <summary>
        /// 自定义sql条件
        /// </summary>
        public string sqlWhere { get; set; }

        public PageReq()
        {
            page = 1;
            limit = 10;
        }
    }
}
