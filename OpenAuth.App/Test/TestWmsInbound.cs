using System;
using System.Threading;
using System.Threading.Tasks;
using Infrastructure;
using Infrastructure.Cache;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Moq;
using NUnit.Framework;
using OpenAuth.App.Request;
using OpenAuth.App.SSO;
using System.Collections.Generic;
using Yitter.IdGenerator;

namespace OpenAuth.App.Test
{
    public class TestWmsInbound : TestBase
    {
        public override ServiceCollection GetService()
        {
            var services = new ServiceCollection();

            var cachemock = new Mock<ICacheContext>();
            cachemock.Setup(x => x.Get<UserAuthSession>("tokentest"))
                .Returns(new UserAuthSession { Account = Define.SYSTEM_USERNAME });
            services.AddScoped(x => cachemock.Object);

            var httpContextAccessorMock = new Mock<IHttpContextAccessor>();
            httpContextAccessorMock.Setup(x => x.HttpContext.Request.Query[Define.TOKEN_NAME])
                .Returns("tokentest");

            services.AddScoped(x => httpContextAccessorMock.Object);

            return services;
        }

        [Test]
        public async Task Add()
        {
            var app = _autofacServiceProvider.GetService<WmsInboundOrderTblApp>();
            var options = new IdGeneratorOptions()
            {
                Method = 1,
                WorkerId = 1
            };
            YitIdHelper.SetIdGenerator(options);

            //添加
            var addReq = new AddOrUpdateWmsInboundOrderTblReq()
            {
                Id = "673870840217669",
                ExternalNo = "123456",
                ExternalType = "1",
                Status = 1,
                OrderType = "1",
                StockId = "123456",
                OwnerId = "123456",
                Remark = "123456",

                WmsInboundOrderDtblReqs = new List<AddOrUpdateWmsInboundOrderDtblReq>()
                {
                    new()
                    {
                        GoodsId = "123456",
                        GoodsBatch = "123456",
                        QualityFlg = "1",
                        OrderNum = 1,
                        InNum = 1,
                        LeaveNum = 1,
                        HoldNum = 1,
                        OwnerId = "123456",
                    }
                }
            };
            app.Add(addReq);

            //异步测试，延长主线程，防止程序退出
            Thread.Sleep(1000);
        }

        [Test]
        public async Task Update()
        {
            var app = _autofacServiceProvider.GetService<WmsInboundOrderTblApp>();
            var updateReq = new AddOrUpdateWmsInboundOrderTblReq()
            {
                Id = "673870840217669",
                ExternalNo = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                ExternalType = "1",
                Status = 1,
                OrderType = "1",
                StockId = "123456",
                OwnerId = "123456",
                Remark = "123456",
                WmsInboundOrderDtblReqs = new List<AddOrUpdateWmsInboundOrderDtblReq>()
                {
                    new()
                    { //这个用来测试更新
                        Id = "52c69eb9-e28c-47d9-8888-3e5c1090716b",
                        OrderId = "673870840217669",
                        GoodsId = "123456",
                        OwnerId = "123456",
                        GoodsBatch = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                        QualityFlg = "1",
                        OrderNum = 1,
                        InNum = 1,
                        LeaveNum = 1,
                        HoldNum = 1
                    },
                    new()
                    {  //这个用来测试添加
                        OrderId = "673870840217669",
                        GoodsId = "123456",
                        OwnerId = "123456",
                        GoodsBatch = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                        QualityFlg = "1",
                        OrderNum = 1,
                        InNum = 1,
                        LeaveNum = 1,
                        HoldNum = 1
                    }
                }
            };
            app.Update(updateReq);

            //异步测试，延长主线程，防止程序退出
            Thread.Sleep(1000);
        }

    }
}
