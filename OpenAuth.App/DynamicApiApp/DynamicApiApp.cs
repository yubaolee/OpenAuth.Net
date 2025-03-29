using System;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Infrastructure;
using OpenAuth.App.Interface;
using OpenAuth.App.Response;
using OpenAuth.Repository.Core;
using SqlSugar;

namespace OpenAuth.App
{
    /// <summary>
    /// 动态API应用层
    /// 用于处理任意实体的CRUD操作
    /// </summary>
    public class DynamicApiApp 
    {
        private readonly ISqlSugarClient _client;
        private readonly IAuth _auth;

        public DynamicApiApp(ISqlSugarClient client, IAuth auth)
        {
            _client = client;
            _auth = auth;
        }

        /// <summary>
        /// 获取实体列表
        /// </summary>
        /// <param name="entityName">实体名称，例如：ExternalDataSource</param>
        /// <param name="page">页码</param>
        /// <param name="limit">每页记录数</param>
        /// <param name="key">搜索关键字</param>
        /// <returns></returns>
        public async Task<TableData> GetList(string entityName, int page = 1, int limit = 10, string key = "")
        {
            var result = new TableData();
            try
            {
                // 获取实体类型
                var entityType = GetEntityType(entityName);
                if (entityType == null)
                {
                    result.code = 500;
                    result.msg = $"未找到实体：{entityName}";
                    return result;
                }

                // 创建动态查询
                dynamic queryable = _client.GetType().GetMethod("Queryable", new Type[] { })
                    .MakeGenericMethod(entityType)
                    .Invoke(_client, null);
                
                // 如果有搜索关键字，尝试在常见字段中搜索
                if (!string.IsNullOrEmpty(key))
                {
                    // 获取实体的所有属性
                    var properties = entityType.GetProperties();
                    
                    // 尝试在Name、Title等常见字段中搜索
                    var nameProperty = properties.FirstOrDefault(p => 
                        p.Name.Equals("Name", StringComparison.OrdinalIgnoreCase));
                    
                    if (nameProperty != null)
                    {
                        queryable = queryable.Where($"{nameProperty.Name} like @key", new { key = $"%{key}%" });
                    }
                }

                // 获取总记录数
                var total = await queryable.CountAsync();
                
                // 分页查询
                var list = await queryable.OrderBy("CreateTime DESC")
                    .Skip((page - 1) * limit)
                    .Take(limit)
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
        /// 获取实体详情
        /// </summary>
        /// <param name="entityName">实体名称，例如：ExternalDataSource</param>
        /// <param name="id">实体ID</param>
        /// <returns></returns>
        public Response<object> Get(string entityName, string id)
        {
            var result = new Response<object>();
            try
            {
                // 获取实体类型
                var entityType = GetEntityType(entityName);
                if (entityType == null)
                {
                    result.Code = 500;
                    result.Message = $"未找到实体：{entityName}";
                    return result;
                }

                // 获取实体
                dynamic queryable = _client.GetType().GetMethod("Queryable", new Type[] { })
                    .MakeGenericMethod(entityType)
                    .Invoke(_client, null);
                
                var entity = queryable.Where("Id = @id", new { id }).First();
                
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
        /// 添加实体
        /// </summary>
        /// <param name="entityName">实体名称，例如：ExternalDataSource</param>
        /// <param name="obj">实体对象</param>
        /// <returns></returns>
        public Infrastructure.Response Add(string entityName, object obj)
        {
            var result = new Infrastructure.Response();
            try
            {
                // 获取实体类型
                var entityType = GetEntityType(entityName);
                if (entityType == null)
                {
                    result.Code = 500;
                    result.Message = $"未找到实体：{entityName}";
                    return result;
                }

                // 将传入的对象转换为实体类型
                var entity = obj.MapTo(entityType);
                
                // 设置创建信息
                var idProperty = entityType.GetProperty("Id");
                if (idProperty != null && idProperty.PropertyType == typeof(string))
                {
                    idProperty.SetValue(entity, Guid.NewGuid().ToString());
                }
                
                var createTimeProperty = entityType.GetProperty("CreateTime");
                if (createTimeProperty != null && createTimeProperty.PropertyType == typeof(DateTime))
                {
                    createTimeProperty.SetValue(entity, DateTime.Now);
                }
                
                // 如果有用户信息，设置创建用户
                var currentUser = _auth.GetCurrentUser();
                if (currentUser != null)
                {
                    // 尝试设置创建用户信息
                    TrySetProperty(entity, "CreateUserId", currentUser.User.Id);
                    TrySetProperty(entity, "CreateUserName", currentUser.User.Name);
                }

                // 添加实体
                var insertMethod = _client.GetType().GetMethod("Insertable")
                    .MakeGenericMethod(entityType);
                dynamic insertable = insertMethod.Invoke(_client, new[] { entity });
                insertable.ExecuteCommand();
                
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
        /// 更新实体
        /// </summary>
        /// <param name="entityName">实体名称，例如：ExternalDataSource</param>
        /// <param name="obj">实体对象</param>
        /// <returns></returns>
        public Infrastructure.Response Update(string entityName, object obj)
        {
            var result = new Infrastructure.Response();
            try
            {
                // 获取实体类型
                var entityType = GetEntityType(entityName);
                if (entityType == null)
                {
                    result.Code = 500;
                    result.Message = $"未找到实体：{entityName}";
                    return result;
                }

                // 将传入的对象转换为实体类型
                var entity = obj.MapTo(entityType);
                
                // 设置更新信息
                // 尝试设置更新时间
                TrySetProperty(entity, "UpdateTime", DateTime.Now);
                
                // 如果有用户信息，设置更新用户
                var currentUser = _auth.GetCurrentUser();
                if (currentUser != null)
                {
                    // 尝试设置更新用户信息
                    TrySetProperty(entity, "UpdateUserId", currentUser.User.Id);
                    TrySetProperty(entity, "UpdateUserName", currentUser.User.Name);
                }

                // 更新实体
                var updateMethod = _client.GetType().GetMethod("Updateable")
                    .MakeGenericMethod(entityType);
                dynamic updateable = updateMethod.Invoke(_client, new[] { entity });
                updateable.ExecuteCommand();
                
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
        /// 删除实体
        /// </summary>
        /// <param name="entityName">实体名称，例如：ExternalDataSource</param>
        /// <param name="id">实体ID</param>
        /// <returns></returns>
        public Infrastructure.Response Delete(string entityName, string id)
        {
            var result = new Infrastructure.Response();
            try
            {
                // 获取实体类型
                var entityType = GetEntityType(entityName);
                if (entityType == null)
                {
                    result.Code = 500;
                    result.Message = $"未找到实体：{entityName}";
                    return result;
                }

                // 创建动态查询
                dynamic queryable = _client.GetType().GetMethod("Queryable", new Type[] { })
                    .MakeGenericMethod(entityType)
                    .Invoke(_client, null);
                
                // 获取要删除的实体
                var entity = queryable.Where("Id = @id", new { id }).First();
                
                if (entity == null)
                {
                    result.Code = 500;
                    result.Message = "未找到要删除的实体";
                    return result;
                }
                
                // 删除实体
                var deleteMethod = _client.GetType().GetMethod("Deleteable")
                    .MakeGenericMethod(entityType);
                dynamic deleteable = deleteMethod.Invoke(_client, new[] { entity });
                deleteable.ExecuteCommand();
                
                result.Message = "删除成功";
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.InnerException?.Message ?? ex.Message;
            }

            return result;
        }

        /// <summary>
        /// 批量删除实体
        /// </summary>
        /// <param name="entityName">实体名称，例如：ExternalDataSource</param>
        /// <param name="ids">实体ID数组</param>
        /// <returns></returns>
        public Infrastructure.Response BatchDelete(string entityName, string[] ids)
        {
            var result = new Infrastructure.Response();
            try
            {
                // 获取实体类型
                var entityType = GetEntityType(entityName);
                if (entityType == null)
                {
                    result.Code = 500;
                    result.Message = $"未找到实体：{entityName}";
                    return result;
                }

                // 创建动态查询
                dynamic queryable = _client.GetType().GetMethod("Queryable", new Type[] { })
                    .MakeGenericMethod(entityType)
                    .Invoke(_client, null);
                
                // 获取要删除的实体列表
                var entities = queryable.Where("Id in (@ids)", new { ids }).ToList();
                
                if (entities == null || entities.Count == 0)
                {
                    result.Code = 500;
                    result.Message = "未找到要删除的实体";
                    return result;
                }
                
                // 批量删除实体
                var deleteMethod = _client.GetType().GetMethod("Deleteable")
                    .MakeGenericMethod(entityType);
                dynamic deleteable = deleteMethod.Invoke(_client, new[] { entities });
                deleteable.ExecuteCommand();
                
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
        /// 获取实体类型
        /// </summary>
        /// <param name="entityName">实体名称</param>
        /// <returns></returns>
        private Type GetEntityType(string entityName)
        {
            // 获取所有实体类型
            var entityTypes = typeof(StringEntity).Assembly.GetTypes()
                .Where(t => t.IsClass && !t.IsAbstract && t.IsSubclassOf(typeof(StringEntity)))
                .ToList();

            // 查找匹配的实体类型
            return entityTypes.FirstOrDefault(t => 
                t.Name.Equals(entityName, StringComparison.OrdinalIgnoreCase));
        }

        /// <summary>
        /// 尝试设置属性值
        /// </summary>
        /// <param name="obj">对象</param>
        /// <param name="propertyName">属性名</param>
        /// <param name="value">属性值</param>
        private void TrySetProperty(object obj, string propertyName, object value)
        {
            var property = obj.GetType().GetProperty(propertyName, 
                BindingFlags.Public | BindingFlags.Instance | BindingFlags.IgnoreCase);
            
            if (property != null && property.CanWrite)
            {
                property.SetValue(obj, value);
            }
        }
    }
}