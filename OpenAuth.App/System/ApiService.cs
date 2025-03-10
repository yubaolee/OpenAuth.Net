using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.OpenApi.Readers;

public class ApiService
{
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly IConfiguration _configuration;

    public ApiService(IHttpClientFactory httpClientFactory, IConfiguration configuration)
    {
        _httpClientFactory = httpClientFactory;
        _configuration = configuration;
    }

    /// <summary>
    /// 获取所有API接口信息
    /// <para>这个方法单元测试必须启动WebApi站点</para>
    /// </summary>
    public async Task<List<SwaggerEndpointInfo>> GetSwaggerEndpoints()
    {

        var reader = new OpenApiStringReader();
        var client = _httpClientFactory.CreateClient();

        var baseUrl = _configuration["AppSetting:HttpHost"]?.Replace("*", "localhost");

        var apis = new List<SwaggerEndpointInfo>();
        var controllers = GetControllers();

        foreach (var controller in controllers)
        {
            var groupname = GetSwaggerGroupName(controller);
            var swaggerJsonUrl = $"{baseUrl}/swagger/{groupname}/swagger.json";

            var response = await client.GetAsync(swaggerJsonUrl).ConfigureAwait(false);

            var content = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
            var document = reader.Read(content, out var diagnostic);
            //获取所有api
            var controllerApis = document.Paths
                .SelectMany(path => path.Value.Operations
                    .Select(op => new SwaggerEndpointInfo(
                        path.Key,
                        op.Key.ToString(),
                        op.Value.Summary,
                        op.Value.Description,
                        op.Value.Tags.FirstOrDefault()?.Name)));

            apis.AddRange(controllerApis);
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
        var webApiAssembly = AppDomain.CurrentDomain.GetAssemblies()
            .FirstOrDefault(a => a.GetName().Name.Contains("OpenAuth.WebApi"));

        var controlleractionlist = webApiAssembly.GetTypes()
            .Where(type => typeof(Microsoft.AspNetCore.Mvc.ControllerBase).IsAssignableFrom(type))
            .ToList();

        return controlleractionlist;
    }
}

public record SwaggerEndpointInfo(
   string Path,
   string HttpMethod,
   string Summary,
   string Description,
   string Tag);