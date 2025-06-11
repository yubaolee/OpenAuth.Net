using System;
using System.Linq;
using System.Threading.Tasks;
using Infrastructure;
using OpenAuth.App.Interface;
using OpenAuth.App.Request;
using OpenAuth.App.Response;
using OpenAuth.Repository.Domain;
using SqlSugar;

namespace OpenAuth.App
{
    public class DataPrivilegeRuleApp : SqlSugarBaseApp<DataPrivilegeRule>
    {
        /// <summary>
        /// 加载列表
        /// </summary>
        public async Task<PagedDynamicDataResp> Load(QueryDataPrivilegeRuleListReq request)
        {
            var loginContext = _auth.GetCurrentUser();
            if (loginContext == null)
            {
                throw new CommonException("登录已过期", Define.INVALID_TOKEN);
            }
            
            var columnFields = loginContext.GetTableColumns("DataPrivilegeRule");
            if (columnFields == null || columnFields.Count == 0)
            {
                throw new Exception("请在代码生成界面配置DataPrivilegeRule表的字段属性");
            }

            var result = new PagedDynamicDataResp();
            var objs = SugarClient.Queryable<DataPrivilegeRule>();
            if (!string.IsNullOrEmpty(request.key))
            {
                objs = objs.Where(u => u.Id.Contains(request.key) || u.SourceCode.Contains(request.key) || u.Description.Contains(request.key));
            }
            if (!string.IsNullOrEmpty(request.sqlWhere))
            {
                objs = objs.Where(request.sqlWhere);
            }

            var propertyStr = string.Join(',', columnFields.Select(u => u.ColumnName));
            result.ColumnFields = columnFields;
            result.Data = objs.OrderBy(u => u.Id)
                .Skip((request.page - 1) * request.limit)
                .Take(request.limit).Select($"{propertyStr}").ToList();
            result.Count = await objs.CountAsync();
            return result;
        }

        public void Add(AddOrUpdateDataPriviReq req)
        {
            if (Repository.IsAny(u => u.SourceCode == req.SourceCode))
            {
                throw new Exception($"已经存在{req.SourceCode}的数据规则，如果想调整规制请直接修改");
            }
            var obj = req.MapTo<DataPrivilegeRule>();
            obj.CreateUserId = _auth.GetCurrentUser().User.Id;
            obj.CreateTime = DateTime.Now;
            SugarClient.Insertable(obj).ExecuteCommand();
        }
        
        public void Update(AddOrUpdateDataPriviReq obj)
        {
             Repository.Update(u => new DataPrivilegeRule
            {
                SortNo = obj.SortNo,
                SourceCode = obj.SourceCode,
                UpdateTime = DateTime.Now,
                UpdateUserId = _auth.GetCurrentUser().User.Id,
                Description = obj.Description,
                PrivilegeRules = obj.PrivilegeRules,
                Enable = obj.Enable
               //todo:要修改的字段赋值
            },u => u.Id == obj.Id);
    
        }

        public DataPrivilegeRuleApp(ISqlSugarClient client, IAuth auth) : base(client, auth)
        {
        }

        public DataPrivilegeRule GetByModuleName(string moduleName)
        {
            return Repository.GetFirst(u=>u.SourceCode == moduleName);
        }

        public void Clear()
        {
            SugarClient.Deleteable<DataPrivilegeRule>(u => true).ExecuteCommand();
        }
    }
}