using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using Infrastructure;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.OpenApi.Readers;

[ApiController]
[Route("api/[controller]")]
[ApiExplorerSettings(GroupName = "系统管理_System")]
public class SystemController : ControllerBase
{
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly IConfiguration _configuration;

    public SystemController(IHttpClientFactory httpClientFactory
    , IConfiguration configuration)
    {
        _httpClientFactory = httpClientFactory;
        _configuration = configuration;
    }

    /// <summary>
    /// 获取所有API接口信息
    /// </summary>
    /// <returns></returns>
    [HttpGet]
    [AllowAnonymous]
    public async Task<Response<List<SwaggerEndpointInfo>>> Get()
    {
        var result = new Response<List<SwaggerEndpointInfo>>();
        try
        {
            var apis = await GetSwaggerEndpoints();

            result.Result = apis;
        }
        catch (Exception ex)
        {
            result.Code = 500;
            result.Message = ex.InnerException?.Message ?? ex.Message;
        }

        return result;
    }

    /// <summary>
    /// 获取所有API接口信息
    /// </summary>
    private async Task<List<SwaggerEndpointInfo>> GetSwaggerEndpoints()
    {
        var reader = new OpenApiStringReader();
        var client = _httpClientFactory.CreateClient();

        var baseUrl = _configuration["AppSetting:HttpHost"]?.Replace("*", "localhost");
        var apis = new List<SwaggerEndpointInfo>();
        foreach (var controller in GetControllers())
        {
            var groupname = GetSwaggerGroupName(controller);

            var swaggerJsonUrl = $"{baseUrl}/swagger/{groupname}/swagger.json";
            var response = await client.GetAsync(swaggerJsonUrl);
            var content = await response.Content.ReadAsStringAsync();
            var document = reader.Read(content, out var diagnostic);
            //获取所有api
            apis.AddRange(document.Paths
                .SelectMany(path => path.Value.Operations
                    .Select(op => new SwaggerEndpointInfo(
                        path.Key,
                        op.Key.ToString(),
                        op.Value.Summary,
                        op.Value.Description,
                        op.Value.Tags.FirstOrDefault()?.Name))));
        }

        return apis;
    }

    /// <summary>
    /// 获取控制器对应的swagger分组值
    /// </summary>
    private string GetSwaggerGroupName(Type controller)
    {
        var groupname = controller.Name.Replace("Controller", "");
        var apisetting = controller.GetCustomAttribute(typeof(ApiExplorerSettingsAttribute));
        if (apisetting != null)
        {
            groupname = ((ApiExplorerSettingsAttribute)apisetting).GroupName;
        }

        return groupname;
    }

    /// <summary>
    /// 获取所有的控制器
    /// </summary>
    private List<Type> GetControllers()
    {
        Assembly asm = Assembly.GetExecutingAssembly();

        var controlleractionlist = asm.GetTypes()
            .Where(type => typeof(ControllerBase).IsAssignableFrom(type))
            .OrderBy(x => x.Name).ToList();
        return controlleractionlist;
    }

    public record SwaggerEndpointInfo(
    string Path,
    string HttpMethod,
    string Summary,
    string Description,
    string Tag);
}