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
    /// <summary>
    /// DynamicApiApp 单元测试
    /// 测试表：noentity (id varchar(50), name varchar(255), age int)
    /// 支持 MySQL 和 SqlServer 数据库
    /// 测试大小写混合属性命名
    /// </summary>
    [TestFixture]
    public class TestDynamicApiApp : TestBase
    {
        private const string TEST_TABLE = "noentity";

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


        #region 基础 CRUD 测试

        /// <summary>
        /// 测试添加数据 - 标准属性名（PascalCase）
        /// </summary>
        [Test]
        public async Task TestAdd_PascalCase()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();
            var id = Guid.NewGuid().ToString();

            var result = await app.Add(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"Id\":\"{id}\",\"Name\":\"测试PascalCase\",\"Age\":25}}"
            });

            Console.WriteLine($"添加结果（PascalCase）: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(200), $"添加失败: {result.Message}");

        }

        /// <summary>
        /// 测试添加数据 - 小写属性名（camelCase）
        /// </summary>
        [Test]
        public async Task TestAdd_CamelCase()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();
            var id = Guid.NewGuid().ToString();

            var result = await app.Add(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"id\":\"{id}\",\"name\":\"测试camelCase\",\"age\":30}}"
            });

            Console.WriteLine($"添加结果（camelCase）: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(200), $"添加失败: {result.Message}");


        }

        /// <summary>
        /// 测试添加数据 - 大写属性名（UPPERCASE）
        /// </summary>
        [Test]
        public async Task TestAdd_UpperCase()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();
            var id = Guid.NewGuid().ToString();

            var result = await app.Add(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"ID\":\"{id}\",\"NAME\":\"测试UPPERCASE\",\"AGE\":35}}"
            });

            Console.WriteLine($"添加结果（UPPERCASE）: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(200), $"添加失败: {result.Message}");


        }

        /// <summary>
        /// 测试添加数据 - 混合大小写属性名（MixedCase）
        /// </summary>
        [Test]
        public async Task TestAdd_MixedCase()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();
            var id = Guid.NewGuid().ToString();

            // 混合使用不同大小写：Id(PascalCase), name(camelCase), AGE(UPPERCASE)
            var result = await app.Add(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"Id\":\"{id}\",\"name\":\"测试MixedCase\",\"AGE\":40}}"
            });

            Console.WriteLine($"添加结果（MixedCase）: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(200), $"添加失败: {result.Message}");


        }

        /// <summary>
        /// 测试获取单条数据
        /// </summary>
        [Test]
        public async Task TestGet()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();
            var id = Guid.NewGuid().ToString();

            // 先添加数据
            await app.Add(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"Id\":\"{id}\",\"Name\":\"测试获取\",\"Age\":28}}"
            });

            // 获取数据
            var result = await app.Get(new QueryDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Id = id
            });

            Console.WriteLine($"获取结果: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(200), $"获取失败: {result.Message}");
            Assert.That(result.Data, Is.Not.Null, "未找到数据");


        }

        /// <summary>
        /// 测试获取列表
        /// </summary>
        [Test]
        public async Task TestGetList()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();

            var result = await app.GetList(new QueryDynamicListReq
            {
                TableName = TEST_TABLE,
                page = 1,
                limit = 10,
                key = ""
            });

            Console.WriteLine($"列表查询结果: 总数={result.Count}, 数据条数={result.Data?.Count ?? 0}");
            Console.WriteLine($"详细结果: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(200), $"查询失败: {result.Message}");
        }

        /// <summary>
        /// 测试带关键字搜索的列表查询
        /// </summary>
        [Test]
        public async Task TestGetList_WithKey()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();
            var id = Guid.NewGuid().ToString();
            var searchKey = "搜索测试_" + DateTime.Now.Ticks;

            // 先添加测试数据
            await app.Add(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"Id\":\"{id}\",\"Name\":\"{searchKey}\",\"Age\":22}}"
            });

            // 查询
            var result = await app.GetList(new QueryDynamicListReq
            {
                TableName = TEST_TABLE,
                page = 1,
                limit = 10,
                key = searchKey
            });

            Console.WriteLine($"带关键字搜索结果: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(200), $"查询失败: {result.Message}");
            Assert.That(result.Count, Is.GreaterThanOrEqualTo(1), "应该至少找到一条数据");

            // 清理测试数据
            await CleanupTestData(app, id);
        }

        /// <summary>
        /// 测试更新数据 - 标准属性名（PascalCase）
        /// </summary>
        [Test]
        public async Task TestUpdate_PascalCase()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();
            var id = Guid.NewGuid().ToString();

            // 先添加数据
            await app.Add(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"Id\":\"{id}\",\"Name\":\"原始名称\",\"Age\":20}}"
            });

            // 更新数据
            var result = await app.Update(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"Id\":\"{id}\",\"Name\":\"更新后PascalCase\",\"Age\":21}}"
            });

            Console.WriteLine($"更新结果（PascalCase）: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(200), $"更新失败: {result.Message}");

            // 验证更新结果
            var getResult = await app.Get(new QueryDynamicEntityReq { TableName = TEST_TABLE, Id = id });
            Console.WriteLine($"更新后数据: {JsonHelper.Instance.Serialize(getResult)}");
        }

        /// <summary>
        /// 测试更新数据 - 小写属性名（camelCase）
        /// </summary>
        [Test]
        public async Task TestUpdate_CamelCase()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();
            var id = Guid.NewGuid().ToString();

            // 先添加数据
            await app.Add(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"id\":\"{id}\",\"name\":\"原始名称\",\"age\":20}}"
            });

            // 更新数据
            var result = await app.Update(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"id\":\"{id}\",\"name\":\"更新后camelCase\",\"age\":22}}"
            });

            Console.WriteLine($"更新结果（camelCase）: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(200), $"更新失败: {result.Message}");
        }

        /// <summary>
        /// 测试更新数据 - 混合大小写属性名
        /// </summary>
        [Test]
        public async Task TestUpdate_MixedCase()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();
            var id = Guid.NewGuid().ToString();

            // 先添加数据（使用PascalCase）
            await app.Add(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"Id\":\"{id}\",\"Name\":\"原始名称\",\"Age\":20}}"
            });

            // 更新数据（使用混合大小写）
            var result = await app.Update(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"Id\":\"{id}\",\"name\":\"更新后MixedCase\",\"AGE\":23}}"
            });

            Console.WriteLine($"更新结果（MixedCase）: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(200), $"更新失败: {result.Message}");
        }

        /// <summary>
        /// 测试删除单条数据
        /// </summary>
        [Test]
        public async Task TestDelete_Single()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();
            var id = Guid.NewGuid().ToString();

            // 先添加数据
            await app.Add(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"Id\":\"{id}\",\"Name\":\"待删除\",\"Age\":99}}"
            });

            // 删除数据
            var result = await app.Delete(new DelDynamicReq
            {
                TableName = TEST_TABLE,
                Ids = new[] { id }
            });

            Console.WriteLine($"删除结果: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(200), $"删除失败: {result.Message}");

            // 验证删除结果
            var getResult = await app.Get(new QueryDynamicEntityReq { TableName = TEST_TABLE, Id = id });
            Assert.That(getResult.Data, Is.Null, "数据应该已被删除");
        }

        /// <summary>
        /// 测试批量删除
        /// </summary>
        [Test]
        public async Task TestDelete_Batch()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();
            var ids = new[] { Guid.NewGuid().ToString(), Guid.NewGuid().ToString(), Guid.NewGuid().ToString() };

            // 添加多条测试数据
            foreach (var id in ids)
            {
                await app.Add(new AddOrUpdateDynamicEntityReq
                {
                    TableName = TEST_TABLE,
                    Obj = $"{{\"Id\":\"{id}\",\"Name\":\"批量删除测试_{id.Substring(0, 8)}\",\"Age\":50}}"
                });
            }

            // 批量删除
            var result = await app.Delete(new DelDynamicReq
            {
                TableName = TEST_TABLE,
                Ids = ids
            });

            Console.WriteLine($"批量删除结果: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(200), $"批量删除失败: {result.Message}");

            // 验证删除结果
            foreach (var id in ids)
            {
                var getResult = await app.Get(new QueryDynamicEntityReq { TableName = TEST_TABLE, Id = id });
                Assert.That(getResult.Data, Is.Null, $"数据 {id} 应该已被删除");
            }
        }

        #endregion

        #region 完整 CRUD 流程测试

        /// <summary>
        /// 测试完整的 CRUD 流程
        /// </summary>
        [Test]
        public async Task TestCRUD_FullFlow()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();
            var id = Guid.NewGuid().ToString();

            Console.WriteLine("=== 开始完整 CRUD 流程测试 ===");

            // 1. Create - 创建数据
            Console.WriteLine("\n1. 创建数据...");
            var addResult = await app.Add(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"Id\":\"{id}\",\"Name\":\"CRUD测试\",\"Age\":18}}"
            });
            Console.WriteLine($"创建结果: {JsonHelper.Instance.Serialize(addResult)}");
            Assert.That(addResult.Code, Is.EqualTo(200), $"创建失败: {addResult.Message}");

            // 2. Read - 读取数据
            Console.WriteLine("\n2. 读取数据...");
            var getResult = await app.Get(new QueryDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Id = id
            });
            Console.WriteLine($"读取结果: {JsonHelper.Instance.Serialize(getResult)}");
            Assert.That(getResult.Code, Is.EqualTo(200), $"读取失败: {getResult.Message}");
            Assert.That(getResult.Data, Is.Not.Null, "数据不应为空");

            // 3. Update - 更新数据
            Console.WriteLine("\n3. 更新数据...");
            var updateResult = await app.Update(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"Id\":\"{id}\",\"Name\":\"CRUD测试_已更新\",\"Age\":19}}"
            });
            Console.WriteLine($"更新结果: {JsonHelper.Instance.Serialize(updateResult)}");
            Assert.That(updateResult.Code, Is.EqualTo(200), $"更新失败: {updateResult.Message}");

            // 验证更新
            var getResult2 = await app.Get(new QueryDynamicEntityReq { TableName = TEST_TABLE, Id = id });
            Console.WriteLine($"更新后数据: {JsonHelper.Instance.Serialize(getResult2)}");

            // 4. Delete - 删除数据
            Console.WriteLine("\n4. 删除数据...");
            var deleteResult = await app.Delete(new DelDynamicReq
            {
                TableName = TEST_TABLE,
                Ids = new[] { id }
            });
            Console.WriteLine($"删除结果: {JsonHelper.Instance.Serialize(deleteResult)}");
            Assert.That(deleteResult.Code, Is.EqualTo(200), $"删除失败: {deleteResult.Message}");

            // 验证删除
            var getResult3 = await app.Get(new QueryDynamicEntityReq { TableName = TEST_TABLE, Id = id });
            Assert.That(getResult3.Data, Is.Null, "数据应该已被删除");

            Console.WriteLine("\n=== 完整 CRUD 流程测试完成 ===");
        }

        #endregion

        #region Invoke 方法测试

        /// <summary>
        /// 测试 Invoke 调用 - 获取父级用户
        /// </summary>
        [Test]
        public async Task TestInvoke_GetParent()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();

            var result = await app.Invoke(new InvokeDynamicReq
            {
                ServiceName = "UserManagerApp",
                MethodName = "GetParent",
                Parameters = "{\"userid\":\"0ceff0f8-f848-440c-bc26-d8605ac858cd\"}"
            });

            Console.WriteLine($"Invoke GetParent 结果: {JsonHelper.Instance.Serialize(result)}");
        }

        /// <summary>
        /// 测试 Invoke 调用 - 加载用户列表
        /// </summary>
        [Test]
        public async Task TestInvoke_Load()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();

            var result = await app.Invoke(new InvokeDynamicReq
            {
                ServiceName = "UserManagerApp",
                MethodName = "Load",
                Parameters = "{\"request\":{\"page\":1,\"limit\":10,\"key\":\"\"}}"
            });

            Console.WriteLine($"Invoke Load 结果: {JsonHelper.Instance.Serialize(result)}");
        }

        /// <summary>
        /// 测试 Invoke 调用 - 参数大小写混合
        /// </summary>
        [Test]
        public async Task TestInvoke_MixedCaseParameters()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();

            // 使用混合大小写的参数
            var result = await app.Invoke(new InvokeDynamicReq
            {
                ServiceName = "UserManagerApp",
                MethodName = "Load",
                Parameters = "{\"Request\":{\"Page\":1,\"Limit\":10,\"Key\":\"\"}}"
            });

            Console.WriteLine($"Invoke MixedCase 结果: {JsonHelper.Instance.Serialize(result)}");
        }

        #endregion

        #region 异常场景测试

        /// <summary>
        /// 测试不存在的表
        /// </summary>
        [Test]
        public async Task TestNonExistentTable()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();

            var result = await app.GetList(new QueryDynamicListReq
            {
                TableName = "non_existent_table_12345",
                page = 1,
                limit = 10
            });

            Console.WriteLine($"查询不存在的表结果: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(500), "应该返回错误");
            Assert.That(result.Message, Does.Contain("表不存在"), "错误信息应包含'表不存在'");
        }

        /// <summary>
        /// 测试更新不包含Id的数据
        /// </summary>
        [Test]
        public async Task TestUpdate_WithoutId()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();

            var result = await app.Update(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = "{\"Name\":\"没有Id的更新\",\"Age\":99}"
            });

            Console.WriteLine($"无Id更新结果: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(500), "应该返回错误");
            Assert.That(result.Message, Does.Contain("Id"), "错误信息应包含'Id'");
        }

        /// <summary>
        /// 测试添加重复Id的数据
        /// </summary>
        [Test]
        public async Task TestAdd_DuplicateId()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();
            var id = Guid.NewGuid().ToString();

            // 第一次添加
            await app.Add(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"Id\":\"{id}\",\"Name\":\"第一次添加\",\"Age\":1}}"
            });

            // 第二次添加相同Id
            var result = await app.Add(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = $"{{\"Id\":\"{id}\",\"Name\":\"第二次添加\",\"Age\":2}}"
            });

            Console.WriteLine($"重复Id添加结果: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(500), "应该返回错误");
            Assert.That(result.Message, Does.Contain("Id已存在"), "错误信息应包含'Id已存在'");

            // 清理测试数据
            await CleanupTestData(app, id);
        }

        /// <summary>
        /// 测试获取不存在的记录
        /// </summary>
        [Test]
        public async Task TestGet_NonExistent()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();

            var result = await app.Get(new QueryDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Id = "non_existent_id_12345"
            });

            Console.WriteLine($"获取不存在记录结果: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(500), "应该返回错误");
            Assert.That(result.Message, Does.Contain("未找到"), "错误信息应包含'未找到'");
        }

        #endregion

        #region 自动生成ID测试

        /// <summary>
        /// 测试添加数据时自动生成Id
        /// </summary>
        [Test]
        public async Task TestAdd_AutoGenerateId()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();

            // 不传Id
            var result = await app.Add(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = "{\"Name\":\"自动生成Id测试\",\"Age\":33}"
            });

            Console.WriteLine($"自动生成Id结果: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(200), $"添加失败: {result.Message}");

            // 查询并验证确实有数据被添加
            var listResult = await app.GetList(new QueryDynamicListReq
            {
                TableName = TEST_TABLE,
                page = 1,
                limit = 100,
                key = "自动生成Id测试"
            });

            Console.WriteLine($"查询结果: {JsonHelper.Instance.Serialize(listResult)}");
            Assert.That(listResult.Count, Is.GreaterThan(0), "应该能查到数据");
        }

        /// <summary>
        /// 测试添加数据时Id为空字符串，应自动生成
        /// </summary>
        [Test]
        public async Task TestAdd_EmptyId()
        {
            var app = _autofacServiceProvider.GetService<DynamicApiApp>();

            // 传空Id
            var result = await app.Add(new AddOrUpdateDynamicEntityReq
            {
                TableName = TEST_TABLE,
                Obj = "{\"Id\":\"\",\"Name\":\"空Id测试\",\"Age\":34}"
            });

            Console.WriteLine($"空Id测试结果: {JsonHelper.Instance.Serialize(result)}");
            Assert.That(result.Code, Is.EqualTo(200), $"添加失败: {result.Message}");
        }

        #endregion

        #region 辅助方法

        /// <summary>
        /// 清理测试数据
        /// </summary>
        private async Task CleanupTestData(DynamicApiApp app, string id)
        {
            try
            {
                await app.Delete(new DelDynamicReq
                {
                    TableName = TEST_TABLE,
                    Ids = new[] { id }
                });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"清理测试数据失败: {ex.Message}");
            }
        }

        #endregion
    }
}
