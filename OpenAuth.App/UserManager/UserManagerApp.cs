using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Castle.Core.Internal;
using Infrastructure;
using Infrastructure.Extensions;
using Microsoft.EntityFrameworkCore;
using OpenAuth.App.Interface;
using OpenAuth.App.Request;
using OpenAuth.App.Response;
using OpenAuth.Repository;
using OpenAuth.Repository.Domain;
using OpenAuth.Repository.Interface;
using SqlSugar;
namespace OpenAuth.App
{
    public class UserManagerApp : SqlSugarBaseApp<SysUser>
    {
        private RevelanceManagerApp _revelanceApp;
        private OrgManagerApp _orgManagerApp;
        public UserManagerApp(ISqlSugarClient client,
            RevelanceManagerApp app, IAuth auth, OrgManagerApp orgManagerApp) : base(client, auth)
        {
            _revelanceApp = app;
            _orgManagerApp = orgManagerApp;
        }
        public SysUser GetByAccount(string account)
        {
            return SugarClient.Queryable<SysUser>().First(u => u.Account == account);
        }

        /// <summary>
        /// 加载用户列表
        /// </summary>
        /// <param name="request"></param>
        /// <param name="ignoreAuth">是否忽略权限，如果忽略权限，可以获取到所有用户</param>
        /// <returns></returns>
        private async Task<PagedListDataResp<UserView>> LoadUsers(QueryUserListReq request, bool ignoreAuth = false)
        {
            var loginUser = _auth.GetCurrentUser();
            var query = SugarClient.Queryable<SysUser>();
            if (!string.IsNullOrEmpty(request.key))
            {
                query = SugarClient.Queryable<SysUser>().Where(u => u.Name.Contains(request.key) || u.Account.Contains(request.key));
            }
            var userOrgs = query
                .LeftJoin<SysUser>((user, u) => user.ParentId == u.Id)
                .LeftJoin<Relevance>((user, u, r) => user.Id == r.FirstId && r.RelKey == Define.USERORG)
                .LeftJoin<SysOrg>((user, u, r, o) => r.SecondId == o.Id);

            //如果请求的orgId不为空，加载用户可以看到的机构及下级的所有用户
            if (!string.IsNullOrEmpty(request.orgId))
            {
                var org = loginUser.Orgs.SingleOrDefault(u => u.Id == request.orgId);
                var cascadeId = org.CascadeId;
                var orgIds = loginUser.Orgs.Where(u => u.CascadeId.Contains(cascadeId)).Select(u => u.Id).ToArray();
                //只获取机构里面的用户
                userOrgs = userOrgs.Where((user, u, r, o) => r.RelKey == Define.USERORG && orgIds.Contains(o.Id));
            }
            else if (!ignoreAuth)  //如果请求的orgId为空，即为跟节点，如果不忽略权限，只能获取到用户可以看到的机构及未分配机构的用户
            {
                var orgIds = loginUser.Orgs.Select(u => u.Id).ToArray();
                //获取用户可以访问的机构的用户和没有任何机构关联的用户（机构被删除后，没有删除这里面的关联关系）
                userOrgs = userOrgs.Where((user, u, r, o) => (r.RelKey == Define.USERORG && orgIds.Contains(o.Id)) || (o == null));
            }

            var userOrgsResult = userOrgs.Select((user, u, r, o) => new
            {
                Account = user.Account,
                Name = user.Name,
                Id = user.Id,
                Sex = user.Sex,
                Status = user.Status,
                BizCode = user.BizCode,
                CreateId = user.CreateId,
                CreateTime = user.CreateTime,
                TypeId = user.TypeId,
                TypeName = user.TypeName,
                ParentId = user.ParentId,
                ParentName = u.Name,
                Key = r.RelKey,
                OrgId = o.Id,
                OrgName = o.Name
            });
            var userViews = (await userOrgsResult.ToListAsync()).GroupBy(b => b.Account)
                .Select(u => new UserView
                {
                    Id = u.First().Id,
                    Account = u.Key,
                    Name = u.First().Name,
                    ParentName = u.First().ParentName,
                    Sex = u.First().Sex,
                    Status = u.First().Status,
                    ParentId = u.First().ParentId,
                    CreateTime = u.First().CreateTime,
                    CreateUser = u.First().CreateId,
                    OrganizationIds = string.Join(",", u.Select(x => x.OrgId)),
                    Organizations = string.Join(",", u.Select(x => x.OrgName))
                });
            return new PagedListDataResp<UserView>
            {
                Count = userViews.Count(),
                Data = userViews.OrderBy(u => u.Name)
                    .Skip((request.page - 1) * request.limit)
                    .Take(request.limit).ToList(),
            };
        }
        /// <summary>
        /// 加载当前登录用户可访问的一个部门及子部门全部用户
        /// 如果请求的request.OrgId为空，则可以获取到已被删除机构的用户（即：没有分配任何机构的用户）
        /// </summary>
        public async Task<PagedListDataResp<UserView>> Load(QueryUserListReq request)
        {
            return await LoadUsers(request, false);
        }
        /// <summary>
        /// 获取所有的用户
        /// 为了控制权限，通常只用于流程实例选择执行角色，其他地方请使用Load
        /// </summary>
        public async Task<PagedListDataResp<UserView>> LoadAll(QueryUserListReq request)
        {
            return await LoadUsers(request, true);
        }
        public void AddOrUpdate(UpdateUserReq request)
        {
            request.ValidationEntity(u => new { u.Account, u.Name, u.OrganizationIds });
            if (string.IsNullOrEmpty(request.OrganizationIds))
                throw new Exception("请为用户分配机构");
            SysUser requser = request;
            requser.CreateId = _auth.GetCurrentUser().User.Id;
            SugarClient.Ado.BeginTran();
            if (string.IsNullOrEmpty(request.Id))
            {
                if (SugarClient.Queryable<SysUser>().Any(u => u.Account == request.Account))
                {
                    throw new Exception("用户账号已存在");
                }
                if (string.IsNullOrEmpty(requser.Password))
                {
                    requser.Password = requser.Account;   //如果客户端没提供密码，默认密码同账号
                }
                requser.CreateTime = DateTime.Now;
                Repository.Insert(requser);
                request.Id = requser.Id; //要把保存后的ID存入view
            }
            else
            {
                Repository.Update(u => new SysUser
                {
                    Account = requser.Account,
                    BizCode = requser.BizCode,
                    Name = requser.Name,
                    Sex = requser.Sex,
                    Status = requser.Status,
                    ParentId = request.ParentId
                }, u => u.Id == request.Id);
                if (!string.IsNullOrEmpty(requser.Password))  //密码为空的时候，不做修改
                {
                    Repository.Update(u => new SysUser
                    {
                        Password = requser.Password
                    }, u => u.Id == request.Id);
                }
            }
            string[] orgIds = request.OrganizationIds.Split(',').ToArray();
            _revelanceApp.DeleteBy(Define.USERORG, requser.Id);
            _revelanceApp.Assign(Define.USERORG, orgIds.ToLookup(u => requser.Id));

            SugarClient.Ado.CommitTran();
        }
        /// <summary>
        /// 删除用户,包含用户与组织关系、用户与角色关系
        /// </summary>
        /// <param name="ids"></param>
        public new void Delete(string[] ids)
        {
            SugarClient.Ado.BeginTran();
            SugarClient.Deleteable<Relevance>().Where(u => (u.RelKey == Define.USERROLE || u.RelKey == Define.USERORG)
                                        && ids.Contains(u.FirstId)).ExecuteCommand();
            SugarClient.Deleteable<SysUser>().Where(u => ids.Contains(u.Id)).ExecuteCommand();
            SugarClient.Ado.CommitTran();
        }
        /// <summary>
        /// 修改密码
        /// </summary>
        /// <param name="request"></param>
        public void ChangePassword(ChangePasswordReq request)
        {
            Repository.Update(u => new SysUser
            {
                Password = request.Password
            }, u => u.Account == request.Account);
        }
        /// <summary>
        /// 获取指定角色包含的用户列表
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        public async Task<PagedDynamicDataResp> LoadByRole(QueryUserListByRoleReq request)
        {
            var users = SugarClient.Queryable<Relevance>()
                .Where(u => u.SecondId == request.roleId && u.RelKey == Define.USERROLE)
                .LeftJoin<SysUser>((userRole, user) => userRole.FirstId == user.Id)
                .Where((userRole, user) => user.Id != null)
                .Select((userRole, user) => user);
            return new PagedDynamicDataResp
            {
                Count = await users.CountAsync(),
                Data = await users.Skip((request.page - 1) * request.limit).Take(request.limit).ToListAsync()
            };
        }
        /// <summary>
        /// 获取指定机构包含的用户列表
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        public async Task<PagedDynamicDataResp> LoadByOrg(QueryUserListByOrgReq request)
        {
            var users = SugarClient.Queryable<Relevance>()
                .Where(u => u.SecondId == request.orgId && u.RelKey == Define.USERORG)
                .LeftJoin<SysUser>((userOrg, user) => userOrg.FirstId == user.Id)
                .Where((userOrg, user) => user.Id != null)
                .Select((userOrg, user) => user);
            return new PagedDynamicDataResp
            {
                Count = await users.CountAsync(),
                Data = await users.Skip((request.page - 1) * request.limit).Take(request.limit).ToListAsync()
            };
        }
        /// <summary>
        /// 修改用户资料
        /// </summary>
        /// <param name="request"></param>
        public void ChangeProfile(ChangeProfileReq request)
        {
            if (request.Account == Define.SYSTEM_USERNAME)
            {
                throw new Exception("不能修改超级管理员信息");
            }
            Repository.Update(u => new SysUser
            {
                Name = request.Name,
                Sex = request.Sex
            }, u => u.Account == request.Account);
        }

        /// <summary>
        /// 获取用户的直属上级ID
        /// </summary>
        /// <param name="userid">用户ID</param>
        /// <returns></returns>
        public string GetParent(string userid)
        {
            if (userid == Guid.Empty.ToString())
            {
                throw new Exception("超级管理员没有直属上级，请检查配置");
            }
            return SugarClient.Queryable<SysUser>().First(u => u.Id == userid).ParentId;
        }


        /// <summary>
        /// 获取流程实例通知的用户
        /// </summary>
        /// <param name="instanceId"></param>
        /// <returns></returns>
        public List<string> GetNoticeUsers(string instanceId)
        {
            var sql = $@"
            select u.*
            from sysuser u
                    join (select distinct SecondId as UserId
                        from Relevance
                        where RelKey = '{Define.INSTANCE_NOTICE_USER}'
                            and FirstId = '{instanceId}'
                        union
                        select distinct FirstId as UserId
                        from Relevance a
                                inner join (select SecondId as RoleId
                                            from Relevance
                                            where RelKey = '{Define.INSTANCE_NOTICE_ROLE}'
                                                and FirstId = '{instanceId}') b on a.SecondId = b.RoleId
                        where RelKey = '{Define.USERROLE}') userids on u.Id = userids.UserId";
            var users = SugarClient.Ado.SqlQuery<SysUser>(sql);
            return users.Select(u => u.Id).ToList();
        }

        public List<UserView> LoadByIds(string[] ids)
        {
            var users = SugarClient.Queryable<SysUser>().Where(u => ids.Contains(u.Id));

            //获取用户及用户关联的机构
            var userOrgs = users
                .LeftJoin<Relevance>((user, r) => user.Id == r.FirstId && r.RelKey == Define.USERORG)
                .LeftJoin<SysOrg>((user, r, o) => r.SecondId == o.Id)
                .Select((user, r, o) => new
                {
                    user.Id,
                    user.Account,
                    user.Name,
                    user.Sex,
                    user.Status,
                    user.CreateTime,
                    user.CreateId,
                    user.ParentId,
                    OrgId = o.Id,
                    OrgName = o.Name
                });

            var userOrgsList = userOrgs.ToList();  // 先执行ToList()
            var userViews = userOrgsList.GroupBy(b => b.Account).Select(g => new UserView
            {
                Id = g.First().Id,
                Account = g.Key,
                Name = g.First().Name,
                Sex = g.First().Sex,
                Status = g.First().Status,
                CreateTime = g.First().CreateTime,
                CreateUser = g.First().CreateId,
                ParentName = g.First().ParentId,
                ParentId = g.First().ParentId,
                OrganizationIds = string.Join(",", g.Select(x => x.OrgId)),
                Organizations = string.Join(",", g.Select(x => x.OrgName))
            });

            return userViews.ToList();
        }
    }
}