using System;
using System.Threading.Tasks;
using Infrastructure;
using OpenAuth.App.Interface;
using OpenAuth.App.Request;
using OpenAuth.App.Response;
using OpenAuth.Repository.Domain;
using SqlSugar;


namespace OpenAuth.App
{
    public class ExtDataSourceApp : SqlSugarBaseApp<ExternalDataSource>
    {

        /// <summary>
        /// 加载列表
        /// </summary>
        public async Task<TableData> Load(QueryExternalDataSourceListReq request)
        {
            var loginContext = _auth.GetCurrentUser();
            if (loginContext == null)
            {
                throw new CommonException("登录已过期", Define.INVALID_TOKEN);
            }

            var result = new TableData();
            var objs = GetDataPrivilege("u");
            if (!string.IsNullOrEmpty(request.key))
            {
                objs = objs.Where(u => u.Name.Contains(request.key));
            }

            result.data = objs.OrderBy(u => u.Name)
                .Skip((request.page - 1) * request.limit)
                .Take(request.limit).ToList();
            result.count = await objs.CountAsync();
            return result;
        }

        public void Add(AddOrUpdateExternalDataSourceReq req)
        {
            var obj = req.MapTo<ExternalDataSource>();
            obj.Createtime = DateTime.Now;
            var user = _auth.GetCurrentUser().User;
            obj.Createuserid = user.Id;
            obj.Createusername = user.Name;
            Repository.Insert(obj);
        }

        public void Update(AddOrUpdateExternalDataSourceReq obj)
        {
            var user = _auth.GetCurrentUser().User;
            Repository.Update(u => new ExternalDataSource
            {
                Dbtype = obj.Dbtype,
                Databasename = obj.Databasename,
                Server = obj.Server,
                Port = obj.Port,
                Username = obj.Username,
                Password = obj.Password,
                Description = obj.Description,
                Enabled = obj.Enabled,
                Testsuccess = obj.Testsuccess,
                Connectionstring = obj.Connectionstring,
                Updatetime = DateTime.Now,
                Updateuserid = user.Id,
                Updateusername = user.Name
            },u => u.Id == obj.Id);

        }

        public ExtDataSourceApp(ISqlSugarClient client, IAuth auth) : base(client, auth)
        {
        }
    }
}