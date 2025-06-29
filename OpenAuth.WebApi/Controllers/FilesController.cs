
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Infrastructure;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using OpenAuth.App;
using OpenAuth.App.Request;
using OpenAuth.App.Response;
using OpenAuth.Repository.Domain;

namespace OpenAuth.WebApi.Controllers
{
    /// <summary>  文件上传</summary>
    /// <remarks>   yubaolee, 2019-03-08. </remarks>

    [Route("api/[controller]/[action]")]
    [ApiController]
    [ApiExplorerSettings(GroupName = "文件管理_Files")]
    public class FilesController :ControllerBase
    {

        private FileApp _app;

        public FilesController(FileApp app)
        {
            _app = app;
        }
        
        /// <summary>
        /// 加载附件列表
        /// </summary>
        [HttpGet]
        public async Task<PagedDynamicDataResp> Load([FromQuery]QueryFileListReq request)
        {
            return await _app.Load(request);
        }
        
        /// <summary>
        /// 删除附件
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
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

        /// <summary>
        ///  批量上传文件接口
        /// <para>客户端文本框需设置name='files'</para>
        /// </summary>
        /// <param name="files">不能读取文件以外的其他form-data参数</param>
        /// <returns>服务器存储的文件信息</returns>
        [HttpPost]
        [AllowAnonymous]
        public Response<IList<UploadFile>> Upload([FromForm] IFormFileCollection files)
        {
            var result = new Response<IList<UploadFile>>();
            try
            {
                result.Data = _app.Add(files);
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.Message;
            }

            return result;
        }
        
        /// <summary>
        ///  以form-data的形式上传文件
        /// <para>通常用于类似vform上传等功能</para>
        /// </summary>
        /// <param name="formdata">客户端可以带其他参数</param>
        /// <returns>服务器存储的文件信息</returns>
        [HttpPost]
        [AllowAnonymous]
        public Response<IList<UploadFile>> UploadWithFormData([FromForm] IFormCollection formdata)
        {
            var result = new Response<IList<UploadFile>>();
            try
            {
                var files = HttpContext.Request.Form.Files;
                result.Data = _app.Add(files);
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.Message;
            }

            return result;
        }

    }
}
