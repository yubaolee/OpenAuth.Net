
namespace OpenAuth.App.Request
{
    public class InvokeDynamicReq
    {
        /// <summary>
        /// 服务名称,如：OpenAuth.App.MoudleApp
        /// </summary>
        public string ServiceName { get; set; }
        
        /// <summary>
        /// 方法名称,如：Add
        /// </summary>
        public string MethodName { get; set; }
        
        /// <summary>
        /// 参数,如：{ "Id": 1, "Name": "test" }
        /// </summary>
        public string Parameters { get; set; }
    }
}
