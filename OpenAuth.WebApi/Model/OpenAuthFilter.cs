using System.Reflection;
using Infrastructure;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using OpenAuth.App;
using OpenAuth.App.Interface;
using OpenAuth.Repository.Domain;

namespace OpenAuth.WebApi.Model
{
    public class OpenAuthFilter : IActionFilter
    {
        private readonly IAuth _authUtil;
        private readonly SysLogApp _logApp;

        private readonly ResourceApp _resourceApp;

        public OpenAuthFilter(IAuth authUtil, SysLogApp logApp, ResourceApp resourceApp)
        {
            _authUtil = authUtil;
            _logApp = logApp;
            _resourceApp = resourceApp;
        }

        public void OnActionExecuting(ActionExecutingContext context)
        {
            var description =
                (Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor)context.ActionDescriptor;

            var Controllername = description.ControllerName.ToLower();
            var Actionname = description.ActionName.ToLower();

            //匿名访问的不需要验证
            var allowAnonymous = description.MethodInfo.GetCustomAttribute(typeof(AllowAnonymousAttribute));
            if (allowAnonymous != null)
            {
                return;
            }

            if (!_authUtil.CheckLogin())
            {
                context.HttpContext.Response.StatusCode = 401;
                context.Result = new JsonResult(new Response
                {
                    Code = 401,
                    Message = "登录已过期，请重新登录"
                });
                return;
            }

            var apiPath = $"{Controllername}/{Actionname}";
            //判断登录角色是否拥有访问该URL的权限
            var resource = _resourceApp.CanAccess(apiPath);
            if(!resource)
            {
                context.Result = new JsonResult(new Response
                {
                    Code = 500,
                    Message = $"当前用户没有访问{apiPath}的权限,请在【角色管理】中分配资源"
                });
                return;
            }


            _logApp.Add(new SysLog
            {
                Content = $"用户访问",
                Href = apiPath,
                CreateName = _authUtil.GetUserName(),
                CreateId = _authUtil.GetCurrentUser().User.Id,
                TypeName = "访问日志"
            });
        }

        public void OnActionExecuted(ActionExecutedContext context)
        {
            return;
        }
    }
}
