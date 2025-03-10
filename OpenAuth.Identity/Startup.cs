﻿// Copyright (c) Brock Allen & Dominick Baier. All rights reserved.
// Licensed under the Apache License, Version 2.0. See LICENSE in the project root for license information.


using System;
using System.Linq;
using Autofac;
using Infrastructure;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using OpenAuth.App;
using OpenAuth.Repository;
using SqlSugar;

namespace OpenAuth.IdentityServer
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
        
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllersWithViews();

            var builder = services.AddIdentityServer()
                .AddInMemoryIdentityResources(Config.GetIdentityResources())
                .AddInMemoryApiResources(Config.GetApis())
                .AddInMemoryClients(Config.GetClients(Environment.IsProduction()))
                .AddProfileService<CustomProfileService>();
            
            services.ConfigureNonBreakingSameSiteCookies();
            
            services.AddCors();
//          todo:如果正式 环境请用下面的方式限制随意访问跨域
//            var origins = new []
//            {
//                "http://localhost:1803",
//                "http://localhost:52789"
//            };
//            if (Environment.IsProduction())
//            {
//                origins = new []
//                {
//                    "http://demo.openauth.net.cn:1803",
//                    "http://demo.openauth.net.cn:52789"
//                };
//            }
//            services.AddCors(option=>option.AddPolicy("cors", policy =>
//                policy.AllowAnyHeader().AllowAnyMethod().AllowCredentials().WithOrigins(origins)));

            //全部用测试环境，正式环境请参考https://www.cnblogs.com/guolianyu/p/9872661.html
            //if (Environment.IsDevelopment())
            //{
            builder.AddDeveloperSigningCredential();
            //}
            //else
            //{
            //    throw new Exception("need to configure key material");
            //}

            services.AddAuthentication();
            
            //映射配置文件
            services.Configure<AppSetting>(Configuration.GetSection("AppSetting"));
            
            //在startup里面只能通过这种方式获取到appsettings里面的值，不能用IOptions😰
            var dbtypes = ((ConfigurationSection)Configuration.GetSection("AppSetting:DbTypes")).GetChildren()
                .ToDictionary(x => x.Key, x => x.Value);
            var dbType = dbtypes["OpenAuthDBContext"];
            var connectionString = Configuration.GetConnectionString("OpenAuthDBContext");
            if (dbType == Define.DBTYPE_SQLSERVER)
            {
                services.AddDbContext<OpenAuthDBContext>(options =>
                    options.UseSqlServer(connectionString));
            }
            else if(dbType == Define.DBTYPE_MYSQL) //mysql
            {
                services.AddDbContext<OpenAuthDBContext>(options =>
                    options.UseMySql(connectionString,new MySqlServerVersion(new Version(8, 0, 11))));
            }
            else  //oracle
            {
                services.AddDbContext<OpenAuthDBContext>(options =>
                    options.UseOracle(connectionString, o=>o.UseOracleSQLCompatibility("11")));
            }
            
            var sqlsugarTypes = UtilMethods.EnumToDictionary<SqlSugar.DbType>();
            var sugarDbtype = sqlsugarTypes.FirstOrDefault(it =>
                dbtypes.ToDictionary(u => u.Key, v => v.Value.ToLower()).ContainsValue(it.Key));

            services.AddScoped<ISqlSugarClient>(s =>
            {
                var sqlSugar = new SqlSugarClient(new ConnectionConfig()
                {
                    DbType = sugarDbtype.Value,
                    ConnectionString = connectionString,
                    IsAutoCloseConnection = true
                });

                 if(sugarDbtype.Value != SqlSugar.DbType.PostgreSQL){
                    return sqlSugar;
                }
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
                return sqlSugar;
            });

        }
        
        public void ConfigureContainer(ContainerBuilder builder)
        {
            AutofacExt.InitAutofac(builder);
        }

        public void Configure(IApplicationBuilder app, IHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            
            
            app.UseCookiePolicy();
            
            //todo:测试可以允许任意跨域，正式环境要加权限
            app.UseCors(builder => builder.AllowAnyOrigin()
                .AllowAnyMethod()
                .AllowAnyHeader());

            app.UseStaticFiles();
            app.UseRouting();

            app.UseIdentityServer();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapDefaultControllerRoute();
            });
        }
    }
}