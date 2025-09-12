using System;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Hosting;

namespace OpenAuth.WebApi.Controllers
{
    /// <summary>
    /// 系统信息相关接口
    /// </summary>
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class SystemController : ControllerBase
    {
        private readonly IHostEnvironment _environment;

        public SystemController(IHostEnvironment environment)
        {
            _environment = environment;
        }

        /// <summary>
        /// 获取系统环境信息
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [AllowAnonymous]
        public IActionResult GetEnvironmentInfo()
        {
            return Ok(new
            {
                EnvironmentName = _environment.EnvironmentName,
                IsDevelopment = _environment.IsDevelopment(),
                IsProduction = _environment.IsProduction(),
                IsStaging = _environment.IsStaging(),
                SwaggerEnabled = _environment.IsDevelopment(), // Swagger 只在开发环境启用
                Timestamp = DateTime.Now
            });
        }
    }
} 