---
title: 接口数据验证
createTime: 2025/04/23 21:03:10
permalink: /core/datavalidation/
---

数据验证是做接口开发时一个非常重要的功能，它用来确保调用API时传入的数据完整和正确。框架提供灵活的实体模型验证功能。可以方便地对实体进行验证。只需两步即可：
1. 在实体类中使用特性（Attributes）来定义验证规则。
2. 业务代码中执行验证

## 定义验证规则

在请求参数中添加验证注解

```csharp
namespace OpenAuth.App.Request
{
    public  class UpdateUserReq
    {
        /// <summary>
        /// </summary>
        /// <returns></returns>
        [Required(ErrorMessage = "账号肯定不能为空啊~~")]
        public string Account { get; set; }

        /// <summary>
        /// 用户姓名
        /// </summary>
        /// <returns></returns>
        [Required(ErrorMessage="姓名不能为空")]
        public string Name { get; set; }


        /// <summary>
        /// 所属组织Id，多个可用，分隔
        /// </summary>
        /// <value>The organizations.</value>
        [Required(ErrorMessage = "请为用户分配机构")]
        public string OrganizationIds { get; set; }

        ...
    }
}
```

## 执行验证

在OpenAuth.App中调用验证

```csharp
namespace OpenAuth.App
{
    public class UserManagerApp : BaseApp<User,OpenAuthDBContext>
    {
        public void AddOrUpdate(UpdateUserReq request)
        {
            //验证Account/Name/OrganizationIds
            request.ValidationEntity(u => new {u.Account,u.Name, u.OrganizationIds});

            ...//其他代码略
        }
    }
}
```
