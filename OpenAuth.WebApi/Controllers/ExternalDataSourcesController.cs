using System;
using System.Threading.Tasks;
using Infrastructure;
using Microsoft.AspNetCore.Mvc;
using OpenAuth.App;
using OpenAuth.App.Request;
using OpenAuth.App.Response;
using OpenAuth.Repository.Domain;

namespace OpenAuth.WebApi.Controllers
{
    /// <summary>
    /// 外部数据源管理接口
    /// </summary>
    [Route("api/[controller]/[action]")]
    [ApiController]
    [ApiExplorerSettings(GroupName = "外部数据源管理接口_ExternalDataSources")]
    public class ExternalDataSourcesController : ControllerBase
    {
        private readonly ExtDataSourceApp _app;
        
        //获取详情
        [HttpGet]
        public Response<ExternalDataSource> Get(string id)
        {
            var result = new Response<ExternalDataSource>();
            try
            {
                result.Data = _app.Get(id);
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        //添加
       [HttpPost]
        public Response Add([FromBody]AddOrUpdateExternalDataSourceReq obj)
        {
            var result = new Response();
            try
            {
                _app.Add(obj);

            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        //测试连接
       [HttpPost]
        public Response TestConnection([FromBody]TestConnectionReq obj)
        {
            var result = new Response();
            try
            {
                _app.TestConnection(obj);

            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        //修改
       [HttpPost]
        public Response Update([FromBody]AddOrUpdateExternalDataSourceReq obj)
        {
            var result = new Response();
            try
            {
                _app.Update(obj);

            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        /// <summary>
        /// 加载列表
        /// </summary>
        [HttpGet]
        public async Task<PagedDynamicDataResp> Load([FromQuery]QueryExternalDataSourceListReq request)
        {
            return await _app.Load(request);
        }

        /// <summary>
        /// 获取数据库类型
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public PagedDynamicDataResp GetDbTypes()
        {
            
            return _app.GetDbTypes();
        }

        /// <summary>
        /// 批量删除
        /// </summary>
       [HttpPost]
        public Response Delete([FromBody]string[] ids)
        {
            var result = new Response();
            try
            {
                _app.Delete(ids);

            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        public ExternalDataSourcesController(ExtDataSourceApp app) 
        {
            _app = app;
        }
    }
}
