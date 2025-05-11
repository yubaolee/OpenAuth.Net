using System;
using System.Collections.Generic;
using System.Linq;
using Infrastructure;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using OpenAuth.App;
using OpenAuth.App.Response;
using OpenAuth.Repository.QueryObj;

namespace OpenAuth.WebApi.Controllers
{
    /// <summary>
    /// 系统配置信息
    /// </summary>
    [Route("api/[controller]/[action]")]
    [ApiController]
    [ApiExplorerSettings(GroupName = "系统配置_SysConf")]
    public class SysConfController : ControllerBase
    {
        private IOptions<AppSetting> _appConfiguration;
        private DbExtension _dbExtension;

        public SysConfController(IOptions<AppSetting> appConfiguration, DbExtension dbExtension)
        {
            _appConfiguration = appConfiguration;
            _dbExtension = dbExtension;
        }

        /// <summary>
        /// 是否Identity认证
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet]
        public Response<bool> IsIdentityAuth()
        {
            return new Response<bool>
            {
                Result = _appConfiguration.Value.IsIdentityAuth
            };
        }

        /// <summary>
        /// 获取数据库表结构
        /// </summary>
        /// <param name="tableName">表名</param>
        /// <param name="externalDataSourceId">外部数据源ID</param>
        /// <returns></returns>
        [HttpGet]
        public Response<List<SysTableColumn>> GetDbTableStructure(string tableName, string externalDataSourceId)
        {
            var result = new Response<List<SysTableColumn>>();
            try
            {
                result.Result = _dbExtension.GetDbTableStructure(tableName, externalDataSourceId).ToList();
            }
            catch (Exception ex)
            {
                result.Code = 500;
                result.Message = ex.Message;
            }
            return result;
        }

        /// <summary>
        /// 获取数据库表结构（用于下拉框）
        /// </summary>
        /// <param name="tableName">表名</param>
        /// <param name="externalDataSourceId">外部数据源ID</param>
        /// <returns></returns>
        [HttpGet]
        public TableData GetDbTableStructureForSelect(string tableName, string externalDataSourceId)
        {
            var result = new TableData();
            try
            {
                result.data = _dbExtension.GetDbTableStructure(tableName, externalDataSourceId).Select(u => new
                {
                    Id = u.ColumnName,
                    Name = u.ColumnName
                });
            }
            catch (Exception ex)
            {
                result.code = 500;
                result.msg = ex.Message;
            }
            return result;
        }
    }
}
