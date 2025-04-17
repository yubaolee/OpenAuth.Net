namespace Infrastructure
{
    /// <summary>
    /// 常量定义
    /// </summary>
    public static class Define
    {
        //Relevance关联KEY
        public static string USERROLE = "UserRole"; //用户角色关联KEY
        public const string ROLERESOURCE = "RoleResource"; //角色资源关联KEY
        public const string USERORG = "UserOrg"; //用户机构关联KEY
        public const string ROLEELEMENT = "RoleElement"; //角色菜单关联KEY
        public const string ROLEMODULE = "RoleModule"; //角色模块关联KEY
        public const string ROLEDATAPROPERTY = "RoleDataProperty"; //角色数据字段权限
        public const string MODULEPRINTERPLAN = "ModulePrinterPlan"; //模块配置打印方案
        public const string MODULE_FLOWSCHEME = "ModuleFlowScheme"; //模块挂载流程模板

        //数据库类型
        public const string DBTYPE_SQLSERVER = "SqlServer"; //sql server
        public const string DBTYPE_MYSQL = "MySql"; //mysql
        public const string DBTYPE_PostgreSQL = "PostgreSQL"; //PostgreSQL
        public const string DBTYPE_ORACLE = "Oracle"; //oracle

        public const int INVALID_TOKEN = 50014; //token无效

        public const string TOKEN_NAME = "X-Token";
        public const string TENANT_ID = "tenantId";

        public const string SYSTEM_USERNAME = "System";
        public const string SYSTEM_USERPWD = "123456";

        public const string DATAPRIVILEGE_LOGINUSER = "{loginUser}"; //数据权限配置中，当前登录用户的key
        public const string DATAPRIVILEGE_LOGINROLE = "{loginRole}"; //数据权限配置中，当前登录用户角色的key
        public const string DATAPRIVILEGE_LOGINORG = "{loginOrg}"; //数据权限配置中，当前登录用户部门的key

        public const string JOBMAPKEY = "OpenJob";

        public const string DEFAULT_FORM_INSTANCE_ID_NAME = "InstanceId";

        //表单类型
        public const int FORM_TYPE_DYNAMIC = 0;  //动态表单
        public const int FORM_TYPE_DEVELOP = 1;  //自定义表单
        public const int FORM_TYPE_DRAG = 2;  //vForm拖拽表单
        public const int FORM_TYPE_URL = 3;  //URL表单


        //节点类型
        public const string NODE_TYPE_START = "start"; //开始节点
        public const string NODE_TYPE_END = "end"; //结束节点
        public const string NODE_TYPE_TASK = "node"; //任务节点
        public const string NODE_TYPE_FORK = "fork"; //网关开始
        public const string NODE_TYPE_JOIN = "join"; //网关结束
        public const string NODE_TYPE_MULTI_INSTANCE = "multiInstance"; //多实例、会签节点

        //流程实例知会用户
        public const string INSTANCE_NOTICE_USER = "INSTANCE_NOTICE_USER"; 
        //流程实例知会角色
        public const string INSTANCE_NOTICE_ROLE = "INSTANCE_NOTICE_ROLE";

        //流程节点执行权限类型
        public const string ALL_USER = "ALL_USER"; //所有用户
        public const string SPECIAL_ROLE = "SPECIAL_ROLE"; //指定角色
        public const string SPECIAL_USER = "SPECIAL_USER"; //指定用户
        public const string SPECIAL_SQL = "SPECIAL_SQL"; //指定SQL
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

        public const string RUNTIME_SPECIAL_ROLE = "RUNTIME_SPECIAL_ROLE"; //运行时指定角色
        public const string RUNTIME_SPECIAL_USER = "RUNTIME_SPECIAL_USER"; //运行时指定用户

        //加签类型
        public const string APPROVE_TYPE_SEQUENTIAL = "sequential"; //顺序
        public const string APPROVE_TYPE_ALL = "all"; //并行且
        public const string APPROVE_TYPE_ONE = "one"; //并行或



        public const string API = "API_RESOURCE";
    }
}