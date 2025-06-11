using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Infrastructure;
using Microsoft.AspNetCore.Mvc;
using OpenAuth.App;
using OpenAuth.App.Interface;
using OpenAuth.App.Request;
using OpenAuth.App.Response;
using OpenAuth.Repository.Domain;

namespace OpenAuth.WebApi.Controllers
{
    /// <summary>
    /// 三方资源管理（暂时没有业务关联）
    /// </summary>
    [Route("api/[controller]/[action]")]
    [ApiController]
    [ApiExplorerSettings(GroupName = "资源管理_Resources")]
    public class ResourcesController : ControllerBase
    {
        private readonly ResourceApp _app;

        public ResourcesController(ResourceApp app) 
        {
            _app = app;
        }
        [HttpGet]
        public async Task<PagedDynamicDataResp> Load([FromQuery]QueryResourcesReq request)
        {
            return await _app.Load(request);
        }

        /// <summary>
        /// 同步站点API到资源列表
        /// <para>读取站点API信息，如果资源列表中不存在，则添加</para>
        /// </summary>
        [HttpPost]
        public async Task<Response> Sync()
        {
            var result = new Response();
            try
            {
                await _app.Sync();
                return result;
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

       [HttpPost]
        public Response Delete([FromBody]string[] ids)
        {
            Response resp = new Response();
            try
            {
                _app.Delete(ids);
            }
            catch (Exception e)
            {
                resp.Code = 500;
                resp.Message = e.Message;
            }
            return resp;
        }

       [HttpPost]
        public Response<string> Add([FromBody] AddOrUpdateResReq obj)
        {
            var resp = new Response<string>();
            try
            {
                _app.Add(obj);
                resp.Data = obj.Id;
            }
            catch (Exception e)
            {
                resp.Code = 500;
                resp.Message = e.Message;
            }
            return resp;
        }

       [HttpPost]
        public Response Update([FromBody] AddOrUpdateResReq obj)
        {
            Response resp = new Response();
            try
            {
                _app.Update(obj);
            }
            catch (Exception e)
            {
                resp.Code = 500;
                resp.Message = e.Message;
            }
            return resp;
        }

        /// <summary>
        /// 加载角色资源
        /// </summary>
        /// <param name="appId">应用ID</param>
        /// <param name="firstId">角色ID</param>
        [HttpGet]
        public Response<List<SysResource>> LoadForRole(string appId, string firstId)
        {
            var result = new Response<List<SysResource>>();
            try
            {
                result.Data = _app.LoadForRole(appId, firstId).ToList();

            }
            catch (Exception e)
            {
                result.Code = 500;
                result.Message = e.InnerException?.Message ?? e.Message;
            }

            return result;
        }

        /// <summary>
        /// 获取资源所属应用
        /// </summary>
        [HttpGet]
        public async Task<Response<List<SysResourceApp>>> GetResourceApps()
        {
            var result = new Response<List<SysResourceApp>>();
            try
            {
                result.Data = await _app.GetResourceApps();
            }
            catch (Exception e)
            {
                result.Code = 500;
                result.Message = e.InnerException?.Message ?? e.Message;
            }
            return result;
        }
    }
}