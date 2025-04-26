---
title: SqlSugar集成
createTime: 2025/04/23 21:03:10
permalink: /core/sqlsugar/
---

SqlSugar 是一款老牌.NET开源ORM框架，相对于EntityFramework复杂的Linq表达式，它拥有灵活的动态查询，如果你喜欢直接码Sql，那么它是你的不二之选。OpenAuth.Net 6.0及以后版本默认支持使用SqlSugar方式访问数据库。

框架提供`SqlSugarBaseApp`基类，该基类定义了SqlSugar最常用的两个成员变量：
```csharp
protected ISqlSugarClient SugarClient; //SqlSugar基础数据库读写
protected SqlSugarRepository<T> Repository; //SqlSugar的仓储模式
```
只需要继承该基类，即可使用SqlSugar的强大功能。

目前框架大多数模块都已继承`SqlSugarBaseApp`基类，这里以资源管理为例：
```csharp
public class ResourceApp:SqlSugarBaseApp<Resource>
    {
        public void Add(AddOrUpdateResReq resource)
        {
            ...
            Repository.Insert(obj);
        }

        public void Update(AddOrUpdateResReq obj)
        {
            Repository.Update(u => new Resource
            {
                Name = obj.Name,
                //todo:要修改的字段赋值
            },u => u.Id == obj.Id);
        }
       
        public void Delete(string[] ids)
        {
            Repository.DeleteByIds(ids);
        }

        public ResourceApp(ISqlSugarClient client, IAuth auth) : base(client, auth)
        {
        }

    }
```


## 使用方法

当编写业务代码需要使用SqlSugar的模块时，只需要继承`SqlSugarBaseApp`即可使用SqlSugar强大功能。其中

### Repository
实现的是SqlSugar的仓储模式，详细Api请查看：[SqlSugar使用仓储](https://www.donet5.com/Home/Doc?typeId=1228)。在OpenAuth.Net中：
```csharp
public class ResourceApp:SqlSugarBaseApp<Resource>
    {
        public void Add(AddOrUpdateResReq resource)
        {
            ...
            Repository.Insert(obj);
        }
    }
```
### SugarClient
SqlSugar基础数据库读写用法。详细Api请查看：[SqlSugar入门必看](https://www.donet5.com/Home/Doc?typeId=1181)。在OpenAuth.Net中：
```csharp
public class ResourceApp:SqlSugarBaseApp<Resource>
    {
        public List<Resource> Load()
        {
            ...
            return SugarClient.Queryable<Resource>().ToList();
        }
    }
```

