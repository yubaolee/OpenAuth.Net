using System;
using System.Threading.Tasks;
using Infrastructure;
using Microsoft.AspNetCore.Mvc;
using OpenAuth.App;
using OpenAuth.App.Response;

namespace OpenAuth.WebApi.Controllers
{
    /// <summary>
    /// 动态实体API控制器
    /// 用于处理任意实体的CRUD操作
    /// </summary>
    [Route("api/dynamic/[action]")]
    [ApiController]
    [ApiExplorerSettings(GroupName = "动态API_DynamicEntity")]
    public class DynamicApiController : ControllerBase
    {
        private readonly DynamicApiApp _app;

        public DynamicApiController(DynamicApiApp app)
        {
            _app = app;
        }

        /// <summary>
        /// 获取实体列表
        /// </summary>
        /// <param name="entityName">实体名称，例如：ExternalDataSource</param>
        /// <param name="page">页码</param>
        /// <param name="limit">每页记录数</param>
        /// <param name="key">搜索关键字</param>
        /// <returns></returns>
        [HttpGet]
        public async Task<TableData> GetList(string entityName, int page = 1, int limit = 10, string key = "")
        {
            TableData result = new TableData();
            try
            {
                // 获取实体类型
                result = await _app.GetList(entityName, page, limit, key);
            }
            catch (Exception ex)
            {
                result.code = 500;
                result.msg = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        /// <summary>
        /// 获取实体详情
        /// </summary>
        /// <param name="entityName">实体名称，例如：ExternalDataSource</param>
        /// <param name="id">实体ID</param>
        /// <returns></returns>
        [HttpGet]
        public Response<object> Get(string entityName, string id)
        {
            var result = new Response<object>();
            try
            {
                // 获取实体类型
                result = _app.Get(entityName, id);
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        /// <summary>
        /// 添加实体
        /// </summary>
        /// <param name="entityName">实体名称，例如：ExternalDataSource</param>
        /// <param name="obj">实体对象</param>
        /// <returns></returns>
        [HttpPost]
        public Response Add(string entityName, [FromBody] object obj)
        {
            var result = new Response();
            try
            {
                // 获取实体类型
                result = _app.Add(entityName, obj);
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
        public Response Update(string entityName, [FromBody] object obj)
        {
            var result = new Response();
            try
            {
                // 获取实体类型
                result = _app.Update(entityName, obj);
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        /// <summary>
        /// 删除实体
        /// </summary>
        /// <param name="entityName">实体名称，例如：ExternalDataSource</param>
        /// <param name="id">实体ID</param>
        /// <returns></returns>
        [HttpPost]
        public Response Delete(string entityName, string id)
        {
            var result = new Response();
            try
            {
                // 获取实体类型
                result = _app.Delete(entityName, id);
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
        public Response BatchDelete(string entityName, [FromBody] string[] ids)
        {
            var result = new Response();
            try
            {
                // 获取实体类型
                result = _app.BatchDelete(entityName, ids);
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