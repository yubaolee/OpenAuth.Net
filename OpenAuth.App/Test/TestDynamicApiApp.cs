using System;
using System.Threading.Tasks;
using Infrastructure;
using Infrastructure.Cache;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Moq;
using NUnit.Framework;
using OpenAuth.App.Request;
using OpenAuth.App.SSO;

namespace OpenAuth.App.Test
{
    class TestDynamicApiApp :TestBase
    {
        public override ServiceCollection GetService()
        {
            var services = new ServiceCollection();

            var cachemock = new Mock<ICacheContext>();
            cachemock.Setup(x => x.Get<UserAuthSession>("tokentest")).Returns(new UserAuthSession { Account = "test" });
            services.AddScoped(x => cachemock.Object);

            var httpContextAccessorMock = new Mock<IHttpContextAccessor>();
            httpContextAccessorMock.Setup(x => x.HttpContext.Request.Query[Define.TOKEN_NAME]).Returns("tokentest");

            services.AddScoped(x => httpContextAccessorMock.Object);

            return services;
        }

        [Test]
        public async Task TestGet()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();

            var obj = await app.Get(new QueryDynamicEntityReq { TableName = "noentity", Id = "1" });
            Console.WriteLine(JsonHelper.Instance.Serialize(obj));
        }

        [Test]
        public async Task TestGetList()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();

            var obj = await app.GetList(new QueryDynamicListReq { TableName = "noentity", page = 1, limit = 10, key = "" });
            Console.WriteLine(JsonHelper.Instance.Serialize(obj));
        }

        [Test]
        public void TestInvoke()    
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();

            var  obj = app.Invoke(new InvokeDynamicReq { ServiceName = "UserManagerApp", MethodName = "GetParent", 
            Parameters = "{\"userid\":\"0ceff0f8-f848-440c-bc26-d8605ac858cd\"}" });
            Console.WriteLine(JsonHelper.Instance.Serialize(obj));
        }

        [Test]
        public async Task TestInvoke2()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();
       
            var obj = app.Invoke(new InvokeDynamicReq { 
               ServiceName = "UserManagerApp", 
               MethodName = "Load", 
               Parameters = "{\"request\":{\"page\":1,\"limit\":10,\"key\":\"\"}}" 
           });
           
           // 如果返回的是Task，需要等待它完成并获取结果
           if (obj is Task task)
           {
               await task;
               // 使用反射获取Task的Result属性
               var resultProperty = task.GetType().GetProperty("Result");
               if (resultProperty != null)
               {
                   var result = resultProperty.GetValue(task);
                   Console.WriteLine(JsonHelper.Instance.Serialize(result));
               }
           }
           else
           {
               Console.WriteLine(JsonHelper.Instance.Serialize(obj));
           }
       }
    }
}
