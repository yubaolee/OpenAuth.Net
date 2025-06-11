using System;
using System.Collections.Generic;
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
    public class CategoryApp : SqlSugarBaseApp<Category>
    {
        /// <summary>
        /// 加载列表
        /// </summary>
        public async Task<PagedDynamicDataResp> Load(QueryCategoryListReq request)
        {
            var loginContext = _auth.GetCurrentUser();
            if (loginContext == null)
            {
                throw new CommonException("登录已过期", Define.INVALID_TOKEN);
            }
            
            var columnFields = loginContext.GetTableColumns("Category");
            if (columnFields == null || columnFields.Count == 0)
            {
                //因为分类字典值需要在别的地方使用，必需初始化有值
                columnFields = new List<BuilderTableColumn>
                {
                    new() { ColumnName = "Name", ColumnType = "string" },
                    new() { ColumnName = "DtCode", ColumnType = "string" },
                    new() { ColumnName = "DtValue", ColumnType = "string" }
                };
            }
            
            var result = new PagedDynamicDataResp();
            var objs = SugarClient.Queryable<Category>();
            if (!string.IsNullOrEmpty(request.TypeId))
            {
                objs = objs.Where(u => u.TypeId == request.TypeId);
            }
            
            if (!string.IsNullOrEmpty(request.key))
            {
                objs = objs.Where(u => u.Id.Contains(request.key) || u.Name.Contains(request.key));
            }

            if (!string.IsNullOrEmpty(request.sqlWhere))
            {
                objs = objs.Where(request.sqlWhere);
            }

            var propertyStr = string.Join(',', columnFields.Select(u =>u.ColumnName));
            result.ColumnFields = columnFields;
            result.Data = objs.OrderBy(u => u.DtCode)
                .Skip((request.page - 1) * request.limit)
                .Take(request.limit).Select($"{propertyStr}").ToList();
            result.Count = await objs.CountAsync();
            return result;
        }

        public async Task Add(AddOrUpdateCategoryReq req)
        {
            var obj = req.MapTo<Category>();
            obj.CreateTime = DateTime.Now;
            var user = _auth.GetCurrentUser().User;
            obj.CreateUserId = user.Id;
            obj.CreateUserName = user.Name;
            await SugarClient.Insertable(obj).ExecuteCommandAsync();
        }
        
        public void Update(AddOrUpdateCategoryReq obj)
        {
            var user = _auth.GetCurrentUser().User;
            Repository.Update(u => new Category
            {
                Name = obj.Name,
                Enable = obj.Enable,
                DtValue = obj.DtValue,
                DtCode = obj.DtCode,
                TypeId = obj.TypeId,
                UpdateTime = DateTime.Now,
                UpdateUserId = user.Id,
                UpdateUserName = user.Name,
                SortNo = obj.SortNo
            },u => u.Id == obj.Id);

        }

        /// <summary>
        /// 加载一个分类类型里面的所有值，即字典的所有值
        /// </summary>
        /// <param name="typeId"></param>
        /// <returns></returns>
        public List<Category> LoadByTypeId(string typeId)
        {
            return SugarClient.Queryable<Category>().Where(u => u.TypeId == typeId).ToList();
        }

        public CategoryApp(ISqlSugarClient client, IAuth auth) : base(client, auth)
        {
        }
    }
}