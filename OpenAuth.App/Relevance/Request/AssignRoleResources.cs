namespace OpenAuth.App.Request
{
    /// <summary>
    /// 角色分配资源
    /// </summary>
    public class AssignRoleResources
    {
        /// <summary>
        /// 角色id
        /// </summary>
        public string RoleId { get; set; }
        /// <summary>
        /// 资源id列表
        /// </summary>
        public string[] ResourceIds { get; set; }
    }
}