using System;
using System.Linq;
using System.Threading.Tasks;
using System.Collections.Generic;
using Infrastructure;
using OpenAuth.App.Interface;
using OpenAuth.App.Response;
using SqlSugar;
using OpenAuth.App.Request;

namespace OpenAuth.App
{
    /// <summary>
    /// 动态API应用层
    /// 用于直接操作数据库表，不依赖实体
    /// </summary>
    public class DynamicApiApp
    {
        private readonly ISqlSugarClient _client;
        private readonly IAuth _auth;
        private readonly IServiceProvider _serviceProvider;

        public DynamicApiApp(ISqlSugarClient client, IAuth auth, IServiceProvider serviceProvider)
        {
            _client = client;
            _auth = auth;
            _serviceProvider = serviceProvider;
        }

        /// <summary>
        /// 获取表数据列表
        /// </summary>
        /// <param name="req">查询参数</param>
        /// <returns></returns>
        public async Task<TableData> GetList(QueryDynamicListReq req)
        {
            var result = new TableData();
            try
            {
                // 验证表名是否存在
                if (!TableExists(req.TableName))
                {
                    result.code = 500;
                    result.msg = $"表不存在：{req.TableName}";
                    return result;
                }

                // 创建动态查询
                var queryable = _client.Queryable<dynamic>().AS(req.TableName);

                // 获取表结构
                var columns = GetTableColumns(req.TableName);

                // 如果有搜索关键字，尝试在常见字段中搜索
                if (!string.IsNullOrEmpty(req.key))
                {
                    //todo: 尝试在Name、Title等常见字段中搜索
                    var nameColumn = columns.FirstOrDefault(c =>
                        c.DbColumnName.Equals("Name", StringComparison.OrdinalIgnoreCase));

                    if (nameColumn != null)
                    {
                        queryable = queryable.Where($"{nameColumn.DbColumnName} like @key", new { key = $"%{req.key}%" });
                    }
                }

                // 获取总记录数
                var total = await queryable.CountAsync();

                // 分页查询
                var list = await queryable
                    .OrderBy($"{columns[0].DbColumnName} DESC")
                    .Skip((req.page - 1) * req.limit)
                    .Take(req.limit)
                    .ToListAsync();

                result.data = list;
                result.count = total;
            }
            catch (Exception ex)
            {
                result.code = 500;
                result.msg = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        /// <summary>
        /// 获取表数据详情
        /// </summary>
        /// <param name="tableName">表名称</param>
        /// <param name="id">记录ID</param>
        /// <returns></returns>
        public async Task<Response<object>> Get(QueryDynamicEntityReq req)
        {
            var result = new Response<object>();
            try
            {
                // 验证表名是否存在
                if (!TableExists(req.TableName))
                {
                    result.Code = 500;
                    result.Message = $"表不存在：{req.TableName}";
                    return result;
                }

                // 获取数据
                var entity = await _client.Queryable<dynamic>()
                    .AS(req.TableName)
                    .Where("Id = @id", new { id = req.Id })
                    .FirstAsync();

                if (entity == null)
                {
                    result.Code = 500;
                    result.Message = "未找到记录";
                    return result;
                }

                result.Result = entity;
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        /// <summary>
        /// 添加表数据
        /// </summary>
        /// <param name="tableName">表名称</param>
        /// <param name="obj">数据对象
        /// <para>如果数据里面没有Id，自动会添加ID</para>
        /// </param>
        /// <returns></returns>
        public async Task<Response<object>> Add(AddOrUpdateDynamicEntityReq req)
        {
            var result = new Response<object>();
            try
            {
                // 验证表名是否存在
                if (!TableExists(req.TableName))
                {
                    result.Code = 500;
                    result.Message = $"表不存在：{req.TableName}";
                    return result;
                }

                // 将对象转换为字典
                var dict = JsonHelper.Instance.Deserialize<Dictionary<string, Object>>(req.Obj);

                // 设置ID
                if (!dict.ContainsKey("Id"))
                {
                    dict["Id"] = Guid.NewGuid().ToString();
                }
                else if (string.IsNullOrEmpty(dict["Id"]?.ToString()))
                {
                    dict["Id"] = Guid.NewGuid().ToString();
                }
                else
                {
                    //如果Id不为空,需要判断Id是否存在
                    var entity = await _client.Queryable<dynamic>()
                        .AS(req.TableName)
                        .Where("Id = @id", new { id = dict["Id"] })
                        .FirstAsync();
                    if (entity != null)
                    {
                        result.Code = 500;
                        result.Message = "Id已存在";
                        return result;
                    }
                }

                //如果有CreateTime字段，自动设置
                if (dict.ContainsKey("CreateTime"))
                {
                    dict["CreateTime"] = DateTime.Now.ToString();
                }

                // 添加数据
                await _client.Insertable(dict)
                    .AS(req.TableName)
                    .ExecuteCommandAsync();

                result.Message = "添加成功";
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        /// <summary>
        /// 更新表数据
        /// </summary>
        /// <param name="tableName">表名称</param>
        /// <param name="obj">数据对象</param>
        /// <returns></returns>
        public async Task<Infrastructure.Response> Update(AddOrUpdateDynamicEntityReq req)
        {
            var result = new Infrastructure.Response();
            try
            {
                // 验证表名是否存在
                if (!TableExists(req.TableName))
                {
                    result.Code = 500;
                    result.Message = $"表不存在：{req.TableName}";
                    return result;
                }

                // 将对象转换为字典
                var dict =  JsonHelper.Instance.Deserialize<Dictionary<string, Object>>(req.Obj);

                // 检查ID是否存在
                if (!dict.ContainsKey("Id"))
                {
                    result.Code = 500;
                    result.Message = "更新数据必须包含Id字段";
                    return result;
                }

                // 如果有UpdateTime字段，自动设置
                if (dict.ContainsKey("UpdateTime"))
                {
                    dict["UpdateTime"] = DateTime.Now.ToString();
                }

                // 如果有用户信息，设置更新用户
                var currentUser = _auth.GetCurrentUser();
                if (dict.ContainsKey("UpdateUserId") && currentUser != null)
                {
                    // 设置更新用户信息
                    dict["UpdateUserId"] = currentUser.User.Id;
                    dict["UpdateUserName"] = currentUser.User.Name;
                }

                // 更新数据
                await _client.Updateable(dict)
                    .AS(req.TableName)
                    .WhereColumns("Id")  // 使用Id作为更新条件
                    .ExecuteCommandAsync();

                result.Message = "更新成功";
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        /// <summary>
        /// 批量删除表数据
        /// </summary>
        /// <param name="tableName">表名称</param>
        /// <param name="ids">记录ID数组</param>
        /// <returns></returns>
        public async Task<Infrastructure.Response> Delete(DelDynamicReq req)
        {
            var result = new Infrastructure.Response();
            try
            {
                // 验证表名是否存在
                if (!TableExists(req.TableName))
                {
                    result.Code = 500;
                    result.Message = $"表不存在：{req.TableName}";
                    return result;
                }

                // 批量删除数据
                await _client.Deleteable<dynamic>()
                    .AS(req.TableName)
                    .Where("Id in (@ids)", new { ids = req.Ids })
                    .ExecuteCommandAsync();

                result.Message = "批量删除成功";
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        /// <summary>
        /// 检查表是否存在
        /// </summary>
        /// <param name="tableName">表名</param>
        /// <returns></returns>
        private bool TableExists(string tableName)
        {
            // 获取数据库类型
            var dbType = _client.CurrentConnectionConfig.DbType;
            string sql = string.Empty;

            switch (dbType)
            {
                case DbType.SqlServer:
                    sql = $"SELECT COUNT(1) FROM sys.tables WHERE name = '{tableName}'";
                    break;
                case DbType.MySql:
                    sql = $"SELECT COUNT(1) FROM information_schema.tables WHERE table_name = '{tableName}' AND table_schema = DATABASE()";
                    break;
                case DbType.PostgreSQL:
                    sql = $"SELECT COUNT(1) FROM pg_tables WHERE tablename = '{tableName.ToLower()}'";
                    break;
                case DbType.Oracle:
                    sql = $"SELECT COUNT(1) FROM user_tables WHERE table_name = '{tableName.ToUpper()}'";
                    break;
                default:
                    throw new NotSupportedException($"不支持的数据库类型：{dbType}");
            }

            var count = _client.Ado.GetInt(sql);
            return count > 0;
        }

        /// <summary>
        /// 获取表字段信息
        /// </summary>
        /// <param name="tableName">表名</param>
        /// <returns></returns>
        private List<DbColumnInfo> GetTableColumns(string tableName)
        {
            return _client.DbMaintenance.GetColumnInfosByTableName(tableName);
        }

        /// <summary>
        /// 调用OpenAuth.App的各种应用
        /// </summary>
        /// <param name="req">调用参数</param>
        /// <returns></returns>
        public object Invoke(InvokeDynamicReq req)
        {
            var result = new object();

            // 获取服务类型
            var serviceType = Type.GetType($"OpenAuth.App.{req.ServiceName}, OpenAuth.App");
            if (serviceType == null)
            {
                throw new Exception($"未找到服务类型：{req.ServiceName}");
            }

            // 获取服务实例
            var service = _serviceProvider.GetService(serviceType);
            if (service == null)
            {
                throw new Exception($"无法获取服务实例：{req.ServiceName}");
            }

            // 获取方法信息
            var method = serviceType.GetMethod(req.MethodName);
            if (method == null)
            {
                throw new Exception($"未找到方法：{req.MethodName}");
            }

            // 获取方法参数信息
            var parameters = method.GetParameters();
            var paramValues = new object[parameters.Length];
            
            // 构建参数数组
            for (int i = 0; i < parameters.Length; i++)
            {
                var param = parameters[i];
                
                // 尝试从JSON中获取参数值
                try
                {
                    var json = req.Parameters;
                    // 检查参数名是否存在于JSON中
                    if (json.Contains($"\"{param.Name}\""))
                    {
                        // 解析完整的JSON对象
                        var jsonObj = JsonHelper.Instance.Deserialize<Dictionary<string, object>>(json);
                        
                        // 从JSON对象中获取参数值
                        if (jsonObj.ContainsKey(param.Name))
                        {
                            // 获取参数对应的JSON值并序列化为字符串
                            var paramValue = JsonHelper.Instance.Serialize(jsonObj[param.Name]);
                            
                            // 将JSON字符串反序列化为目标类型
                            var deserializeMethod = typeof(JsonHelper).GetMethod("Deserialize").MakeGenericMethod(param.ParameterType);
                            paramValues[i] = deserializeMethod.Invoke(JsonHelper.Instance, new object[] { paramValue });
                        }
                        else
                        {
                            // 参数名存在但获取不到，使用默认值
                            paramValues[i] = param.HasDefaultValue ? param.DefaultValue : null;
                        }
                    }
                    else
                    {
                        // 如果JSON中没有对应的属性，使用默认值
                        paramValues[i] = param.HasDefaultValue ? param.DefaultValue : null;
                    }
                }
                catch (Exception ex)
                {
                    // 记录错误日志
                    Console.WriteLine($"反序列化参数 {param.Name} 失败: {ex.Message}");
                    // 反序列化失败，使用默认值
                    paramValues[i] = param.HasDefaultValue ? param.DefaultValue : null;
                }
            }
            
            // 使用参数数组调用方法
            result = method.Invoke(service, paramValues);

            return result;
        }

    }
   
}