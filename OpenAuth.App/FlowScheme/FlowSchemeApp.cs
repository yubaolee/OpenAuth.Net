using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Infrastructure;
using Infrastructure.Helpers;
using OpenAuth.App.Interface;
using OpenAuth.App.Request;
using OpenAuth.App.Response;
using OpenAuth.Repository.Domain;
using SqlSugar;

namespace OpenAuth.App
{
    public class FlowSchemeApp :SqlSugarBaseApp<FlowScheme>
    {
        public void Add(FlowScheme flowScheme)
        {
            if (Repository.IsAny(u => u.SchemeName == flowScheme.SchemeName))
            {
                throw new Exception("流程名称已经存在");
            }
            
            var user = _auth.GetCurrentUser().User;
            flowScheme.CreateUserId = user.Id;
            flowScheme.CreateUserName = user.Name;
            Repository.Insert(flowScheme);
        }

        public FlowScheme FindByCode(string code)
        {
            return Repository.GetFirst(u => u.SchemeCode == code);
        }

        public void Update(FlowScheme flowScheme)
        {
            if (Repository.IsAny(u => u.SchemeName == flowScheme.SchemeName && u.Id != flowScheme.Id))
            {
                throw new Exception("流程名称已经存在");
            }

            Repository.Update(u => new FlowScheme
            {
                SchemeContent = flowScheme.SchemeContent,
                SchemeName = flowScheme.SchemeName,
                ModifyDate = TimeHelper.Now,
                FrmId = flowScheme.FrmId,
                FrmType = flowScheme.FrmType,
                FrmUrlTemplate = flowScheme.FrmUrlTemplate,
                Disabled = flowScheme.Disabled,
                Description = flowScheme.Description,
                OrgId = flowScheme.OrgId
            },u => u.Id == flowScheme.Id);
        }

        /// <summary>
        /// 加载所有流程表单为URL表单的流程模板
        /// <para>
        /// 目前业务系统只挂载URL表单，后期优化挂载其他表单类型
        /// </para>
        /// </summary>
        /// <returns></returns>
        public List<FlowScheme> LoadUrlFormFlowScheme()
        {
            return Repository.GetList(u => u.FrmType == Define.FORM_TYPE_URL);
        }


        public async Task<PagedDynamicDataResp> Load(QueryFlowSchemeListReq request)
        {
            var result = new PagedDynamicDataResp();
            var objs = GetDataPrivilege("u");
            if (!string.IsNullOrEmpty(request.key))
            {
                objs = objs.Where(u => u.SchemeName.Contains(request.key) || u.Id.Contains(request.key));
            }

            result.Data = await objs.OrderByDescending(u => u.CreateDate)
                .Skip((request.page - 1) * request.limit)
                .Take(request.limit).ToListAsync();
            result.Count = await objs.CountAsync();
            return result;
        }

        public FlowSchemeApp(ISqlSugarClient client, IAuth auth) : base(client, auth)
        {
        }
    }
}
