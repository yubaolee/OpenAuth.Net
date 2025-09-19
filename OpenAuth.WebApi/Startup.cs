using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using Autofac;
using IdentityServer4.AccessTokenValidation;
using Infrastructure;
using Infrastructure.Extensions.AutofacManager;
using Infrastructure.Middleware;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;
using Newtonsoft.Json;
using OpenAuth.App;
using OpenAuth.App.HostedService;
using OpenAuth.Repository;
using OpenAuth.WebApi.Model;
using SqlSugar;
using Swashbuckle.AspNetCore.SwaggerUI;

namespace OpenAuth.WebApi
{
    public class Startup
    {
        public IHostEnvironment Environment { get; }
        public IConfiguration Configuration { get; }

        public Startup(IConfiguration configuration, IHostEnvironment environment)
        {
            Configuration = configuration;
            Environment = environment;
        }


        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            //在startup中需要强制创建log4net
            var loggerFactory = LoggerFactory.Create(builder => { builder.AddLog4Net(); });
            ILogger logger = loggerFactory.CreateLogger<Startup>();

            var identityServer =
                ((ConfigurationSection) Configuration.GetSection("AppSetting:IdentityServerUrl")).Value;
            if (!string.IsNullOrEmpty(identityServer))
            {
                services.AddAuthorization();

                services.AddAuthentication(IdentityServerAuthenticationDefaults.AuthenticationScheme)
                    .AddJwtBearer(options =>
                    {
                        options.Authority = identityServer;
                        options.RequireHttpsMetadata = false; // 指定是否为HTTPS
                        options.Audience = "openauthapi";
                    });
            }

            // 只在开发环境中添加MiniProfiler服务
            if (Environment.IsDevelopment())
            {
                services.AddMiniProfiler(options =>
                {
                    // 设定访问分析结果URL的路由基地址
                    options.RouteBasePath = "/profiler";

                    options.ColorScheme = StackExchange.Profiling.ColorScheme.Auto;
                    options.PopupRenderPosition = StackExchange.Profiling.RenderPosition.BottomLeft;
                    options.PopupShowTimeWithChildren = true;
                    options.PopupShowTrivial = true;
                    options.SqlFormatter = new StackExchange.Profiling.SqlFormatters.InlineFormatter();
                    //  options.IgnoredPaths.Add("/swagger/");
                }).AddEntityFramework(); //显示SQL语句及耗时
            }

            // 只在开发环境中添加swagger
            if (Environment.IsDevelopment())
            {
                services.AddSwaggerGen(option =>
                {
                    foreach (var controller in GetControllers())
                    {
                        var groupname = GetSwaggerGroupName(controller);

                        option.SwaggerDoc(groupname, new OpenApiInfo
                        {
                            Version = "v1",
                            Title = groupname,
                            Description = "by yubaolee"
                        });
                    }

                    logger.LogInformation($"api doc basepath:{AppContext.BaseDirectory}");
                    foreach (var name in Directory.GetFiles(AppContext.BaseDirectory, "*.*",
                                SearchOption.AllDirectories).Where(f => Path.GetExtension(f).ToLower() == ".xml"))
                    {
                        option.IncludeXmlComments(name, includeControllerXmlComments: true);
                        // logger.LogInformation($"find api file{name}");
                    }

                    option.OperationFilter<GlobalHttpHeaderOperationFilter>(); // 添加httpHeader参数

                    if (!string.IsNullOrEmpty(identityServer))
                    {
                        //接入identityserver
                        option.AddSecurityDefinition("oauth2", new OpenApiSecurityScheme
                        {
                            Type = SecuritySchemeType.OAuth2,
                            Description = "OAuth2登陆授权",
                            Flows = new OpenApiOAuthFlows
                            {
                                Implicit = new OpenApiOAuthFlow
                                {
                                    AuthorizationUrl = new Uri($"{identityServer}/connect/authorize"),
                                    Scopes = new Dictionary<string, string>
                                    {
                                        {"openauthapi", "同意openauth.webapi 的访问权限"} //指定客户端请求的api作用域。 如果为空，则客户端无法访问
                                    }
                                }
                            }
                        });
                        option.OperationFilter<AuthResponsesOperationFilter>();
                    }
                });
            }
            services.Configure<AppSetting>(Configuration.GetSection("AppSetting"));
            services.AddControllers(option => { option.Filters.Add<OpenAuthFilter>(); })
                .ConfigureApiBehaviorOptions(options =>
                {
                    //启动WebAPI自动模态验证，处理返回值
                    options.InvalidModelStateResponseFactory = (ActionContext context) =>
                    {
                        var problems = new CustomBadRequest(context);

                        return new BadRequestObjectResult(problems);
                    };
                }).AddNewtonsoftJson(options =>
                {
                    //忽略循环引用
                    options.SerializerSettings.ReferenceLoopHandling = ReferenceLoopHandling.Ignore;
                    //不使用驼峰样式的key
                    //options.SerializerSettings.ContractResolver = new DefaultContractResolver();    
                    options.SerializerSettings.DateFormatString = "yyyy-MM-dd HH:mm:ss";
                });
            services.AddMemoryCache();
            services.AddCors();
            services.AddDbContext<OpenAuthDBContext>();

            services.AddHttpClient();

            services.AddDataProtection().PersistKeysToFileSystem(new DirectoryInfo(Configuration["DataProtection"]));

            //在startup里面只能通过这种方式获取到appsettings里面的值，不能用IOptions😰
            var dbtypes = ((ConfigurationSection) Configuration.GetSection("AppSetting:DbTypes")).GetChildren()
                .ToDictionary(x => x.Key, x => x.Value);
            var sqlsugarTypes = UtilMethods.EnumToDictionary<SqlSugar.DbType>();
            services.AddScoped<ISqlSugarClient>(s =>
            {
                // 获取所有连接字符串配置
                var connectionStrings = Configuration.GetSection("ConnectionStrings").GetChildren()
                    .ToDictionary(x => x.Key, x => x.Value);
                
                // 准备ConnectionConfig列表
                var connectionConfigs = new List<ConnectionConfig>();
                
                // 遍历所有连接字符串
                foreach (var conn in connectionStrings)
                {
                    // 获取对应的数据库类型
                    var connDbType = dbtypes.ContainsKey(conn.Key) ? 
                        sqlsugarTypes.FirstOrDefault(it => dbtypes[conn.Key].ToLower().Contains(it.Key)).Value :
                        DbType.SqlServer; // 如果没有定义DbType，使用默认类型
                    
                    // 创建连接配置
                    var config = new ConnectionConfig
                    {
                        DbType = connDbType,
                        ConnectionString = conn.Value,
                        IsAutoCloseConnection = true,
                    };
                    
                    // 如果不是默认连接，设置ConfigId
                    if (conn.Key != Define.DEFAULT_TENANT_ID)
                    {
                        config.ConfigId = conn.Key;
                    }
                    
                    connectionConfigs.Add(config);
                    logger.LogInformation($"添加数据库连接: {conn.Key} / {(dbtypes.ContainsKey(conn.Key) ? dbtypes[conn.Key] : "未指定类型")}，连接字符串：{conn.Value}");
                }

                //通过ConfigId为空判断是否有默认的连接字符串
                if(!connectionConfigs.Any(x => x.ConfigId == null))
                {
                    throw new Exception($"没有找到默认的连接字符串:{Define.DEFAULT_TENANT_ID}");
                }

                //把connectionConfigs排序，ConfigId为空的放在最前面，即默认的连接字符串必须排最前面
                connectionConfigs = connectionConfigs.OrderBy(x => x.ConfigId == null ? 0 : 1).ToList();
                
                var sqlSugar = new SqlSugarClient(connectionConfigs);

                // 配置PostgreSQL数据库处理
                foreach (var connConfig in connectionConfigs)
                {
                    if(connConfig.DbType == SqlSugar.DbType.PostgreSQL)
                    {
                        // 配置bool类型转换为smallint
                        sqlSugar.Aop.OnExecutingChangeSql = (sql, parameters) =>
                        {
                            foreach (var param in parameters)
                            {
                                if (param.Value is bool boolValue)
                                {
                                    param.DbType = System.Data.DbType.Int16;
                                    // 将 bool 转换为 smallint
                                    param.Value = boolValue ? (short)1 : (short)0;
                                }
                            }
                            // 返回修改后的 SQL 和参数
                            return new System.Collections.Generic.KeyValuePair<string, SugarParameter[]>(sql, parameters);
                        };
                        break; // 找到一个PostgreSQL连接后就设置一次即可
                    }
                }
                
                return sqlSugar;
            });


            //设置定时启动的任务
            services.AddHostedService<QuartzService>();
        }

        public void ConfigureContainer(ContainerBuilder builder)
        {
            AutofacExt.InitAutofac(builder);
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostEnvironment env, ILoggerFactory loggerFactory)
        {
            loggerFactory.AddLog4Net();

            //todo:测试可以允许任意跨域，正式环境要加权限
            app.UseCors(builder => builder.AllowAnyOrigin()
                .AllowAnyMethod()
                .AllowAnyHeader());

            app.UseRouting();
            app.UseAuthentication();

            // 启用日志追踪记录和异常友好提示
            app.UseLogMiddleware();

            // 只在开发环境中启用 Swagger 和 MiniProfiler
            if (env.IsDevelopment())
            {
                app.UseMiniProfiler();
                app.UseDeveloperExceptionPage();
                app.UseSwagger();

                // Enable middleware to serve swagger-ui (HTML, JS, CSS, etc.), 
                // specifying the Swagger JSON endpoint.
                app.UseSwaggerUI(c =>
                {
                    c.IndexStream = () =>
                        IntrospectionExtensions.GetTypeInfo(GetType()).Assembly
                            .GetManifestResourceStream("OpenAuth.WebApi.index.html");

                    foreach (var controller in GetControllers())
                    {
                        var groupname = GetSwaggerGroupName(controller);

                        c.SwaggerEndpoint($"/swagger/{groupname}/swagger.json", groupname);
                    }

                    c.DocExpansion(DocExpansion.List); //默认展开列表
                    c.OAuthClientId("OpenAuth.WebApi"); //oauth客户端名称
                    c.OAuthAppName("开源版webapi认证"); // 描述
                });
            }

            app.UseEndpoints(endpoints => { endpoints.MapControllers(); });

            //配置ServiceProvider
            AutofacContainerModule.ConfigServiceProvider(app.ApplicationServices);

            //可以访问根目录下面的静态文件
            var staticfile = new StaticFileOptions
            {
                FileProvider = new PhysicalFileProvider(AppContext.BaseDirectory),
                OnPrepareResponse = (ctx) =>
                {
                    //可以在这里为静态文件添加其他http头信息，默认添加跨域信息
                    ctx.Context.Response.Headers["Access-Control-Allow-Origin"] = "*";
                }
            };
            app.UseStaticFiles(staticfile);

            

            
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
                groupname = ((ApiExplorerSettingsAttribute) apisetting).GroupName;
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
    }
}