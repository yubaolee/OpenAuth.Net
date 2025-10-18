using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.AccessControl;
using System.Threading.Tasks;
using Infrastructure;
using NUnit.Framework;
using OpenAuth.App.Interface;
using OpenAuth.App.Request;
using OpenAuth.App.Response;
using OpenAuth.Repository.Domain;
using SqlSugar;
using Infrastructure.Helpers;

namespace OpenAuth.App
{
    /// <summary>
    /// 分类管理
    /// </summary>
    public class ResourceApp:SqlSugarBaseApp<SysResource>
    {
        private RevelanceManagerApp _revelanceApp;
        private ApiService _apiService;

        private readonly IAuth _auth;

        public ResourceApp(ISqlSugarClient client, IAuth auth, RevelanceManagerApp revelanceApp, ApiService apiService) : base(client, auth)
        {
            _revelanceApp = revelanceApp;
            _apiService = apiService;
            _auth = auth;
        }

        public void Add(AddOrUpdateResReq resource)
        {
            var obj = resource.MapTo<SysResource>();
            CaculateCascade(obj);
            obj.CreateTime = TimeHelper.Now;
            var user = _auth.GetCurrentUser().User;
            obj.CreateUserId = user.Id;
            obj.CreateUserName = user.Name;
            Repository.Insert(obj);
        }

        public void Update(AddOrUpdateResReq obj)
        {
            var user = _auth.GetCurrentUser().User;
            Repository.Update(u => new SysResource
            {
                Name = obj.Name,
                Disable = obj.Disable,
                CascadeId = obj.CascadeId,
                AppId = obj.AppId,
                AppName = obj.AppName,
                ParentId = obj.ParentId,
                ParentName = obj.ParentName,
                TypeId = obj.TypeId,
                TypeName = obj.TypeName,
                Description = obj.Description,
                UpdateTime = TimeHelper.Now,
                UpdateUserId = user.Id,
                UpdateUserName = user.Name
                //todo:要修改的字段赋值
            },u => u.Id == obj.Id);
        }

        public IEnumerable<SysResource> LoadForRole(string appId, string roleId)
        {
            var elementIds = _revelanceApp.Get(Define.ROLERESOURCE, true, roleId);
            return SugarClient.Queryable<SysResource>().Where(u => elementIds.Contains(u.Id) && (appId == null || appId =="" || u.AppId == appId)).ToArray();
        }

        public List<SysResource> LoadByIds(string[] ids)
        {
            return SugarClient.Queryable<SysResource>().Where(u => ids.Contains(u.Id)).ToList();
        }
        
        public async Task<PagedDynamicDataResp> Load(QueryResourcesReq request)
        {
            var loginContext = _auth.GetCurrentUser();
            if (loginContext == null)
            {
                throw new CommonException("登录已过期", Define.INVALID_TOKEN);
            }

            var columnFields = loginContext.GetTableColumns("SysResource");
            if (columnFields == null || columnFields.Count == 0)
            {
                throw new Exception("请在代码生成界面配置SysResource表的字段属性");
            }


            var result = new PagedDynamicDataResp();
            var resources = GetDataPrivilege("u");
            if (!string.IsNullOrEmpty(request.key))
            {
                resources = resources.Where(u => u.Name.Contains(request.key) || u.Id.Contains(request.key));
            }

            if (!string.IsNullOrEmpty(request.appId))
            {
                resources = resources.Where(u => u.AppId == request.appId);
            }

            if (!string.IsNullOrEmpty(request.sqlWhere))
            {
                resources = resources.Where(request.sqlWhere);
            }

            var columnnames = columnFields.Select(u => u.ColumnName);
            
            var propertyStr = string.Join(',', columnnames);
            result.ColumnFields = columnFields;
            result.Data = resources.OrderBy(u => u.TypeId)
                .Skip((request.page - 1) * request.limit)
                .Take(request.limit).Select($"{propertyStr}").ToList();
            result.Count = await resources.CountAsync();
            return result;
        }

        /// <summary>
        /// 获取资源类型
        /// </summary>
        /// <returns></returns>
        public async Task<List<SysResourceApp>> GetResourceApps()
        {
            var types = await SugarClient.Queryable<SysResource>()
                .Distinct()
                .Select(u => new {u.AppId,u.AppName})
                .ToListAsync();
            return types.Select(u => new SysResourceApp(u.AppId, u.AppName)).ToList();
        }
        /// <summary>
        /// 同步站点API到资源列表
        /// <para>读取站点API信息，如果资源列表中不存在，则添加</para>
        /// </summary>
        public async Task Sync()
        {
            var apis = await _apiService.GetSwaggerEndpoints();
            var user = _auth.GetCurrentUser().User;
            foreach (var api in apis)
            {
                //检查资源是否存在
                var resource = Repository.GetFirst(u => u.Name == api.Path && u.TypeId == Define.API);
                if (resource != null)
                {
                    continue;
                }

                resource = new SysResource
                {
                    Id = api.Path,
                    Name = api.Path,
                    Disable = false,
                    SortNo = 0,
                    AppId = $"{Define.API}_{api.Tag}",
                    AppName = $"API接口-{api.Tag}",
                    TypeId = Define.API,
                    TypeName = "API接口",
                    Description = api.Summary??"",
                    CreateTime = TimeHelper.Now,
                    CreateUserId = user.Id,
                    CreateUserName = user.Name
                };
                CaculateCascade(resource);
                Repository.Insert(resource);
            }
        }

        /// <summary>
        /// 判断当前登录用户是否拥有访问该API的权限
        /// <para>如果角色没有做任何分配，则默认拥有权限。这个可以根据实际需要修改。</para>
        /// </summary>
        /// <param name="apiPath">API路径</param>
        /// <returns>true:拥有权限,false:没有权限</returns>
        public bool CanAccess(string apiPath)
        {
            var loginContext = _auth.GetCurrentUser();
            if (loginContext == null)
            {
                throw new CommonException("登录已过期", Define.INVALID_TOKEN);
            }

            //如果当前登录用户是管理员，则拥有所有权限
            if(loginContext.User.Account == Define.SYSTEM_USERNAME){
                return true;
            }

            var elementIds = _revelanceApp.Get(Define.ROLERESOURCE, true, loginContext.Roles.Select(u => u.Id).ToArray());
            //如果角色没有做任何分配，则默认拥有权限。这个可以根据实际需要修改。
            if(elementIds.Count == 0)
            {
                return true;
            }
            //如果分配了资源，则判断是否拥有权限
            var resource = Repository.GetFirst(u => u.Name.Contains(apiPath) && u.TypeId == Define.API && elementIds.Contains(u.Id));
            if(resource == null)
            {
                return false;
            }
            return true;
        }
    }

    /// <summary>
    /// 资源类型
    /// </summary>
    public record SysResourceApp(string Id, string Name);
}