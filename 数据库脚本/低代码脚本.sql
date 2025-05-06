-- 1. 租户管理相关表

-- 1.1 租户表
CREATE TABLE `systenant` (
  `id` varchar(50) NOT NULL COMMENT '租户ID',
  `name` varchar(100) NOT NULL COMMENT '租户名称',
  `code` varchar(50) NOT NULL COMMENT '租户编码',
  `datasource` varchar(50) NULL COMMENT '外部数据源',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0=未激活，1=已激活，2=已禁用',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间',
  `logo` varchar(200) DEFAULT NULL COMMENT '租户Logo',
  `description` varchar(500) DEFAULT NULL COMMENT '租户描述',
  `createtime` datetime NOT NULL COMMENT '创建时间',
  `createuserid` varchar(50) NOT NULL COMMENT '创建用户ID',
  `createusername` varchar(50) DEFAULT NULL COMMENT '创建用户名',
  `updatetime` datetime DEFAULT NULL COMMENT '更新时间',
  `updateuserid` varchar(50) DEFAULT NULL COMMENT '更新用户ID',
  `updateusername` varchar(50) DEFAULT NULL COMMENT '更新用户名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统租户表';

-- 2. 核心功能表

-- 2.1 应用表
CREATE TABLE `lowcodeapp` (
  `id` varchar(50) NOT NULL COMMENT '应用ID',
  `tenantid` varchar(50) NOT NULL COMMENT '租户ID',
  `name` varchar(100) NOT NULL COMMENT '应用名称',
  `description` varchar(500) DEFAULT NULL COMMENT '应用描述',
  `icon` varchar(100) DEFAULT NULL COMMENT '应用图标',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0=开发中，1=已发布，2=已下线',
  `createtime` datetime NOT NULL COMMENT '创建时间',
  `createuserid` varchar(50) NOT NULL COMMENT '创建用户ID',
  `createusername` varchar(50) DEFAULT NULL COMMENT '创建用户名',
  `updatetime` datetime DEFAULT NULL COMMENT '更新时间',
  `updateuserid` varchar(50) DEFAULT NULL COMMENT '更新用户ID',
  `updateusername` varchar(50) DEFAULT NULL COMMENT '更新用户名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='低代码应用表';

-- 2.2 页面表
CREATE TABLE `lowcodepage` (
  `id` varchar(50) NOT NULL COMMENT '页面ID',
  `tenantid` varchar(50) NOT NULL COMMENT '租户ID',
  `applicationid` varchar(50) NOT NULL COMMENT '所属应用ID',
  `name` varchar(100) NOT NULL COMMENT '页面名称',
  `title` varchar(100) NOT NULL COMMENT '页面标题',
  `type` varchar(50) NOT NULL COMMENT '页面类型：form=表单页，list=列表页，detail=详情页，dashboard=数据看板，custom=自定义页',
  `url` varchar(200) DEFAULT NULL COMMENT '页面路由',
  `layout` text COMMENT '页面布局配置JSON',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0=草稿，1=已发布',
  `sortno` int(11) DEFAULT '0' COMMENT '排序号',
  `icon` varchar(50) DEFAULT NULL COMMENT '页面图标',
  `createtime` datetime NOT NULL COMMENT '创建时间',
  `createuserid` varchar(50) NOT NULL COMMENT '创建用户ID',
  `createusername` varchar(50) DEFAULT NULL COMMENT '创建用户名',
  `updatetime` datetime DEFAULT NULL COMMENT '更新时间',
  `updateuserid` varchar(50) DEFAULT NULL COMMENT '更新用户ID',
  `updateusername` varchar(50) DEFAULT NULL COMMENT '更新用户名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='低代码页面表';

-- 2.3 组件表
CREATE TABLE `lowcodecomponent` (
  `id` varchar(50) NOT NULL COMMENT '组件ID',
  `tenantid` varchar(50) NOT NULL COMMENT '租户ID',
  `page_id` varchar(50) NOT NULL COMMENT '所属页面ID',
  `parentname` varchar(50) DEFAULT NULL COMMENT '父组件名称',
  `parentid` varchar(50) DEFAULT NULL COMMENT '父组件ID',
  `type` varchar(50) NOT NULL COMMENT '组件类型：input, select, table, chart, card等',
  `name` varchar(100) NOT NULL COMMENT '组件名称',
  `label` varchar(100) DEFAULT NULL COMMENT '组件标签文本',
  `prop_config` text COMMENT '组件属性配置JSON',
  `style_config` text COMMENT '组件样式配置JSON',
  `data_config` text COMMENT '组件数据配置JSON',
  `sortno` int(11) DEFAULT '0' COMMENT '排序号',
  `createtime` datetime NOT NULL COMMENT '创建时间',
  `updatetime` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='低代码组件表';

-- 2.4 数据模型表,用buildertable
CREATE TABLE `lowcodedatamodel` (
  `id` varchar(50) NOT NULL COMMENT '模型ID',
  `tenantid` varchar(50) NOT NULL COMMENT '租户ID',
  `applicationid` varchar(50) NOT NULL COMMENT '所属应用ID',
  `name` varchar(100) NOT NULL COMMENT '模型名称',
  `code` varchar(100) NOT NULL COMMENT '模型编码',
  `description` varchar(500) DEFAULT NULL COMMENT '模型描述',
  `table_name` varchar(100) DEFAULT NULL COMMENT '关联的物理表名',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0=设计中，1=已发布',
  `createtime` datetime NOT NULL COMMENT '创建时间',
  `createuserid` varchar(50) NOT NULL COMMENT '创建用户ID',
  `createusername` varchar(50) DEFAULT NULL COMMENT '创建用户名',
  `updatetime` datetime DEFAULT NULL COMMENT '更新时间',
  `updateuserid` varchar(50) DEFAULT NULL COMMENT '更新用户ID',
  `updateusername` varchar(50) DEFAULT NULL COMMENT '更新用户名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='低代码数据模型表';

-- 2.5 数据字段表,用buildertablecolumn
CREATE TABLE `lowcodedatafield` (
  `id` varchar(50) NOT NULL COMMENT '字段ID',
  `tenantid` varchar(50) NOT NULL COMMENT '租户ID',
  `model_id` varchar(50) NOT NULL COMMENT '所属模型ID',
  `name` varchar(100) NOT NULL COMMENT '字段名称',
  `code` varchar(100) NOT NULL COMMENT '字段编码',
  `type` varchar(50) NOT NULL COMMENT '字段类型：string, number, boolean, date等',
  `length` int(11) DEFAULT NULL COMMENT '字段长度',
  `default_value` varchar(200) DEFAULT NULL COMMENT '默认值',
  `is_required` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否必填',
  `is_key` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否主键',
  `is_display` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否在列表中显示',
  `is_search` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否可搜索',
  `is_sort` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否可排序',
  `description` varchar(500) DEFAULT NULL COMMENT '字段描述',
  `sortno` int(11) DEFAULT '0' COMMENT '排序号',
  `createtime` datetime NOT NULL COMMENT '创建时间',
  `updatetime` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='低代码数据字段表';

-- 2.6 表单设计表
CREATE TABLE `lowcodeform` (
  `id` varchar(50) NOT NULL COMMENT '表单ID',
  `tenantid` varchar(50) NOT NULL COMMENT '租户ID',
  `applicationid` varchar(50) NOT NULL COMMENT '所属应用ID',
  `name` varchar(100) NOT NULL COMMENT '表单名称',
  `code` varchar(100) NOT NULL COMMENT '表单编码',
  `description` varchar(500) DEFAULT NULL COMMENT '表单描述',
  `model_id` varchar(50) DEFAULT NULL COMMENT '关联的数据模型ID',
  `form_config` text NOT NULL COMMENT '表单配置JSON',
  `form_type` varchar(20) NOT NULL DEFAULT 'create' COMMENT '表单类型：create=新建表单，edit=编辑表单，query=查询表单，view=查看表单',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0=草稿，1=已发布',
  `version` varchar(20) DEFAULT '1.0' COMMENT '表单版本',
  `createtime` datetime NOT NULL COMMENT '创建时间',
  `createuserid` varchar(50) NOT NULL COMMENT '创建用户ID',
  `createusername` varchar(50) DEFAULT NULL COMMENT '创建用户名',
  `updatetime` datetime DEFAULT NULL COMMENT '更新时间',
  `updateuserid` varchar(50) DEFAULT NULL COMMENT '更新用户ID',
  `updateusername` varchar(50) DEFAULT NULL COMMENT '更新用户名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='低代码表单设计表';

-- 2.7 数据源表，用externaldatasource
CREATE TABLE `lowcodedatasource` (
  `id` varchar(50) NOT NULL COMMENT '数据源ID',
  `tenantid` varchar(50) NOT NULL COMMENT '租户ID',
  `applicationid` varchar(50) NOT NULL COMMENT '所属应用ID',
  `name` varchar(100) NOT NULL COMMENT '数据源名称',
  `type` varchar(20) NOT NULL COMMENT '数据源类型：mysql,sqlserver,oracle,api,excel等',
  `connection_config` text COMMENT '连接配置JSON',
  `description` varchar(500) DEFAULT NULL COMMENT '数据源描述',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0=未启用，1=已启用',
  `createtime` datetime NOT NULL COMMENT '创建时间',
  `createuserid` varchar(50) NOT NULL COMMENT '创建用户ID',
  `createusername` varchar(50) DEFAULT NULL COMMENT '创建用户名',
  `updatetime` datetime DEFAULT NULL COMMENT '更新时间',
  `updateuserid` varchar(50) DEFAULT NULL COMMENT '更新用户ID',
  `updateusername` varchar(50) DEFAULT NULL COMMENT '更新用户名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='低代码数据源表';

-- 2.8 数据可视化表
CREATE TABLE `lowcodevisualization` (
  `id` varchar(50) NOT NULL COMMENT '可视化ID',
  `tenantid` varchar(50) NOT NULL COMMENT '租户ID',
  `applicationid` varchar(50) NOT NULL COMMENT '所属应用ID',
  `name` varchar(100) NOT NULL COMMENT '可视化名称',
  `type` varchar(50) NOT NULL COMMENT '可视化类型：chart=图表，table=表格，metric=指标卡，map=地图等',
  `datasource` varchar(50) DEFAULT NULL COMMENT '数据源ID',
  `data_config` text NOT NULL COMMENT '数据配置JSON',
  `style_config` text COMMENT '样式配置JSON',
  `filter_config` text COMMENT '筛选配置JSON',
  `description` varchar(500) DEFAULT NULL COMMENT '可视化描述',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0=草稿，1=已发布',
  `createtime` datetime NOT NULL COMMENT '创建时间',
  `createuserid` varchar(50) NOT NULL COMMENT '创建用户ID',
  `createusername` varchar(50) DEFAULT NULL COMMENT '创建用户名',
  `updatetime` datetime DEFAULT NULL COMMENT '更新时间',
  `updateuserid` varchar(50) DEFAULT NULL COMMENT '更新用户ID',
  `updateusername` varchar(50) DEFAULT NULL COMMENT '更新用户名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='低代码数据可视化表';

-- 2.9 菜单表
CREATE TABLE `lowcodemenu` (
  `id` varchar(50) NOT NULL COMMENT '菜单ID',
  `tenantid` varchar(50) NOT NULL COMMENT '租户ID',
  `applicationid` varchar(50) NOT NULL COMMENT '所属应用ID',
  `parentid` varchar(50) DEFAULT NULL COMMENT '父菜单ID',
  `name` varchar(100) NOT NULL COMMENT '菜单名称',
  `icon` varchar(50) DEFAULT NULL COMMENT '菜单图标',
  `path` varchar(200) DEFAULT NULL COMMENT '菜单路径',
  `page_id` varchar(50) DEFAULT NULL COMMENT '关联的页面ID',
  `sortno` int(11) DEFAULT '0' COMMENT '排序号',
  `is_visible` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否可见',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0=未启用，1=已启用',
  `createtime` datetime NOT NULL COMMENT '创建时间',
  `updatetime` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='低代码菜单表';

-- 2.10 API接口表,用sysresource表
CREATE TABLE `lowcodeapi` (
  `id` varchar(50) NOT NULL COMMENT 'API ID',
  `tenantid` varchar(50) NOT NULL COMMENT '租户ID',
  `applicationid` varchar(50) NOT NULL COMMENT '所属应用ID',
  `name` varchar(100) NOT NULL COMMENT 'API名称',
  `method` varchar(10) NOT NULL COMMENT '请求方法：GET, POST, PUT, DELETE等',
  `url` varchar(500) NOT NULL COMMENT 'API地址',
  `request_config` text COMMENT '请求参数配置JSON',
  `response_config` text COMMENT '响应结果配置JSON',
  `description` varchar(500) DEFAULT NULL COMMENT 'API描述',
  `model_id` varchar(50) DEFAULT NULL COMMENT '关联的数据模型ID',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态：0=开发中，1=已发布',
  `createtime` datetime NOT NULL COMMENT '创建时间',
  `createuserid` varchar(50) NOT NULL COMMENT '创建用户ID',
  `createusername` varchar(50) DEFAULT NULL COMMENT '创建用户名',
  `updatetime` datetime DEFAULT NULL COMMENT '更新时间',
  `updateuserid` varchar(50) DEFAULT NULL COMMENT '更新用户ID',
  `updateusername` varchar(50) DEFAULT NULL COMMENT '更新用户名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='低代码API接口表';
