using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;
using OpenAuth.Repository.Core;

namespace OpenAuth.Repository.Domain
{
    /// <summary>
    ///外部数据源
    /// </summary>
    [Table("ExternalDataSource")]
    public class ExternalDataSource : StringEntity
    {
        public ExternalDataSource()
        {
            this.Createtime = DateTime.Now;
            this.Createusername = "";
            this.Createuserid = "";
            this.Updateuserid = "";
            this.Updateusername = "";
            this.Testsuccess = false;
            this.Updatetime = DateTime.Now;
            this.Enabled = false;
            this.Connectionstring = "";
            this.Description = "";
            this.Password = "";
            this.Username = "";
            this.Port = null;
            this.Server = "";
            this.Databasename = "";
            this.Dbtype = 0;
            this.Name = "";

        }
        /// <summary>
        ///创建时间
        /// </summary>
        [Description("创建时间")]
        public DateTime Createtime { get; set; }

        /// <summary>
        ///创建用户名
        /// </summary>
        [Description("创建用户名")]
        public string Createusername { get; set; }

        /// <summary>
        ///创建用户ID
        /// </summary>
        [Description("创建用户ID")]
        public string Createuserid { get; set; }

        /// <summary>
        ///更新用户ID
        /// </summary>
        [Description("更新用户ID")]
        public string Updateuserid { get; set; }

        /// <summary>
        ///更新用户名
        /// </summary>
        [Description("更新用户名")]
        public string Updateusername { get; set; }

        /// <summary>
        ///是否测试成功
        /// </summary>
        [Description("是否测试成功")]
        public bool? Testsuccess { get; set; }

        /// <summary>
        ///最后测试时间
        /// </summary>
        [Description("最后测试时间")]
        public DateTime? Updatetime { get; set; }

        /// <summary>
        ///是否启用
        /// </summary>
        [Description("是否启用")]
        public bool Enabled { get; set; }

        /// <summary>
        ///连接字符串
        /// </summary>
        [Description("连接字符串")]
        public string Connectionstring { get; set; }

        /// <summary>
        ///描述
        /// </summary>
        [Description("描述")]
        public string Description { get; set; }

        /// <summary>
        ///密码
        /// </summary>
        [Description("密码")]
        public string Password { get; set; }

        /// <summary>
        ///用户名
        /// </summary>
        [Description("用户名")]
        public string Username { get; set; }

        /// <summary>
        ///端口
        /// </summary>
        [Description("端口")]
        public int? Port { get; set; }

        /// <summary>
        ///服务器地址
        /// </summary>
        [Description("服务器地址")]
        public string Server { get; set; }

        /// <summary>
        ///数据库名称
        /// </summary>
        [Description("数据库名称")]
        public string Databasename { get; set; }

        /// <summary>
        ///数据库类型
        /// </summary>
        [Description("数据库类型")]
        public int Dbtype { get; set; }

        /// <summary>
        ///数据源名称
        /// </summary>
        [Description("数据源名称")]
        public string Name { get; set; }


    }
}