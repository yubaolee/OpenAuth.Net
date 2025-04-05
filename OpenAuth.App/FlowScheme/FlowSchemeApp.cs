using System;
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
    public class FlowSchemeApp :BaseStringApp<FlowScheme,OpenAuthDBContext>
    {
        public void Add(FlowScheme flowScheme)
        {
            if (Repository.Any(u => u.SchemeName == flowScheme.SchemeName))
            {
                throw new Exception("流程名称已经存在");
            }
            
            var user = _auth.GetCurrentUser().User;
            flowScheme.CreateUserId = user.Id;
            flowScheme.CreateUserName = user.Name;
            Repository.Add(flowScheme);
        }

        public FlowScheme FindByCode(string code)
        {
            return Repository.FirstOrDefault(u => u.SchemeCode == code);
        }

        public void Update(FlowScheme flowScheme)
        {
            if (Repository.Any(u => u.SchemeName == flowScheme.SchemeName && u.Id != flowScheme.Id))
            {
                throw new Exception("流程名称已经存在");
            }
            
            UnitWork.Update<FlowScheme>(u => u.Id == flowScheme.Id, u => new FlowScheme
            {
                FrmUrlTemplate = flowScheme.FrmUrlTemplate,
                SchemeContent = flowScheme.SchemeContent,
                SchemeName = flowScheme.SchemeName,
                ModifyDate = DateTime.Now,
                FrmId = flowScheme.FrmId,
                FrmType = flowScheme.FrmType,
                Disabled = flowScheme.Disabled,
                Description = flowScheme.Description,
                OrgId = flowScheme.OrgId
            });
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
            return Repository.Find(u => u.FrmType == Define.FORM_TYPE_URL).ToList();
        }


        public async Task<TableData> Load(QueryFlowSchemeListReq request)
        {
            var result = new TableData();
            var objs = GetDataPrivilege("u");
            if (!string.IsNullOrEmpty(request.key))
            {
                objs = objs.Where(u => u.SchemeName.Contains(request.key) || u.Id.Contains(request.key));
            }

            result.data = await objs.OrderByDescending(u => u.CreateDate)
                .Skip((request.page - 1) * request.limit)
                .Take(request.limit).ToListAsync();
            result.count = await objs.CountAsync();
            return result;
        }

        public FlowSchemeApp(IUnitWork<OpenAuthDBContext> unitWork, IRepository<FlowScheme,OpenAuthDBContext> repository,IAuth auth) : base(unitWork, repository, auth)
        {
        }
    }
}
