﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Infrastructure;
using Microsoft.EntityFrameworkCore;
using OpenAuth.App.Interface;
using OpenAuth.App.Request;
using OpenAuth.App.Response;
using OpenAuth.Repository;
using OpenAuth.Repository.Domain;
using OpenAuth.Repository.Interface;


namespace OpenAuth.App
{
    public class CategoryApp : BaseStringApp<Category,OpenAuthDBContext>
    {
        /// <summary>
        /// 加载列表
        /// </summary>
        public async Task<TableData> Load(QueryCategoryListReq request)
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
            
            var result = new TableData();
            var objs = UnitWork.Find<Category>(null);
            if (!string.IsNullOrEmpty(request.TypeId))
            {
                objs = objs.Where(u => u.TypeId == request.TypeId);
            }
            
            if (!string.IsNullOrEmpty(request.key))
            {
                objs = objs.Where(u => u.Id.Contains(request.key) || u.Name.Contains(request.key));
            }

            var propertyStr = string.Join(',', columnFields.Select(u =>u.ColumnName));
            result.columnFields = columnFields;
            result.data = objs.OrderBy(u => u.DtCode)
                .Skip((request.page - 1) * request.limit)
                .Take(request.limit).Select($"new ({propertyStr})");
            result.count = await objs.CountAsync();
            return result;
        }

        public async Task Add(AddOrUpdateCategoryReq req)
        {
            var obj = req.MapTo<Category>();
            obj.CreateTime = DateTime.Now;
            var user = _auth.GetCurrentUser().User;
            obj.CreateUserId = user.Id;
            obj.CreateUserName = user.Name;
            await Repository.AddAsync(obj);
        }
        
        public void Update(AddOrUpdateCategoryReq obj)
        {
            var user = _auth.GetCurrentUser().User;
            UnitWork.Update<Category>(u => u.Id == obj.Id, u => new Category
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
            });

        }

        /// <summary>
        /// 加载一个分类类型里面的所有值，即字典的所有值
        /// </summary>
        /// <param name="typeId"></param>
        /// <returns></returns>
        public List<Category> LoadByTypeId(string typeId)
        {
            return Repository.Find(u => u.TypeId == typeId).ToList();
        }

        public CategoryApp(IUnitWork<OpenAuthDBContext> unitWork, IRepository<Category,OpenAuthDBContext> repository,IAuth auth) : base(unitWork, repository, auth)
        {
        }
    }
}