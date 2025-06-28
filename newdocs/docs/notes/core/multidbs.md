---
title: 多数据库
createTime: 2025/04/23 21:03:10
permalink: /core/multidbs/
---

框架支持同时访问多个数据库。具体操作如下：

## 添加新连接字符串

在配置文件appsettings.json中，添加新的连接字符串`OpenAuthDBContext2`

```csharp
 "ConnectionStrings": {
    "OpenAuthDBContext": "Data Source=.;Initial Catalog=OpenAuthPro;User=sa;Password=000000",
    "OpenAuthDBContext2": "Data Source=.;Initial Catalog=OpenAuthDB;User=sa;Password=000000"
  }
 "AppSetting": {
    "DbTypes": {
        "OpenAuthDBContext":"SqlServer"   //数据库类型：SqlServer、MySql、Oracle
       ,"OpenAuthDBContext2":"SqlServer"  //链接字符串OpenAuthDBContext2对应的数据库类型
    }
  }
```

## SqlSugar操作多数据库

当需要使用SqlSugar操作多数据库时，因为框架初始化时会自动识别所有的连接字符串，所以只需要按以下步骤编写业务代码即可。

### 新建数据库访问基类

在项目OpenAuth.App中，新建数据库访问基类，比如`SqlSugarApp2`
```csharp
namespace OpenAuth.App
{
    public abstract class SqlSugarApp2<T>  : SqlSugarBaseApp<T> where T : BaseEntity, new()
    {
        public SqlSugarApp2(ISqlSugarClient client, IAuth auth) : base(client, auth)
        {
            client = client.AsTenant().GetConnection("OpenAuthDBContext2");
            Repository = new SqlSugarRepository<T>(client); //这里用new而不用注入，可以保证client和repository用的是同一个client
            SugarClient = client;
            _auth = auth;
        }
    }
}

```

### 编写业务代码

我们以系统日志模块为例，只需要调整以下代码，然后运行就可以发现，日志已经全部记录到新的数据库中。

```csharp
    public class SysLogApp2 : SqlSugarApp2<SysLog>
    {
        public void Add(SysLog obj)
        {
            //程序类型取入口应用的名称，可以根据自己需要调整
            obj.Application = Assembly.GetEntryAssembly().FullName.Split(',')[0];
            Repository.Insert(obj);
        }
        
        public void Update(SysLog obj)
        {
            Repository.Update(u => new SysLog
            {
                Content = obj.Content,
                CreateTime = obj.CreateTime,
                Id = obj.Id,
                Ip = obj.Ip,
            },u => u.Id == obj.Id);
        }

        public SysLogApp2(ISqlSugarClient client, IAuth auth) : base(client, auth)
        {
        }
    }
```

## EF操作多数据库

### 添加数据上下文

在OpenAuth.Repository中添加新的数据库上下文，比如`OpenAuthDBContext2`

```csharp
 public partial class OpenAuthDBContext2 : DbContext
    {
        private ILoggerFactory _LoggerFactory;
        private IConfiguration _configuration;

        private const string _connectstr = "OpenAuthDBContext2"; //这里是第二数据库的连接字符串

        public OpenAuthDBContext2(DbContextOptions<OpenAuthDBContext2> options, ILoggerFactory loggerFactory,
            IConfiguration configuration,
            IOptions<AppSetting> appConfiguration)
            : base(options)
        {
            _LoggerFactory = loggerFactory;
            _configuration = configuration;
        }

        //初始化多租户信息，根据租户id调整数据库
        private void InitTenant(DbContextOptionsBuilder optionsBuilder)
        {
            string connect = _configuration.GetConnectionString(_connectstr);
            if (string.IsNullOrEmpty(connect))
            {
                throw new Exception($"未能找到租户{_connectstr}对应的连接字符串信息");
            }

            // 其他代码参考OpenAuthDBContext.cs
        }
        // 其他代码参考OpenAuthDBContext.cs
    }

```

### 注入新数据库

在项目OpenAuth.WebApi的启动代码`Startup.cs`中，把`ConfigureServices`方法中注入刚刚添加的数据库上下文

```csharp
 services.AddDbContext<OpenAuthDBContext2>();
```

### 编写业务代码

我们以系统日志模块为例，只需要调整以下代码，然后运行就可以发现，日志已经全部记录到新的数据库中。

```csharp
  public class SysLogApp : BaseApp<SysLog,OpenAuthDBContext2>
    {
        public SysLogApp(IUnitWork<OpenAuthDBContext2> unitWork, IRepository<SysLog,OpenAuthDBContext2> repository) : base(unitWork, repository, null)
        {
        }

        ...//剩余的代码和系统自带的模块完全一致
    }
```
