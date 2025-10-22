using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Linq;
using Humanizer;
using Infrastructure;
using Infrastructure.Utilities;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using OpenAuth.Repository.Core;
using OpenAuth.Repository.Domain;
using OpenAuth.Repository.QueryObj;
using SqlSugar;

namespace OpenAuth.App
{
    public class DbExtension
    {
        protected ISqlSugarClient SugarClient;
        private string _dbTypeStr;

        private IOptions<AppSetting> _appConfiguration;
        private IHttpContextAccessor _httpContextAccessor;

        public DbExtension(IOptions<AppSetting> appConfiguration, ISqlSugarClient sugarClient, IHttpContextAccessor httpContextAccessor)
        {
            _appConfiguration = appConfiguration;
            _httpContextAccessor = httpContextAccessor;
            SugarClient = sugarClient;
        }

        /// <summary>
        /// 获取数据库表结构信息
        /// </summary>
        /// <param name="tableName"></param>
        /// <returns></returns>
        public IList<SysTableColumn> GetDbTableStructure(string tableName)
        {
            if(string.IsNullOrEmpty(tableName))
            {
                return new List<SysTableColumn>();
            }

            //如果是空,说明没有通过ProcessExternalDb设置过，直接从本地读取
            if(string.IsNullOrEmpty(_dbTypeStr)){
                _dbTypeStr = _appConfiguration.Value.DbTypes[_httpContextAccessor.GetTenantId()];
            }

            if (_dbTypeStr == Define.DBTYPE_MYSQL)
            {
                return GetMySqlStructure(tableName);
            }
            else if (_dbTypeStr == Define.DBTYPE_SQLSERVER)
            {
                return GetSqlServerStructure(tableName);
            }
            else if (_dbTypeStr == Define.DBTYPE_PostgreSQL)
            {
                return GetPostgreStructure(tableName);
            }
            else
            {
                return GetOracleStructure(tableName);
            }
        }

        /// <summary>
        /// 获取Oracle表结构
        /// </summary>
        private IList<SysTableColumn> GetOracleStructure(string tableName)
        {
            tableName = tableName.ToUpper();
            var sql = $@"
            select utc.column_name as columnname
                , utc.data_type columntype
                , utc.data_length maxlength
                , case utc.nullable when 'N' then 0 else 1 end isnull
                , utc.data_default defaultval
                , ucc.comments ""COMMENT""
                , utc.table_name tablename
                , case utc.column_name
                    when (select col.column_name
                            from user_constraints con
                                , user_cons_columns col
                            where con.constraint_name = col.constraint_name
                            and con.constraint_type = 'P'
                            and col.table_name = '{tableName}') then 1
                    else 0 end as iskey
                , case
                    when utc.column_name in ('CreateUserId', 'UpdateUserId', 'Id')
                        then 0
                    else 1
                end as isdisplay
                , case
                    when data_type in ('BIT', 'BOOL') then
                        'bool'
                    when data_type in ('SMALLINT') then 'short'
                    when data_type in ('TINYINT') then 'bool'
                    when data_type in ('NUMBER', 'CHAR', 'INT', 'Year') then
                        'int'
                    when data_type in ('BIGINT') then
                        'bigint'
                    when data_type in ('FLOAT', 'DOUBLE', 'DECIMAL') then
                        'decimal'
                    when data_type in
                            ('CHAR', 'VARCHAR', 'TINY TEXT', 'TEXT', 'MEDIUMTEXT', 'LONGTEXT', 'TINYBLOB', 'BLOB',
                            'MEDIUMBLOB', 'LONGBLOB', 'Time') then
                        'string'
                    when data_type in ('DATE', 'DATETIME', 'TIMESTAMP(6)') then
                        'DateTime'
                    else 'string'
                end as entitytype
            from user_tab_columns utc
            , user_col_comments ucc
            where utc.table_name = ucc.table_name
            and utc.column_name = ucc.column_name
            and utc.table_name = '{tableName}'
            order by column_id;  ";

            var columns = SugarClient.SqlQueryable<SysTableColumn>(sql);
            var columnList = columns?.ToList();
            if (columnList != null && columnList.Any())
            {
                columnList.ForEach(u => u.ColumnName = u.ColumnName.Transform(To.LowerCase, To.TitleCase));
                return columnList;
            }

            return new List<SysTableColumn>();
        }

        /// <summary>
        /// 获取Mysql表结构信息
        /// </summary>
        private IList<SysTableColumn> GetMySqlStructure(string tableName)
        {
            var sql = $@"SELECT  DISTINCT
                    Column_Name AS ColumnName,
                     '{tableName}'  as tableName,
	                Column_Comment AS Comment,
                    data_type as ColumnType,
                        CASE
                          WHEN data_type IN( 'BIT', 'BOOL', 'bit', 'bool') THEN
                'bool'
		             WHEN data_type in('smallint','SMALLINT') THEN 'short'
								WHEN data_type in('tinyint','TINYINT') THEN 'bool'
                        WHEN data_type IN('MEDIUMINT','mediumint', 'int','INT','year', 'Year') THEN
                    'int'
                    WHEN data_type in ( 'BIGINT','bigint') THEN
                    'bigint'
                    WHEN data_type IN('FLOAT', 'DOUBLE', 'DECIMAL','float', 'double', 'decimal') THEN
                    'decimal'
                    WHEN data_type IN('CHAR', 'VARCHAR', 'TINY TEXT', 'TEXT', 'MEDIUMTEXT', 'LONGTEXT', 'TINYBLOB', 'BLOB', 'MEDIUMBLOB', 'LONGBLOB', 'Time','char', 'varchar', 'tiny text', 'text', 'mediumtext', 'longtext', 'tinyblob', 'blob', 'mediumblob', 'longblob', 'time') THEN
                    'string'
                    WHEN data_type IN('Date', 'DateTime', 'TimeStamp','date', 'datetime', 'timestamp') THEN
                    'DateTime' ELSE 'string'
                END AS EntityType,
	              case WHEN CHARACTER_MAXIMUM_LENGTH>8000 THEN 0 ELSE CHARACTER_MAXIMUM_LENGTH end  AS Maxlength,
            CASE
                    WHEN COLUMN_KEY = 'PRI' THEN  
                    1 ELSE 0
                END AS IsKey,
            CASE
                    WHEN Column_Name IN( 'CreateID', 'ModifyID', '' ) 
		            OR COLUMN_KEY<> '' THEN
                        0 ELSE 1
                        END AS IsDisplay,
		            1 AS IsColumnData,
                    120 AS ColumnWidth,
                    0 AS OrderNo,
                CASE
                        WHEN IS_NULLABLE = 'NO' THEN
                        0 ELSE 1
                    END AS IsNull,
	            CASE
                        WHEN COLUMN_KEY <> '' THEN
                        1 ELSE 0
                    END AS IsReadDataset
                FROM
                    information_schema.COLUMNS
                WHERE
                    table_name = '{tableName}'";

          
                var columns = SugarClient.SqlQueryable<SysTableColumn>(sql);
                var columnList = columns?.ToList();
                if (columnList != null && columnList.Any())
                {
                    columnList.ForEach(u => u.ColumnName = u.ColumnName.Transform(To.LowerCase, To.TitleCase));
                    return columnList;
                }
  

            return new List<SysTableColumn>();

        }


        /// <summary>
        /// 获取pgsql表结构信息
        /// </summary>
        private IList<SysTableColumn> GetPostgreStructure(string tableName)
        {
            tableName = tableName.ToLower();
            var sql = $@"select attr.attrelid
                , schema.nspname as schemaname
                , class.relname as tablename --表名
                , attr.attname as columnname --列名
                , attr.atttypid --类型ID
                , attr.atttypmod
                , case when con.conname is not null then 1 else 0 end as iskey --是否主键
                , case when attr.attnotnull is true then 0 else 1 end as isnull --可空
                , t.typname columntype --类型名称
                ,case
                    -- 布尔类型
                    when typname in ('bit', 'bool', 'boolean') then 'bool'
                    
                    -- 整数类型
                    when typname in ('int2', 'smallint') then 'short'
                    when typname in ('int4', 'int', 'integer') then 'int'
                    when typname in ('int8', 'bigint') then 'bigint'
                    
                    -- 浮点数类型
                    when typname in ('real', 'float4') then 'float'
                    when typname in ('float8', 'double precision') then 'double'
                    when typname in ('numeric', 'decimal') then 'decimal'
                    
                    -- 字符串类型
                    when typname in ('char', 'bpchar', 'character') then 'string'
                    when typname in ('varchar', 'character varying') then 'string'
                    when typname in ('text') then 'string'
                    
                    -- 日期时间类型
                    when typname in ('time', 'timetz') then 'TimeSpan'
                    when typname in ('timestamp', 'timestamptz', 'datetime','date') then 'DateTime'
                    when typname in ('interval') then 'TimeSpan'
                    
                    -- 其他类型
                    when typname in ('uuid') then 'Guid'
                    when typname in ('bytea') then 'byte[]'
                    when typname in ('json', 'jsonb') then 'string'
                    
                    else 'string'
                end as entitytype
                , comment.description as comment
                , 1 as iscolumndata
                , case
                    when t.typname = 'varchar' or t.typname = 'bpchar' then attr.atttypmod - 4
                    else 10
                end as columnwidth
                , 0 as orderno
                , case
                    when t.typname = 'varchar' or t.typname = 'bpchar' then attr.atttypmod - 4
                    else 10
                end as maxlength
                , case
                    when attname in ('createid', 'modifyid', '')
                        or con.conname is null then 0
                    else 1
                end as isdisplay --是否显示
            from pg_catalog.pg_class class
                    inner join pg_catalog.pg_attribute attr on attr.attrelid = class.oid
                    left join pg_catalog.pg_constraint con
                            on con.conrelid = class.oid and attr.attnum = any (con.conkey) and con.contype = 'p'
                    left join pg_catalog.pg_type t on attr.atttypid = t.oid
                    inner join pg_catalog.pg_description comment
                                on comment.objoid = attr.attrelid and comment.objsubid = attr.attnum
                    inner join pg_catalog.pg_namespace schema on schema.oid = class.relnamespace
            where attr.attnum > 0
            and not attr.attisdropped
            and schema.nspname = 'public' -- replace 'your_schema' with your schema name
            and class.relname = '{tableName}'";

            var columns = SugarClient.SqlQueryable<SysTableColumn>(sql);
            var columnList = columns?.ToList();
            if (columnList != null && columnList.Any())
            {
                columnList.ForEach(u => u.ColumnName = u.ColumnName.Transform(To.LowerCase, To.TitleCase));
                return columnList;
            }

            return new List<SysTableColumn>();

        }



        /// <summary>
        /// 获取SqlServer表结构信息
        /// </summary>
        /// <param name="tableName"></param>
        /// <returns></returns>
        private IList<SysTableColumn> GetSqlServerStructure(string tableName)
        {
            var sql = $@"
            SELECT TableName,
                LTRIM(RTRIM(ColumnName)) AS ColumnName,
                Comment,
                CASE WHEN ColumnType = 'uniqueidentifier' THEN 'guid'
                     WHEN ColumnType IN('smallint', 'INT') THEN 'int'
                     WHEN ColumnType = 'BIGINT' THEN 'long'
                     WHEN ColumnType IN('CHAR', 'VARCHAR', 'NVARCHAR',
                                          'text', 'xml', 'varbinary', 'image')
                     THEN 'string'
                     WHEN ColumnType IN('tinyint')
                     THEN 'byte'
                     WHEN ColumnType IN('bit')
                     THEN 'bool'

                     WHEN ColumnType IN('bit') THEN 'bool'
                     WHEN ColumnType IN('time', 'date', 'DATETIME', 'smallDATETIME')
                     THEN 'DateTime'
                     WHEN ColumnType IN('smallmoney', 'DECIMAL', 'numeric',
                                          'money') THEN 'decimal'
                     WHEN ColumnType = 'float' THEN 'double'
                     ELSE 'string'
                END as  EntityType,
                    ColumnType,
                    [Maxlength],
                IsKey,
                CASE WHEN ColumnName IN('CreateID', 'ModifyID', '')
                          OR IsKey = 1 THEN 0
                     ELSE 1
                END AS IsDisplay ,
				1 AS IsColumnData,

              CASE   
                     WHEN ColumnName IN('Modifier', 'Creator') THEN 130
                     WHEN[Maxlength] < 110 AND[Maxlength] > 60 THEN 120
                     WHEN[Maxlength] < 200 AND[Maxlength] >= 110 THEN 180
                     WHEN[Maxlength] > 200 THEN 220
                     ELSE 90
                   END AS ColumnWidth ,
                0 AS OrderNo,
                --CASE WHEN IsKey = 1 OR t.[IsNull]=0 THEN 0
                --     ELSE 1 END
                t.[IsNull] AS
                 [IsNull],
            CASE WHEN IsKey = 1 THEN 1 ELSE 0 END IsReadDataset,
            CASE WHEN IsKey!=1 AND t.[IsNull] = 0 THEN 0 ELSE NULL END AS EditColNo
        FROM    (SELECT obj.name AS TableName ,
                            col.name AS ColumnName ,
                            CONVERT(NVARCHAR(100),ISNULL(ep.[value], '')) AS Comment,
                            t.name AS ColumnType ,
                           CASE WHEN  col.length<1 THEN 0 ELSE  col.length END  AS[Maxlength],
                            CASE WHEN EXISTS (SELECT   1
                                               FROM dbo.sysindexes si
                                                        INNER JOIN dbo.sysindexkeys sik ON si.id = sik.id
                                                              AND si.indid = sik.indid
                                                        INNER JOIN dbo.syscolumns sc ON sc.id = sik.id
                                                              AND sc.colid = sik.colid
                                                        INNER JOIN dbo.sysobjects so ON so.name = si.name
                                                              AND so.xtype = 'PK'
                                               WHERE sc.id = col.id
                                                        AND sc.colid = col.colid)
                                 THEN 1
                                 ELSE 0
                            END AS IsKey ,
                            CASE WHEN col.isnullable = 1 THEN 1
                                 ELSE 0
                            END AS[IsNull],
                            col.colorder
                  FROM      dbo.syscolumns col
                            LEFT JOIN dbo.systypes t ON col.xtype = t.xusertype
                           INNER JOIN dbo.sysobjects obj ON col.id = obj.id

                                                            AND obj.xtype IN ( 'U','V')
                                                          --   AND obj.status >= 01
                            LEFT JOIN dbo.syscomments comm ON col.cdefault = comm.id
                            LEFT JOIN sys.extended_properties ep ON col.id = ep.major_id
                                                              AND col.colid = ep.minor_id
                                                              AND ep.name = 'MS_Description'
                            LEFT JOIN sys.extended_properties epTwo ON obj.id = epTwo.major_id
                                                              AND epTwo.minor_id = 0
                                                              AND epTwo.name = 'MS_Description'
                  WHERE obj.name =  '{tableName}') AS t
            ORDER BY t.colorder";

            var columns = SugarClient.SqlQueryable<SysTableColumn>(sql);
            var columnList = columns?.ToList();
            if (columnList != null && columnList.Any())
            {
                return columnList;
            }
            return new List<SysTableColumn>();
        }

        /// <summary>
        /// 通过表名和外部数据源ID获取表结构
        /// </summary>
        /// <param name="tableName">表名</param>
        /// <param name="externalDataSourceId">外部数据源ID</param>
        /// <returns></returns>
        public IList<SysTableColumn> GetDbTableStructure(string tableName, string externalDataSourceId){
            var connection = SugarClient.Queryable<ExternalDataSource>().First(u => u.Id == externalDataSourceId);
            if (connection != null)
            {
                var dbType = connection.Dbtype;
                SetConnection(connection.Connectionstring, dbType);
            }
            return GetDbTableStructure(tableName);
        }

        /// <summary>
        /// 处理外部数据库
        /// </summary>
        /// <param name="buildertableId">代码生成器表ID</param>
        public void ProcessExternalDb(string buildertableId){
            var builderTable = SugarClient.Queryable<BuilderTable>().First(u => u.Id == buildertableId);
            if (builderTable != null)
            {
                //如果代码生成器配置了外部数据库连接，则使用外部数据库连接
                var connection = SugarClient.Queryable<ExternalDataSource>().First(u => u.Id == builderTable.ExternalDataSourceId);
                if (connection != null)
                {
                    var dbType = connection.Dbtype;
                    SetConnection(connection.Connectionstring, dbType);
                }
            }
        }

        /// <summary>
        /// 设置数据库连接
        /// </summary>
        /// <param name="connectionString">数据库连接字符串</param>
        /// <param name="dbType">数据库类型</param>
        private void SetConnection(string connectionString, int? dbType)
        {
            switch ((SqlSugar.DbType)dbType)
            {
                case SqlSugar.DbType.MySql:
                    _dbTypeStr = Define.DBTYPE_MYSQL;
                    break;
                case SqlSugar.DbType.SqlServer:
                    _dbTypeStr = Define.DBTYPE_SQLSERVER;
                    break;
                case SqlSugar.DbType.Oracle:
                    _dbTypeStr = Define.DBTYPE_ORACLE;
                    break;
                case SqlSugar.DbType.PostgreSQL:
                    _dbTypeStr = Define.DBTYPE_PostgreSQL;
                    break;
                default:
                    _dbTypeStr = Define.DBTYPE_MYSQL;
                    break;
            }
            var config = new ConnectionConfig
            {
                ConnectionString = connectionString,
                IsAutoCloseConnection = true,
                DbType = (SqlSugar.DbType)dbType
            };
            // 创建新的SqlSugarClient实例
            SugarClient = new SqlSugarClient(config);
            
        }
    }
}