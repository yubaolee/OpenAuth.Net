using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using Autofac;
using Autofac.Extensions.DependencyInjection;
using Infrastructure;
using Infrastructure.Utilities;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Moq;
using NUnit.Framework;
using OpenAuth.Repository.Interface;
using SqlSugar;

namespace OpenAuth.Repository.Test
{
    /// <summary>
    /// Repository测试基类
    /// 测试用于测试DbContext、UnitWork、Repository，如果需要测试业务逻辑，请使用OpenAuth.App里面的单元测试
    /// </summary>
    public class TestBase
    {
        protected AutofacServiceProvider _autofacServiceProvider;

        [SetUp]
        public void Init()
        {
            var serviceCollection = GetService();
            serviceCollection.AddMemoryCache();
            serviceCollection.AddOptions();
            serviceCollection.AddLogging();
            serviceCollection.AddScoped(typeof(IRepository<,>), typeof(BaseRepository<,>));
            serviceCollection.AddScoped(typeof(IUnitWork<>), typeof(UnitWork<>));

            //模拟配置文件
            //读取OpenAuth.WebApi的配置文件用于单元测试
            var path = AppContext.BaseDirectory;
            int pos =  path.LastIndexOf("OpenAuth.");
            var basepath = Path.Combine(path.Substring(0,pos) ,"OpenAuth.WebApi");
            IConfiguration config = new ConfigurationBuilder()
                .SetBasePath(basepath)
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                .AddJsonFile("appsettings.Development.json", optional: true)
                .AddEnvironmentVariables()
                .Build();
         
            //添加log4net
            serviceCollection.AddLogging(builder =>
            {
                builder.ClearProviders(); //去掉默认的日志
                builder.AddConfiguration(config.GetSection("Logging"));  //读取配置文件中的Logging配置
            });
            //注入OpenAuth.WebApi配置文件
            serviceCollection.AddScoped(x => config);
            

            var httpContextAccessorMock = new Mock<IHttpContextAccessor>();
            httpContextAccessorMock.Setup(x => x.HttpContext.Request.Query[Define.TOKEN_NAME]).Returns("tokentest");
            httpContextAccessorMock.Setup(x => x.HttpContext.Request.Query[Define.TENANT_ID]).Returns("OpenAuthDBContext");

            serviceCollection.AddScoped(x => httpContextAccessorMock.Object);

            serviceCollection.AddDbContext<OpenAuthDBContext>();
            
           var dbtypes = config.GetSection("AppSetting:DbTypes").GetChildren()
                .ToDictionary(x => x.Key, x => x.Value);;
            var sqlsugarTypes = UtilMethods.EnumToDictionary<SqlSugar.DbType>();
            serviceCollection.AddScoped<ISqlSugarClient>(s =>
            {
                // 获取所有连接字符串配置
                var connectionStrings = config.GetSection("ConnectionStrings").GetChildren()
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
                    Console.WriteLine($"添加数据库连接: {conn.Key} / {(dbtypes.ContainsKey(conn.Key) ? dbtypes[conn.Key] : "未指定类型")}，连接字符串：{conn.Value}");
                }
                
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

            var builder = new ContainerBuilder();

            //注册repository层
            builder.RegisterAssemblyTypes(Assembly.GetExecutingAssembly());

            builder.Populate(serviceCollection);
          
            var _container = builder.Build();
            _autofacServiceProvider = new AutofacServiceProvider(_container);

        }

        /// <summary>
        /// 测试框架默认只注入了缓存Cache，配置Option；
        /// 如果在测试的过程中需要模拟登录用户，cookie等信息，需要重写该方法，可以参考TestFlow的写法
        /// </summary>
        public virtual ServiceCollection GetService()
        {
            return  new ServiceCollection();
        }
    }
}
