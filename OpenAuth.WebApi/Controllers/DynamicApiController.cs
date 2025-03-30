using System;
using System.Threading.Tasks;
using Infrastructure;
using Microsoft.AspNetCore.Mvc;
using OpenAuth.App;
using OpenAuth.App.Response;
using OpenAuth.App.Request;
using Microsoft.AspNetCore.Authorization;

namespace OpenAuth.WebApi.Controllers
{
    /// <summary>
    /// 动态API控制器
    /// 用于处理任意表的CRUD操作及直接调用OpenAuth.App的各种应用
    /// </summary>
    [Route("api/dynamic/[action]")]
    [ApiController]
    [ApiExplorerSettings(GroupName = "动态API_DynamicApi")]
    public class DynamicApiController : ControllerBase
    {
        private readonly DynamicApiApp _app;

        public DynamicApiController(DynamicApiApp app)
        {
            _app = app;
        }



        /// <summary>
        /// 获取表数据列表
        /// </summary>
        /// <param name="req">查询参数</param>
        /// <returns></returns>
        [HttpPost]
        [AllowAnonymous]
        public async Task<TableData> GetList([FromBody] QueryDynamicListReq req)
        {
            TableData result = new TableData();
            try
            {
                // 获取实体类型
                result = await _app.GetList(req);
            }
            catch (Exception ex)
            {
                result.code = 500;
                result.msg = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        /// <summary>
        /// 获取表数据详情
        /// </summary>
        /// <param name="req">查询参数</param>
        /// <returns></returns>
        [HttpPost]
        [AllowAnonymous]
        public async Task<Response<object>> Get([FromBody] QueryDynamicEntityReq req)
        {
            var result = new Response<object>();
            try
            {
                // 获取实体类型
                result = await _app.Get(req);
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        /// <summary>
        /// 添加表数据
        /// </summary>
        /// <param name="req">添加参数</param>
        /// <returns></returns>
        [HttpPost]
        [AllowAnonymous]
        public async Task<Response> Add([FromBody] AddOrUpdateDynamicEntityReq req)
        {
            var result = new Response();
            try
            {
                // 获取实体类型
                result = await _app.Add(req);
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        /// <summary>
        /// 更新实体
        /// </summary>
        /// <param name="entityName">实体名称，例如：ExternalDataSource</param>
        /// <param name="obj">实体对象</param>
        /// <returns></returns>
        [HttpPost]
        [AllowAnonymous]
        public async Task<Response> Update([FromBody] AddOrUpdateDynamicEntityReq req)
        {
            var result = new Response();
            try
            {
                // 获取实体类型
                result = await _app.Update(req);
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        /// <summary>
        /// 批量删除实体
        /// </summary>
        /// <param name="entityName">实体名称，例如：ExternalDataSource</param>
        /// <param name="ids">实体ID数组</param>
        /// <returns></returns>
        [HttpPost]
        [AllowAnonymous]
        public async Task<Response> Delete([FromBody] DelDynamicReq req)
        {
            var result = new Response();
            try
            {
                result = await _app.Delete(req);
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        /// <summary>
        /// 直接调用OpenAuth.App的各种应用
        /// </summary>
        /// <param name="req">调用参数</param>
        /// <returns></returns>
        [HttpPost]
        [AllowAnonymous]
        public Response<object> Invoke([FromBody] InvokeDynamicReq req)
        {
            var result = new Response<object>();
            try
            {
                result.Result = _app.Invoke(req);
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }
    }


}