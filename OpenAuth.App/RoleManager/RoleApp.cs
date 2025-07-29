using System;
using System.Collections.Generic;
using OpenAuth.App.Interface;
using OpenAuth.App.Response;
using OpenAuth.Repository.Domain;
using OpenAuth.Repository.Interface;
using System.Linq;
using System.Threading.Tasks;
using Infrastructure;
using Microsoft.EntityFrameworkCore;
using OpenAuth.App.Request;
using OpenAuth.Repository;

using SqlSugar;

namespace OpenAuth.App
{
    public class RoleApp : SqlSugarBaseApp<Role>
    {
        private RevelanceManagerApp _revelanceApp;

        /// <summary>
        /// 加载当前登录用户可访问的全部角色
        /// </summary>
        public List<Role> Load(QueryRoleListReq request)
        {
            var loginUser = _auth.GetCurrentUser();
            var roles = loginUser.Roles;
            if (!string.IsNullOrEmpty(request.key))
            {
                roles = roles.Where(u => u.Name.Contains(request.key)).ToList();
            }

            return roles;
        }
        
        /// <summary>
        /// 获取所有的角色
        /// 为了控制权限，通常只用于流程实例选择执行角色，其他地方请使用Load
        /// </summary>
        public async Task<PagedListDataResp<Role>> LoadAll(QueryRoleListReq request)
        {
            var result = new PagedListDataResp<Role>();
            var objs = SugarClient.Queryable<Role>();
            if (!string.IsNullOrEmpty(request.key))
            {
                objs = objs.Where(u => u.Name.Contains(request.key));
            }

            result.Data = await objs.OrderBy(u => u.Name)
                .Skip((request.page - 1) * request.limit)
                .Take(request.limit).ToListAsync();
            result.Count = await objs.CountAsync();
            return result;
        }

        /// <summary>
        /// 根据ID加载角色
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        public List<Role> LoadByIds(string[] ids)
        {
            return Repository.GetList(u => ids.Contains(u.Id));
        }


        /// <summary>
        /// 添加角色，如果当前登录用户不是System，则直接把新角色分配给当前登录用户
        /// </summary>
        public void Add(RoleView obj)
        {
            SugarClient.Ado.BeginTran();
            Role role = obj;
            role.CreateTime = DateTime.Now;
            Repository.Insert(role);
            obj.Id = role.Id;   //要把保存后的ID存入view
        
            //如果当前账号不是SYSTEM，则直接分配
            var loginUser = _auth.GetCurrentUser();
            if (loginUser.User.Account != Define.SYSTEM_USERNAME)
            {
                _revelanceApp.Assign(new AssignReq
                {
                    type = Define.USERROLE,
                    firstId = loginUser.User.Id,
                    secIds = new[] {role.Id}
                });
            }
            SugarClient.Ado.CommitTran();
        }
        
        /// <summary>
        /// 删除角色时，需要删除角色对应的权限
        /// </summary>
        /// <param name="ids"></param>
        public new void Delete(string[] ids)
        {
            SugarClient.Ado.BeginTran();
            SugarClient.Deleteable<Relevance>().Where(u=>(u.RelKey == Define.ROLEMODULE || u.RelKey == Define.ROLEELEMENT) && ids.Contains(u.FirstId)).ExecuteCommand();
            SugarClient.Deleteable<Relevance>().Where(u=>u.RelKey == Define.USERROLE && ids.Contains(u.SecondId)).ExecuteCommand();
            SugarClient.Deleteable<Role>().Where(u =>ids.Contains(u.Id)).ExecuteCommand();
            SugarClient.Ado.CommitTran();
          
        }
        
        /// <summary>
        /// 更新角色属性
        /// </summary>
        /// <param name="obj"></param>
        public void Update(RoleView obj)
        {
            Repository.Update(u => new Role
            {
                Name = obj.Name,
                Status = obj.Status
            }, u => u.Id == obj.Id);
        }


        public RoleApp(ISqlSugarClient client,
            RevelanceManagerApp app,IAuth auth) : base(client, auth)
        {
            _revelanceApp = app;
        }

        
    }
}