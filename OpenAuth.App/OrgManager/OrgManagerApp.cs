using System;
using System.Collections.Generic;
using System.Linq;
using Infrastructure;
using OpenAuth.App.Interface;
using OpenAuth.App.Request;
using OpenAuth.App.Response;
using OpenAuth.Repository;
using OpenAuth.Repository.Domain;
using OpenAuth.Repository.Interface;
using SqlSugar;

namespace OpenAuth.App
{
    public class OrgManagerApp : SqlSugarBaseTreeApp<SysOrg>
    {
        private RevelanceManagerApp _revelanceApp;
        /// <summary>
        /// 添加部门
        /// </summary>
        /// <param name="sysOrg">The org.</param>
        /// <returns>System.Int32.</returns>
        /// <exception cref="System.Exception">未能找到该组织的父节点信息</exception>
        public string Add(SysOrg sysOrg)
        {
            var loginContext = _auth.GetCurrentUser();
            if (loginContext == null)
            {
                throw new CommonException("登录已过期", Define.INVALID_TOKEN);
            }
            CaculateCascade(sysOrg);

            SugarClient.Ado.BeginTran();
            Repository.Insert(sysOrg);

            //如果当前账号不是SYSTEM，则直接分配
            if (loginContext.User.Account != Define.SYSTEM_USERNAME)
            {
                _revelanceApp.Assign(new AssignReq
                {
                    type = Define.USERORG,
                    firstId = loginContext.User.Id,
                    secIds = new[] { sysOrg.Id }
                });
            }
            SugarClient.Ado.CommitTran();

            return sysOrg.Id;
        }

        public string Update(SysOrg sysOrg)
        {
            if (sysOrg.Id == sysOrg.ParentId)
            {
                throw new Exception("上级节点不能为自己");
            }
            UpdateTreeObj(sysOrg);

            return sysOrg.Id;
        }

        /// <summary>
        /// 删除指定ID的部门及其所有子部门
        /// </summary>
        public void DelOrgCascade(string[] ids)
        {
            var delOrgCascadeIds = SugarClient.Queryable<SysOrg>().Where(u => ids.Contains(u.Id)).Select(u => u.CascadeId).ToArray();
            var delOrgIds = new List<string>();
            foreach (var cascadeId in delOrgCascadeIds)
            {
                delOrgIds.AddRange(SugarClient.Queryable<SysOrg>().Where(u => u.CascadeId.Contains(cascadeId)).Select(u => u.Id).ToArray());
            }

            SugarClient.Deleteable<Relevance>().Where(u => u.RelKey == Define.USERORG && delOrgIds.Contains(u.SecondId)).ExecuteCommand();
            SugarClient.Deleteable<SysOrg>().Where(u => delOrgIds.Contains(u.Id)).ExecuteCommand();

        }

        /// <summary>
        /// 获取所有机构
        /// </summary>
        /// <returns></returns>
        public List<OrgView> LoadAll()
        {
            return SugarClient.Queryable<SysOrg>()
                    .LeftJoin<SysUser>((org, user) => org.ChairmanId ==user.Id)
                    .Select((org,user)=>new OrgView
                    {
                        Id = org.Id.SelectAll(),
                        ChairmanName = user.Name
                    }).ToList();
        }

        public OrgManagerApp(ISqlSugarClient client, IAuth auth,
            RevelanceManagerApp revelanceApp) : base(client, auth)
        {
            _revelanceApp = revelanceApp;
        }

        public string[] GetChairmanId(string[] orgIds)
        {
            return SugarClient.Queryable<SysOrg>().Where(u => orgIds.Contains(u.Id) && u.ChairmanId != null).Select(u => u.ChairmanId).ToArray();
        }
    }
}