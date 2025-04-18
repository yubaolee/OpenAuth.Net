namespace Infrastructure
{
    /// <summary>
    /// 常量定义
    /// </summary>
    public static class Define
    {
        //Relevance关联KEY
        /// <summary>
        /// 用户角色关联KEY
        /// </summary>
        public static string USERROLE = "UserRole";
        
        /// <summary>
        /// 角色资源关联KEY
        /// </summary>
        public const string ROLERESOURCE = "RoleResource";
        
        /// <summary>
        /// 用户机构关联KEY
        /// </summary>
        public const string USERORG = "UserOrg";
        
        /// <summary>
        /// 角色菜单关联KEY
        /// </summary>
        public const string ROLEELEMENT = "RoleElement";
        
        /// <summary>
        /// 角色模块关联KEY
        /// </summary>
        public const string ROLEMODULE = "RoleModule";
        
        /// <summary>
        /// 角色数据字段权限
        /// </summary>
        public const string ROLEDATAPROPERTY = "RoleDataProperty";
        
        /// <summary>
        /// 模块配置打印方案
        /// </summary>
        public const string MODULEPRINTERPLAN = "ModulePrinterPlan";
        
        /// <summary>
        /// 模块挂载流程模板
        /// </summary>
        public const string MODULE_FLOWSCHEME = "ModuleFlowScheme";

        //数据库类型
        /// <summary>
        /// 数据库类型：SQL Server
        /// </summary>
        public const string DBTYPE_SQLSERVER = "SqlServer";
        
        /// <summary>
        /// 数据库类型：MySQL
        /// </summary>
        public const string DBTYPE_MYSQL = "MySql";
        
        /// <summary>
        /// 数据库类型：PostgreSQL
        /// </summary>
        public const string DBTYPE_PostgreSQL = "PostgreSQL";
        
        /// <summary>
        /// 数据库类型：Oracle
        /// </summary>
        public const string DBTYPE_ORACLE = "Oracle";

        /// <summary>
        /// Token无效错误码：50014
        /// </summary>
        public const int INVALID_TOKEN = 50014;

        /// <summary>
        /// Token名称，用于HTTP请求头
        /// </summary>
        public const string TOKEN_NAME = "X-Token";
        
        /// <summary>
        /// 租户ID标识
        /// </summary>
        public const string TENANT_ID = "tenantId";

        /// <summary>
        /// 系统用户名
        /// </summary>
        public const string SYSTEM_USERNAME = "System";
        
        /// <summary>
        /// 系统用户默认密码
        /// </summary>
        public const string SYSTEM_USERPWD = "123456";

        /// <summary>
        /// 数据权限配置中，当前登录用户的key
        /// </summary>
        public const string DATAPRIVILEGE_LOGINUSER = "{loginUser}";
        
        /// <summary>
        /// 数据权限配置中，当前登录用户角色的key
        /// </summary>
        public const string DATAPRIVILEGE_LOGINROLE = "{loginRole}";
        
        /// <summary>
        /// 数据权限配置中，当前登录用户部门的key
        /// </summary>
        public const string DATAPRIVILEGE_LOGINORG = "{loginOrg}";

        /// <summary>
        /// 任务调度映射键
        /// </summary>
        public const string JOBMAPKEY = "OpenJob";

        /// <summary>
        /// 默认表单实例ID字段名
        /// </summary>
        public const string DEFAULT_FORM_INSTANCE_ID_NAME = "InstanceId";

        //表单类型
        /// <summary>
        /// 表单类型：动态表单(0)
        /// </summary>
        public const int FORM_TYPE_DYNAMIC = 0;
        
        /// <summary>
        /// 表单类型：自定义表单(1)
        /// </summary>
        public const int FORM_TYPE_DEVELOP = 1;
        
        /// <summary>
        /// 表单类型：vForm拖拽表单(2)
        /// </summary>
        public const int FORM_TYPE_DRAG = 2;
        
        /// <summary>
        /// 表单类型：URL表单(3)
        /// </summary>
        public const int FORM_TYPE_URL = 3;


        //节点类型
        /// <summary>
        /// 节点类型：开始节点
        /// </summary>
        public const string NODE_TYPE_START = "start";
        
        /// <summary>
        /// 节点类型：结束节点
        /// </summary>
        public const string NODE_TYPE_END = "end";
        
        /// <summary>
        /// 节点类型：任务节点
        /// </summary>
        public const string NODE_TYPE_TASK = "node";
        
        /// <summary>
        /// 节点类型：网关开始
        /// </summary>
        public const string NODE_TYPE_FORK = "fork";
        
        /// <summary>
        /// 节点类型：网关结束
        /// </summary>
        public const string NODE_TYPE_JOIN = "join";
        
        /// <summary>
        /// 节点类型：多实例、会签节点
        /// </summary>
        public const string NODE_TYPE_MULTI_INSTANCE = "multiInstance";

        /// <summary>
        /// 流程实例知会用户
        /// </summary>
        public const string INSTANCE_NOTICE_USER = "INSTANCE_NOTICE_USER"; 
        
        /// <summary>
        /// 流程实例知会角色
        /// </summary>
        public const string INSTANCE_NOTICE_ROLE = "INSTANCE_NOTICE_ROLE";

        //流程节点执行权限类型
        /// <summary>
        /// 流程节点执行权限类型：所有用户
        /// </summary>
        public const string ALL_USER = "ALL_USER";
        
        /// <summary>
        /// 流程节点执行权限类型：指定角色
        /// </summary>
        public const string SPECIAL_ROLE = "SPECIAL_ROLE";
        
        /// <summary>
        /// 流程节点执行权限类型：指定用户
        /// </summary>
        public const string SPECIAL_USER = "SPECIAL_USER";
        
        /// <summary>
        /// 流程节点执行权限类型：指定SQL
        /// </summary>
        public const string SPECIAL_SQL = "SPECIAL_SQL";
        
        /// <summary>
        /// 连续多级直属上级
        /// <para>不同于钉钉的各上级部门负责人审批，OpenAuth以用户的各级直属上级审批模式</para>
        /// </summary>
        public const string RUNTIME_MANY_PARENTS = "RUNTIME_MANY_PARENTS"; 
        
        /// <summary>
        /// 部门负责人
        /// </summary>
        public const string RUNTIME_CHAIRMAN = "RUNTIME_CHAIRMAN"; 
        
        /// <summary>
        /// 上一节点执行人的直属上级
        /// </summary>
        public const string RUNTIME_PARENT = "RUNTIME_PARENT"; 

        /// <summary>
        /// 流程节点执行权限类型：运行时指定角色
        /// </summary>
        public const string RUNTIME_SPECIAL_ROLE = "RUNTIME_SPECIAL_ROLE";
        
        /// <summary>
        /// 流程节点执行权限类型：运行时指定用户
        /// </summary>
        public const string RUNTIME_SPECIAL_USER = "RUNTIME_SPECIAL_USER";

        //加签类型
        /// <summary>
        /// 加签类型：顺序审批
        /// </summary>
        public const string APPROVE_TYPE_SEQUENTIAL = "sequential";
        
        /// <summary>
        /// 加签类型：并行且审批（所有人必须同意）
        /// </summary>
        public const string APPROVE_TYPE_ALL = "all";
        
        /// <summary>
        /// 加签类型：并行或审批（一人同意即可）
        /// </summary>
        public const string APPROVE_TYPE_ONE = "one";

        /// <summary>
        /// API资源标识
        /// </summary>
        public const string API = "API_RESOURCE";
    }
}