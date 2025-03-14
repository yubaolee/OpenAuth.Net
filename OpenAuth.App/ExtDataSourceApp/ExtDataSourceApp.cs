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

        /// <summary>
        /// 获取数据库类型
        /// </summary>
        /// <returns></returns>
        public TableData GetDbTypes()
        {
            var result = new TableData();
            // 创建包含键值对的列表
            var dbTypeList = Enum.GetValues(typeof(DbType))
                .Cast<DbType>()
                .Select(item => new { label = item.ToString(), value = (int)item })
                .ToList();
            result.data = dbTypeList;
            return result;
        }

        /// <summary>
        /// 测试数据源连接
        /// </summary>
        /// <param name="id">数据源ID</param>
        /// <returns>是否连接成功</returns>
        public bool TestConnection(string id)
        {
            var obj = Repository.GetById(id);
            if (obj == null)
            {
                throw new Exception("数据源不存在");
            }
            var conn = new SqlSugarClient(new ConnectionConfig()
            {
                ConnectionString = obj.Connectionstring,
                DbType = (DbType)Enum.Parse(typeof(DbType), obj.Dbtype.ToString()),
                IsAutoCloseConnection = true,
            });
            conn.Open();
            return true;
        }
        public void Add(AddOrUpdateExternalDataSourceReq req)
        {
            var obj = req.MapTo<ExternalDataSource>();
            obj.Id = Guid.NewGuid().ToString();
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
                Name = obj.Name,
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