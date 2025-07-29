using System.Linq;
using Microsoft.EntityFrameworkCore;
using OpenAuth.App.Interface;
using OpenAuth.Repository.Core;
using SqlSugar;
using OpenAuth.Repository.Interface;

namespace OpenAuth.App
{
    /// <summary>
    /// 树状结构处理
    /// </summary>
    /// <typeparam name="T"></typeparam>
    ///  /// <typeparam name="TDbContext"></typeparam>
    public class SqlSugarBaseTreeApp<T> :SqlSugarBaseApp<T> where T : TreeEntity, new()
    {


        public SqlSugarBaseTreeApp(ISqlSugarClient client, IAuth auth) 
            : base(client, auth)
        {
        }

       
        /// <summary>
        /// 更新树状结构实体
        /// </summary>
        /// <param name="obj"></param>
        /// <typeparam name="U"></typeparam>
        public void UpdateTreeObj<U>(U obj) where U : TreeEntity, new()
        {
            CaculateCascade(obj);

            //获取旧的的CascadeId
            var cascadeId = SugarClient.Queryable<U>().First(o => o.Id == obj.Id).CascadeId;
            //根据CascadeId查询子部门
            var objs = SugarClient.Queryable<U>().Where(u => u.CascadeId.Contains(cascadeId) && u.Id != obj.Id)
                .OrderBy(u => u.CascadeId).ToList();

            //更新操作
            SugarClient.Updateable(obj).ExecuteCommand();

            //更新子模块的CascadeId
            foreach (var a in objs)
            {
                a.CascadeId = a.CascadeId.Replace(cascadeId, obj.CascadeId);
                if (a.ParentId == obj.Id)
                {
                    a.ParentName = obj.Name;
                }

                SugarClient.Updateable(a).ExecuteCommand();
            }
        }

       
    }
}