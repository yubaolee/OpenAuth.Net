

-- ----------------------------
-- Table structure for application
-- ----------------------------
DROP TABLE IF EXISTS "public"."application";
CREATE TABLE "public"."application" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "appsecret" varchar(255) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "icon" varchar(255) COLLATE "pg_catalog"."default",
  "disable" int2 NOT NULL,
  "createtime" date NOT NULL,
  "createuser" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."application"."id" IS 'AppId';
COMMENT ON COLUMN "public"."application"."name" IS '应用名称';
COMMENT ON COLUMN "public"."application"."appsecret" IS '应用密钥';
COMMENT ON COLUMN "public"."application"."description" IS '应用描述';
COMMENT ON COLUMN "public"."application"."icon" IS '应用图标';
COMMENT ON COLUMN "public"."application"."disable" IS '是否可用';
COMMENT ON COLUMN "public"."application"."createtime" IS '创建日期';
COMMENT ON COLUMN "public"."application"."createuser" IS '创建人';
COMMENT ON TABLE "public"."application" IS '应用';

-- ----------------------------
-- Records of application
-- ----------------------------
INSERT INTO "public"."application" VALUES ('110', 'OpenAuth.Net', 'openauthdotnetyubaolee', '最好用的.NET权限工作流框架', NULL, 0, '2018-04-14', NULL);
INSERT INTO "public"."application" VALUES ('119', 'XXX管理平台', 'manageryubaolee', '这是一个第三的平台', NULL, 0, '2018-04-14', NULL);

-- ----------------------------
-- Table structure for buildertable
-- ----------------------------
DROP TABLE IF EXISTS "public"."buildertable";
CREATE TABLE "public"."buildertable" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "tablename" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "remark" text COLLATE "pg_catalog"."default",
  "detailtablename" varchar(255) COLLATE "pg_catalog"."default",
  "detailcomment" text COLLATE "pg_catalog"."default",
  "classname" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "namespace" varchar(100) COLLATE "pg_catalog"."default",
  "modulecode" varchar(255) COLLATE "pg_catalog"."default",
  "modulename" text COLLATE "pg_catalog"."default",
  "folder" text COLLATE "pg_catalog"."default",
  "options" text COLLATE "pg_catalog"."default",
  "typeid" varchar(50) COLLATE "pg_catalog"."default",
  "typename" varchar(20) COLLATE "pg_catalog"."default",
  "createtime" timestamp(6) NOT NULL,
  "createuserid" varchar(50) COLLATE "pg_catalog"."default",
  "updatetime" timestamp(6),
  "updateuserid" varchar(50) COLLATE "pg_catalog"."default",
  "updateusername" varchar(50) COLLATE "pg_catalog"."default",
  "createusername" varchar(50) COLLATE "pg_catalog"."default",
  "foreignkey" varchar(50) COLLATE "pg_catalog"."default",
  "isdynamicheader" int2,
  "parenttableid" varchar(50) COLLATE "pg_catalog"."default",
  "externaldatasourceid" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."buildertable"."id" IS '编号';
COMMENT ON COLUMN "public"."buildertable"."tablename" IS '表英文全称';
COMMENT ON COLUMN "public"."buildertable"."remark" IS '表描述、中文名称';
COMMENT ON COLUMN "public"."buildertable"."detailtablename" IS '子表英文全称';
COMMENT ON COLUMN "public"."buildertable"."detailcomment" IS '子表描述、中文名称';
COMMENT ON COLUMN "public"."buildertable"."classname" IS '实体类名称';
COMMENT ON COLUMN "public"."buildertable"."namespace" IS '命名空间';
COMMENT ON COLUMN "public"."buildertable"."modulecode" IS '模块标识';
COMMENT ON COLUMN "public"."buildertable"."modulename" IS '模块名称';
COMMENT ON COLUMN "public"."buildertable"."folder" IS '代码相对文件夹路径';
COMMENT ON COLUMN "public"."buildertable"."options" IS '其它生成选项';
COMMENT ON COLUMN "public"."buildertable"."typeid" IS '分类ID';
COMMENT ON COLUMN "public"."buildertable"."typename" IS '分类名称';
COMMENT ON COLUMN "public"."buildertable"."createtime" IS '创建时间';
COMMENT ON COLUMN "public"."buildertable"."createuserid" IS '创建人ID';
COMMENT ON COLUMN "public"."buildertable"."updatetime" IS '修改时间';
COMMENT ON COLUMN "public"."buildertable"."updateuserid" IS '修改人ID';
COMMENT ON COLUMN "public"."buildertable"."updateusername" IS '修改人姓名';
COMMENT ON COLUMN "public"."buildertable"."createusername" IS '创建人姓名';
COMMENT ON COLUMN "public"."buildertable"."foreignkey" IS '外键';
COMMENT ON COLUMN "public"."buildertable"."isdynamicheader" IS '是否为动态头部';
COMMENT ON COLUMN "public"."buildertable"."externaldatasourceid" IS '外部数据源ID';
COMMENT ON TABLE "public"."buildertable" IS '代码生成器的表信息';

-- ----------------------------
-- Records of buildertable
-- ----------------------------
INSERT INTO "public"."buildertable" VALUES ('03761b53-e229-4e0e-b7b1-2831bdc84384', 'Stock', '请在自己的电脑测试，服务器是看不出效果的', '', '', 'Stock', 'OpenAuth.Repository.Domain', 'StockApp', '仓储', 'D:/OpenAuth.Pro/Client', '', '', '', '2020-09-29 00:52:58', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:32:09', '00000000-0000-0000-0000-000000000000', '超级管理员', '超级管理员', '', 1, NULL, NULL);
INSERT INTO "public"."buildertable" VALUES ('1751d517-6d2b-4638-8f5c-aa6355bccb0e', 'Category', '', '', '', 'Category', 'OpenAuth.Repository.Domain', 'CategoryApp', '分类管理', 'D:/OpenAuth.Pro/Client', '', '', '', '2021-09-27 00:26:54', '00000000-0000-0000-0000-000000000000', '2021-09-27 00:45:56', '00000000-0000-0000-0000-000000000000', '超级管理员', '超级管理员', '', 1, NULL, NULL);
INSERT INTO "public"."buildertable" VALUES ('7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', '入库订单头表', '', '', 'wmsinboundordertbl', 'OpenAuth.Repository.Domain', 'WmsInApp', '入库模块', 'D:/OpenAuth.Pro/Client', '', '', '', '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-09-27 00:48:54', '00000000-0000-0000-0000-000000000000', '超级管理员', '超级管理员', '', 1, NULL, NULL);
INSERT INTO "public"."buildertable" VALUES ('de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', '', '', '', 'Resource', 'OpenAuth.Repository.Domain', 'ResourceApp', '资源管理', 'D:/OpenAuth.Pro/Client', '', '', '', '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:50:17', '00000000-0000-0000-0000-000000000000', '超级管理员', '超级管理员', '', 1, NULL, NULL);
INSERT INTO "public"."buildertable" VALUES ('f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', '', '', '', 'wmsinboundorderdtbl', 'OpenAuth.Repository.Domain', 'wmsinboundorderdtbl', '入库订单模块子表', 'D:/OpenAuth.Pro/Client', '', '', '', '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 01:09:27', '00000000-0000-0000-0000-000000000000', '超级管理员', '超级管理员', 'OrderId', 1, '7f0ca2fd-7fa0-4316-a466-22733d466dd2', NULL);
INSERT INTO "public"."buildertable" VALUES ('fc52b31a-fc29-42b6-b53c-99463644fff2', 'dataprivilegerule', '', '', '', 'DataPrivilegeRule', 'OpenAuth.Repository.Domain', 'DataPrivilegeRuleApp', '数据权限', 'D:/OpenAuth.Pro/Client', '', '', '', '2021-09-23 22:35:02', '00000000-0000-0000-0000-000000000000', '2021-09-26 00:28:20', '00000000-0000-0000-0000-000000000000', '超级管理员', '超级管理员', '', 1, NULL, NULL);

-- ----------------------------
-- Table structure for buildertablecolumn
-- ----------------------------
DROP TABLE IF EXISTS "public"."buildertablecolumn";
CREATE TABLE "public"."buildertablecolumn" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "tableid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "tablename" varchar(255) COLLATE "pg_catalog"."default",
  "columnname" varchar(200) COLLATE "pg_catalog"."default",
  "remark" text COLLATE "pg_catalog"."default",
  "columntype" varchar(100) COLLATE "pg_catalog"."default",
  "entitytype" text COLLATE "pg_catalog"."default",
  "entityname" varchar(200) COLLATE "pg_catalog"."default",
  "iskey" int2 NOT NULL,
  "isincrement" int2 NOT NULL,
  "isrequired" int2 NOT NULL,
  "isinsert" int2 NOT NULL,
  "isedit" int2 NOT NULL,
  "islist" int2 NOT NULL,
  "isquery" int2 NOT NULL,
  "querytype" varchar(200) COLLATE "pg_catalog"."default",
  "htmltype" varchar(200) COLLATE "pg_catalog"."default",
  "edittype" varchar(200) COLLATE "pg_catalog"."default",
  "sort" int4 NOT NULL,
  "createtime" timestamp(6) NOT NULL,
  "createuserid" varchar(50) COLLATE "pg_catalog"."default",
  "updatetime" timestamp(6),
  "updateuserid" varchar(50) COLLATE "pg_catalog"."default",
  "editrow" int4,
  "editcol" int4,
  "updateusername" varchar(50) COLLATE "pg_catalog"."default",
  "createusername" varchar(50) COLLATE "pg_catalog"."default",
  "maxlength" int4,
  "datasource" varchar(200) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."buildertablecolumn"."id" IS '编号';
COMMENT ON COLUMN "public"."buildertablecolumn"."tableid" IS '归属表编号';
COMMENT ON COLUMN "public"."buildertablecolumn"."tablename" IS '表名称';
COMMENT ON COLUMN "public"."buildertablecolumn"."columnname" IS '列名称';
COMMENT ON COLUMN "public"."buildertablecolumn"."remark" IS '列描述';
COMMENT ON COLUMN "public"."buildertablecolumn"."columntype" IS '列类型';
COMMENT ON COLUMN "public"."buildertablecolumn"."entitytype" IS '实体类型';
COMMENT ON COLUMN "public"."buildertablecolumn"."entityname" IS '实体名称';
COMMENT ON COLUMN "public"."buildertablecolumn"."iskey" IS '是否主键';
COMMENT ON COLUMN "public"."buildertablecolumn"."isincrement" IS '是否自增';
COMMENT ON COLUMN "public"."buildertablecolumn"."isrequired" IS '是否必填';
COMMENT ON COLUMN "public"."buildertablecolumn"."isinsert" IS '是否为插入字段';
COMMENT ON COLUMN "public"."buildertablecolumn"."isedit" IS '是否编辑字段';
COMMENT ON COLUMN "public"."buildertablecolumn"."islist" IS '是否列表字段';
COMMENT ON COLUMN "public"."buildertablecolumn"."isquery" IS '是否查询字段';
COMMENT ON COLUMN "public"."buildertablecolumn"."querytype" IS '查询方式（等于、不等于、大于、小于、范围）';
COMMENT ON COLUMN "public"."buildertablecolumn"."htmltype" IS '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）';
COMMENT ON COLUMN "public"."buildertablecolumn"."edittype" IS '编辑类型（文本框、文本域、下拉框、复选框、单选框、日期控件）';
COMMENT ON COLUMN "public"."buildertablecolumn"."sort" IS '排序';
COMMENT ON COLUMN "public"."buildertablecolumn"."createtime" IS '创建时间';
COMMENT ON COLUMN "public"."buildertablecolumn"."createuserid" IS '创建人ID';
COMMENT ON COLUMN "public"."buildertablecolumn"."updatetime" IS '修改时间';
COMMENT ON COLUMN "public"."buildertablecolumn"."updateuserid" IS '修改人ID';
COMMENT ON COLUMN "public"."buildertablecolumn"."editrow" IS '修改时的行位置';
COMMENT ON COLUMN "public"."buildertablecolumn"."editcol" IS '修改时的列位置';
COMMENT ON COLUMN "public"."buildertablecolumn"."updateusername" IS '修改人姓名';
COMMENT ON COLUMN "public"."buildertablecolumn"."createusername" IS '创建人姓名';
COMMENT ON COLUMN "public"."buildertablecolumn"."maxlength" IS '最大长度';
COMMENT ON COLUMN "public"."buildertablecolumn"."datasource" IS '数据源（当类型为复选框、下拉列表时使用）';
COMMENT ON TABLE "public"."buildertablecolumn" IS '代码生成器的字段信息';

-- ----------------------------
-- Records of buildertablecolumn
-- ----------------------------
INSERT INTO "public"."buildertablecolumn" VALUES ('01fab5d4-f004-47e7-909a-c548c0949f04', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'HoldNum', '占用数量', 'decimal', 'decimal', 'HoldNum', 0, 0, 1, 1, 1, 1, 0, '', '', 'number', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:48:02', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('03129db7-5ba9-4410-b43e-b77ac9fe7929', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'CreateUserId', '创建人ID', 'varchar', 'string', 'CreateUserId', 0, 0, 0, 0, 0, 0, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:57:46', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('08e80261-e4ae-4a6f-adf5-09ad5267a975', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'GoodsBatch', '商品批号', 'varchar', 'string', 'GoodsBatch', 0, 0, 1, 1, 1, 1, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-11 22:54:21', '', NULL, NULL, '', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('0ff3a09e-5a37-459f-be55-49ad2b90d934', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'Id', '入库通知单号', 'varchar', 'string', 'Id', 1, 0, 1, 1, 1, 1, 0, '', '', 'text', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:45:59', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('10462120-3731-4b3d-a44e-f8ee039b3b26', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'Disable', '是否禁用', 'tinyint', 'bool', 'Disable', 0, 0, 1, 1, 1, 1, 0, '', '', 'switch', 93, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-29 11:39:46', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, '');
INSERT INTO "public"."buildertablecolumn" VALUES ('11997d76-06da-480f-9505-d7b6ed824d30', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'OrgId', '所属部门', 'varchar', 'string', 'OrgId', 0, 0, 0, 1, 0, 0, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 01:50:35', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('15797df5-1392-4eff-8c2f-e142eed7a9f9', 'fc52b31a-fc29-42b6-b53c-99463644fff2', 'dataprivilegerule', 'CreateTime', '创建时间', 'datetime', 'DateTime', 'CreateTime', 0, 0, 1, 1, 0, 1, 0, '', '', '', 0, '2021-09-23 22:35:02', '00000000-0000-0000-0000-000000000000', '2021-09-23 22:39:53', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('165bb5dd-634d-470a-850c-8483bf967d0b', '1751d517-6d2b-4638-8f5c-aa6355bccb0e', 'Category', 'UpdateTime', '最后更新时间', 'datetime', 'DateTime', 'UpdateTime', 0, 0, 0, 1, 0, 0, 0, '', '', '', 0, '2021-09-27 00:26:55', '00000000-0000-0000-0000-000000000000', '2021-09-27 00:40:31', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('17cf3076-9b38-4ac8-a05a-07b1f5b4a309', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'Remark', '备注', 'varchar', 'string', 'Remark', 0, 0, 0, 1, 1, 1, 0, '', '', 'textarea', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:49:42', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 128, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('18f07476-eaa9-4f5e-a4fd-14a8e1bd4c87', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'CreateUserName', '创建人', 'varchar', 'string', 'CreateUserName', 0, 0, 1, 1, 0, 1, 0, '', '', '', 80, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-29 00:59:35', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 200, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('2105d04e-8c65-4a21-9701-76f64ac119d3', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'OrderId', '入库单号', 'varchar', 'string', 'OrderId', 1, 0, 1, 1, 1, 1, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 03:06:40', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('24d51a8f-7102-41f1-8d39-c8e9e6d72a53', 'fc52b31a-fc29-42b6-b53c-99463644fff2', 'dataprivilegerule', 'SortNo', '排序号', 'int', 'int', 'SortNo', 0, 0, 1, 1, 1, 1, 0, '', '', 'number', 0, '2021-09-23 22:35:02', '00000000-0000-0000-0000-000000000000', '2021-09-23 22:39:19', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('27178bae-387a-4e16-84c4-3fb9d5927afb', '1751d517-6d2b-4638-8f5c-aa6355bccb0e', 'Category', 'CreateTime', '创建时间', 'datetime', 'DateTime', 'CreateTime', 0, 0, 1, 1, 0, 1, 0, '', '', '', 0, '2021-09-27 00:26:55', '00000000-0000-0000-0000-000000000000', '2021-09-27 00:42:27', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('28bd8b85-b62a-4fa3-a50d-a78b015897be', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'OwnerId', '货主编号', 'varchar', 'string', 'OwnerId', 0, 0, 1, 1, 1, 1, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-11 22:54:21', '', NULL, NULL, '', '超级管理员', 32, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('2bc4953d-a863-492e-845f-36bff59bc107', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'UpdateUserId', '更新人ID', 'varchar', 'string', 'UpdateUserId', 0, 0, 0, 1, 0, 0, 0, '', '', '', 0, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:51:27', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('2bed33d9-c8bf-46ea-8a35-99a6b079da66', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'UpdateTime', '更新时间', 'datetime', 'DateTime', 'UpdateTime', 0, 0, 0, 0, 0, 1, 0, '', '', 'datetime', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 03:06:47', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('32b5b4e9-44a7-410a-80d9-1200ffe048d5', 'fc52b31a-fc29-42b6-b53c-99463644fff2', 'dataprivilegerule', 'UpdateUserId', '最后更新人ID', 'varchar', 'string', 'UpdateUserId', 0, 0, 0, 1, 0, 0, 0, '', '', '', 0, '2021-09-23 22:35:02', '00000000-0000-0000-0000-000000000000', '2021-09-23 22:39:38', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('33a8a1bd-ea81-4942-9469-4f20a037bf94', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'AppName', '应用名称', 'varchar', 'string', 'AppName', 0, 0, 0, 1, 1, 1, 0, '', '', '', 90, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:51:44', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('3508e108-6fb3-44f2-aa61-4c61a42f5f38', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'CreateTime', '创建时间', 'datetime', 'DateTime', 'CreateTime', 0, 0, 1, 1, 0, 1, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 01:09:47', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('37219218-c8a1-40a8-be28-77d423a019b7', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'AppId', '应用ID', 'varchar', 'string', 'AppId', 0, 0, 0, 1, 1, 0, 0, '', '', 'select', 0, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:51:49', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, 'PLATFORM');
INSERT INTO "public"."buildertablecolumn" VALUES ('3a5ed37f-4dca-420f-8a62-8465650dc1a3', 'fc52b31a-fc29-42b6-b53c-99463644fff2', 'dataprivilegerule', 'UpdateTime', '最后更新时间', 'datetime', 'DateTime', 'UpdateTime', 0, 0, 0, 1, 0, 1, 0, '', '', '', 0, '2021-09-23 22:35:02', '00000000-0000-0000-0000-000000000000', '2021-09-23 22:39:33', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('3b96bd7f-38a6-4188-9205-5f6340e29548', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'UpdateTime', '最后更新时间', 'datetime', 'DateTime', 'UpdateTime', 0, 0, 0, 1, 0, 0, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 01:52:29', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('3d1b1192-aad3-4a6f-9770-ecf486bc4cc0', '03761b53-e229-4e0e-b7b1-2831bdc84384', 'Stock', 'Status', '出库/入库', 'int', 'int', 'Status', 0, 0, 1, 1, 1, 1, 0, '', '', 'select', 7, '2020-09-29 00:52:58', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:30:15', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, 'COMMON_STATUS');
INSERT INTO "public"."buildertablecolumn" VALUES ('3e0dcc3c-3978-4615-bfe9-e65b78e67f4e', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'CreateTime', '创建时间', 'datetime', 'DateTime', 'CreateTime', 0, 0, 0, 0, 0, 1, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:51:57', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('430a695a-7975-4c63-bf57-13c9614d086d', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'TaxRate', '税率', 'decimal', 'decimal', 'TaxRate', 0, 0, 0, 1, 1, 1, 0, '', '', 'decimal', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:49:47', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('450ff804-a22e-4676-83e8-474a2d32cc75', '1751d517-6d2b-4638-8f5c-aa6355bccb0e', 'Category', 'CreateUserName', '创建人', 'varchar', 'string', 'CreateUserName', 0, 0, 1, 1, 0, 1, 0, '', '', '', 0, '2021-09-27 00:26:55', '00000000-0000-0000-0000-000000000000', '2021-09-27 00:42:32', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 200, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('4922ec7f-8730-4c48-913b-a1c110c1e8c4', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'ScheduledInboundTime', '预定入库时间', 'datetime', 'DateTime', 'ScheduledInboundTime', 0, 0, 0, 1, 1, 0, 0, '', '', 'date', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 01:51:12', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('4b52a996-4f4d-4a7c-b068-091d1a378b4c', '03761b53-e229-4e0e-b7b1-2831bdc84384', 'Stock', 'OrgId', '组织ID', 'varchar', 'string', 'OrgId', 0, 0, 0, 1, 0, 0, 0, '', '', '', 20, '2020-09-29 00:52:58', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:30:02', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('4c44c915-d771-44b5-8030-f1c242425c7d', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'Id', '入库通知单明细号', 'varchar', 'string', 'Id', 1, 0, 1, 1, 1, 1, 0, '', '', 'text', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:48:11', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('4d6d87f3-b597-4dda-8f1f-a0d3d66a25e7', '1751d517-6d2b-4638-8f5c-aa6355bccb0e', 'Category', 'DtValue', '分类值', 'varchar', 'string', 'DtValue', 0, 0, 0, 1, 1, 1, 0, '', '', 'textarea', 95, '2021-09-27 00:26:55', '00000000-0000-0000-0000-000000000000', '2021-09-27 00:42:07', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('4ddd9669-84c6-4fd4-ae2b-fc72eb2aecf7', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'Description', '描述', 'varchar', 'string', 'Description', 0, 0, 1, 1, 1, 1, 0, '', '', '', 85, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-29 00:59:28', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 500, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('4e967746-afe2-431c-b549-3ffbe982c25a', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'TypeName', '分类名称', 'varchar', 'string', 'TypeName', 0, 0, 0, 1, 1, 1, 0, '', '', '', 0, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-29 00:27:29', '', NULL, NULL, '', '超级管理员', 20, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('50cf4640-ef20-4122-b21e-c4a6562813f3', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'SortNo', '排序号', 'int', 'int', 'SortNo', 0, 0, 1, 1, 1, 1, 0, '', '', 'text', 0, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-29 00:31:48', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('51f693cc-33c9-47e0-8080-81118a1d6924', 'fc52b31a-fc29-42b6-b53c-99463644fff2', 'dataprivilegerule', 'UpdateUserName', '最后更新人', 'varchar', 'string', 'UpdateUserName', 0, 0, 0, 1, 0, 0, 0, '', '', '', 0, '2021-09-23 22:35:02', '00000000-0000-0000-0000-000000000000', '2021-09-23 22:40:06', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 200, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('53b76400-51d6-4f38-8142-7a855e9f872a', '1751d517-6d2b-4638-8f5c-aa6355bccb0e', 'Category', 'DtCode', '分类标识', 'varchar', 'string', 'DtCode', 0, 0, 1, 1, 1, 1, 0, '', '', '', 99, '2021-09-27 00:26:55', '00000000-0000-0000-0000-000000000000', '2021-09-27 00:42:00', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('54954a8b-b34b-41c3-a2bf-46cf5c3f1afa', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'UpdateTime', '更新时间', 'datetime', 'DateTime', 'UpdateTime', 0, 0, 0, 1, 0, 1, 0, '', '', '', 0, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:51:24', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('56f222a5-bce9-4ae9-acfc-a6c7de0c6dfa', '03761b53-e229-4e0e-b7b1-2831bdc84384', 'Stock', 'Name', '产品名称', 'text', 'string', 'Name', 0, 0, 1, 1, 1, 1, 0, '', '', 'text', 40, '2020-09-29 00:52:58', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:29:52', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 0, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('5d372a7e-09f8-480c-9f05-0b28d24b713b', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'ShipperId', '承运人编号', 'varchar', 'string', 'ShipperId', 0, 0, 0, 1, 1, 1, 0, '', '', 'text', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:45:44', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('5d6c8d4f-b127-4959-a34c-5e641a9d89ed', '1751d517-6d2b-4638-8f5c-aa6355bccb0e', 'Category', 'SortNo', '排序号', 'int', 'int', 'SortNo', 0, 0, 1, 1, 1, 1, 0, '', '', 'number', 70, '2021-09-27 00:26:55', '00000000-0000-0000-0000-000000000000', '2021-09-27 00:42:51', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('6383b218-2658-4981-9f62-4690f398c1f2', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'Price', '含税单价', 'decimal', 'decimal', 'Price', 0, 0, 0, 1, 1, 1, 0, '', '', 'decimal', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:49:05', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('67137a1d-f572-40ed-8c67-7fd570b63f42', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'UpdateUserName', '最后更新人', 'varchar', 'string', 'UpdateUserName', 0, 0, 0, 0, 0, 1, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:52:05', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 200, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('67a497dd-19b5-44d6-9804-6b8c0769cef0', '03761b53-e229-4e0e-b7b1-2831bdc84384', 'Stock', 'Viewable', '可见范围', 'varchar', 'string', 'Viewable', 0, 0, 1, 1, 1, 1, 0, '', '', '', 1, '2020-09-29 00:52:58', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:30:25', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('6bd63965-6353-47f8-bf46-eaa507457669', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'OrderType', '入库类型', 'varchar', 'string', 'OrderType', 0, 0, 1, 1, 1, 1, 0, '', '', 'select', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:45:23', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, 'SYS_INBOUNDTYPE');
INSERT INTO "public"."buildertablecolumn" VALUES ('6cb07125-18fd-4268-adcc-e23ca1144ba5', 'fc52b31a-fc29-42b6-b53c-99463644fff2', 'dataprivilegerule', 'PrivilegeRules', '权限规则', 'varchar', 'string', 'PrivilegeRules', 0, 0, 1, 1, 1, 1, 0, '', '', '', 0, '2021-09-23 22:35:02', '00000000-0000-0000-0000-000000000000', '2021-09-23 22:35:02', '', NULL, NULL, '', '超级管理员', 1000, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('6e6c331c-31ff-40cf-bddc-f331f936c982', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'Name', '名称', 'varchar', 'string', 'Name', 0, 0, 1, 1, 1, 1, 0, '', '', '', 95, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-29 00:58:42', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 255, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('6ec4c6b1-7a5f-4000-bf69-a2511b0febb2', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'ExternalType', '相关单据类型', 'varchar', 'string', 'ExternalType', 0, 0, 0, 0, 0, 0, 0, '', '', 'select', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 01:13:21', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, 'SYS_ORDERTYPE');
INSERT INTO "public"."buildertablecolumn" VALUES ('6f59479c-9795-4df2-bd33-8f659f6b659d', 'fc52b31a-fc29-42b6-b53c-99463644fff2', 'dataprivilegerule', 'CreateUserId', '创建人ID', 'varchar', 'string', 'CreateUserId', 0, 0, 1, 1, 0, 0, 0, '', '', '', 0, '2021-09-23 22:35:02', '00000000-0000-0000-0000-000000000000', '2021-09-23 22:38:44', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('7000e82f-da5d-4d5e-ac4b-eda825ae40c7', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'GoodsType', '商品类别', 'varchar', 'string', 'GoodsType', 0, 0, 0, 1, 1, 1, 0, '', '', 'select', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 01:10:28', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, 'SYS_GOODSTYPE');
INSERT INTO "public"."buildertablecolumn" VALUES ('73759b1d-df4a-4c88-879e-503196604f67', '03761b53-e229-4e0e-b7b1-2831bdc84384', 'Stock', 'Time', '操作时间', 'datetime', 'DateTime', 'Time', 0, 0, 1, 1, 0, 1, 0, '', '', 'date', 5, '2020-09-29 00:52:58', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:30:19', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('7bc33f75-16dc-49b7-822d-32be5aae904b', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'OrderNum', '通知数量', 'decimal', 'decimal', 'OrderNum', 0, 0, 1, 1, 1, 1, 0, '', '', 'number', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:48:58', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('7edebf71-aa41-4bac-bff3-eaa3c3159b40', 'fc52b31a-fc29-42b6-b53c-99463644fff2', 'dataprivilegerule', 'SourceCode', '资源标识（模块编号）', 'varchar', 'string', 'SourceCode', 0, 0, 1, 1, 1, 1, 0, '', '', '', 0, '2021-09-23 22:35:02', '00000000-0000-0000-0000-000000000000', '2021-09-23 22:35:02', '', NULL, NULL, '', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('85ebb3a8-1a19-44f8-9706-acac1c8bdc44', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'AsnStatus', '到货状况', 'int', 'int', 'AsnStatus', 0, 0, 1, 1, 1, 1, 0, '', '', 'select', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:47:30', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, 'SYS_STATUS');
INSERT INTO "public"."buildertablecolumn" VALUES ('861ca9ab-e81e-4fa8-8b56-375127a8cb59', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'LeaveNum', '剩余数量', 'decimal', 'decimal', 'LeaveNum', 0, 0, 1, 1, 1, 1, 0, '', '', 'number', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:48:44', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('87d68d3a-22b1-475c-a20a-d39724ca7639', 'fc52b31a-fc29-42b6-b53c-99463644fff2', 'dataprivilegerule', 'CreateUserName', '创建人', 'varchar', 'string', 'CreateUserName', 0, 0, 1, 1, 0, 0, 0, '', '', '', 0, '2021-09-23 22:35:02', '00000000-0000-0000-0000-000000000000', '2021-09-23 22:38:48', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 200, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('8a43f4d1-73a7-408d-b3cc-02be321b8ef9', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'OwnerId', '货主编号', 'varchar', 'string', 'OwnerId', 0, 0, 0, 1, 1, 1, 0, '', '', 'text', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:45:33', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('8c0836e9-6da1-4510-a59b-ccc94f4c2c14', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'GoodsId', '商品编号', 'varchar', 'string', 'GoodsId', 0, 0, 1, 1, 1, 1, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-11 22:54:21', '', NULL, NULL, '', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('8d0326c3-fcbc-4b37-8c8b-20421daf6b34', 'fc52b31a-fc29-42b6-b53c-99463644fff2', 'dataprivilegerule', 'Description', '权限描述', 'varchar', 'string', 'Description', 0, 0, 1, 1, 1, 1, 0, '', '', '', 0, '2021-09-23 22:35:02', '00000000-0000-0000-0000-000000000000', '2021-09-23 22:35:02', '', NULL, NULL, '', '超级管理员', 255, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('8effdc32-477a-44a4-a0e6-3e58c5631307', '03761b53-e229-4e0e-b7b1-2831bdc84384', 'Stock', 'Price', '产品单价', 'decimal', 'decimal', 'Price', 0, 0, 1, 1, 1, 1, 0, '', '', 'text', 10, '2020-09-29 00:52:58', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:31:44', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('8f161c08-1880-4b9f-95d6-88abb78a573b', 'fc52b31a-fc29-42b6-b53c-99463644fff2', 'dataprivilegerule', 'SubSourceCode', '二级资源标识', 'varchar', 'string', 'SubSourceCode', 0, 0, 0, 1, 0, 0, 0, '', '', '', 0, '2021-09-23 22:35:02', '00000000-0000-0000-0000-000000000000', '2021-09-26 00:28:18', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('94d03bc7-832c-4dbe-9df1-84e8ec6f1707', '1751d517-6d2b-4638-8f5c-aa6355bccb0e', 'Category', 'Description', '描述', 'varchar', 'string', 'Description', 0, 0, 0, 1, 0, 0, 0, '', '', '', 55, '2021-09-27 00:26:55', '00000000-0000-0000-0000-000000000000', '2021-09-27 00:45:53', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 500, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('95b6e356-3687-4001-9ffb-1271c3baf31e', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'Id', '标识', 'varchar', 'string', 'Id', 1, 0, 1, 1, 1, 1, 0, '', '', 'text', 99, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:52:12', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('96083a87-d21b-4b25-98c6-780156d68b08', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'ParentName', '父节点名称', 'varchar', 'string', 'ParentName', 0, 0, 0, 1, 0, 1, 0, '', '', '', 0, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:50:16', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('9864568d-9816-47e6-ae35-992a3b10bae2', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'ReturnBoxNum', '销退箱数', 'decimal', 'decimal', 'ReturnBoxNum', 0, 0, 1, 1, 1, 1, 0, '', '', 'number', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:44:24', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('9b140a3f-4d00-4a94-80d4-c7fac7be15cb', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'UpdateUserId', '最后更新人ID', 'varchar', 'string', 'UpdateUserId', 0, 0, 0, 1, 0, 0, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 01:49:42', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('9cdf9bd0-a017-49d3-8724-843fe98c2c41', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'CascadeId', '节点语义ID', 'varchar', 'string', 'CascadeId', 0, 0, 1, 1, 0, 1, 0, '', '', 'text', 0, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:36:14', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 255, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('9ce375d3-6087-467d-8b59-7f45ac0b68a6', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'UpdateUserId', '最后更新人ID', 'varchar', 'string', 'UpdateUserId', 0, 0, 0, 0, 0, 0, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:52:05', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('9f689acf-84ac-4840-b1c7-39bb82ba47a9', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'Remark', '备注', 'varchar', 'string', 'Remark', 0, 0, 0, 1, 1, 0, 0, '', '', 'textarea', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:44:30', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 256, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('a131adb2-9410-40ed-879e-b42af5d29c8c', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'Enable', '有效标志', 'tinyint', 'bool', 'Enable', 0, 0, 1, 1, 1, 1, 0, '', '', 'switch', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:46:03', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('a32c75ea-4095-458a-97b6-815db63d951e', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'TransferType', '承运方式', 'varchar', 'string', 'TransferType', 0, 0, 0, 1, 1, 1, 0, '', '', 'select', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 01:17:20', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, 'SYS_SHIPTYPE');
INSERT INTO "public"."buildertablecolumn" VALUES ('a33882d0-89f1-4d21-b740-051b1742e33c', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'QualityFlg', '品质', 'varchar', 'string', 'QualityFlg', 0, 0, 1, 1, 1, 1, 0, '', '', 'select', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:51:39', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, 'SYS_GOODSTYPE');
INSERT INTO "public"."buildertablecolumn" VALUES ('a5f9c89e-474f-4047-9e18-a8a31050a952', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'SupplierId', '供应商编号', 'varchar', 'string', 'SupplierId', 0, 0, 0, 1, 0, 0, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 01:13:11', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('a6e98eac-afd5-4465-9b60-206cfdeab9e1', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'CreateUserId', '创建人ID', 'varchar', 'string', 'CreateUserId', 0, 0, 1, 1, 0, 0, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 01:09:56', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('a76d32c3-312e-41ba-af71-bee893648a56', '1751d517-6d2b-4638-8f5c-aa6355bccb0e', 'Category', 'UpdateUserName', '最后更新人', 'varchar', 'string', 'UpdateUserName', 0, 0, 0, 1, 0, 0, 0, '', '', '', 0, '2021-09-27 00:26:55', '00000000-0000-0000-0000-000000000000', '2021-09-27 00:40:33', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 200, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('a79e8649-e2d9-4b51-a169-8c7f20472498', '1751d517-6d2b-4638-8f5c-aa6355bccb0e', 'Category', 'Name', '分类名称或描述', 'varchar', 'string', 'Name', 0, 0, 1, 1, 1, 1, 0, '', '', '', 85, '2021-09-27 00:26:55', '00000000-0000-0000-0000-000000000000', '2021-09-27 00:42:46', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 255, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('a8249275-9be3-4a92-ae3e-fa135233ef76', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'InNum', '到货数量', 'decimal', 'decimal', 'InNum', 0, 0, 1, 1, 1, 1, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-11 22:54:21', '', NULL, NULL, '', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('acbae3d8-fb55-404b-8680-53cb02b02927', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'UpdateUserName', '最后更新人', 'varchar', 'string', 'UpdateUserName', 0, 0, 0, 1, 0, 0, 0, '', '', '', 0, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-29 00:56:36', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 200, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('b0898ec0-ff90-46a6-9129-bd67aad6a547', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'CreateTime', '创建时间', 'datetime', 'DateTime', 'CreateTime', 0, 0, 1, 1, 0, 1, 0, '', '', 'datetime', 0, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-29 00:28:32', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('b1d3a4ef-ca85-48af-abdb-ca8b02a67b5e', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'PriceNoTax', '无税单价', 'decimal', 'decimal', 'PriceNoTax', 0, 0, 0, 1, 1, 1, 0, '', '', 'decimal', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:49:09', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('b7f96e95-0adf-4dfe-a153-5048f778a518', '03761b53-e229-4e0e-b7b1-2831bdc84384', 'Stock', 'Number', '产品数量', 'int', 'int', 'Number', 0, 0, 1, 1, 1, 1, 0, '', '', 'number', 30, '2020-09-29 00:52:58', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:29:55', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('b8a74c6e-4ad9-44b2-9c66-a799f6c3feb6', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'CreateUserName', '创建人', 'varchar', 'string', 'CreateUserName', 0, 0, 1, 1, 0, 1, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 01:09:57', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 200, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('b98e4da3-32c0-48bd-b09a-e56b4521504d', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'TypeId', '分类ID', 'varchar', 'string', 'TypeId', 0, 0, 0, 1, 1, 0, 0, '', '', 'select', 0, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-29 00:32:40', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, 'APP_TYPE');
INSERT INTO "public"."buildertablecolumn" VALUES ('bcf8079e-f046-4fba-b98f-3f840c59edd3', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'CreateUserName', '创建人', 'varchar', 'string', 'CreateUserName', 0, 0, 0, 0, 0, 1, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:51:58', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 200, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('bd084fcd-b00b-41b1-85c4-ea856eda4bc1', '03761b53-e229-4e0e-b7b1-2831bdc84384', 'Stock', 'Id', '数据ID', 'varchar', 'string', 'Id', 1, 0, 1, 1, 0, 0, 0, '', '', '', 50, '2020-09-29 00:52:58', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:31:36', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('c084f056-fd43-4b47-8fea-d668d2aef488', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'PurchaseNo', '采购单号', 'varchar', 'string', 'PurchaseNo', 0, 0, 0, 1, 1, 1, 0, '', '', 'text', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:45:39', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 30, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('c7366b20-7fcf-4784-8a7f-57695c2745c0', '1751d517-6d2b-4638-8f5c-aa6355bccb0e', 'Category', 'Id', 'Id', 'varchar', 'string', 'Id', 1, 0, 1, 1, 1, 0, 0, '', '', '', 0, '2021-09-27 00:26:55', '00000000-0000-0000-0000-000000000000', '2021-09-27 00:40:19', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('c7b30d11-9a00-48ba-86ff-68e4b78fd8c2', '1751d517-6d2b-4638-8f5c-aa6355bccb0e', 'Category', 'TypeId', '分类ID', 'varchar', 'string', 'TypeId', 0, 0, 0, 1, 1, 1, 0, '', '', 'text', 80, '2021-09-27 00:26:55', '00000000-0000-0000-0000-000000000000', '2021-09-27 00:42:59', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('c7e16730-9af0-4290-9c4f-e37bb3a22aef', '1751d517-6d2b-4638-8f5c-aa6355bccb0e', 'Category', 'CreateUserId', '创建人ID', 'varchar', 'string', 'CreateUserId', 0, 0, 1, 1, 0, 0, 0, '', '', '', 0, '2021-09-27 00:26:55', '00000000-0000-0000-0000-000000000000', '2021-09-27 00:38:37', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('cac9af55-805e-4af8-8936-8a2ef0f886f5', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'InBondedArea', '是否保税', 'tinyint', 'bool', 'InBondedArea', 0, 0, 1, 1, 1, 1, 0, '', '', 'switch', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:45:12', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('d2366b5d-992f-4f68-b08d-ebd01962c55c', '03761b53-e229-4e0e-b7b1-2831bdc84384', 'Stock', 'User', '操作人', 'varchar', 'string', 'User', 0, 0, 1, 1, 0, 1, 0, '', '', '', 3, '2020-09-29 00:52:58', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:30:22', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('d73b377d-c6a3-4f74-b608-0e0223dbbd0a', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'CreateUserId', '创建人ID', 'varchar', 'string', 'CreateUserId', 0, 0, 1, 1, 0, 0, 0, '', '', '', 0, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-29 00:28:40', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('d8913d5b-c62f-4cb5-aedc-60b652a41427', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'UpdateUserName', '最后更新人', 'varchar', 'string', 'UpdateUserName', 0, 0, 0, 1, 0, 1, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 01:49:50', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 200, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('dfbb6dd4-d03a-452a-8f9e-b6747b585819', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'ExternalNo', '相关单据号', 'varchar', 'string', 'ExternalNo', 0, 0, 0, 0, 0, 0, 0, '', '', 'text', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:46:16', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('e075aeb7-82ba-4858-9551-d11ee7f61156', '1751d517-6d2b-4638-8f5c-aa6355bccb0e', 'Category', 'UpdateUserId', '最后更新人ID', 'varchar', 'string', 'UpdateUserId', 0, 0, 0, 1, 0, 0, 0, '', '', '', 0, '2021-09-27 00:26:55', '00000000-0000-0000-0000-000000000000', '2021-09-27 00:38:22', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('e7f071ca-2ba0-4a89-a988-424d1e9b0b8b', 'fc52b31a-fc29-42b6-b53c-99463644fff2', 'dataprivilegerule', 'Enable', '是否可用', 'tinyint', 'bool', 'Enable', 0, 0, 1, 1, 1, 1, 0, '', '', 'switch', 0, '2021-09-23 22:35:02', '00000000-0000-0000-0000-000000000000', '2021-09-23 22:38:54', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('ea35d6b5-aa14-495f-ba36-d51eb73125ac', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'ExpireDate', '失效日期', 'varchar', 'string', 'ExpireDate', 0, 0, 0, 1, 1, 1, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-11 22:54:21', '', NULL, NULL, '', '超级管理员', 30, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('ec8aac16-7f9c-4b19-977c-aecede234910', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'Status', '入库通知单状态', 'int', 'int', 'Status', 0, 0, 0, 0, 0, 0, 0, '', '', 'select', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 01:14:30', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, 'COMMON_STATUS');
INSERT INTO "public"."buildertablecolumn" VALUES ('ecab3cf5-312c-46a9-aa82-87c34396ea90', '7f0ca2fd-7fa0-4316-a466-22733d466dd2', 'wmsinboundordertbl', 'StockId', '仓库编号', 'varchar', 'string', 'StockId', 0, 0, 0, 0, 0, 0, 0, '', '', '', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 01:14:39', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 12, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('ee53d454-c8f9-48d3-9bc1-b4a1fdf6c390', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'InStockStatus', '是否收货中', 'tinyint', 'bool', 'InStockStatus', 0, 0, 1, 1, 1, 1, 0, '', 'switch', 'switch', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:48:30', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('f8392fe0-0591-4ca7-8ebe-c8f69a8a30f0', 'f07df6d0-eb47-4f00-9167-79d88bcace36', 'wmsinboundorderdtbl', 'ProdDate', '生产日期', 'varchar', 'string', 'ProdDate', 0, 0, 0, 1, 1, 1, 0, '', '', 'datetime', 0, '2021-08-11 22:54:21', '00000000-0000-0000-0000-000000000000', '2021-08-23 02:49:17', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 30, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('f8d7f45a-8754-46a1-8ce4-9a8992801f68', 'de4a5527-0d8c-4493-b668-39fc9c555df1', 'Resource', 'ParentId', '父节点ID', 'varchar', 'string', 'ParentId', 0, 0, 0, 1, 1, 0, 0, '', '', 'selectDynamic', 0, '2021-08-29 00:27:29', '00000000-0000-0000-0000-000000000000', '2021-08-30 00:51:13', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, '/Resources/Load');
INSERT INTO "public"."buildertablecolumn" VALUES ('fc13f50a-51ec-4bfc-82b6-ad1f4c71c297', '1751d517-6d2b-4638-8f5c-aa6355bccb0e', 'Category', 'Enable', '是否可用', 'tinyint', 'bool', 'Enable', 0, 0, 1, 1, 1, 1, 0, '', '', 'switch', 90, '2021-09-27 00:26:55', '00000000-0000-0000-0000-000000000000', '2021-09-27 00:42:13', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', NULL, NULL);
INSERT INTO "public"."buildertablecolumn" VALUES ('fd03c732-f369-4b79-a1be-dc16ee053cb4', 'fc52b31a-fc29-42b6-b53c-99463644fff2', 'dataprivilegerule', 'Id', '数据ID', 'varchar', 'string', 'Id', 1, 0, 1, 1, 1, 0, 0, '', '', '', 0, '2021-09-23 22:35:02', '00000000-0000-0000-0000-000000000000', '2021-09-23 22:39:05', '00000000-0000-0000-0000-000000000000', NULL, NULL, '超级管理员', '超级管理员', 50, NULL);

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS "public"."category";
CREATE TABLE "public"."category" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "dtcode" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "dtvalue" varchar(50) COLLATE "pg_catalog"."default",
  "enable" int2 NOT NULL,
  "sortno" int4 NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "typeid" varchar(50) COLLATE "pg_catalog"."default",
  "createtime" timestamp(6) NOT NULL,
  "createuserid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "createusername" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "updatetime" timestamp(6),
  "updateuserid" varchar(50) COLLATE "pg_catalog"."default",
  "updateusername" varchar(200) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."category"."name" IS '分类名称或描述';
COMMENT ON COLUMN "public"."category"."dtcode" IS '分类标识';
COMMENT ON COLUMN "public"."category"."dtvalue" IS '通常与分类标识一致，但万一有不一样的情况呢？';
COMMENT ON COLUMN "public"."category"."sortno" IS '排序号';
COMMENT ON COLUMN "public"."category"."createtime" IS '创建时间';
COMMENT ON COLUMN "public"."category"."createuserid" IS '创建人ID';
COMMENT ON COLUMN "public"."category"."createusername" IS '创建人';
COMMENT ON COLUMN "public"."category"."updatetime" IS '最后更新时间';
COMMENT ON COLUMN "public"."category"."updateuserid" IS '最后更新人ID';
COMMENT ON COLUMN "public"."category"."updateusername" IS '最后更新人';
COMMENT ON TABLE "public"."category" IS '分类表，也可用作数据字典。表示一个全集，比如：男、女、未知。关联的分类类型表示按什么进行的分类，如：按照性别对人类对象集';

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO "public"."category" VALUES ('01a2736c-cebe-43a2-8068-7e3f88fa7c23', '审核', 'SYS_ORDERSTATUS_CHECK', 'SYS_ORDERSTATUS_CHECK', 1, 0, '', 'SYS_ORDERSTATUS', '2019-10-29 21:20:40', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-10-29 21:20:40', '', '');
INSERT INTO "public"."category" VALUES ('07d21d6d-3bce-4b73-8273-c9f948f468fe', '释放', 'PICKSTATUS_RELEASE', 'PICKSTATUS_RELEASE', 1, 0, '', 'SYS_PICKSTATUS', '2019-10-29 21:29:35', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-10-29 21:29:35', '', '');
INSERT INTO "public"."category" VALUES ('08776116-d1bf-40d1-b7ff-78b7392f4aef', '自提', 'SYS_SHIPTYPE_NORMAL', 'SYS_SHIPTYPE_NORMAL', 1, 0, '', 'SYS_SHIPTYPE', '2019-11-07 01:19:12', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-07 01:19:12', '', '');
INSERT INTO "public"."category" VALUES ('1979955b-901d-4394-8a3c-f81c32970365', '中药材', 'SYS_GOODSTYPE_TCM', 'SYS_GOODSTYPE_TCM', 1, 0, '', 'SYS_GOODSTYPE', '2019-11-07 01:17:36', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-07 01:17:36', '', '');
INSERT INTO "public"."category" VALUES ('2615b6bf-7fc3-46e1-8105-708dda0e6c42', '发货完成', 'PICKSTATUS_OUTSTOCK', 'PICKSTATUS_OUTSTOCK', 1, 0, '', 'SYS_PICKSTATUS', '2019-10-29 21:32:02', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-10-29 21:32:02', '', '');
INSERT INTO "public"."category" VALUES ('354f50b7-0d93-43d6-a721-a4931c650ea3', '创建', 'SYS_ORDERSTATUS_CREATE', 'SYS_ORDERSTATUS_CREATE', 1, 0, '', 'SYS_ORDERSTATUS', '2019-10-29 21:20:02', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-10-29 21:20:02', '', '');
INSERT INTO "public"."category" VALUES ('43303bfb-11e3-4e12-8cdd-2ef090017e4c', '样品入库', 'SYS_INBOUNDTYPE_SAMPLE', 'SYS_INBOUNDTYPE_SAMPLE', 1, 0, '', 'SYS_INBOUNDTYPE', '2019-11-07 00:51:26', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-07 00:51:26', '', '');
INSERT INTO "public"."category" VALUES ('4de1cf0d-b1f5-44f7-a329-4b5fcff73ca6', '普药', 'SYS_GOODSTYPE_COMMON', 'SYS_GOODSTYPE_COMMON', 1, 0, '', 'SYS_GOODSTYPE', '2019-11-07 01:15:35', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-07 01:15:35', '', '');
INSERT INTO "public"."category" VALUES ('52f662c3-39bc-4f5a-9730-107cf26b12f0', '直送', 'SYS_SHIPTYPE_DIRECT', 'SYS_SHIPTYPE_DIRECT', 1, 0, '', 'SYS_SHIPTYPE', '2019-11-07 01:19:41', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-07 01:19:41', '', '');
INSERT INTO "public"."category" VALUES ('74f7bcc8-50a3-4c02-9a25-ee2fa4575e25', '集货完成', 'PICKSTATUS_STAGED', 'PICKSTATUS_STAGED', 1, 0, '', 'SYS_PICKSTATUS', '2019-10-29 21:31:11', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-10-29 21:31:11', '', '');
INSERT INTO "public"."category" VALUES ('77a7f565-cb5c-4876-a139-7901e54b5dde', '正常', 'SYS_STATUS_OK', '0', 0, 0, '', 'SYS_STATUS', '2019-11-06 10:38:46', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-06 10:38:46', '', '');
INSERT INTO "public"."category" VALUES ('7fbeb155-8fbb-44ce-a726-2a6fea7920d5', '异常', 'SYS_STATUS_ERROR', '1', 1, 0, '', 'SYS_STATUS', '2019-11-06 10:39:24', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-06 10:39:24', '', '');
INSERT INTO "public"."category" VALUES ('845ef9f2-4d33-4887-acf0-6d45fdf5e05c', 'EMS', 'SYS_SHIPTYPE_EMS', 'SYS_SHIPTYPE_EMS', 1, 0, '', 'SYS_SHIPTYPE', '2019-11-07 01:20:45', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-07 01:20:45', '', '');
INSERT INTO "public"."category" VALUES ('8641c594-e43e-4469-a5b5-5da06a53eaf9', '打包完成', 'PICKSTATUS_PACK', 'PICKSTATUS_PACK', 1, 0, '', 'SYS_PICKSTATUS', '2019-10-29 21:31:50', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-10-29 21:31:50', '', '');
INSERT INTO "public"."category" VALUES ('86b8d963-63b6-4936-87b1-af248cd26c44', '已完成', 'SYS_ORDERSTATUS_FINISHED', 'SYS_ORDERSTATUS_FINISHED', 1, 0, '', 'SYS_ORDERSTATUS', '2019-10-29 21:27:32', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-10-29 21:27:32', '', '');
INSERT INTO "public"."category" VALUES ('8dcbc59a-c045-4e06-ad13-095cfe9a3209', '销退入库', 'SYS_INBOUNDTYPE_RETURN', 'SYS_INBOUNDTYPE_RETURN', 1, 0, '', 'SYS_INBOUNDTYPE', '2019-11-07 00:52:04', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-07 00:52:04', '', '');
INSERT INTO "public"."category" VALUES ('9bddbcfd-f41e-429f-b112-76db0c1bf0f3', '复核完成', 'PICKSTATUS_CHECKED', 'PICKSTATUS_CHECKED', 1, 0, '', 'SYS_PICKSTATUS', '2019-10-29 21:30:37', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-10-29 21:30:37', '', '');
INSERT INTO "public"."category" VALUES ('a4017f4d-c113-4ec9-bdcb-d9c49019a916', '生物制品', 'SYS_GOODSTYPE_BIOLPROD', 'SYS_GOODSTYPE_BIOLPROD', 1, 0, '', 'SYS_GOODSTYPE', '2019-11-07 01:16:59', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-07 01:16:59', '', '');
INSERT INTO "public"."category" VALUES ('b1d4301b-2378-4598-9b96-8592afbb64d1', '缓存完成', 'PICKSTATUS_CACHE', 'PICKSTATUS_CACHE', 1, 0, '', 'SYS_PICKSTATUS', '2019-10-29 21:30:53', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-10-29 21:30:53', '', '');
INSERT INTO "public"."category" VALUES ('b44bb9f4-166c-4c59-a693-baacd01d2db4', '4+7集中采购', 'SYS_SHIPTYPE_FREIGHT', 'SYS_SHIPTYPE_FREIGHT', 1, 0, '', 'SYS_SHIPTYPE', '2019-11-07 01:20:21', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-07 01:20:21', '', '');
INSERT INTO "public"."category" VALUES ('b77f4a7d-0d22-47dd-97d1-7f8ccd9e5f77', '采购入库', 'SYS_INBOUNDTYPE_PURCHASE', 'SYS_INBOUNDTYPE_PURCHASE', 1, 0, '', 'SYS_INBOUNDTYPE', '2019-11-07 00:50:51', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-07 00:50:51', '', '');
INSERT INTO "public"."category" VALUES ('c3ce85b1-0115-47d4-b562-1bbcc51105e2', '食品', 'SYS_GOODSTYPE_FOOD', 'SYS_GOODSTYPE_FOOD', 1, 0, '', 'SYS_GOODSTYPE', '2019-11-07 01:17:58', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-07 01:17:58', '', '');
INSERT INTO "public"."category" VALUES ('d2dd6a7f-797e-4ff2-96cc-56bf9fbfc24b', '装车完成', 'PICKSTATUS_CAR', 'PICKSTATUS_CAR', 1, 0, '', 'SYS_PICKSTATUS', '2019-10-29 21:31:27', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-10-29 21:31:27', '', '');
INSERT INTO "public"."category" VALUES ('d8152952-cf55-40ba-af81-0d4863247d6a', '拣选完成', 'PICKSTATUS_PICKFINISH', 'PICKSTATUS_PICKFINISH', 1, 0, '', 'SYS_PICKSTATUS', '2019-10-29 21:30:16', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-10-29 21:30:16', '', '');
INSERT INTO "public"."category" VALUES ('de4ccb7b-19e4-4203-a092-b2d8bafe3131', '拣选执行中', 'PICKSTATUS_PICKEXECUTE', 'PICKSTATUS_PICKEXECUTE', 1, 0, '', 'SYS_PICKSTATUS', '2019-10-29 21:29:55', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-10-29 21:29:55', '', '');
INSERT INTO "public"."category" VALUES ('e6292744-a6e8-4a6f-b077-14bd35e31a27', '创建', 'PICKSTATUS_CREATE', 'PICKSTATUS_CREATE', 1, 0, '', 'SYS_PICKSTATUS', '2019-10-29 21:29:18', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-10-29 21:29:18', '', '');
INSERT INTO "public"."category" VALUES ('faef67e8-48e4-44e5-981c-eebb78d79a0f', '已处理', 'SYS_ORDERSTATUS_DISPOSED', 'SYS_ORDERSTATUS_DISPOSED', 1, 0, '', 'SYS_ORDERSTATUS', '2019-10-29 21:27:05', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-10-29 21:27:05', '', '');
INSERT INTO "public"."category" VALUES ('fe1f7181-d3d0-4b0e-b9b3-5d05b503ff0e', '医疗器械', 'SYS_GOODSTYPE_MEDINSTR', 'SYS_GOODSTYPE_MEDINSTR', 1, 0, '', 'SYS_GOODSTYPE', '2019-11-07 01:16:02', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-07 01:16:02', '', '');

-- ----------------------------
-- Table structure for categorytype
-- ----------------------------
DROP TABLE IF EXISTS "public"."categorytype";
CREATE TABLE "public"."categorytype" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createtime" timestamp(6) NOT NULL
)
;
COMMENT ON COLUMN "public"."categorytype"."id" IS '分类表ID';
COMMENT ON COLUMN "public"."categorytype"."name" IS '名称';
COMMENT ON COLUMN "public"."categorytype"."createtime" IS '创建时间';
COMMENT ON TABLE "public"."categorytype" IS '分类类型';

-- ----------------------------
-- Records of categorytype
-- ----------------------------
INSERT INTO "public"."categorytype" VALUES ('SYS_CUSTTYPE', '客户类型', '2019-11-07 00:49:50');
INSERT INTO "public"."categorytype" VALUES ('SYS_GOODSTYPE', '商品类别', '2019-11-07 00:48:47');
INSERT INTO "public"."categorytype" VALUES ('SYS_INBOUNDTYPE', '入库类型', '2019-11-07 00:48:08');
INSERT INTO "public"."categorytype" VALUES ('SYS_ORDERSTATUS', '订单状态', '2019-10-29 21:18:56');
INSERT INTO "public"."categorytype" VALUES ('SYS_ORDERTYPE', '订单类型', '2019-10-29 21:18:32');
INSERT INTO "public"."categorytype" VALUES ('SYS_PICKSTATUS', '拣选任务状态', '2019-10-29 21:28:50');
INSERT INTO "public"."categorytype" VALUES ('SYS_SHIPTYPE', '承运方式', '2019-11-07 00:47:36');
INSERT INTO "public"."categorytype" VALUES ('SYS_STATUS', '系统状态', '2019-11-06 10:38:17');
INSERT INTO "public"."categorytype" VALUES ('USERTYPE', '按用户类型分类', '2017-11-29 21:27:42');

-- ----------------------------
-- Table structure for dataprivilegerule
-- ----------------------------
DROP TABLE IF EXISTS "public"."dataprivilegerule";
CREATE TABLE "public"."dataprivilegerule" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "sourcecode" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "subsourcecode" varchar(50) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "sortno" int4 NOT NULL,
  "privilegerules" text COLLATE "pg_catalog"."default" NOT NULL,
  "enable" int2 NOT NULL,
  "createtime" timestamp(6) NOT NULL,
  "createuserid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "createusername" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "updatetime" timestamp(6),
  "updateuserid" varchar(50) COLLATE "pg_catalog"."default",
  "updateusername" varchar(200) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."dataprivilegerule"."id" IS '数据ID';
COMMENT ON COLUMN "public"."dataprivilegerule"."sourcecode" IS '资源标识（模块编号）';
COMMENT ON COLUMN "public"."dataprivilegerule"."subsourcecode" IS '二级资源标识';
COMMENT ON COLUMN "public"."dataprivilegerule"."description" IS '权限描述';
COMMENT ON COLUMN "public"."dataprivilegerule"."sortno" IS '排序号';
COMMENT ON COLUMN "public"."dataprivilegerule"."privilegerules" IS '权限规则';
COMMENT ON COLUMN "public"."dataprivilegerule"."enable" IS '是否可用';
COMMENT ON COLUMN "public"."dataprivilegerule"."createtime" IS '创建时间';
COMMENT ON COLUMN "public"."dataprivilegerule"."createuserid" IS '创建人ID';
COMMENT ON COLUMN "public"."dataprivilegerule"."createusername" IS '创建人';
COMMENT ON COLUMN "public"."dataprivilegerule"."updatetime" IS '最后更新时间';
COMMENT ON COLUMN "public"."dataprivilegerule"."updateuserid" IS '最后更新人ID';
COMMENT ON COLUMN "public"."dataprivilegerule"."updateusername" IS '最后更新人';
COMMENT ON TABLE "public"."dataprivilegerule" IS '系统授权规制表';

-- ----------------------------
-- Records of dataprivilegerule
-- ----------------------------
INSERT INTO "public"."dataprivilegerule" VALUES ('5098523e-f038-4bc8-850f-9629cac3e4f6', 'Form', '', '只能看到用户自己对应部门的表单,System可以看到所有', 0, '{"Operation":"or","Filters":[{"Key":"OrgId","Value":"{loginOrg}","Contrast":"in","names":"","Text":""}]}', 1, '2020-03-18 23:36:05', '00000000-0000-0000-0000-000000000000', '', '2020-03-19 21:14:34', '00000000-0000-0000-0000-000000000000', '');
INSERT INTO "public"."dataprivilegerule" VALUES ('6a96c5d9-a226-459d-a4e1-aefcbefc6915', 'WmsInboundOrderTbl', '', '【管理员】角色可以看所有人的订单，【测试】只能看自己创建的订单', 0, '{"Operation":"or","Filters":[{"Key":"{loginRole}","Value":"09ee2ffa-7463-4938-ae0b-1cb4e80c7c13,77e6d0c3-f9e1-4933-92c3-c1c6eef75593","Contrast":"contains","names":"","Text":"管理员,神"}],"Children":[{"Operation":"and","Filters":[{"Key":"{loginRole}","Value":"0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d","Contrast":"contains","Text":"测试"},{"Key":"CreateUserId","Value":"{loginUser}","Contrast":"==","Text":""}]}]}', 1, '2019-11-23 01:02:32', '00000000-0000-0000-0000-000000000000', '', '2019-11-23 01:02:32', '', '');
INSERT INTO "public"."dataprivilegerule" VALUES ('ab177ea0-89f3-429e-8f0f-7a00819d8ef3', 'FlowScheme', '', 'System可以看到所有流程设计，【管理员】可以看到部门的，其他人只能看到自己的', 0, '{"Operation":"or","Filters":[{"Key":"CreateUserId","Value":"{loginUser}","Contrast":"==","Text":""}],"Children":[{"Operation":"and","Filters":[{"Key":"OrgId","Value":"{loginOrg}","Contrast":"in","Text":""},{"Key":"{loginRole}","Value":"09ee2ffa-7463-4938-ae0b-1cb4e80c7c13","Contrast":"contains","Text":"管理员"}]}]}', 1, '2020-03-19 21:17:30', '00000000-0000-0000-0000-000000000000', '', '2020-03-19 21:57:47', '00000000-0000-0000-0000-000000000000', '');
INSERT INTO "public"."dataprivilegerule" VALUES ('e7c95fb1-91f7-422e-a11a-73cea0c404b9', 'Resource', NULL, '【管理员】角色可以看所有人的资源，【测试】只能看自己创建的资源，账号test3/test4只能看属于（XXX管理平台）的资源', 0, '{"Operation":"or","Filters":[{"Key":"{loginRole}","Value":"09ee2ffa-7463-4938-ae0b-1cb4e80c7c13","Contrast":"contains","Text":"管理员"}],"Children":[{"Operation":"and","Filters":[{"Key":"{loginRole}","Value":"0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d","Contrast":"contains","Text":"测试"},{"Key":"CreateUserId","Value":"{loginUser}","Contrast":"==","Text":""}]},{"Operation":"and","Filters":[{"Key":"AppName","Value":"XXX管理平台","Contrast":"==","Text":""},{"Key":"{loginUser}","Value":"229f3a49-ab27-49ce-b383-9f10ca23a9d5,1df68dfd-3b6d-4491-872f-00a0fc6c5a64","Contrast":"in","Text":"test3,test4"}]}]}', 1, '2019-10-29 11:05:02', '00000000-0000-0000-0000-000000000000', '', '2019-11-23 01:00:19', '00000000-0000-0000-0000-000000000000', '');

-- ----------------------------
-- Table structure for externaldatasource
-- ----------------------------
DROP TABLE IF EXISTS "public"."externaldatasource";
CREATE TABLE "public"."externaldatasource" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "dbtype" int4 NOT NULL,
  "connectionstring" varchar(500) COLLATE "pg_catalog"."default" NOT NULL,
  "server" varchar(100) COLLATE "pg_catalog"."default",
  "port" int4,
  "databasename" varchar(100) COLLATE "pg_catalog"."default",
  "username" varchar(50) COLLATE "pg_catalog"."default",
  "password" varchar(100) COLLATE "pg_catalog"."default",
  "enabled" int2 NOT NULL,
  "createtime" timestamp(6) NOT NULL,
  "updatetime" timestamp(6),
  "testsuccess" int2,
  "description" varchar(200) COLLATE "pg_catalog"."default",
  "createuserid" varchar(50) COLLATE "pg_catalog"."default",
  "createusername" varchar(50) COLLATE "pg_catalog"."default",
  "updateuserid" varchar(50) COLLATE "pg_catalog"."default",
  "updateusername" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."externaldatasource"."id" IS '主键';
COMMENT ON COLUMN "public"."externaldatasource"."name" IS '数据源名称';
COMMENT ON COLUMN "public"."externaldatasource"."dbtype" IS '数据库类型';
COMMENT ON COLUMN "public"."externaldatasource"."connectionstring" IS '连接字符串';
COMMENT ON COLUMN "public"."externaldatasource"."server" IS '服务器地址';
COMMENT ON COLUMN "public"."externaldatasource"."port" IS '端口';
COMMENT ON COLUMN "public"."externaldatasource"."databasename" IS '数据库名称';
COMMENT ON COLUMN "public"."externaldatasource"."username" IS '用户名';
COMMENT ON COLUMN "public"."externaldatasource"."password" IS '密码';
COMMENT ON COLUMN "public"."externaldatasource"."enabled" IS '是否启用';
COMMENT ON COLUMN "public"."externaldatasource"."createtime" IS '创建时间';
COMMENT ON COLUMN "public"."externaldatasource"."updatetime" IS '最后测试时间';
COMMENT ON COLUMN "public"."externaldatasource"."testsuccess" IS '是否测试成功';
COMMENT ON COLUMN "public"."externaldatasource"."description" IS '描述';
COMMENT ON COLUMN "public"."externaldatasource"."createuserid" IS '创建用户ID';
COMMENT ON COLUMN "public"."externaldatasource"."createusername" IS '创建用户名';
COMMENT ON COLUMN "public"."externaldatasource"."updateuserid" IS '更新用户ID';
COMMENT ON COLUMN "public"."externaldatasource"."updateusername" IS '更新用户名';
COMMENT ON TABLE "public"."externaldatasource" IS '外部数据源管理';

-- ----------------------------
-- Records of externaldatasource
-- ----------------------------

-- ----------------------------
-- Table structure for flowapprover
-- ----------------------------
DROP TABLE IF EXISTS "public"."flowapprover";
CREATE TABLE "public"."flowapprover" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "instanceid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "activityid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "reason" varchar(200) COLLATE "pg_catalog"."default",
  "createdate" timestamp(6),
  "createuserid" varchar(50) COLLATE "pg_catalog"."default",
  "createusername" varchar(50) COLLATE "pg_catalog"."default",
  "status" int4 NOT NULL,
  "approvetype" int4 NOT NULL,
  "approverid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "approvername" varchar(50) COLLATE "pg_catalog"."default",
  "orderno" int4,
  "verifydate" timestamp(6),
  "verifycomment" varchar(200) COLLATE "pg_catalog"."default",
  "cascadeid" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "parentid" varchar(50) COLLATE "pg_catalog"."default",
  "parentname" varchar(100) COLLATE "pg_catalog"."default",
  "returntosignnode" int2 NOT NULL,
  "name" varchar(100) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."flowapprover"."id" IS 'Id';
COMMENT ON COLUMN "public"."flowapprover"."instanceid" IS '工作流实例Id';
COMMENT ON COLUMN "public"."flowapprover"."activityid" IS '当前节点ID';
COMMENT ON COLUMN "public"."flowapprover"."reason" IS '加签原因';
COMMENT ON COLUMN "public"."flowapprover"."createdate" IS '加签时间';
COMMENT ON COLUMN "public"."flowapprover"."createuserid" IS '加签人Id';
COMMENT ON COLUMN "public"."flowapprover"."createusername" IS '加签人';
COMMENT ON COLUMN "public"."flowapprover"."status" IS '状态（0未处理，1通过，2未通过，3驳回）';
COMMENT ON COLUMN "public"."flowapprover"."approvetype" IS '类型（0顺序，1并行且，2并行或）';
COMMENT ON COLUMN "public"."flowapprover"."approverid" IS '审批人ID';
COMMENT ON COLUMN "public"."flowapprover"."approvername" IS '审批人';
COMMENT ON COLUMN "public"."flowapprover"."orderno" IS '顺序号（当类型为0时）';
COMMENT ON COLUMN "public"."flowapprover"."verifydate" IS '审批日期';
COMMENT ON COLUMN "public"."flowapprover"."verifycomment" IS '审批意见';
COMMENT ON COLUMN "public"."flowapprover"."cascadeid" IS '层级ID，应对多次加签';
COMMENT ON COLUMN "public"."flowapprover"."parentid" IS '父节点ID，应对多次加签';
COMMENT ON COLUMN "public"."flowapprover"."parentname" IS '父节点名称，应对多次加签结构';
COMMENT ON COLUMN "public"."flowapprover"."returntosignnode" IS '是否回到加签节点';
COMMENT ON COLUMN "public"."flowapprover"."name" IS '加签节点名称，应对多次加签结构';
COMMENT ON TABLE "public"."flowapprover" IS '工作流加签';

-- ----------------------------
-- Records of flowapprover
-- ----------------------------

-- ----------------------------
-- Table structure for flowinstance
-- ----------------------------
DROP TABLE IF EXISTS "public"."flowinstance";
CREATE TABLE "public"."flowinstance" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "instanceschemeid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "code" varchar(200) COLLATE "pg_catalog"."default",
  "customname" varchar(200) COLLATE "pg_catalog"."default",
  "activityid" varchar(50) COLLATE "pg_catalog"."default",
  "activitytype" int4,
  "activityname" varchar(200) COLLATE "pg_catalog"."default",
  "previousid" varchar(50) COLLATE "pg_catalog"."default",
  "schemecontent" text COLLATE "pg_catalog"."default",
  "schemeid" varchar(50) COLLATE "pg_catalog"."default",
  "dbname" varchar(50) COLLATE "pg_catalog"."default",
  "frmdata" text COLLATE "pg_catalog"."default",
  "frmtype" int4 NOT NULL,
  "frmcontentdata" text COLLATE "pg_catalog"."default",
  "frmcontentparse" text COLLATE "pg_catalog"."default",
  "frmid" varchar(50) COLLATE "pg_catalog"."default",
  "schemetype" varchar(50) COLLATE "pg_catalog"."default",
  "disabled" int4 NOT NULL,
  "createdate" timestamp(6) NOT NULL,
  "createuserid" varchar(50) COLLATE "pg_catalog"."default",
  "createusername" varchar(50) COLLATE "pg_catalog"."default",
  "flowlevel" int4 NOT NULL,
  "description" varchar(200) COLLATE "pg_catalog"."default",
  "isfinish" int4 NOT NULL,
  "makerlist" text COLLATE "pg_catalog"."default",
  "orgid" varchar(50) COLLATE "pg_catalog"."default",
  "businessid" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."flowinstance"."id" IS '主键Id';
COMMENT ON COLUMN "public"."flowinstance"."instanceschemeid" IS '流程实例模板Id';
COMMENT ON COLUMN "public"."flowinstance"."code" IS '实例编号';
COMMENT ON COLUMN "public"."flowinstance"."customname" IS '自定义名称';
COMMENT ON COLUMN "public"."flowinstance"."activityid" IS '当前节点ID';
COMMENT ON COLUMN "public"."flowinstance"."activitytype" IS '当前节点类型（0会签节点）';
COMMENT ON COLUMN "public"."flowinstance"."activityname" IS '当前节点名称';
COMMENT ON COLUMN "public"."flowinstance"."previousid" IS '前一个ID';
COMMENT ON COLUMN "public"."flowinstance"."schemecontent" IS '流程模板内容';
COMMENT ON COLUMN "public"."flowinstance"."schemeid" IS '流程模板ID';
COMMENT ON COLUMN "public"."flowinstance"."dbname" IS '数据库名称';
COMMENT ON COLUMN "public"."flowinstance"."frmdata" IS '表单数据';
COMMENT ON COLUMN "public"."flowinstance"."frmtype" IS '表单类型';
COMMENT ON COLUMN "public"."flowinstance"."frmcontentdata" IS '表单中的控件属性描述';
COMMENT ON COLUMN "public"."flowinstance"."frmcontentparse" IS '表单控件位置模板';
COMMENT ON COLUMN "public"."flowinstance"."frmid" IS '表单ID';
COMMENT ON COLUMN "public"."flowinstance"."schemetype" IS '流程类型';
COMMENT ON COLUMN "public"."flowinstance"."disabled" IS '有效标志';
COMMENT ON COLUMN "public"."flowinstance"."createdate" IS '创建时间';
COMMENT ON COLUMN "public"."flowinstance"."createuserid" IS '创建用户主键';
COMMENT ON COLUMN "public"."flowinstance"."createusername" IS '创建用户';
COMMENT ON COLUMN "public"."flowinstance"."flowlevel" IS '等级';
COMMENT ON COLUMN "public"."flowinstance"."description" IS '实例备注';
COMMENT ON COLUMN "public"."flowinstance"."isfinish" IS '是否完成';
COMMENT ON COLUMN "public"."flowinstance"."makerlist" IS '执行人';
COMMENT ON COLUMN "public"."flowinstance"."orgid" IS '所属部门';
COMMENT ON COLUMN "public"."flowinstance"."businessid" IS '业务单据Id';
COMMENT ON TABLE "public"."flowinstance" IS '工作流流程实例表';

-- ----------------------------
-- Records of flowinstance
-- ----------------------------
INSERT INTO "public"."flowinstance" VALUES ('05e8c579-5d59-4f71-bb3f-7688ac834729', '', '1744355525193', '简单的请假', '1564334153687', 2, '所有人可以审批', '1564334138399', '{"title":"newFlow_1","nodes":[{"name":"node_1","left":44,"top":27,"type":"start","id":"1564334138399","width":26,"height":26,"alt":true},{"name":"node_2","left":50,"top":295,"type":"end","id":"1564334139783","width":26,"height":26,"alt":true},{"name":"所有人可以审批","left":163,"top":43,"type":"node","id":"1564334153687","width":104,"height":56,"alt":true,"setInfo":{"NodeConfluenceType":"all","NodeDesignate":"ALL_USER","ThirdPartyUrl":"","NodeDesignateData":{"users":[],"roles":[]}}},{"name":"小于3的test可以审批","left":23,"top":141,"type":"node","id":"1564334154471","width":167,"height":76,"alt":true,"setInfo":{"NodeConfluenceType":"all","NodeDesignate":"SPECIAL_USER","ThirdPartyUrl":"","NodeDesignateData":{"users":["6ba79766-faa0-4259-8139-a4a6d35784e0"],"roles":[]}}},{"name":"大于3的admin可以审批","left":288,"top":146,"type":"node","id":"1564334155295","width":143,"height":56,"alt":true,"setInfo":{"NodeConfluenceType":"all","NodeDesignate":"SPECIAL_USER","ThirdPartyUrl":"","NodeDesignateData":{"users":["49df1602-f5f3-4d52-afb7-3802da619558"],"roles":[]}}},{"name":"默认","left":171,"top":291,"type":"node","id":"1564334156607","width":104,"height":36,"alt":true,"setInfo":{"NodeConfluenceType":"all","NodeDesignate":"ALL_USER","ThirdPartyUrl":"","NodeDesignateData":{"users":[],"roles":[]}}}],"lines":[{"type":"sl","from":"1564334138399","to":"1564334153687","id":"1564334158551","name":"","dash":false,"alt":true},{"type":"sl","from":"1564334153687","to":"1564334154471","id":"1564334159304","name":"","dash":false,"alt":true,"Compares":[{"FieldName":"DAYS","Operation":"<","Value":"3"}]},{"type":"sl","from":"1564334153687","to":"1564334155295","id":"1564334160383","name":"","dash":false,"alt":true,"Compares":[{"FieldName":"DAYS","Operation":">=","Value":"3"}]},{"type":"sl","from":"1564334154471","to":"1564334156607","id":"1564334161911","name":"","dash":false,"alt":true},{"type":"sl","from":"1564334155295","to":"1564334156607","id":"1564334163959","name":"","dash":false,"alt":true},{"type":"sl","from":"1564334156607","to":"1564334139783","id":"1564334165255","name":"","dash":false,"alt":true}],"areas":[],"initNum":16}', 'bfd4f0f9-6f61-4af9-977e-cbcf7c30dd35', NULL, '{"REASON":"身体原因","DAYS":"5","CUSTOME_NAME":"玉宝"}', 0, '[{"type":"text","name":"REASON","title":"REASON","value":"身体原因","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"REASON\" value=\"身体原因\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"},{"leipiplugins":"select","name":"DAYS","title":"DAYS","size":"1","orgwidth":"150","style":"width: 150px;","value":"1,3,5,10","selected":"selected","content":"<span leipiplugins=\"select\"><select name=\"leipiNewField\" title=\"DAYS\" leipiplugins=\"select\" size=\"1\" orgwidth=\"150\" style=\"width: 150px;\"><option value=\"1\" selected=\"selected\">1</option><option value=\"3\">3</option><option value=\"5\">5</option><option value=\"10\">10</option></select>&nbsp;&nbsp;</span>"},{"type":"text","name":"CUSTOME_NAME","title":"CUSTOME_NAME","value":"玉宝","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"CUSTOME_NAME\" value=\"玉宝\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"}]', '<p style="text-align: center;"><span style="font-size: 36px;">请假条</span></p><p><span style="font-size: 36px;"><br/></span></p><p style="text-align: center;">因{REASON}，本人想请假{DAYS}天，望领导批准！</p><p><br/></p><p style="text-align: center;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;谢谢！</p><p><br/></p><p style="text-align: right;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 申请人：{CUSTOME_NAME}</p>', 'ef89f96a-af33-407c-b02e-897faf46ecf0', '', 0, '2025-04-11 15:12:14', '00000000-0000-0000-0000-000000000000', 'System', 0, NULL, 0, '1', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL);
INSERT INTO "public"."flowinstance" VALUES ('158b4f11-6534-486a-bf42-cd2c0430157c', '', '1744355761498', 'admin请假了', '1584630767445', 2, 'node_2', '1584630766237', '{"title":"newFlow_1","nodes":[{"name":"node_1","left":116,"top":70,"type":"start","id":"1584630766237","width":26,"height":26,"alt":true},{"name":"node_2","left":118,"top":148,"type":"node","id":"1584630767445","width":104,"height":26,"alt":true,"setInfo":{"NodeName":"node_2","NodeCode":"node_2","NodeRejectType":"0","NodeDesignate":"ALL_USER","NodeConfluenceType":"all","ThirdPartyUrl":"","NodeDesignateData":{"users":[],"roles":[],"orgs":[]}}},{"name":"node_3","left":69,"top":223,"type":"end","id":"1584630769587","width":26,"height":26,"alt":true}],"lines":[{"type":"sl","from":"1584630766237","to":"1584630767445","id":"1584630772227","name":"","dash":false,"alt":true},{"type":"sl","from":"1584630767445","to":"1584630769587","id":"1584630773305","name":"","dash":false,"alt":true}],"areas":[],"initNum":7}', 'f11b7ef6-6da4-4cef-9e71-5e4e1454f30a', NULL, '{"USERNAME":""}', 0, '[{"type":"text","name":"USERNAME","title":"USERNAME","value":"","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"USERNAME\" value=\"\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"}]', '<p>你的姓名：{USERNAME}</p>', '0411376a-18fd-4f52-bffb-22ae0d3fa21d', '', 0, '2025-04-11 15:16:17', '49df1602-f5f3-4d52-afb7-3802da619558', 'admin', 0, NULL, 0, '1', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL);
INSERT INTO "public"."flowinstance" VALUES ('20b3d94b-c706-46bf-9ca9-2af7b2ee5dbd', '', '1744355837237', '向高层汇报', '1584631276803', 2, 'node_2', '1584631275414', '{"title":"newFlow_1","nodes":[{"name":"node_1","left":52,"top":43,"type":"start","id":"1584631275414","width":26,"height":26,"alt":true},{"name":"node_2","left":57,"top":113,"type":"node","id":"1584631276803","width":104,"height":26,"alt":true,"setInfo":{"NodeName":"node_2","NodeCode":"node_2","NodeRejectType":"0","NodeDesignate":"ALL_USER","NodeConfluenceType":"all","ThirdPartyUrl":"","NodeDesignateData":{"users":[],"roles":[],"orgs":[]}}},{"name":"node_3","left":60,"top":192,"type":"end","id":"1584631278737","width":26,"height":26,"alt":true}],"lines":[{"type":"sl","from":"1584631275414","to":"1584631276803","id":"1584631280569","name":"","dash":false,"alt":true},{"type":"sl","from":"1584631276803","to":"1584631278737","id":"1584631281701","name":"","dash":false,"alt":true}],"areas":[],"initNum":7}', 'fb1f3cac-a259-4969-9171-addbe22ab102', NULL, '{"USERNAME":"王哥来了"}', 0, '[{"type":"text","name":"USERNAME","title":"USERNAME","value":"","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"USERNAME\" value=\"\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"}]', '<p>你的姓名：{USERNAME}</p>', '0411376a-18fd-4f52-bffb-22ae0d3fa21d', '', 0, '2025-04-11 15:17:30', '00000000-0000-0000-0000-000000000000', 'System', 0, NULL, 0, '1', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL);
INSERT INTO "public"."flowinstance" VALUES ('3eaf3ffc-fd5f-4ea4-b8d1-ac4ca6226136', '', '1744355509444', '会前审批1', '1564334437844', 0, '会签入口，设置会签类型', '1564334435460', '{"title":"newFlow_1","initNum":16,"lines":[{"id":"1564334446774","label":null,"type":"sl","from":"1564334430924","to":"1564334435460","name":"","dash":false,"Compares":null},{"id":"1564334447796","label":null,"type":"sl","from":"1564334435460","to":"1564334437844","name":"","dash":false,"Compares":null},{"id":"1564334448572","label":null,"type":"sl","from":"1564334437844","to":"1564334439828","name":"","dash":false,"Compares":null},{"id":"1564334449628","label":null,"type":"sl","from":"1564334437844","to":"1564334440404","name":"","dash":false,"Compares":null},{"id":"1564334450572","label":null,"type":"sl","from":"1564334439828","to":"1564334441965","name":"","dash":false,"Compares":null},{"id":"1564334451684","label":null,"type":"sl","from":"1564334440404","to":"1564334441965","name":"","dash":false,"Compares":null},{"id":"1564334453900","label":null,"type":"sl","from":"1564334441965","to":"1564334444885","name":"","dash":false,"Compares":null}],"nodes":[{"id":"1564334430924","name":"node_1","type":"start","left":17,"top":12,"width":26,"height":26,"alt":true,"setInfo":null},{"id":"1564334435460","name":"node_2","type":"node","left":141,"top":49,"width":104,"height":26,"alt":true,"setInfo":{"NodeDesignate":"ALL_USER","NodeDesignateData":{"datas":[]},"NodeCode":"node_2","NodeName":"node_2","ThirdPartyUrl":"","NodeRejectType":"0","Taged":1,"UserName":"超级管理员","UserId":"00000000-0000-0000-0000-000000000000","Description":null,"TagedTime":"2025-04-11 15:14","NodeConfluenceType":"all","ConfluenceOk":null,"ConfluenceNo":null,"CanWriteFormItemIds":null}},{"id":"1564334437844","name":"会签入口，设置会签类型","type":"fork","left":141,"top":138,"width":104,"height":76,"alt":true,"setInfo":{"NodeDesignate":"ALL_USER","NodeDesignateData":{"datas":null},"NodeCode":null,"NodeName":null,"ThirdPartyUrl":"","NodeRejectType":null,"Taged":null,"UserName":null,"UserId":null,"Description":null,"TagedTime":null,"NodeConfluenceType":"all","ConfluenceOk":null,"ConfluenceNo":null,"CanWriteFormItemIds":null}},{"id":"1564334439828","name":"admin","type":"node","left":23,"top":272,"width":104,"height":36,"alt":true,"setInfo":{"NodeDesignate":"SPECIAL_USER","NodeDesignateData":{"datas":["49df1602-f5f3-4d52-afb7-3802da619558"]},"NodeCode":"admin","NodeName":"admin","ThirdPartyUrl":"","NodeRejectType":"0","Taged":null,"UserName":null,"UserId":null,"Description":null,"TagedTime":null,"NodeConfluenceType":"all","ConfluenceOk":null,"ConfluenceNo":null,"CanWriteFormItemIds":null}},{"id":"1564334440404","name":"test","type":"node","left":234,"top":265,"width":104,"height":36,"alt":true,"setInfo":{"NodeDesignate":"SPECIAL_USER","NodeDesignateData":{"datas":["6ba79766-faa0-4259-8139-a4a6d35784e0"]},"NodeCode":"test","NodeName":"test","ThirdPartyUrl":"","NodeRejectType":"0","Taged":null,"UserName":null,"UserId":null,"Description":null,"TagedTime":null,"NodeConfluenceType":"all","ConfluenceOk":null,"ConfluenceNo":null,"CanWriteFormItemIds":null}},{"id":"1564334441965","name":"默认所有人","type":"join","left":140,"top":406,"width":104,"height":56,"alt":true,"setInfo":{"NodeDesignate":"ALL_USER","NodeDesignateData":{"datas":null},"NodeCode":null,"NodeName":null,"ThirdPartyUrl":"","NodeRejectType":null,"Taged":null,"UserName":null,"UserId":null,"Description":null,"TagedTime":null,"NodeConfluenceType":"all","ConfluenceOk":null,"ConfluenceNo":null,"CanWriteFormItemIds":null}},{"id":"1564334444885","name":"node_7","type":"end","left":351,"top":420,"width":26,"height":26,"alt":true,"setInfo":null}],"areas":[]}', '73819920-f085-4003-8874-4361b6461c92', '', '{"REASON":"身体原因","DAYS":"1","CUSTOME_NAME":"玉宝"}', 0, '[{"type":"text","name":"REASON","title":"REASON","value":"身体原因","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"REASON\" value=\"身体原因\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"},{"leipiplugins":"select","name":"DAYS","title":"DAYS","size":"1","orgwidth":"150","style":"width: 150px;","value":"1,3,5,10","selected":"selected","content":"<span leipiplugins=\"select\"><select name=\"leipiNewField\" title=\"DAYS\" leipiplugins=\"select\" size=\"1\" orgwidth=\"150\" style=\"width: 150px;\"><option value=\"1\" selected=\"selected\">1</option><option value=\"3\">3</option><option value=\"5\">5</option><option value=\"10\">10</option></select>&nbsp;&nbsp;</span>"},{"type":"text","name":"CUSTOME_NAME","title":"CUSTOME_NAME","value":"玉宝","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"CUSTOME_NAME\" value=\"玉宝\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"}]', '<p style="text-align: center;"><span style="font-size: 36px;">请假条</span></p><p><span style="font-size: 36px;"><br/></span></p><p style="text-align: center;">因{REASON}，本人想请假{DAYS}天，望领导批准！</p><p><br/></p><p style="text-align: center;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;谢谢！</p><p><br/></p><p style="text-align: right;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 申请人：{CUSTOME_NAME}</p>', 'ef89f96a-af33-407c-b02e-897faf46ecf0', '', 0, '2025-04-11 15:12:03', '00000000-0000-0000-0000-000000000000', 'System', 0, '', 0, '49df1602-f5f3-4d52-afb7-3802da619558,6ba79766-faa0-4259-8139-a4a6d35784e0', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL);
INSERT INTO "public"."flowinstance" VALUES ('6da123db-37d4-4def-a380-f1ec56e814e0', '', '1744355426641', '按角色执行的审批', '1564334333133', 2, '测试人员', '1564334332325', '{"title":"newFlow_1","initNum":9,"lines":[{"id":"1564334335789","label":null,"type":"sl","from":"1564334327861","to":"1564334332325","name":"","dash":false,"Compares":null},{"id":"1564334336629","label":null,"type":"sl","from":"1564334332325","to":"1564334333133","name":"","dash":false,"Compares":null},{"id":"1564334337805","label":null,"type":"sl","from":"1564334333133","to":"1564334330157","name":"","dash":false,"Compares":null}],"nodes":[{"id":"1564334327861","name":"node_1","type":"start","left":99,"top":32,"width":26,"height":26,"alt":true,"setInfo":null},{"id":"1564334330157","name":"node_2","type":"end","left":70,"top":295,"width":26,"height":26,"alt":true,"setInfo":null},{"id":"1564334332325","name":"管理员","type":"node","left":43,"top":131,"width":104,"height":36,"alt":true,"setInfo":{"NodeDesignate":"SPECIAL_ROLE","NodeDesignateData":{"datas":["09ee2ffa-7463-4938-ae0b-1cb4e80c7c13"]},"NodeCode":"管理员","NodeName":"管理员","ThirdPartyUrl":"","NodeRejectType":"0","Taged":1,"UserName":"admin","UserId":"49df1602-f5f3-4d52-afb7-3802da619558","Description":null,"TagedTime":"2025-04-11 15:14","NodeConfluenceType":"all","ConfluenceOk":null,"ConfluenceNo":null,"CanWriteFormItemIds":null}},{"id":"1564334333133","name":"测试人员","type":"node","left":185,"top":226,"width":104,"height":36,"alt":true,"setInfo":{"NodeDesignate":"SPECIAL_ROLE","NodeDesignateData":{"datas":["0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d"]},"NodeCode":"测试人员","NodeName":"测试人员","ThirdPartyUrl":"","NodeRejectType":"0","Taged":null,"UserName":null,"UserId":null,"Description":null,"TagedTime":null,"NodeConfluenceType":"all","ConfluenceOk":null,"ConfluenceNo":null,"CanWriteFormItemIds":null}}],"areas":[]}', '0b21f59c-7809-4275-acb4-8e8c08e0167e', '', '{"REASON":"身体原因","DAYS":"1","CUSTOME_NAME":"玉宝"}', 0, '[{"type":"text","name":"REASON","title":"REASON","value":"身体原因","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"REASON\" value=\"身体原因\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"},{"leipiplugins":"select","name":"DAYS","title":"DAYS","size":"1","orgwidth":"150","style":"width: 150px;","value":"1,3,5,10","selected":"selected","content":"<span leipiplugins=\"select\"><select name=\"leipiNewField\" title=\"DAYS\" leipiplugins=\"select\" size=\"1\" orgwidth=\"150\" style=\"width: 150px;\"><option value=\"1\" selected=\"selected\">1</option><option value=\"3\">3</option><option value=\"5\">5</option><option value=\"10\">10</option></select>&nbsp;&nbsp;</span>"},{"type":"text","name":"CUSTOME_NAME","title":"CUSTOME_NAME","value":"玉宝","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"CUSTOME_NAME\" value=\"玉宝\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"}]', '<p style="text-align: center;"><span style="font-size: 36px;">请假条</span></p><p><span style="font-size: 36px;"><br/></span></p><p style="text-align: center;">因{REASON}，本人想请假{DAYS}天，望领导批准！</p><p><br/></p><p style="text-align: center;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;谢谢！</p><p><br/></p><p style="text-align: right;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 申请人：{CUSTOME_NAME}</p>', 'ef89f96a-af33-407c-b02e-897faf46ecf0', '', 0, '2025-04-11 15:10:31', '00000000-0000-0000-0000-000000000000', 'System', 0, '', 0, '6ba79766-faa0-4259-8139-a4a6d35784e0', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL);
INSERT INTO "public"."flowinstance" VALUES ('cbe5dd1a-b820-4c12-be30-f98d9ef70152', '', '1744355405284', '会前审批2', '1584630843608', 2, 'node_2', '1584630842462', '{"title":"newFlow_1","nodes":[{"name":"node_1","left":47,"top":23,"type":"start","id":"1584630842462","width":26,"height":26,"alt":true},{"name":"node_2","left":74,"top":102,"type":"node","id":"1584630843608","width":104,"height":26,"alt":true,"setInfo":{"NodeName":"node_2","NodeCode":"node_2","NodeRejectType":"0","NodeDesignate":"ALL_USER","NodeConfluenceType":"all","ThirdPartyUrl":"","NodeDesignateData":{"users":[],"roles":[],"orgs":[]}}},{"name":"node_3","left":41,"top":179,"type":"end","id":"1584630845368","width":26,"height":26,"alt":true}],"lines":[{"type":"sl","from":"1584630842462","to":"1584630843608","id":"1584630846980","name":"","dash":false,"alt":true},{"type":"sl","from":"1584630843608","to":"1584630845368","id":"1584630847962","name":"","dash":false,"alt":true}],"areas":[],"initNum":7}', '7831e5d0-0ecf-4539-99bc-cd7ecfc8f88f', NULL, '{"USERNAME":""}', 0, '[{"type":"text","name":"USERNAME","title":"USERNAME","value":"","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"USERNAME\" value=\"\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"}]', '<p>你的姓名：{USERNAME}</p>', '0411376a-18fd-4f52-bffb-22ae0d3fa21d', '', 0, '2025-04-11 15:10:13', '00000000-0000-0000-0000-000000000000', 'System', 0, NULL, 0, '1', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL);
INSERT INTO "public"."flowinstance" VALUES ('edd22a7b-e485-4988-b5a6-7955d656aa78', '', '1744355395177', '所有人都可以审批的流程', '1564334038904', 4, 'node_4', '1564334036152', '{"title":"newFlow_1","initNum":9,"lines":[{"id":"1564334041040","label":null,"type":"sl","from":"1564334032785","to":"1564334035352","name":"","dash":false,"Compares":null},{"id":"1564334041720","label":null,"type":"sl","from":"1564334035352","to":"1564334036152","name":"","dash":false,"Compares":null},{"id":"1564334042927","label":null,"type":"sl","from":"1564334036152","to":"1564334038904","name":"","dash":false,"Compares":null}],"nodes":[{"id":"1564334032785","name":"node_1","type":"start","left":19,"top":36,"width":26,"height":26,"alt":true,"setInfo":null},{"id":"1564334035352","name":"所有人可以审批","type":"node","left":133,"top":50,"width":104,"height":56,"alt":true,"setInfo":{"NodeDesignate":"ALL_USER","NodeDesignateData":{"datas":null},"NodeCode":null,"NodeName":null,"ThirdPartyUrl":"http://xxxx.com/api/workflow/callback","NodeRejectType":null,"Taged":1,"UserName":"admin","UserId":"49df1602-f5f3-4d52-afb7-3802da619558","Description":null,"TagedTime":"2025-04-11 15:15","NodeConfluenceType":"all","ConfluenceOk":null,"ConfluenceNo":null,"CanWriteFormItemIds":null}},{"id":"1564334036152","name":"所有人可以审批","type":"node","left":139,"top":123,"width":104,"height":56,"alt":true,"setInfo":{"NodeDesignate":"ALL_USER","NodeDesignateData":{"datas":null},"NodeCode":null,"NodeName":null,"ThirdPartyUrl":"","NodeRejectType":null,"Taged":1,"UserName":"admin","UserId":"49df1602-f5f3-4d52-afb7-3802da619558","Description":null,"TagedTime":"2025-04-11 15:15","NodeConfluenceType":"all","ConfluenceOk":null,"ConfluenceNo":null,"CanWriteFormItemIds":null}},{"id":"1564334038904","name":"node_4","type":"end","left":47,"top":193,"width":26,"height":26,"alt":true,"setInfo":null}],"areas":[]}', '61806396-9498-492b-bc22-9f9e95a389bc', '', '{"REASON":"身体原因","DAYS":"1","CUSTOME_NAME":"玉宝"}', 0, '[{"type":"text","name":"REASON","title":"REASON","value":"身体原因","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"REASON\" value=\"身体原因\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"},{"leipiplugins":"select","name":"DAYS","title":"DAYS","size":"1","orgwidth":"150","style":"width: 150px;","value":"1,3,5,10","selected":"selected","content":"<span leipiplugins=\"select\"><select name=\"leipiNewField\" title=\"DAYS\" leipiplugins=\"select\" size=\"1\" orgwidth=\"150\" style=\"width: 150px;\"><option value=\"1\" selected=\"selected\">1</option><option value=\"3\">3</option><option value=\"5\">5</option><option value=\"10\">10</option></select>&nbsp;&nbsp;</span>"},{"type":"text","name":"CUSTOME_NAME","title":"CUSTOME_NAME","value":"玉宝","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"CUSTOME_NAME\" value=\"玉宝\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"}]', '<p style="text-align: center;"><span style="font-size: 36px;">请假条</span></p><p><span style="font-size: 36px;"><br/></span></p><p style="text-align: center;">因{REASON}，本人想请假{DAYS}天，望领导批准！</p><p><br/></p><p style="text-align: center;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;谢谢！</p><p><br/></p><p style="text-align: right;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 申请人：{CUSTOME_NAME}</p>', 'ef89f96a-af33-407c-b02e-897faf46ecf0', '', 0, '2025-04-11 15:10:02', '00000000-0000-0000-0000-000000000000', 'System', 0, '', 1, '', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL);
INSERT INTO "public"."flowinstance" VALUES ('f1098644-b360-4967-8108-fff8f7c2057c', '', '1744355747101', 'admin发起的审批', '1564334332325', 2, '管理员', '1564334327861', '{"title":"newFlow_1","nodes":[{"name":"node_1","left":99,"top":32,"type":"start","id":"1564334327861","width":26,"height":26,"alt":true},{"name":"node_2","left":70,"top":295,"type":"end","id":"1564334330157","width":26,"height":26,"alt":true},{"name":"管理员","left":43,"top":131,"type":"node","id":"1564334332325","width":104,"height":36,"alt":true,"setInfo":{"NodeName":"管理员","NodeCode":"管理员","NodeRejectType":"0","NodeDesignate":"SPECIAL_ROLE","NodeConfluenceType":"all","ThirdPartyUrl":"","NodeDesignateData":{"datas":["09ee2ffa-7463-4938-ae0b-1cb4e80c7c13"]}}},{"name":"测试人员","left":185,"top":226,"type":"node","id":"1564334333133","width":104,"height":36,"alt":true,"setInfo":{"NodeName":"测试人员","NodeCode":"测试人员","NodeRejectType":"0","NodeDesignate":"SPECIAL_ROLE","NodeConfluenceType":"all","ThirdPartyUrl":"","NodeDesignateData":{"datas":["0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d"]}}}],"lines":[{"type":"sl","from":"1564334327861","to":"1564334332325","id":"1564334335789","name":"","dash":false},{"type":"sl","from":"1564334332325","to":"1564334333133","id":"1564334336629","name":"","dash":false},{"type":"sl","from":"1564334333133","to":"1564334330157","id":"1564334337805","name":"","dash":false}],"areas":[],"initNum":9}', '0b21f59c-7809-4275-acb4-8e8c08e0167e', NULL, '{"REASON":"身体原因","DAYS":"1","CUSTOME_NAME":"玉宝"}', 0, '[{"type":"text","name":"REASON","title":"REASON","value":"身体原因","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"REASON\" value=\"身体原因\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"},{"leipiplugins":"select","name":"DAYS","title":"DAYS","size":"1","orgwidth":"150","style":"width: 150px;","value":"1,3,5,10","selected":"selected","content":"<span leipiplugins=\"select\"><select name=\"leipiNewField\" title=\"DAYS\" leipiplugins=\"select\" size=\"1\" orgwidth=\"150\" style=\"width: 150px;\"><option value=\"1\" selected=\"selected\">1</option><option value=\"3\">3</option><option value=\"5\">5</option><option value=\"10\">10</option></select>&nbsp;&nbsp;</span>"},{"type":"text","name":"CUSTOME_NAME","title":"CUSTOME_NAME","value":"玉宝","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"CUSTOME_NAME\" value=\"玉宝\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"}]', '<p style="text-align: center;"><span style="font-size: 36px;">请假条</span></p><p><span style="font-size: 36px;"><br/></span></p><p style="text-align: center;">因{REASON}，本人想请假{DAYS}天，望领导批准！</p><p><br/></p><p style="text-align: center;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;谢谢！</p><p><br/></p><p style="text-align: right;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 申请人：{CUSTOME_NAME}</p>', 'ef89f96a-af33-407c-b02e-897faf46ecf0', '', 0, '2025-04-11 15:15:59', '49df1602-f5f3-4d52-afb7-3802da619558', 'admin', 0, NULL, 0, '49df1602-f5f3-4d52-afb7-3802da619558', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL);

-- ----------------------------
-- Table structure for flowinstanceoperationhistory
-- ----------------------------
DROP TABLE IF EXISTS "public"."flowinstanceoperationhistory";
CREATE TABLE "public"."flowinstanceoperationhistory" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "instanceid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "content" varchar(200) COLLATE "pg_catalog"."default",
  "createdate" timestamp(6) NOT NULL,
  "createuserid" varchar(50) COLLATE "pg_catalog"."default",
  "createusername" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."flowinstanceoperationhistory"."id" IS '主键Id';
COMMENT ON COLUMN "public"."flowinstanceoperationhistory"."instanceid" IS '实例进程Id';
COMMENT ON COLUMN "public"."flowinstanceoperationhistory"."content" IS '操作内容';
COMMENT ON COLUMN "public"."flowinstanceoperationhistory"."createdate" IS '创建时间';
COMMENT ON COLUMN "public"."flowinstanceoperationhistory"."createuserid" IS '创建用户主键';
COMMENT ON COLUMN "public"."flowinstanceoperationhistory"."createusername" IS '创建用户';
COMMENT ON TABLE "public"."flowinstanceoperationhistory" IS '工作流实例操作记录';

-- ----------------------------
-- Records of flowinstanceoperationhistory
-- ----------------------------
INSERT INTO "public"."flowinstanceoperationhistory" VALUES ('09d94511-02cd-412e-bd95-1452c7fe75f1', '6da123db-37d4-4def-a380-f1ec56e814e0', '【创建】超级管理员创建了流程实例【】', '2025-04-11 15:10:31', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."flowinstanceoperationhistory" VALUES ('109f5f41-8f4e-4b83-b629-38c50ac292a0', 'cbe5dd1a-b820-4c12-be30-f98d9ef70152', '【创建】超级管理员创建了流程实例【】', '2025-04-11 15:10:13', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."flowinstanceoperationhistory" VALUES ('1ded2706-dd4a-4757-afe4-e8112e0e7f1b', '20b3d94b-c706-46bf-9ca9-2af7b2ee5dbd', '【创建】超级管理员创建了流程实例【】', '2025-04-11 15:17:30', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."flowinstanceoperationhistory" VALUES ('20776658-82ca-48fe-a9ae-da54b2317763', '3eaf3ffc-fd5f-4ea4-b8d1-ac4ca6226136', '【创建】超级管理员创建了流程实例【】', '2025-04-11 15:12:03', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."flowinstanceoperationhistory" VALUES ('23d87d42-3004-43f4-ad32-2efb6b58cc1e', '6da123db-37d4-4def-a380-f1ec56e814e0', 'admin-2025-04-11 15:14审批了【管理员】结果：同意，备注：', '2025-04-11 15:15:00', '49df1602-f5f3-4d52-afb7-3802da619558', 'admin');
INSERT INTO "public"."flowinstanceoperationhistory" VALUES ('65ee80b8-6f1e-45a8-9640-468d157f1b2d', 'edd22a7b-e485-4988-b5a6-7955d656aa78', 'admin-2025-04-11 15:15审批了【所有人可以审批】结果：同意，备注：', '2025-04-11 15:15:06', '49df1602-f5f3-4d52-afb7-3802da619558', 'admin');
INSERT INTO "public"."flowinstanceoperationhistory" VALUES ('ab9f7a36-a559-4658-b0c3-bfa065324762', '158b4f11-6534-486a-bf42-cd2c0430157c', '【创建】admin创建了流程实例【admin请假了】', '2025-04-11 15:16:17', '49df1602-f5f3-4d52-afb7-3802da619558', 'admin');
INSERT INTO "public"."flowinstanceoperationhistory" VALUES ('b5dcf121-b9b2-4827-8c61-3f8b205a2220', 'f1098644-b360-4967-8108-fff8f7c2057c', '【创建】admin创建了流程实例【admin发起的审批】', '2025-04-11 15:15:59', '49df1602-f5f3-4d52-afb7-3802da619558', 'admin');
INSERT INTO "public"."flowinstanceoperationhistory" VALUES ('d5d76c13-c802-4ad0-b2b3-077db6560839', 'edd22a7b-e485-4988-b5a6-7955d656aa78', 'admin-2025-04-11 15:15审批了【所有人可以审批】结果：同意，备注：', '2025-04-11 15:15:06', '49df1602-f5f3-4d52-afb7-3802da619558', 'admin');
INSERT INTO "public"."flowinstanceoperationhistory" VALUES ('e9ef6816-3a0f-4f44-9a04-50612b1dca22', '05e8c579-5d59-4f71-bb3f-7688ac834729', '【创建】超级管理员创建了流程实例【】', '2025-04-11 15:12:14', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."flowinstanceoperationhistory" VALUES ('f1fe9a1b-5926-4394-94f2-08410845ad5d', 'edd22a7b-e485-4988-b5a6-7955d656aa78', '【创建】超级管理员创建了流程实例【】', '2025-04-11 15:10:02', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."flowinstanceoperationhistory" VALUES ('f6b4ee82-0e78-4947-87e2-d62b91116775', '3eaf3ffc-fd5f-4ea4-b8d1-ac4ca6226136', 'System-2025-04-11 15:14审批了【node_2】结果：同意，备注：', '2025-04-11 15:14:10', '00000000-0000-0000-0000-000000000000', '超级管理员');

-- ----------------------------
-- Table structure for flowinstancetransitionhistory
-- ----------------------------
DROP TABLE IF EXISTS "public"."flowinstancetransitionhistory";
CREATE TABLE "public"."flowinstancetransitionhistory" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "instanceid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "fromnodeid" varchar(50) COLLATE "pg_catalog"."default",
  "fromnodetype" varchar(50) COLLATE "pg_catalog"."default",
  "fromnodename" varchar(200) COLLATE "pg_catalog"."default",
  "tonodeid" varchar(50) COLLATE "pg_catalog"."default",
  "tonodetype" varchar(50) COLLATE "pg_catalog"."default",
  "tonodename" varchar(200) COLLATE "pg_catalog"."default",
  "transitionsate" int4 NOT NULL,
  "isfinish" int4 NOT NULL,
  "createdate" timestamp(6) NOT NULL,
  "createuserid" varchar(50) COLLATE "pg_catalog"."default",
  "createusername" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."flowinstancetransitionhistory"."id" IS '主键Id';
COMMENT ON COLUMN "public"."flowinstancetransitionhistory"."instanceid" IS '实例Id';
COMMENT ON COLUMN "public"."flowinstancetransitionhistory"."fromnodeid" IS '开始节点Id';
COMMENT ON COLUMN "public"."flowinstancetransitionhistory"."fromnodetype" IS '开始节点类型';
COMMENT ON COLUMN "public"."flowinstancetransitionhistory"."fromnodename" IS '开始节点名称';
COMMENT ON COLUMN "public"."flowinstancetransitionhistory"."tonodeid" IS '结束节点Id';
COMMENT ON COLUMN "public"."flowinstancetransitionhistory"."tonodetype" IS '结束节点类型';
COMMENT ON COLUMN "public"."flowinstancetransitionhistory"."tonodename" IS '结束节点名称';
COMMENT ON COLUMN "public"."flowinstancetransitionhistory"."transitionsate" IS '转化状态';
COMMENT ON COLUMN "public"."flowinstancetransitionhistory"."isfinish" IS '是否结束';
COMMENT ON COLUMN "public"."flowinstancetransitionhistory"."createdate" IS '转化时间';
COMMENT ON COLUMN "public"."flowinstancetransitionhistory"."createuserid" IS '操作人Id';
COMMENT ON COLUMN "public"."flowinstancetransitionhistory"."createusername" IS '操作人名称';
COMMENT ON TABLE "public"."flowinstancetransitionhistory" IS '工作流实例流转历史记录';

-- ----------------------------
-- Records of flowinstancetransitionhistory
-- ----------------------------
INSERT INTO "public"."flowinstancetransitionhistory" VALUES ('2c7baa3a-31b6-476e-936c-732ac32ee2ac', 'f1098644-b360-4967-8108-fff8f7c2057c', '1564334327861', 3, 'node_1', '1564334332325', 2, '管理员', 0, 0, '2025-04-11 15:15:59', '49df1602-f5f3-4d52-afb7-3802da619558', 'admin');
INSERT INTO "public"."flowinstancetransitionhistory" VALUES ('3106487d-c8f0-4a12-8304-3146e9a441c8', 'cbe5dd1a-b820-4c12-be30-f98d9ef70152', '1584630842462', 3, 'node_1', '1584630843608', 2, 'node_2', 0, 0, '2025-04-11 15:10:13', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."flowinstancetransitionhistory" VALUES ('6fad3a96-afb1-4978-8021-a1866a91c496', '3eaf3ffc-fd5f-4ea4-b8d1-ac4ca6226136', '1564334430924', 3, 'node_1', '1564334435460', 2, 'node_2', 0, 0, '2025-04-11 15:12:03', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."flowinstancetransitionhistory" VALUES ('9f5b0f2c-136f-4014-84be-7077a90d4480', '6da123db-37d4-4def-a380-f1ec56e814e0', '1564334327861', 3, 'node_1', '1564334332325', 2, '管理员', 0, 0, '2025-04-11 15:10:31', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."flowinstancetransitionhistory" VALUES ('b4e0a526-0432-4c58-baeb-9b5104366c95', '158b4f11-6534-486a-bf42-cd2c0430157c', '1584630766237', 3, 'node_1', '1584630767445', 2, 'node_2', 0, 0, '2025-04-11 15:16:17', '49df1602-f5f3-4d52-afb7-3802da619558', 'admin');
INSERT INTO "public"."flowinstancetransitionhistory" VALUES ('b8a98b6e-4bfa-468c-8507-bcd7787c842e', '20b3d94b-c706-46bf-9ca9-2af7b2ee5dbd', '1584631275414', 3, 'node_1', '1584631276803', 2, 'node_2', 0, 0, '2025-04-11 15:17:30', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."flowinstancetransitionhistory" VALUES ('cbd29bcb-d034-4800-ac1a-dd44c775aeb2', '05e8c579-5d59-4f71-bb3f-7688ac834729', '1564334138399', 3, 'node_1', '1564334153687', 2, '所有人可以审批', 0, 0, '2025-04-11 15:12:14', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."flowinstancetransitionhistory" VALUES ('f4c5f77b-32ab-4e95-af60-9ca9c94923f2', 'edd22a7b-e485-4988-b5a6-7955d656aa78', '1564334032785', 3, 'node_1', '1564334035352', 2, '所有人可以审批', 0, 0, '2025-04-11 15:10:02', '00000000-0000-0000-0000-000000000000', '超级管理员');

-- ----------------------------
-- Table structure for flowscheme
-- ----------------------------
DROP TABLE IF EXISTS "public"."flowscheme";
CREATE TABLE "public"."flowscheme" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "schemecode" varchar(50) COLLATE "pg_catalog"."default",
  "schemename" varchar(200) COLLATE "pg_catalog"."default",
  "schemetype" varchar(50) COLLATE "pg_catalog"."default",
  "schemeversion" varchar(50) COLLATE "pg_catalog"."default",
  "schemecanuser" text COLLATE "pg_catalog"."default",
  "schemecontent" text COLLATE "pg_catalog"."default",
  "frmid" varchar(50) COLLATE "pg_catalog"."default",
  "frmtype" int4 NOT NULL,
  "authorizetype" int4 NOT NULL,
  "sortcode" int4 NOT NULL,
  "deletemark" int4 NOT NULL,
  "disabled" int4 NOT NULL,
  "description" varchar(200) COLLATE "pg_catalog"."default",
  "createdate" timestamp(6) NOT NULL,
  "createuserid" varchar(50) COLLATE "pg_catalog"."default",
  "createusername" varchar(50) COLLATE "pg_catalog"."default",
  "modifydate" timestamp(6),
  "modifyuserid" varchar(50) COLLATE "pg_catalog"."default",
  "modifyusername" varchar(50) COLLATE "pg_catalog"."default",
  "orgid" varchar(50) COLLATE "pg_catalog"."default",
  "frmurltemplate" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."flowscheme"."id" IS '主键Id';
COMMENT ON COLUMN "public"."flowscheme"."schemecode" IS '流程编号';
COMMENT ON COLUMN "public"."flowscheme"."schemename" IS '流程名称';
COMMENT ON COLUMN "public"."flowscheme"."schemetype" IS '流程分类';
COMMENT ON COLUMN "public"."flowscheme"."schemeversion" IS '流程内容版本';
COMMENT ON COLUMN "public"."flowscheme"."schemecanuser" IS '流程模板使用者';
COMMENT ON COLUMN "public"."flowscheme"."schemecontent" IS '流程内容';
COMMENT ON COLUMN "public"."flowscheme"."frmid" IS '表单ID';
COMMENT ON COLUMN "public"."flowscheme"."frmtype" IS '表单类型';
COMMENT ON COLUMN "public"."flowscheme"."authorizetype" IS '模板权限类型：0完全公开,1指定部门/人员';
COMMENT ON COLUMN "public"."flowscheme"."sortcode" IS '排序码';
COMMENT ON COLUMN "public"."flowscheme"."deletemark" IS '删除标记';
COMMENT ON COLUMN "public"."flowscheme"."disabled" IS '有效';
COMMENT ON COLUMN "public"."flowscheme"."description" IS '备注';
COMMENT ON COLUMN "public"."flowscheme"."createdate" IS '创建时间';
COMMENT ON COLUMN "public"."flowscheme"."createuserid" IS '创建用户主键';
COMMENT ON COLUMN "public"."flowscheme"."createusername" IS '创建用户';
COMMENT ON COLUMN "public"."flowscheme"."modifydate" IS '修改时间';
COMMENT ON COLUMN "public"."flowscheme"."modifyuserid" IS '修改用户主键';
COMMENT ON COLUMN "public"."flowscheme"."modifyusername" IS '修改用户';
COMMENT ON COLUMN "public"."flowscheme"."orgid" IS '所属部门';
COMMENT ON COLUMN "public"."flowscheme"."frmurltemplate" IS '流程设计时表单用的URL模板';
COMMENT ON TABLE "public"."flowscheme" IS '工作流模板信息表';

-- ----------------------------
-- Records of flowscheme
-- ----------------------------
INSERT INTO "public"."flowscheme" VALUES ('73819920-f085-4003-8874-4361b6461c92', '1564334009729', '会签', '', '', '', '{"title":"newFlow_1","nodes":[{"name":"node_1","left":17,"top":12,"type":"start","id":"1564334430924","width":26,"height":26,"alt":true},{"name":"node_2","left":141,"top":49,"type":"node","id":"1564334435460","width":104,"height":26,"alt":true,"setInfo":{"NodeName":"node_2","NodeCode":"node_2","NodeRejectType":"0","NodeDesignate":"ALL_USER","NodeConfluenceType":"all","ThirdPartyUrl":"","NodeDesignateData":{"datas":[]}}},{"name":"会签入口，设置会签类型","left":141,"top":138,"type":"fork","id":"1564334437844","width":104,"height":76,"alt":true,"setInfo":{"NodeConfluenceType":"all","NodeDesignate":"ALL_USER","ThirdPartyUrl":"","NodeDesignateData":{"users":[],"roles":[]}}},{"name":"admin","left":23,"top":272,"type":"node","id":"1564334439828","width":104,"height":36,"alt":true,"setInfo":{"NodeName":"admin","NodeCode":"admin","NodeRejectType":"0","NodeDesignate":"SPECIAL_USER","NodeConfluenceType":"all","ThirdPartyUrl":"","NodeDesignateData":{"datas":["49df1602-f5f3-4d52-afb7-3802da619558"]}}},{"name":"test","left":234,"top":265,"type":"node","id":"1564334440404","width":104,"height":36,"alt":true,"setInfo":{"NodeName":"test","NodeCode":"test","NodeRejectType":"0","NodeDesignate":"SPECIAL_USER","NodeConfluenceType":"all","ThirdPartyUrl":"","NodeDesignateData":{"datas":["6ba79766-faa0-4259-8139-a4a6d35784e0"]}}},{"name":"默认所有人","left":140,"top":406,"type":"join","id":"1564334441965","width":104,"height":56,"alt":true,"setInfo":{"NodeConfluenceType":"all","NodeDesignate":"ALL_USER","ThirdPartyUrl":"","NodeDesignateData":{"users":[],"roles":[]}}},{"name":"node_7","left":351,"top":420,"type":"end","id":"1564334444885","width":26,"height":26,"alt":true}],"lines":[{"type":"sl","from":"1564334430924","to":"1564334435460","id":"1564334446774","name":"","dash":false},{"type":"sl","from":"1564334435460","to":"1564334437844","id":"1564334447796","name":"","dash":false},{"type":"sl","from":"1564334437844","to":"1564334439828","id":"1564334448572","name":"","dash":false},{"type":"sl","from":"1564334437844","to":"1564334440404","id":"1564334449628","name":"","dash":false},{"type":"sl","from":"1564334439828","to":"1564334441965","id":"1564334450572","name":"","dash":false},{"type":"sl","from":"1564334440404","to":"1564334441965","id":"1564334451684","name":"","dash":false},{"type":"sl","from":"1564334441965","to":"1564334444885","id":"1564334453900","name":"","dash":false}],"areas":[],"initNum":16}', 'ef89f96a-af33-407c-b02e-897faf46ecf0', 0, 0, 0, 0, 0, '需要多人审批的流程，比如需要多人全部批准该步骤才能通过，或至少有一个通过', '2019-07-29 01:22:03', '', '', '2025-04-11 15:02:14', '', '', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL);
INSERT INTO "public"."flowscheme" VALUES ('0b21f59c-7809-4275-acb4-8e8c08e0167e', '1564334009729', '按角色执行', '', '', '', '{"title":"newFlow_1","nodes":[{"name":"node_1","left":99,"top":32,"type":"start","id":"1564334327861","width":26,"height":26,"alt":true},{"name":"node_2","left":70,"top":295,"type":"end","id":"1564334330157","width":26,"height":26,"alt":true},{"name":"管理员","left":43,"top":131,"type":"node","id":"1564334332325","width":104,"height":36,"alt":true,"setInfo":{"NodeName":"管理员","NodeCode":"管理员","NodeRejectType":"0","NodeDesignate":"SPECIAL_ROLE","NodeConfluenceType":"all","ThirdPartyUrl":"","NodeDesignateData":{"datas":["09ee2ffa-7463-4938-ae0b-1cb4e80c7c13"]}}},{"name":"测试人员","left":185,"top":226,"type":"node","id":"1564334333133","width":104,"height":36,"alt":true,"setInfo":{"NodeName":"测试人员","NodeCode":"测试人员","NodeRejectType":"0","NodeDesignate":"SPECIAL_ROLE","NodeConfluenceType":"all","ThirdPartyUrl":"","NodeDesignateData":{"datas":["0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d"]}}}],"lines":[{"type":"sl","from":"1564334327861","to":"1564334332325","id":"1564334335789","name":"","dash":false},{"type":"sl","from":"1564334332325","to":"1564334333133","id":"1564334336629","name":"","dash":false},{"type":"sl","from":"1564334333133","to":"1564334330157","id":"1564334337805","name":"","dash":false}],"areas":[],"initNum":9}', 'ef89f96a-af33-407c-b02e-897faf46ecf0', 0, 0, 0, 0, 0, '节点按指定的角色执行而不是指定的人', '2019-07-29 01:19:25', '', '', '2025-04-11 15:07:16', '', '', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL);
INSERT INTO "public"."flowscheme" VALUES ('1648a05b-013c-4dd0-8ecb-5695d08fb8f4', '1584630870659', '【研发小组】测试申请', '', '', '', '{"title":"newFlow_1","nodes":[{"name":"node_1","left":44,"top":49,"type":"start","id":"1584630893821","width":26,"height":26,"alt":true},{"name":"node_2","left":58,"top":120,"type":"node","id":"1584630895194","width":104,"height":26,"alt":true,"setInfo":{"NodeName":"node_2","NodeCode":"node_2","NodeRejectType":"0","NodeDesignate":"ALL_USER","NodeConfluenceType":"all","ThirdPartyUrl":"","NodeDesignateData":{"users":[],"roles":[],"orgs":[]}}},{"name":"node_3","left":42,"top":219,"type":"end","id":"1584630896886","width":26,"height":26,"alt":true}],"lines":[{"type":"sl","from":"1584630893821","to":"1584630895194","id":"1584630898567","name":"","dash":false,"alt":true},{"type":"sl","from":"1584630895194","to":"1584630896886","id":"1584630899588","name":"","dash":false,"alt":true}],"areas":[],"initNum":7}', '0411376a-18fd-4f52-bffb-22ae0d3fa21d', 0, 0, 1, 0, 0, '只有【test3】账号或可以看到【研发小组】的【管理员】才能看到', '2020-03-19 23:15:03', '229f3a49-ab27-49ce-b383-9f10ca23a9d5', 'test3', '2020-03-19 23:15:03', '', '', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL);
INSERT INTO "public"."flowscheme" VALUES ('61806396-9498-492b-bc22-9f9e95a389bc', '1564334009729', '普通的请假', '', '', '', '{"title":"newFlow_1","nodes":[{"name":"node_1","left":19,"top":36,"type":"start","id":"1564334032785","width":26,"height":26,"alt":true},{"name":"所有人可以审批","left":133,"top":50,"type":"node","id":"1564334035352","width":104,"height":56,"alt":true,"setInfo":{"NodeConfluenceType":"all","NodeDesignate":"ALL_USER","ThirdPartyUrl":"http://xxxx.com/api/workflow/callback","NodeDesignateData":{"users":[],"roles":[]}}},{"name":"所有人可以审批","left":139,"top":123,"type":"node","id":"1564334036152","width":104,"height":56,"alt":true,"setInfo":{"NodeConfluenceType":"all","NodeDesignate":"ALL_USER","ThirdPartyUrl":"","NodeDesignateData":{"users":[],"roles":[]}}},{"name":"node_4","left":47,"top":193,"type":"end","id":"1564334038904","width":26,"height":26,"alt":true}],"lines":[{"type":"sl","from":"1564334032785","to":"1564334035352","id":"1564334041040","name":"","dash":false,"alt":true},{"type":"sl","from":"1564334035352","to":"1564334036152","id":"1564334041720","name":"","dash":false,"alt":true},{"type":"sl","from":"1564334036152","to":"1564334038904","id":"1564334042927","name":"","dash":false,"alt":true}],"areas":[],"initNum":9}', 'ef89f96a-af33-407c-b02e-897faf46ecf0', 0, 0, 0, 0, 0, '非常简单的请假流程', '2019-07-29 01:14:48', '', '', '2019-07-29 01:14:48', '', '', NULL, NULL);
INSERT INTO "public"."flowscheme" VALUES ('7831e5d0-0ecf-4539-99bc-cd7ecfc8f88f', '1584630806811', '【研发小组】爱好调研', '', '', '', '{"title":"newFlow_1","nodes":[{"name":"node_1","left":47,"top":23,"type":"start","id":"1584630842462","width":26,"height":26,"alt":true},{"name":"node_2","left":74,"top":102,"type":"node","id":"1584630843608","width":104,"height":26,"alt":true,"setInfo":{"NodeName":"node_2","NodeCode":"node_2","NodeRejectType":"0","NodeDesignate":"ALL_USER","NodeConfluenceType":"all","ThirdPartyUrl":"","NodeDesignateData":{"users":[],"roles":[],"orgs":[]}}},{"name":"node_3","left":41,"top":179,"type":"end","id":"1584630845368","width":26,"height":26,"alt":true}],"lines":[{"type":"sl","from":"1584630842462","to":"1584630843608","id":"1584630846980","name":"","dash":false,"alt":true},{"type":"sl","from":"1584630843608","to":"1584630845368","id":"1584630847962","name":"","dash":false,"alt":true}],"areas":[],"initNum":7}', '0411376a-18fd-4f52-bffb-22ae0d3fa21d', 0, 0, 1, 0, 0, '只有【test】账号或可以看到【研发小组】的【管理员】才能看到', '2020-03-19 23:14:14', '6ba79766-faa0-4259-8139-a4a6d35784e0', 'test', '2020-03-19 23:14:14', '', '', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL);
INSERT INTO "public"."flowscheme" VALUES ('989bd1f3-29f0-43cd-ad01-b55654907dbb', '1564334009729', '带复杂表单的', '', '', '', '{"title":"newFlow_1","nodes":[{"name":"node_1","left":66,"top":46,"type":"start","id":"1564334555981","width":26,"height":26,"alt":true},{"name":"node_2","left":50,"top":145,"type":"node","id":"1564334557205","width":104,"height":26,"alt":true},{"name":"node_3","left":56,"top":206,"type":"node","id":"1564334557764","width":104,"height":26,"alt":true},{"name":"node_4","left":66,"top":294,"type":"end","id":"1564334559716","width":26,"height":26,"alt":true}],"lines":[{"type":"sl","from":"1564334555981","to":"1564334557205","id":"1564334561500","name":"","dash":false},{"type":"sl","from":"1564334557205","to":"1564334557764","id":"1564334562229","name":"","dash":false},{"type":"sl","from":"1564334557764","to":"1564334559716","id":"1564334563268","name":"","dash":false}],"areas":[],"initNum":8}', '8faff4e5-b729-44d2-ac26-e899a228f63d', 1, 0, 0, 0, 0, '这是一个带有复杂表单的流程，比如需要上传文件', '2019-07-29 01:22:45', '', '', '2019-10-29 17:25:20', '', '', NULL, NULL);
INSERT INTO "public"."flowscheme" VALUES ('bfd4f0f9-6f61-4af9-977e-cbcf7c30dd35', '1564334009729', '带分支条件的请假', '', '', '', '{"title":"newFlow_1","nodes":[{"name":"node_1","left":44,"top":27,"type":"start","id":"1564334138399","width":26,"height":26,"alt":true},{"name":"node_2","left":50,"top":295,"type":"end","id":"1564334139783","width":26,"height":26,"alt":true},{"name":"所有人可以审批","left":163,"top":43,"type":"node","id":"1564334153687","width":104,"height":56,"alt":true,"setInfo":{"NodeConfluenceType":"all","NodeDesignate":"ALL_USER","ThirdPartyUrl":"","NodeDesignateData":{"users":[],"roles":[]}}},{"name":"小于3的test可以审批","left":23,"top":141,"type":"node","id":"1564334154471","width":167,"height":76,"alt":true,"setInfo":{"NodeConfluenceType":"all","NodeDesignate":"SPECIAL_USER","ThirdPartyUrl":"","NodeDesignateData":{"users":["6ba79766-faa0-4259-8139-a4a6d35784e0"],"roles":[]}}},{"name":"大于3的admin可以审批","left":288,"top":146,"type":"node","id":"1564334155295","width":143,"height":56,"alt":true,"setInfo":{"NodeConfluenceType":"all","NodeDesignate":"SPECIAL_USER","ThirdPartyUrl":"","NodeDesignateData":{"users":["49df1602-f5f3-4d52-afb7-3802da619558"],"roles":[]}}},{"name":"默认","left":171,"top":291,"type":"node","id":"1564334156607","width":104,"height":36,"alt":true,"setInfo":{"NodeConfluenceType":"all","NodeDesignate":"ALL_USER","ThirdPartyUrl":"","NodeDesignateData":{"users":[],"roles":[]}}}],"lines":[{"type":"sl","from":"1564334138399","to":"1564334153687","id":"1564334158551","name":"","dash":false,"alt":true},{"type":"sl","from":"1564334153687","to":"1564334154471","id":"1564334159304","name":"","dash":false,"alt":true,"Compares":[{"FieldName":"DAYS","Operation":"<","Value":"3"}]},{"type":"sl","from":"1564334153687","to":"1564334155295","id":"1564334160383","name":"","dash":false,"alt":true,"Compares":[{"FieldName":"DAYS","Operation":">=","Value":"3"}]},{"type":"sl","from":"1564334154471","to":"1564334156607","id":"1564334161911","name":"","dash":false,"alt":true},{"type":"sl","from":"1564334155295","to":"1564334156607","id":"1564334163959","name":"","dash":false,"alt":true},{"type":"sl","from":"1564334156607","to":"1564334139783","id":"1564334165255","name":"","dash":false,"alt":true}],"areas":[],"initNum":16}', 'ef89f96a-af33-407c-b02e-897faf46ecf0', 0, 0, 0, 0, 0, '在连接线上可以设置分支条件', '2019-07-29 01:17:46', '', '', '2019-07-29 01:17:46', '', '', NULL, NULL);
INSERT INTO "public"."flowscheme" VALUES ('f11b7ef6-6da4-4cef-9e71-5e4e1454f30a', '1584630699021', '【研发小组】考核表', '', '', '', '{"title":"newFlow_1","nodes":[{"name":"node_1","left":116,"top":70,"type":"start","id":"1584630766237","width":26,"height":26,"alt":true},{"name":"node_2","left":118,"top":148,"type":"node","id":"1584630767445","width":104,"height":26,"alt":true,"setInfo":{"NodeName":"node_2","NodeCode":"node_2","NodeRejectType":"0","NodeDesignate":"ALL_USER","NodeConfluenceType":"all","ThirdPartyUrl":"","NodeDesignateData":{"users":[],"roles":[],"orgs":[]}}},{"name":"node_3","left":69,"top":223,"type":"end","id":"1584630769587","width":26,"height":26,"alt":true}],"lines":[{"type":"sl","from":"1584630766237","to":"1584630767445","id":"1584630772227","name":"","dash":false,"alt":true},{"type":"sl","from":"1584630767445","to":"1584630769587","id":"1584630773305","name":"","dash":false,"alt":true}],"areas":[],"initNum":7}', '0411376a-18fd-4f52-bffb-22ae0d3fa21d', 0, 0, 1, 0, 0, '只有可以看到【研发小组】的【管理员】才能看到', '2020-03-19 23:13:03', '49df1602-f5f3-4d52-afb7-3802da619558', 'admin', '2020-03-19 23:13:03', '', '', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL);
INSERT INTO "public"."flowscheme" VALUES ('fb1f3cac-a259-4969-9171-addbe22ab102', '1584631233711', '【研发小组】高层汇报', '', '', '', '{"title":"newFlow_1","nodes":[{"name":"node_1","left":52,"top":43,"type":"start","id":"1584631275414","width":26,"height":26,"alt":true},{"name":"node_2","left":57,"top":113,"type":"node","id":"1584631276803","width":104,"height":26,"alt":true,"setInfo":{"NodeName":"node_2","NodeCode":"node_2","NodeRejectType":"0","NodeDesignate":"ALL_USER","NodeConfluenceType":"all","ThirdPartyUrl":"","NodeDesignateData":{"users":[],"roles":[],"orgs":[]}}},{"name":"node_3","left":60,"top":192,"type":"end","id":"1584631278737","width":26,"height":26,"alt":true}],"lines":[{"type":"sl","from":"1584631275414","to":"1584631276803","id":"1584631280569","name":"","dash":false,"alt":true},{"type":"sl","from":"1584631276803","to":"1584631278737","id":"1584631281701","name":"","dash":false,"alt":true}],"areas":[],"initNum":7}', '0411376a-18fd-4f52-bffb-22ae0d3fa21d', 0, 0, 1, 0, 0, '只有可以看到【研发小组】的【管理员】才能看到', '2020-03-19 23:21:43', '49df1602-f5f3-4d52-afb7-3802da619558', 'admin', '2020-03-19 23:21:43', '', '', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL);

-- ----------------------------
-- Table structure for form
-- ----------------------------
DROP TABLE IF EXISTS "public"."form";
CREATE TABLE "public"."form" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(200) COLLATE "pg_catalog"."default",
  "frmtype" int4 NOT NULL,
  "webid" varchar(200) COLLATE "pg_catalog"."default",
  "fields" int4 NOT NULL,
  "contentdata" text COLLATE "pg_catalog"."default",
  "contentparse" text COLLATE "pg_catalog"."default",
  "content" text COLLATE "pg_catalog"."default",
  "sortcode" int4 NOT NULL,
  "deletemark" int4 NOT NULL,
  "dbname" varchar(50) COLLATE "pg_catalog"."default",
  "disabled" int4 NOT NULL,
  "description" varchar(200) COLLATE "pg_catalog"."default",
  "createdate" timestamp(6) NOT NULL,
  "createuserid" varchar(50) COLLATE "pg_catalog"."default",
  "createusername" varchar(50) COLLATE "pg_catalog"."default",
  "modifydate" timestamp(6),
  "modifyuserid" varchar(50) COLLATE "pg_catalog"."default",
  "modifyusername" varchar(50) COLLATE "pg_catalog"."default",
  "orgid" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."form"."id" IS '表单模板Id';
COMMENT ON COLUMN "public"."form"."name" IS '表单名称';
COMMENT ON COLUMN "public"."form"."frmtype" IS '表单类型，0：默认动态表单；1：Web自定义表单';
COMMENT ON COLUMN "public"."form"."webid" IS '系统页面标识，当表单类型为用Web自定义的表单时，需要标识加载哪个页面';
COMMENT ON COLUMN "public"."form"."fields" IS '字段个数';
COMMENT ON COLUMN "public"."form"."contentdata" IS '表单中的控件属性描述';
COMMENT ON COLUMN "public"."form"."contentparse" IS '表单控件位置模板';
COMMENT ON COLUMN "public"."form"."content" IS '表单原html模板未经处理的';
COMMENT ON COLUMN "public"."form"."sortcode" IS '排序码';
COMMENT ON COLUMN "public"."form"."deletemark" IS '删除标记';
COMMENT ON COLUMN "public"."form"."dbname" IS '数据库名称';
COMMENT ON COLUMN "public"."form"."disabled" IS '有效';
COMMENT ON COLUMN "public"."form"."description" IS '备注';
COMMENT ON COLUMN "public"."form"."createdate" IS '创建时间';
COMMENT ON COLUMN "public"."form"."createuserid" IS '创建用户主键';
COMMENT ON COLUMN "public"."form"."createusername" IS '创建用户';
COMMENT ON COLUMN "public"."form"."modifydate" IS '修改时间';
COMMENT ON COLUMN "public"."form"."modifyuserid" IS '修改用户主键';
COMMENT ON COLUMN "public"."form"."modifyusername" IS '修改用户';
COMMENT ON COLUMN "public"."form"."orgid" IS '所属部门';
COMMENT ON TABLE "public"."form" IS '表单模板表';

-- ----------------------------
-- Records of form
-- ----------------------------
INSERT INTO "public"."form" VALUES ('0411376a-18fd-4f52-bffb-22ae0d3fa21d', '【研发小组】新人报到', 0, '', 0, '[{"type":"text","name":"USERNAME","title":"USERNAME","value":"","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"USERNAME\" value=\"\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"}]', '<p>你的姓名：{USERNAME}</p>', '<p>你的姓名：<input name="leipiNewField" type="text" title="USERNAME" value="" leipiplugins="text" orghide="0" orgalign="left" orgwidth="150" orgtype="text" style="text-align: left; width: 150px;"/></p>', 1, 0, NULL, 0, '这个表单只有【研发小组】权限的人可以看到', '2020-03-18 22:56:02', '', '', '2020-03-18 22:56:44', '', '', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b');
INSERT INTO "public"."form" VALUES ('318bb233-c9df-4374-9937-e55b71fbcf99', '【西南片区】报道', 0, '', 0, '[{"type":"text","name":"USERNAME","title":"USERNAME","value":"","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"USERNAME\" value=\"\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"}]', '<p>{USERNAME}，欢迎来到西南大区</p>', '<p><input name="leipiNewField" type="text" title="USERNAME" value="" leipiplugins="text" orghide="0" orgalign="left" orgwidth="150" orgtype="text" style="text-align: left; width: 150px;"/>，欢迎来到西南大区</p>', 1, 0, NULL, 0, '只有可以访问【西南片区】的用户可以看到', '2020-03-18 22:58:44', '', '', '2020-03-18 22:58:44', '', '', '60620558-89a2-4b28-8637-52f514773725');
INSERT INTO "public"."form" VALUES ('8faff4e5-b729-44d2-ac26-e899a228f63d', '系统内置的复杂请假条表单', 1, 'FrmLeaveReq', 0, '', '', '', 0, 0, '', 0, '企业版内置的复杂请假条表单', '2019-07-29 01:03:36', '', '', '2019-07-29 01:03:36', '', '', NULL);
INSERT INTO "public"."form" VALUES ('b08bb00f-e1df-44f8-904f-58ee5b1f4eb4', '领料单', 0, '', 0, '[{"leipiplugins":"select","name":"TOOLS","title":"TOOLS","size":"1","orgwidth":"150","style":"width: 150px;","value":"电脑,平板,手机,签字笔","selected":"selected","content":"<span leipiplugins=\"select\"><select name=\"leipiNewField\" title=\"TOOLS\" leipiplugins=\"select\" size=\"1\" orgwidth=\"150\" style=\"width: 150px;\"><option value=\"电脑\" selected=\"selected\">电脑</option><option value=\"平板\">平板</option><option value=\"手机\">手机</option><option value=\"签字笔\">签字笔</option></select>&nbsp;&nbsp;</span>"},{"type":"text","name":"NUMBERS","title":"NUMBERS","value":"1","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"int","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"NUMBERS\" value=\"1\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"int\" style=\"text-align: left; width: 150px;\"/>"},{"name":"APPLY_REASON","title":"APPLY_REASON","leipiplugins":"textarea","value":"","orgrich":"0","orgfontsize":"","orgwidth":"300","orgheight":"80","style":"width:300px;height:80px;","content":"<textarea title=\"APPLY_REASON\" name=\"leipiNewField\" leipiplugins=\"textarea\" value=\"\" orgrich=\"0\" orgfontsize=\"\" orgwidth=\"300\" orgheight=\"80\" style=\"width:300px;height:80px;\"></textarea>"},{"leipiplugins":"checkboxs","name":"","title":"NEEDRETURN","parse_name":"checkboxs_0","value":"归还,无需归还","content":"<span leipiplugins=\"checkboxs\"  title=\"NEEDRETURN\"><input type=\"checkbox\" name=\"leipiNewField\" value=\"归还\"  checked=\"checked\"/>归还&nbsp;<input type=\"checkbox\" name=\"leipiNewField\" value=\"无需归还\"  />无需归还&nbsp;</span>","options":[{"name":"leipiNewField","value":"归还","checked":"checked","type":"checkbox"},{"name":"leipiNewField","value":"无需归还","type":"checkbox"}]}]', '<p style="text-align: center;"><span style="font-size: 36px;">领料单</span></p><p><span style="font-size: 36px;"><br/></span></p><table data-sort="sortDisabled"><tbody><tr class="firstRow"><td width="534" valign="top" style="word-break: break-all;"><span style="font-size: 24px;">名目</span></td><td width="534" valign="top" style="word-break: break-all;"><span style="font-size: 24px;">数量</span></td><td width="534" valign="top" style="word-break: break-all;"><span style="font-size: 24px;">说明</span></td></tr><tr><td width="534" valign="top">{TOOLS}</td><td width="534" valign="top">{NUMBERS}</td><td width="534" valign="top">{APPLY_REASON}</td></tr><tr><td valign="top" rowspan="1" colspan="3" style="word-break: break-all;">{checkboxs_0}</td></tr></tbody></table><p style="text-align: center;"><br/></p>', '<p style="text-align: center;"><span style="font-size: 36px;">领料单</span></p><p><span style="font-size: 36px;"><br/></span></p><table data-sort="sortDisabled"><tbody><tr class="firstRow"><td width="534" valign="top" style="word-break: break-all;"><span style="font-size: 24px;">名目</span></td><td width="534" valign="top" style="word-break: break-all;"><span style="font-size: 24px;">数量</span></td><td width="534" valign="top" style="word-break: break-all;"><span style="font-size: 24px;">说明</span></td></tr><tr><td width="534" valign="top">{|-<span leipiplugins="select"><select name="leipiNewField" title="TOOLS" leipiplugins="select" size="1" orgwidth="150" style="width: 150px;"><option value="电脑" selected="selected">电脑</option><option value="平板">平板</option><option value="手机">手机</option><option value="签字笔">签字笔</option></select>&nbsp;&nbsp;</span>-|}</td><td width="534" valign="top"><input name="leipiNewField" type="text" title="NUMBERS" value="1" leipiplugins="text" orghide="0" orgalign="left" orgwidth="150" orgtype="int" style="text-align: left; width: 150px;"/></td><td width="534" valign="top"><textarea title="APPLY_REASON" name="leipiNewField" leipiplugins="textarea" value="" orgrich="0" orgfontsize="" orgwidth="300" orgheight="80" style="width:300px;height:80px;"></textarea></td></tr><tr><td valign="top" rowspan="1" colspan="3" style="word-break: break-all;">{|-<span leipiplugins="checkboxs"  title="NEEDRETURN"><input type="checkbox" name="leipiNewField" value="归还"  checked="checked"/>归还&nbsp;<input type="checkbox" name="leipiNewField" value="无需归还"  />无需归还&nbsp;</span>-|}</td></tr></tbody></table><p style="text-align: center;"><br/></p>', 0, 0, '', 0, '带有选择框文本框复选框等的领料单据', '2019-07-29 01:13:02', '', '', '2019-07-29 01:13:02', '', '', NULL);
INSERT INTO "public"."form" VALUES ('ef89f96a-af33-407c-b02e-897faf46ecf0', '请假条表单', 0, '', 0, '[{"type":"text","name":"REASON","title":"REASON","value":"身体原因","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"REASON\" value=\"身体原因\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"},{"leipiplugins":"select","name":"DAYS","title":"DAYS","size":"1","orgwidth":"150","style":"width: 150px;","value":"1,3,5,10","selected":"selected","content":"<span leipiplugins=\"select\"><select name=\"leipiNewField\" title=\"DAYS\" leipiplugins=\"select\" size=\"1\" orgwidth=\"150\" style=\"width: 150px;\"><option value=\"1\" selected=\"selected\">1</option><option value=\"3\">3</option><option value=\"5\">5</option><option value=\"10\">10</option></select>&nbsp;&nbsp;</span>"},{"type":"text","name":"CUSTOME_NAME","title":"CUSTOME_NAME","value":"玉宝","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"CUSTOME_NAME\" value=\"玉宝\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"}]', '<p style="text-align: center;"><span style="font-size: 36px;">请假条</span></p><p><span style="font-size: 36px;"><br/></span></p><p style="text-align: center;">因{REASON}，本人想请假{DAYS}天，望领导批准！</p><p><br/></p><p style="text-align: center;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;谢谢！</p><p><br/></p><p style="text-align: right;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 申请人：{CUSTOME_NAME}</p>', '<p style="text-align: center;"><span style="font-size: 36px;">请假条</span></p><p><span style="font-size: 36px;"><br/></span></p><p style="text-align: center;">因<input name="leipiNewField" type="text" title="REASON" value="身体原因" leipiplugins="text" orghide="0" orgalign="left" orgwidth="150" orgtype="text" style="text-align: left; width: 150px;"/>，本人想请假{|-<span leipiplugins="select"><select name="leipiNewField" title="DAYS" leipiplugins="select" size="1" orgwidth="150" style="width: 150px;"><option value="1" selected="selected">1</option><option value="3">3</option><option value="5">5</option><option value="10">10</option></select>&nbsp;&nbsp;</span>-|}天，望领导批准！</p><p><br/></p><p style="text-align: center;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;谢谢！</p><p><br/></p><p style="text-align: right;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 申请人：<input name="leipiNewField" type="text" title="CUSTOME_NAME" value="玉宝" leipiplugins="text" orghide="0" orgalign="left" orgwidth="150" orgtype="text" style="text-align: left; width: 150px;"/></p>', 0, 0, '', 0, '带有选择框文本框的请假条', '2019-07-29 01:07:03', '', '', '2019-07-29 01:07:03', '', '', NULL);
INSERT INTO "public"."form" VALUES ('febe218d-21a6-44b6-b7ce-b83e73556ad9', '审批流程', 0, 'FrmLeaveReq', 0, '[{"type":"text","name":"姓名","title":"姓名","value":"","leipiplugins":"text","orghide":"0","orgalign":"left","orgwidth":"150","orgtype":"text","style":"text-align: left; width: 150px;","content":"<input name=\"leipiNewField\" type=\"text\" title=\"姓名\" value=\"\" leipiplugins=\"text\" orghide=\"0\" orgalign=\"left\" orgwidth=\"150\" orgtype=\"text\" style=\"text-align: left; width: 150px;\"/>"}]', '<p>{姓名}</p>', '<p><input name="leipiNewField" type="text" title="姓名" value="" leipiplugins="text" orghide="0" orgalign="left" orgwidth="150" orgtype="text" style="text-align: left; width: 150px;"/></p>', 0, 0, '', 0, '', '2019-10-29 13:57:35', '', '', '2019-10-29 13:57:35', '', '', NULL);

-- ----------------------------
-- Table structure for frmleavereq
-- ----------------------------
DROP TABLE IF EXISTS "public"."frmleavereq";
CREATE TABLE "public"."frmleavereq" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "username" varchar(10) COLLATE "pg_catalog"."default" NOT NULL,
  "requesttype" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "startdate" date NOT NULL,
  "starttime" timestamp(6),
  "enddate" date NOT NULL,
  "endtime" timestamp(6),
  "requestcomment" text COLLATE "pg_catalog"."default",
  "attachment" text COLLATE "pg_catalog"."default",
  "createdate" timestamp(6) NOT NULL,
  "createuserid" varchar(50) COLLATE "pg_catalog"."default",
  "createusername" varchar(50) COLLATE "pg_catalog"."default",
  "flowinstanceid" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."frmleavereq"."id" IS 'ID';
COMMENT ON COLUMN "public"."frmleavereq"."username" IS '请假人姓名';
COMMENT ON COLUMN "public"."frmleavereq"."requesttype" IS '请假分类，病假，事假，公休等';
COMMENT ON COLUMN "public"."frmleavereq"."startdate" IS '开始日期';
COMMENT ON COLUMN "public"."frmleavereq"."starttime" IS '开始时间';
COMMENT ON COLUMN "public"."frmleavereq"."enddate" IS '结束日期';
COMMENT ON COLUMN "public"."frmleavereq"."endtime" IS '结束时间';
COMMENT ON COLUMN "public"."frmleavereq"."requestcomment" IS '请假说明';
COMMENT ON COLUMN "public"."frmleavereq"."attachment" IS '附件，用于提交病假证据等';
COMMENT ON COLUMN "public"."frmleavereq"."createdate" IS '创建时间';
COMMENT ON COLUMN "public"."frmleavereq"."createuserid" IS '创建用户主键';
COMMENT ON COLUMN "public"."frmleavereq"."createusername" IS '创建用户';
COMMENT ON COLUMN "public"."frmleavereq"."flowinstanceid" IS '所属流程实例';
COMMENT ON TABLE "public"."frmleavereq" IS '模拟一个自定页面的表单，该数据会关联到流程实例FrmData，可用于复杂页面的设计及后期的数据分析';

-- ----------------------------
-- Records of frmleavereq
-- ----------------------------
INSERT INTO "public"."frmleavereq" VALUES ('06307008-1dd9-48ad-a516-bcf4714cc9a7', '1', '病假', '2019-10-07', '2019-10-29 09:26:52', '2019-10-27', '2019-10-29 09:26:54', '111', '', '2019-10-29 17:27:06', '', '', 'd4f8d2b9-6374-4c10-8d3c-1ca540bc309b');
INSERT INTO "public"."frmleavereq" VALUES ('59b5b72f-b8fb-44d4-bb24-319d02b2ab80', '李玉宝', '事假', '2019-07-08', '2019-07-28 17:23:14', '2019-07-24', '2019-07-28 17:23:18', '太累了，就是想休息一下', '', '2019-07-29 01:23:58', '', '', '0ae5abe6-f571-4e08-b264-667dc27c5025');

-- ----------------------------
-- Table structure for module
-- ----------------------------
DROP TABLE IF EXISTS "public"."module";
CREATE TABLE "public"."module" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "cascadeid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "url" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "hotkey" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "isleaf" int2 NOT NULL,
  "isautoexpand" int2 NOT NULL,
  "iconname" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "status" int4 NOT NULL,
  "parentname" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "vector" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "sortno" int4 NOT NULL,
  "parentid" varchar(50) COLLATE "pg_catalog"."default",
  "code" varchar(50) COLLATE "pg_catalog"."default",
  "issys" int2 NOT NULL,
  "keepalive" int2
)
;
COMMENT ON COLUMN "public"."module"."id" IS '功能模块流水号';
COMMENT ON COLUMN "public"."module"."cascadeid" IS '节点语义ID';
COMMENT ON COLUMN "public"."module"."name" IS '功能模块名称';
COMMENT ON COLUMN "public"."module"."url" IS '主页面URL';
COMMENT ON COLUMN "public"."module"."hotkey" IS '热键';
COMMENT ON COLUMN "public"."module"."isleaf" IS '是否叶子节点';
COMMENT ON COLUMN "public"."module"."isautoexpand" IS '是否自动展开';
COMMENT ON COLUMN "public"."module"."iconname" IS '节点图标文件名称';
COMMENT ON COLUMN "public"."module"."status" IS '当前状态';
COMMENT ON COLUMN "public"."module"."parentname" IS '父节点名称';
COMMENT ON COLUMN "public"."module"."vector" IS '矢量图标';
COMMENT ON COLUMN "public"."module"."sortno" IS '排序号';
COMMENT ON COLUMN "public"."module"."parentid" IS '父节点流水号';
COMMENT ON COLUMN "public"."module"."issys" IS '是否为系统模块';
COMMENT ON COLUMN "public"."module"."keepalive" IS '前端是否缓存';
COMMENT ON TABLE "public"."module" IS '功能模块表';

-- ----------------------------
-- Records of module
-- ----------------------------
INSERT INTO "public"."module" VALUES ('0031262c-689c-4b96-bae2-2c9d67076ade', '.0.1.9.', '流程设计', '/flowSchemes/index', '', 0, 0, 'layui-icon-engine', 0, '基础配置', '', 6, '7580672f-a390-4bb6-982d-9a4570cb5199', 'FlowScheme', 1, NULL);
INSERT INTO "public"."module" VALUES ('069475e3-c997-487a-9f29-e6a864c5c1d4', '.0.2.', '流程中心', '/', '', 0, 0, 'layui-icon-senior', 0, '根节点', '', 3, NULL, NULL, 1, NULL);
INSERT INTO "public"."module" VALUES ('15a3a401-e8eb-4d8b-9035-ecd5f53ed0c9', '.0.4.', '仓储中心', '/', '', 0, 0, '', 0, '根节点', '', 2, NULL, '', 0, NULL);
INSERT INTO "public"."module" VALUES ('37bb9414-19a0-4223-9056-71f8c758a930', '.0.2.5.', '已处理流程', '/flowinstances/disposed', '', 0, 0, 'layui-icon-ok-circle', 0, '流程中心', '', 3, '069475e3-c997-487a-9f29-e6a864c5c1d4', 'FlowInstanceDisposed', 1, NULL);
INSERT INTO "public"."module" VALUES ('4abafc83-c8f5-452f-9882-e113a86e7a3e', '.0.2.6.', '待处理流程', '/flowinstances/wait', '', 0, 0, 'layui-icon-help', 0, '流程中心', '', 1, '069475e3-c997-487a-9f29-e6a864c5c1d4', 'FlowInstanceWait', 1, NULL);
INSERT INTO "public"."module" VALUES ('6a9e1346-0c01-44d2-8eb1-f929fdab542a', '.0.1.10.', '部门管理', '/OrgManager/Index', '', 0, 0, 'layui-icon-group', 0, '基础配置', '', 4, '7580672f-a390-4bb6-982d-9a4570cb5199', 'Org', 1, NULL);
INSERT INTO "public"."module" VALUES ('7580672f-a390-4bb6-982d-9a4570cb5199', '.0.1.', '基础配置', ' /', '', 0, 0, 'layui-icon-set-fill', 0, '根节点', '', 1, NULL, NULL, 1, NULL);
INSERT INTO "public"."module" VALUES ('7bc7e527-478d-49fd-868d-5f31951586f5', '.0.3.1.', '系统日志', '/SysLogs/Index', '', 0, 0, 'layui-icon-theme', 0, '消息日志', '', 1, 'b19bce90-5508-43b6-93ed-cd9ff9e356a9', 'SysLog', 1, NULL);
INSERT INTO "public"."module" VALUES ('7bc7e527-478d-49fd-868d-5f31951586f6', '.0.3.2.', '我的消息', '/SysMessages/Index', '', 0, 0, 'layui-icon-theme', 0, '消息日志', '', 2, 'b19bce90-5508-43b6-93ed-cd9ff9e356a9', 'SysMessage', 1, NULL);
INSERT INTO "public"."module" VALUES ('907a24c6-3c95-4073-8f90-ea7ec42c63f7', '.0.1.19.', '定时任务', '/OpenJobs/Index', '', 0, 0, 'layui-icon-time', 0, '基础配置', '', 2, '7580672f-a390-4bb6-982d-9a4570cb5199', 'OpenJob', 1, NULL);
INSERT INTO "public"."module" VALUES ('92b00259-2d15-43e7-9321-adffb29e8bf2', '.0.1.11.', '表单设计', '/forms/index', '', 0, 0, 'layui-icon-theme', 0, '基础配置', '', 5, '7580672f-a390-4bb6-982d-9a4570cb5199', 'Form', 1, NULL);
INSERT INTO "public"."module" VALUES ('9486ff22-b696-4d7f-8093-8a3e53c45453', '.0.2.7.', '我的流程', '/flowInstances/Index', '', 0, 0, 'layui-icon-share', 0, '流程中心', '', 2, '069475e3-c997-487a-9f29-e6a864c5c1d4', 'FlowInstance', 1, NULL);
INSERT INTO "public"."module" VALUES ('98a949e8-8704-40a7-b9a1-c0e8801e4057', '.0.4.1.', '入库订单', '/wmsinboundordertbls/index', '', 0, 0, '', 0, '仓储中心', '', 1, '15a3a401-e8eb-4d8b-9035-ecd5f53ed0c9', 'WmsInboundOrderTbl', 0, NULL);
INSERT INTO "public"."module" VALUES ('9a87c0fa-9172-42a1-9505-7492433dcb8e', '.0.1.16.', '数据权限', '/dataprivilegerules/index', '', 0, 0, 'layui-icon-auz', 0, '基础配置', '', 1, '7580672f-a390-4bb6-982d-9a4570cb5199', 'DataPrivilegeRule', 0, NULL);
INSERT INTO "public"."module" VALUES ('a94d5648-c2a9-405e-ba6f-f1602ec9b807', '.0.1.17.', '字典分类', '/Categories/Index', '', 0, 0, '', 0, '基础配置', '', 7, '7580672f-a390-4bb6-982d-9a4570cb5199', 'Category', 0, NULL);
INSERT INTO "public"."module" VALUES ('b19bce90-5508-43b6-93ed-cd9ff9e356a9', '.0.3.', '消息日志', ' /', '', 0, 0, 'layui-icon-set-fill', 0, '根节点', '', 4, NULL, NULL, 1, NULL);
INSERT INTO "public"."module" VALUES ('bc80478d-0547-4437-9cff-be4b40144bdf', '.0.1.13.', '模块管理', '/ModuleManager/Index', '', 0, 0, 'layui-icon-tabs', 0, '基础配置', '', 1, '7580672f-a390-4bb6-982d-9a4570cb5199', 'Module', 1, NULL);
INSERT INTO "public"."module" VALUES ('bedb41a2-f310-4775-af99-01be08adda93', '.0.1.14.', '角色管理', '/RoleManager/Index', '', 0, 0, 'layui-icon-user', 0, '基础配置', '', 2, '7580672f-a390-4bb6-982d-9a4570cb5199', 'Role', 1, NULL);
INSERT INTO "public"."module" VALUES ('e8dc5db6-4fc4-4795-a1cc-681cbcceec91', '.0.1.3.', '资源管理', '/Resources/Index', '', 0, 0, 'layui-icon-cellphone', 0, '基础配置', '', 8, '7580672f-a390-4bb6-982d-9a4570cb5199', 'Resource', 0, NULL);
INSERT INTO "public"."module" VALUES ('ef386d5d-cd58-43c0-a4ab-80afd0dbcd6c', '.0.1.15.', '用户管理', '/UserManager/Index', '', 0, 0, 'layui-icon-friends', 0, '基础配置', '', 3, '7580672f-a390-4bb6-982d-9a4570cb5199', 'User', 1, NULL);

-- ----------------------------
-- Table structure for moduleelement
-- ----------------------------
DROP TABLE IF EXISTS "public"."moduleelement";
CREATE TABLE "public"."moduleelement" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "domid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "attr" text COLLATE "pg_catalog"."default" NOT NULL,
  "script" text COLLATE "pg_catalog"."default" NOT NULL,
  "icon" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "class" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "remark" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "sort" int4 NOT NULL,
  "moduleid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "typename" varchar(20) COLLATE "pg_catalog"."default",
  "typeid" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."moduleelement"."id" IS '流水号';
COMMENT ON COLUMN "public"."moduleelement"."domid" IS 'DOM ID';
COMMENT ON COLUMN "public"."moduleelement"."name" IS '名称';
COMMENT ON COLUMN "public"."moduleelement"."attr" IS '元素附加属性';
COMMENT ON COLUMN "public"."moduleelement"."script" IS '元素调用脚本';
COMMENT ON COLUMN "public"."moduleelement"."icon" IS '元素图标';
COMMENT ON COLUMN "public"."moduleelement"."class" IS '元素样式';
COMMENT ON COLUMN "public"."moduleelement"."remark" IS '备注';
COMMENT ON COLUMN "public"."moduleelement"."sort" IS '排序字段';
COMMENT ON COLUMN "public"."moduleelement"."moduleid" IS '功能模块Id';
COMMENT ON COLUMN "public"."moduleelement"."typename" IS '分类名称';
COMMENT ON COLUMN "public"."moduleelement"."typeid" IS '分类ID';
COMMENT ON TABLE "public"."moduleelement" IS '模块元素表(需要权限控制的按钮)';

-- ----------------------------
-- Records of moduleelement
-- ----------------------------
INSERT INTO "public"."moduleelement" VALUES ('054e9699-7828-4b8b-a28b-d7ae45ed3306', 'btnEdit', '编辑', '', '', 'layui-icon-edit', 'layui-btn-normal', '', 2, '98a949e8-8704-40a7-b9a1-c0e8801e4057', '', '');
INSERT INTO "public"."moduleelement" VALUES ('06fe4738-b4f4-4ecf-b9da-07dd3bb26cb3', 'btnDel', '撤销订单', '', '', 'layui-icon-delete', 'layui-btn-danger', '', 3, '98a949e8-8704-40a7-b9a1-c0e8801e4057', '', '');
INSERT INTO "public"."moduleelement" VALUES ('0d25438e-1436-48e0-aedf-0f1690693281', 'btnRoleAccessUser', '添加角色用户', '', 'assignRoleUser(this)', 'layui-icon-search', 'layui-btn-normal', '添加角色用户', 4, 'bedb41a2-f310-4775-af99-01be08adda93', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('0d25438e-1436-48e0-aedf-0f1690693282', 'btnAccessModule', '为角色分配模块', '', 'assignRoleModule(this)', 'layui-icon-search', 'layui-btn-normal', '为角色分配模块', 4, 'bedb41a2-f310-4775-af99-01be08adda93', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('13617796-049c-4ae4-a62b-1ca84002b273', 'btnDelCategory', '删除分类', '', '', 'layui-icon-delete', 'layui-btn-danger', '', 0, 'a94d5648-c2a9-405e-ba6f-f1602ec9b807', '', '');
INSERT INTO "public"."moduleelement" VALUES ('15a4f88c-4fae-4cab-ba2f-0cbd2cca8736', 'btnAssignReource', '为角色分配资源', '', 'openRoleReourceAccess(this)', 'layui-icon-search', 'layui-btn-normal', '为角色分配资源', 3, 'bedb41a2-f310-4775-af99-01be08adda93', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('17ae4fd4-ab4e-439e-ba1d-2a53b46d112b', 'btnDel', '删除', '', 'del()', 'layui-icon-delete', 'layui-btn-danger', '', 2, '0031262c-689c-4b96-bae2-2c9d67076ade', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('18cc3217-28a6-49b2-9a20-080230065984', 'btnEdit', '编辑', '', 'edit()', 'layui-icon-edit', 'layui-btn-normal', '', 1, '0031262c-689c-4b96-bae2-2c9d67076ade', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('1a473afd-cbd4-41e9-9471-81f9435aaabe', 'btnEdit', '编辑', ' ', 'edit()', 'layui-icon-edit', 'layui-btn-normal', '编辑分类', 2, 'a94d5648-c2a9-405e-ba6f-f1602ec9b807', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('1c870438-4260-43a5-8996-a6e1dc8bbf6a', 'btnAdd', '添加', '', 'add()', 'layui-icon-add-1', 'layui-btn-normal', '添加部门', 0, '6a9e1346-0c01-44d2-8eb1-f929fdab542a', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('1c870438-4260-43a5-8996-a6e1dc8bbf6b', 'btnAssignOrgUser', '分配用户', '', 'assignOrgUser(this)', 'layui-icon-add-1', 'layui-btn-normal', '分配用户', 0, '6a9e1346-0c01-44d2-8eb1-f929fdab542a', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('1c9acc3e-a40d-4d07-b495-6e60eb9b71b9', 'btnEdit', '编辑', '', 'edit()', 'layui-icon-edit', 'layui-btn-normal', '编辑角色', 1, 'bedb41a2-f310-4775-af99-01be08adda93', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('2d595a2a-5de5-479e-a331-b53c799a6b10', 'btnAdd', '添加', '', 'add()', 'layui-icon-add-1', 'layui-btn-normal', '添加分类', 1, 'a94d5648-c2a9-405e-ba6f-f1602ec9b807', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('2d595a2a-5de5-479e-a331-b53c799a6b11', 'btnAdd', '添加', '', 'add()', 'layui-icon-add-1', 'layui-btn-normal', '添加定时任务', 1, '907a24c6-3c95-4073-8f90-ea7ec42c63f7', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('2feefce1-e3d8-42ac-b811-2352679628da', 'btnDel', '删除', '', 'del()', 'layui-icon-delete', 'layui-btn-danger', '刪除用戶', 2, 'ef386d5d-cd58-43c0-a4ab-80afd0dbcd6c', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('2feefce1-e3d8-42ac-b811-2352679628dd', 'btnDel', '删除', '', 'del()', 'layui-icon-delete', 'layui-btn-danger', '刪除定时任务', 3, '907a24c6-3c95-4073-8f90-ea7ec42c63f7', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('34730f5a-d307-457b-9041-5f7de30abfa9', 'btnEdit', '编辑', '', 'edit()', 'layui-icon-edit', 'layui-btn-normal', '编辑用户', 1, 'ef386d5d-cd58-43c0-a4ab-80afd0dbcd6c', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('34730f5a-d307-457b-9041-5f7de30abfaa', 'btnEdit', '编辑', '', 'edit()', 'layui-icon-edit', 'layui-btn-normal', '编辑定时任务', 2, '907a24c6-3c95-4073-8f90-ea7ec42c63f7', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('362d1eda-c85e-4b14-a80a-b923291e08de', 'btnAdd', '添加', '', 'add()', 'layui-icon-add-1', 'layui-btn-normal', '添加', 0, 'f0f06b8f-0a86-487c-8b0e-0a12573ccd46', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('38109ca0-32ec-44bd-a243-017e591b532b', 'btnEditStock', '编辑', ' ', 'edit()', 'layui-icon-edit', 'layui-btn-normal', '编辑进出库', 0, '89c3bfbe-246f-4112-8eb1-b6789da54202', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('3dc0ec4d-bf86-4bae-9ec0-1d6c2403fb99', 'btnAdd', '添加', '', 'add()', 'layui-icon-add-1', 'layui-btn-normal', '', 1, '92b00259-2d15-43e7-9321-adffb29e8bf2', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('44075557-496e-4dde-bb75-7b69f51ab4fe', 'btnEdit', '编辑', '', 'edit()', 'layui-icon-edit', 'layui-btn-normal', '编辑模块', 2, 'bc80478d-0547-4437-9cff-be4b40144bdf', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('4bfa8ea0-6b0d-426f-8687-b654575ca780', 'btnEdit', '编辑', '', 'edit()', 'layui-icon-edit', 'layui-btn-normal', '编辑资源', 2, 'e8dc5db6-4fc4-4795-a1cc-681cbcceec91', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('4f2737db-633f-4946-8a71-b08b9885f151', 'btnEdit', '编辑', '', 'edit()', 'layui-icon-edit', 'layui-btn-normal', '', 2, '92b00259-2d15-43e7-9321-adffb29e8bf2', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('50c9df24-b233-42cb-9a0d-4ce158c75f86', 'btnAdd', '添加', '', 'add()', 'layui-icon-add-1', 'layui-btn-normal', '添加用戶', 0, 'ef386d5d-cd58-43c0-a4ab-80afd0dbcd6c', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('584c7a3b-d28a-47b4-8648-7797d05d83d1', 'btnDel', '删除', '', 'del()', 'layui-icon-delete', 'layui-btn-danger', '', 3, '9486ff22-b696-4d7f-8093-8a3e53c45453', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('5ed1681c-13d2-4c87-8675-a8d95c0b40ae', 'btnAddMenu', '添加菜单', '', 'assignButton()', 'layui-icon-add-1', 'layui-btn-normal', '为模块分配按钮', 4, 'bc80478d-0547-4437-9cff-be4b40144bdf', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('5ed1681c-13d2-4c87-8676-a8d95c0b40ae', 'btnEditMenu', '编辑菜单', '', '', 'layui-icon-add-1', 'layui-btn-normal', '编辑菜单', 5, 'bc80478d-0547-4437-9cff-be4b40144bdf', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('5ed1681c-13d2-4c87-8677-a8d95c0b40ae', 'btnDelMenu', '删除菜单', '', '', 'layui-icon-delete', 'layui-btn-danger', '', 6, 'bc80478d-0547-4437-9cff-be4b40144bdf', '', '');
INSERT INTO "public"."moduleelement" VALUES ('645b40ac-4223-44a7-aab4-66eb56cf9864', 'btnAdd', '添加', '', 'add()', 'layui-icon-add-1', 'layui-btn-normal', '添加角色', 0, 'bedb41a2-f310-4775-af99-01be08adda93', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('68484265-7802-4f06-b024-33e8b2f2edcf', 'btnAdd', '新的申请', '', 'add()', 'layui-icon-add-1', 'layui-btn-normal', '申请物品', 0, '9486ff22-b696-4d7f-8093-8a3e53c45453', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('68fc793f-069f-43e1-a012-42ac2d7c585c', 'btnDel', '删除', '', 'del()', 'layui-icon-delete', 'layui-btn-danger', '删除角色', 2, 'bedb41a2-f310-4775-af99-01be08adda93', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('6c814946-db5c-48bd-84dd-b1c38196ad74', 'btnAdd', '添加模版', '', 'add()', 'layui-icon-add-1', 'layui-btn-normal', '', 0, '0031262c-689c-4b96-bae2-2c9d67076ade', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('6db928fe-93df-460f-9472-8bb0b6cae52c', 'btnAdd', '添加', '', 'add()', 'layui-icon-add-1', 'layui-btn-normal', '添加进出库', 0, '89c3bfbe-246f-4112-8eb1-b6789da54202', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('79dcd3eb-3aaf-4e08-83c9-713d8ff446fe', 'btnVerification', '处理', '', 'verificationForm()', 'layui-icon-triangle-r', 'layui-btn-normal', '', 1, '4abafc83-c8f5-452f-9882-e113a86e7a3e', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('7b2b1ffb-398b-4f7b-83da-8f484e1bcea0', 'btnDel', '删除', '', 'del()', 'layui-icon-delete', 'layui-btn-danger', '删除部门', 2, '6a9e1346-0c01-44d2-8eb1-f929fdab542a', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('7f071c63-1620-4486-9264-5806b2e63218', 'btnAccessRole', '为用户分配角色', '', 'openUserRoleAccess(this)', 'layui-icon-search', 'layui-btn-normal', '为用户分配角色', 5, 'ef386d5d-cd58-43c0-a4ab-80afd0dbcd6c', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('816b12b3-e916-446d-a2fa-329cfd13c831', 'btnDetail', '进度详情', '', '', 'layui-icon-search', 'layui-btn-normal', '', 4, '9486ff22-b696-4d7f-8093-8a3e53c45453', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('81ce1abe-209d-4e4c-a8d2-efbc6a3b45ba', 'btnAdd', '添加', '', '', 'layui-icon-add-1', 'layui-btn-normal', '', 1, '9a87c0fa-9172-42a1-9505-7492433dcb8e', '', '');
INSERT INTO "public"."moduleelement" VALUES ('826b12b3-e916-446d-a2fa-329cfd13c831', 'btnDetail', '进度详情', '', '', 'layui-icon-search', 'layui-btn-normal', '', 2, '4abafc83-c8f5-452f-9882-e113a86e7a3e', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('84694ea5-d6e1-4a65-8a59-7b5b779688d4', 'btnAdd', '添加', '', 'add()', 'layui-icon-add-1', 'layui-btn-normal', '添加模块', 1, 'bc80478d-0547-4437-9cff-be4b40144bdf', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('84e38920-f6e5-499c-bf52-a3c6f8499ff7', 'btnDel', '删除', ' ', 'del()', 'layui-icon-delete', 'layui-btn-danger', '删除分类', 3, 'a94d5648-c2a9-405e-ba6f-f1602ec9b807', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('8966b04f-8e26-4046-8b03-0c64f9f833dd', 'btnDel', '删除', '', 'del()', 'layui-icon-delete', 'layui-btn-danger', '', 3, '92b00259-2d15-43e7-9321-adffb29e8bf2', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('95c2dde0-f2a7-4474-8aa7-c7eaa7c4c87f', 'btnDel', '删除', '', '', 'layui-icon-delete', 'layui-btn-danger', '', 1, '9a87c0fa-9172-42a1-9505-7492433dcb8e', '', '');
INSERT INTO "public"."moduleelement" VALUES ('9c96e485-84a6-45f0-b6a7-f01dab94b0c6', 'btnPreview', '预览', '', 'preview()', 'layui-icon-search', 'layui-btn-normal', '', 4, '92b00259-2d15-43e7-9321-adffb29e8bf2', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('9e2c6754-f258-4b14-96a0-b9d981196a65', 'btnAdd', '添加', '', 'add()', 'layui-icon-add-1', 'layui-btn-normal', '添加资源', 0, 'e8dc5db6-4fc4-4795-a1cc-681cbcceec91', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('a7eea5dc-3b10-4550-9cf3-0dba9b9fc32c', 'btnAddCategory', '添加分类', '', '', 'layui-icon-add-1', 'layui-btn-normal', '', 0, 'a94d5648-c2a9-405e-ba6f-f1602ec9b807', '', '');
INSERT INTO "public"."moduleelement" VALUES ('b3e23ebc-0ff2-41b3-bff0-fd5e93f6828a', 'btnDetail', '查看详情', '', '', 'layui-icon-search', 'layui-btn-normal', '', 0, '37bb9414-19a0-4223-9056-71f8c758a930', '', '');
INSERT INTO "public"."moduleelement" VALUES ('c35d8f5b-0d38-4f31-84f9-39e476eeab08', 'btnAdd', '新订单', '', '', 'layui-icon-add-1', 'layui-btn-normal', '', 1, '98a949e8-8704-40a7-b9a1-c0e8801e4057', '', '');
INSERT INTO "public"."moduleelement" VALUES ('c3d7b478-21e9-4c1e-b866-a3c80be7909b', 'btnRefresh', '刷新', '', 'refresh()', 'layui-icon-refresh', 'layui-btn-normal', '刷新分类', 0, 'a94d5648-c2a9-405e-ba6f-f1602ec9b807', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('c4c1acbb-9cbf-4b1e-9cc0-ccf5ff544ec2', 'btnDel', '删除', '', 'del()', 'layui-icon-delete', 'layui-btn-danger', '删除进出库', 0, '89c3bfbe-246f-4112-8eb1-b6789da54202', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('c7d7daf0-3669-4a22-8bed-b092617deb9c', 'btnDel', '删除', '', 'del()', 'layui-icon-delete', 'layui-btn-danger', '删除资源', 3, 'e8dc5db6-4fc4-4795-a1cc-681cbcceec91', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('d1ba6a72-ba14-44c0-baba-46d0ad96fe8a', 'btnRefresh', '刷新', '', 'refresh()', 'layui-icon-refresh', 'layui-btn-normal', '刷新用户', 3, 'ef386d5d-cd58-43c0-a4ab-80afd0dbcd6c', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('d352c8ee-3dff-4d28-a0de-903ae68f2533', 'btnPreview', '预览', '', 'preview()', 'layui-icon-cellphone', 'layui-btn-normal', '', 3, '0031262c-689c-4b96-bae2-2c9d67076ade', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('daddf3b9-71b5-45ac-b85d-5a11c522f2f4', 'btnDel', '删除', ' ', 'del()', 'layui-icon-delete', 'layui-btn-danger', '删除模块', 3, 'bc80478d-0547-4437-9cff-be4b40144bdf', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('ef42721f-d223-4a00-a1d9-80b81121f21a', 'btnEdit', '编辑', ' ', 'edit()', 'layui-icon-edit', 'layui-btn-normal', '编辑部门', 1, '6a9e1346-0c01-44d2-8eb1-f929fdab542a', NULL, NULL);
INSERT INTO "public"."moduleelement" VALUES ('f8dde22a-2a37-47c4-8e67-70fb3af5303e', 'btnRefresh', '刷新', '', 'refresh()', 'layui-icon-refresh', 'layui-btn-normal', '刷新部门', 3, '6a9e1346-0c01-44d2-8eb1-f929fdab542a', NULL, NULL);

-- ----------------------------
-- Table structure for openjob
-- ----------------------------
DROP TABLE IF EXISTS "public"."openjob";
CREATE TABLE "public"."openjob" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "jobname" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "runcount" int4 NOT NULL,
  "errorcount" int4 NOT NULL,
  "nextruntime" timestamp(6),
  "lastruntime" timestamp(6),
  "lasterrortime" timestamp(6),
  "jobtype" int4 NOT NULL,
  "jobcall" text COLLATE "pg_catalog"."default" NOT NULL,
  "jobcallparams" text COLLATE "pg_catalog"."default",
  "cron" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "status" int4 NOT NULL,
  "remark" varchar(128) COLLATE "pg_catalog"."default",
  "createtime" timestamp(6) NOT NULL,
  "createuserid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "createusername" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "updatetime" timestamp(6),
  "updateuserid" varchar(50) COLLATE "pg_catalog"."default",
  "updateusername" varchar(200) COLLATE "pg_catalog"."default",
  "orgid" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."openjob"."id" IS 'Id';
COMMENT ON COLUMN "public"."openjob"."jobname" IS '任务名称';
COMMENT ON COLUMN "public"."openjob"."runcount" IS '任务执行次数';
COMMENT ON COLUMN "public"."openjob"."errorcount" IS '异常次数';
COMMENT ON COLUMN "public"."openjob"."nextruntime" IS '下次执行时间';
COMMENT ON COLUMN "public"."openjob"."lastruntime" IS '最后一次执行时间';
COMMENT ON COLUMN "public"."openjob"."lasterrortime" IS '最后一次失败时间';
COMMENT ON COLUMN "public"."openjob"."jobtype" IS '任务执行方式0：本地任务；1：外部接口任务';
COMMENT ON COLUMN "public"."openjob"."jobcall" IS '任务地址';
COMMENT ON COLUMN "public"."openjob"."jobcallparams" IS '任务参数，JSON格式';
COMMENT ON COLUMN "public"."openjob"."cron" IS 'CRON表达式';
COMMENT ON COLUMN "public"."openjob"."status" IS '任务运行状态（0：停止，1：正在运行，2：暂停）';
COMMENT ON COLUMN "public"."openjob"."remark" IS '备注';
COMMENT ON COLUMN "public"."openjob"."createtime" IS '创建时间';
COMMENT ON COLUMN "public"."openjob"."createuserid" IS '创建人ID';
COMMENT ON COLUMN "public"."openjob"."createusername" IS '创建人';
COMMENT ON COLUMN "public"."openjob"."updatetime" IS '最后更新时间';
COMMENT ON COLUMN "public"."openjob"."updateuserid" IS '最后更新人ID';
COMMENT ON COLUMN "public"."openjob"."updateusername" IS '最后更新人';
COMMENT ON COLUMN "public"."openjob"."orgid" IS '所属部门';
COMMENT ON TABLE "public"."openjob" IS '定时任务';

-- ----------------------------
-- Records of openjob
-- ----------------------------
INSERT INTO "public"."openjob" VALUES ('f40fe48d-71a4-4f47-b324-6178d97abfb9', '定时日志任务', 0, 0, '2020-04-25 12:16:20', '2020-04-25 12:16:20', '2020-04-25 12:16:20', 0, 'OpenAuth.App.Jobs.SysLogJob', 'null', '0/10 * * * * ?', 0, '这是个每10秒运行一次的任务，可以在系统日志中查看运行结果', '2020-04-25 12:16:20', '00000000-0000-0000-0000-000000000000', '超级管理员', '2020-04-25 19:31:38', '00000000-0000-0000-0000-000000000000', '超级管理员', '');

-- ----------------------------
-- Table structure for org
-- ----------------------------
DROP TABLE IF EXISTS "public"."org";
CREATE TABLE "public"."org" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "cascadeid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "hotkey" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "parentname" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "isleaf" int2 NOT NULL,
  "isautoexpand" int2 NOT NULL,
  "iconname" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "status" int4 NOT NULL,
  "bizcode" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "customcode" text COLLATE "pg_catalog"."default" NOT NULL,
  "createtime" timestamp(6) NOT NULL,
  "createid" int4 NOT NULL,
  "sortno" int4 NOT NULL,
  "parentid" varchar(50) COLLATE "pg_catalog"."default",
  "typename" varchar(20) COLLATE "pg_catalog"."default",
  "typeid" varchar(50) COLLATE "pg_catalog"."default",
  "chairmanid" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."org"."id" IS '流水号';
COMMENT ON COLUMN "public"."org"."cascadeid" IS '节点语义ID';
COMMENT ON COLUMN "public"."org"."name" IS '组织名称';
COMMENT ON COLUMN "public"."org"."hotkey" IS '热键';
COMMENT ON COLUMN "public"."org"."parentname" IS '父节点名称';
COMMENT ON COLUMN "public"."org"."isleaf" IS '是否叶子节点';
COMMENT ON COLUMN "public"."org"."isautoexpand" IS '是否自动展开';
COMMENT ON COLUMN "public"."org"."iconname" IS '节点图标文件名称';
COMMENT ON COLUMN "public"."org"."status" IS '当前状态';
COMMENT ON COLUMN "public"."org"."bizcode" IS '业务对照码';
COMMENT ON COLUMN "public"."org"."customcode" IS '自定义扩展码';
COMMENT ON COLUMN "public"."org"."createtime" IS '创建时间';
COMMENT ON COLUMN "public"."org"."createid" IS '创建人ID';
COMMENT ON COLUMN "public"."org"."sortno" IS '排序号';
COMMENT ON COLUMN "public"."org"."parentid" IS '父节点流水号';
COMMENT ON COLUMN "public"."org"."typename" IS '分类名称';
COMMENT ON COLUMN "public"."org"."typeid" IS '分类ID';
COMMENT ON COLUMN "public"."org"."chairmanid" IS '负责人ID';
COMMENT ON TABLE "public"."org" IS '组织表';

-- ----------------------------
-- Records of org
-- ----------------------------
INSERT INTO "public"."org" VALUES ('08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', '.0.8.11.1.', '研发小组', '', '软件部', 0, 0, '', 0, '0', '', '2016-10-14 11:40:31', 0, 1, '86449128-d5ac-44bf-b999-f7735b7458fd', NULL, NULL, '6ba79766-faa0-4259-8139-a4a6d35784e0');
INSERT INTO "public"."org" VALUES ('182dac38-64a0-414c-990c-7c9b7558a367', '.0.4.', '中部片区', '', '根节点', 0, 0, '', 0, '', '', '2022-10-31 21:52:38', 0, 0, NULL, '', '', NULL);
INSERT INTO "public"."org" VALUES ('1b965fff-3dcd-42ff-9624-2c8eb4f9b1c6', '.0.5.1.', '广州营销中心', '', '华南片区', 0, 0, '', 0, '', '', '2022-10-31 21:56:39', 0, 0, '8e31553c-cab8-4eb3-90b5-5f8ff1d21801', '', '', NULL);
INSERT INTO "public"."org" VALUES ('2089637b-403d-4d4d-91ff-c8a554973f96', '.0.4.1.', '海外市场部', '', '中部片区', 0, 0, '', 0, '', '', '2022-10-31 21:53:54', 0, 0, '182dac38-64a0-414c-990c-7c9b7558a367', '', '', NULL);
INSERT INTO "public"."org" VALUES ('3d2ad14c-2c56-4a90-a2db-6bde26b0b8b3', '.0.9.1.', '成都营销中心', '', '西南片区', 0, 0, '', 0, '', '', '2022-10-31 21:55:42', 0, 0, '60620558-89a2-4b28-8637-52f514773725', '', '', NULL);
INSERT INTO "public"."org" VALUES ('4a3920f1-1470-477e-97ec-0996eb83b638', '.0.8.6.', '市场2部', '', '总部大区', 0, 0, '', 0, '', '', '2022-10-31 21:55:07', 0, 0, '543a9fcf-4770-4fd9-865f-030e562be238', '', '', NULL);
INSERT INTO "public"."org" VALUES ('543a9fcf-4770-4fd9-865f-030e562be238', '.0.8.', '总部大区', '', '根节点', 0, 0, '', 0, '0', '', '2016-10-14 11:37:13', 0, 0, NULL, NULL, NULL, '49df1602-f5f3-4d52-afb7-3802da619558');
INSERT INTO "public"."org" VALUES ('60620558-89a2-4b28-8637-52f514773725', '.0.9.', '西南片区', '', '根节点', 0, 0, '', 0, '', '', '2022-10-31 21:52:30', 0, 0, NULL, '', '', '96f63f9d-e8c8-4258-963e-3327ed7d6f56');
INSERT INTO "public"."org" VALUES ('66386671-0494-4e83-8346-fbcf73283f7b', '.0.2.', '华东片区', '', '根节点', 0, 0, '', 0, '', '', '2022-10-31 21:52:19', 0, 0, NULL, '', '', NULL);
INSERT INTO "public"."org" VALUES ('8047e605-c54a-48bd-81da-daa9c1fc9091', '.0.4.2.', '郑州营销中心', '', '中部片区', 0, 0, '', 0, '', '', '2022-10-31 21:54:50', 0, 0, '182dac38-64a0-414c-990c-7c9b7558a367', '', '', NULL);
INSERT INTO "public"."org" VALUES ('86449128-d5ac-44bf-b999-f7735b7458fd', '.0.8.11.', '软件部', '', '总部大区', 0, 0, '', 1, '0', '', '2016-05-26 15:11:03', 0, 1, '543a9fcf-4770-4fd9-865f-030e562be238', NULL, NULL, '6ba79766-faa0-4259-8139-a4a6d35784e0');
INSERT INTO "public"."org" VALUES ('8e31553c-cab8-4eb3-90b5-5f8ff1d21801', '.0.5.', '华南片区', '', '根节点', 0, 0, '', 0, '', '', '2022-10-31 21:52:55', 0, 0, NULL, '', '', NULL);
INSERT INTO "public"."org" VALUES ('9cd918bf-28bc-44de-8e07-23cacbb67f42', '.0.8.7.', '总经办', '', '总部大区', 0, 0, '', 0, '', '', '2022-10-31 21:57:40', 0, 0, '543a9fcf-4770-4fd9-865f-030e562be238', '', '', NULL);
INSERT INTO "public"."org" VALUES ('b2083488-64e5-44cc-b8f4-929ffa6f2f72', '.0.2.1.', '上海VIP中心', '', '华东片区', 0, 0, '', 0, '', '', '2022-10-31 21:56:25', 0, 0, '66386671-0494-4e83-8346-fbcf73283f7b', '', '', '758a34c7-5a31-438c-bdf7-02fdd846b901');
INSERT INTO "public"."org" VALUES ('c36e43df-3a99-45da-80d9-3ac5d24f4014', '.0.8.10.', '市场1部', '', '总部大区', 0, 0, '', 0, '0', '', '2016-05-26 15:10:40', 0, 1, '543a9fcf-4770-4fd9-865f-030e562be238', NULL, NULL, 'de8be521-f1ec-4483-b124-0be342890507');
INSERT INTO "public"."org" VALUES ('c455d009-12d7-4c78-953f-264f0ca67a3d', '.0.6.1.', '天津营销中心', '', '华北片区', 0, 0, '', 0, '', '', '2022-10-31 21:56:54', 0, 0, 'eed8756d-587b-46de-96c7-0a400e3d80fa', '', '', NULL);
INSERT INTO "public"."org" VALUES ('ced1b2f0-4b53-44b8-9c42-a5d607ccc9c9', '.0.8.8.', '上市办', '', '总部大区', 0, 0, '', 0, '', '', '2022-10-31 21:57:53', 0, 0, '543a9fcf-4770-4fd9-865f-030e562be238', '', '', NULL);
INSERT INTO "public"."org" VALUES ('df442c27-68a0-428e-a309-cba23a994a9d', '.0.9.2.', '重庆营销中心', '', '西南片区', 0, 0, '', 0, '', '', '2022-10-31 21:56:06', 0, 0, '60620558-89a2-4b28-8637-52f514773725', '', '', NULL);
INSERT INTO "public"."org" VALUES ('eed8756d-587b-46de-96c7-0a400e3d80fa', '.0.6.', '华北片区', '', '根节点', 0, 0, '', 0, '', '', '2022-10-31 21:53:04', 0, 0, NULL, '', '', NULL);

-- ----------------------------
-- Table structure for relevance
-- ----------------------------
DROP TABLE IF EXISTS "public"."relevance";
CREATE TABLE "public"."relevance" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "description" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "relkey" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "status" int4 NOT NULL,
  "operatetime" timestamp(6) NOT NULL,
  "operatorid" varchar(50) COLLATE "pg_catalog"."default",
  "firstid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "secondid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "thirdid" varchar(50) COLLATE "pg_catalog"."default",
  "extendinfo" varchar(100) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."relevance"."id" IS '流水号';
COMMENT ON COLUMN "public"."relevance"."description" IS '描述';
COMMENT ON COLUMN "public"."relevance"."relkey" IS '映射标识';
COMMENT ON COLUMN "public"."relevance"."status" IS '状态';
COMMENT ON COLUMN "public"."relevance"."operatetime" IS '授权时间';
COMMENT ON COLUMN "public"."relevance"."operatorid" IS '授权人';
COMMENT ON COLUMN "public"."relevance"."firstid" IS '第一个表主键ID';
COMMENT ON COLUMN "public"."relevance"."secondid" IS '第二个表主键ID';
COMMENT ON COLUMN "public"."relevance"."thirdid" IS '第三个表主键ID';
COMMENT ON COLUMN "public"."relevance"."extendinfo" IS '扩展信息';
COMMENT ON TABLE "public"."relevance" IS '多对多关系集中映射';

-- ----------------------------
-- Records of relevance
-- ----------------------------
INSERT INTO "public"."relevance" VALUES ('00ae6b5c-21fa-4dc9-8ca4-7df669253255', '', 'RoleElement', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'c3d7b478-21e9-4c1e-b866-a3c80be7909b', '', '');
INSERT INTO "public"."relevance" VALUES ('01ba383d-fe81-473a-84a1-f64ce8a5aae5', '', 'UserOrg', 0, '2019-10-31 21:50:42', '', '229f3a49-ab27-49ce-b383-9f10ca23a9d5', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', '', '');
INSERT INTO "public"."relevance" VALUES ('026ffa48-8cdf-4452-9ac7-b1b55e58e02a', '', 'RoleElement', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'c35d8f5b-0d38-4f31-84f9-39e476eeab08', '', '');
INSERT INTO "public"."relevance" VALUES ('032e20b6-7273-49f9-9b84-0040323114c0', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'CreateUserId', '');
INSERT INTO "public"."relevance" VALUES ('03b55a9e-a44f-44fa-9383-4117bf8aba60', '', 'RoleResource', 0, '2018-09-12 00:15:54', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'XXX_DELETEACCOUNT', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('03be9b5e-38b0-4525-8431-b26d35ce6ce3', '', 'UserElement', 0, '2016-09-07 15:30:43', '0', '3a95e392-07d4-4af3-b30d-140ca93340f5', '816b12b3-e916-446d-a2fa-329cfd13c831', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('054a8347-a62c-4e62-b9b2-0b2d14e9ff94', '', 'RoleModule', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '7580672f-a390-4bb6-982d-9a4570cb5199', '', '');
INSERT INTO "public"."relevance" VALUES ('06dfd97d-17e0-42b8-bde7-40006d8c8eb2', '', 'UserElement', 0, '2018-04-06 14:50:37', '', '49df1602-f5f3-4d52-afb7-3802da619558', '584c7a3b-d28a-47b4-8648-7797d05d83d1', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('06f4c4a2-faa8-4bad-9184-50ceb517f30b', '', 'ProcessUser', 0, '2016-09-08 16:48:14', '0', '10cc09fb-d469-41e5-ae3f-fdd805a4bd4c', '3b64b643-cb9a-4654-81e4-6dd9b2f8a6f7', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('077e24ab-4c48-4a5e-bfa9-90ea00449136', '', 'RoleOrg', 0, '2018-09-12 00:08:47', '', '3e761e88-ddf7-4a62-b219-9a315b4564f2', '86449128-d5ac-44bf-b999-f7735b7458fd', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('08ff97f7-17fc-4072-b29a-287135898ece', '', 'RoleResource', 0, '2016-09-04 23:20:22', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', 'fdf3aac3-4507-40ad-aa2f-d7f0459de252', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('0b3d3a9b-8a96-43d4-918c-fa7e3ea5f5ca', '', 'RoleOrg', 0, '2018-09-12 00:08:37', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '990cb229-cc18-41f3-8e2b-13f0f0110798', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('0fd5b371-b010-4846-8833-95cc1e813a32', '', 'UserElement', 0, '2016-09-07 15:31:16', '0', 'ea25646b-964b-4d41-ab03-d8964e1494fb', '68484265-7802-4f06-b024-33e8b2f2edcf', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('10669494-70e2-4583-b5fd-191d7219b792', '', 'RoleDataProperty', 0, '2019-11-23 00:51:40', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', 'Resource', 'AppId', '');
INSERT INTO "public"."relevance" VALUES ('109dcd85-9f50-4b7b-8615-c107496986ba', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'b3e23ebc-0ff2-41b3-bff0-fd5e93f6828a', '', '');
INSERT INTO "public"."relevance" VALUES ('10a76196-ba0c-4294-bb8f-dcd063eb4aab', '', 'UserOrg', 0, '2017-10-12 09:13:38', '', '3eacdedd-e93a-4816-b49c-99ba3d5323c2', '990cb229-cc18-41f3-8e2b-13f0f0110798', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('10e58d75-dec1-4b85-882f-9dac79ad1210', '', 'RoleResource', 0, '2016-10-21 18:08:13', '0', '4980a85b-e3db-4607-bc2c-0baf0140d7df', 'ec99f670-0eca-465c-9f64-d4d5dc510b83', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('120d7a5d-203c-4261-95f5-0125757fb386', '', 'UserElement', 0, '2016-10-20 17:01:01', '0', '3a95e392-07d4-4af3-b30d-140ca93340f5', '7f071c63-1620-4486-9264-5806b2e63218', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('12f282b5-e87f-416e-8a7c-f9830d115b9a', '', 'RoleDataProperty', 0, '2019-11-23 01:05:44', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'WmsInboundOrderTbl', 'UpdateUserId', '');
INSERT INTO "public"."relevance" VALUES ('13433400-a32c-4539-b988-8b417c09bc0e', '', 'UserModule', 0, '2016-09-07 15:30:07', '0', '3b64b643-cb9a-4654-81e4-6dd9b2f8a6f7', '9486ff22-b696-4d7f-8093-8a3e53c45453', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('13612a4c-b20c-4bd0-a2cd-0ae47576364d', '', 'UserElement', 0, '2016-10-20 16:34:12', '0', '3a95e392-07d4-4af3-b30d-140ca93340f5', 'c7d7daf0-3669-4a22-8bed-b092617deb9c', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('148e317e-dacf-44b4-b3b8-7f68af74acdd', '', 'RoleModule', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '069475e3-c997-487a-9f29-e6a864c5c1d4', '', '');
INSERT INTO "public"."relevance" VALUES ('1490edd4-9bd3-4e71-bfa4-56f6558c1d3f', '', 'UserElement', 0, '2018-04-06 09:48:24', '', '6ba79766-faa0-4259-8139-a4a6d35784e0', '79dcd3eb-3aaf-4e08-83c9-713d8ff446fe', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('15705855-3e8d-4404-98f4-59af683f20ce', '', 'RoleModule', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '98a949e8-8704-40a7-b9a1-c0e8801e4057', '', '');
INSERT INTO "public"."relevance" VALUES ('15e66b55-cdce-47a1-9c08-21d5525524e8', '', 'RoleModule', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '0031262c-689c-4b96-bae2-2c9d67076ade', '', '');
INSERT INTO "public"."relevance" VALUES ('16154fc4-d18e-44a3-bcf2-5539b168aba7', '', 'RoleElement', 0, '2016-10-24 17:25:15', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '18cc3217-28a6-49b2-9a20-080230065984', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('1740ff26-a4d0-44cc-9fab-a0105c2c60b6', '', 'UserOrg', 0, '2017-10-12 13:59:49', '', '63c9c82a-e0d3-4bde-bbd2-057cda2f5283', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('18389d29-c82d-4181-8ea0-1440ca1c2093', '', 'RoleElement', 0, '2020-03-19 22:31:02', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', '9e2c6754-f258-4b14-96a0-b9d981196a65', '', '');
INSERT INTO "public"."relevance" VALUES ('183905f3-620c-4995-aead-1e80c5899517', '', 'RoleDataProperty', 0, '2019-11-23 00:19:30', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'Category', 'Id', '');
INSERT INTO "public"."relevance" VALUES ('1873ed85-a88a-4236-bd40-2c416aa2576c', '', 'RoleModule', 0, '2016-09-02 17:03:39', '0', '211e12c7-e466-496e-8d26-0660a38e24cc', '7580672f-a390-4bb6-982d-9a4570cb5199', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('18aa904d-6625-430d-9475-ec84d8c8e605', '', 'RoleModule', 0, '2020-03-19 22:31:02', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', 'e8dc5db6-4fc4-4795-a1cc-681cbcceec91', '', '');
INSERT INTO "public"."relevance" VALUES ('19c9621c-3d23-46b7-a841-54d5c82ec8e8', '', 'UserOrg', 0, '2016-09-02 13:56:53', '0', '3b64b643-cb9a-4654-81e4-6dd9b2f8a6f7', '990cb229-cc18-41f3-8e2b-13f0f0110798', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('1aaa04f0-bd9f-44a0-8bc2-3f7a74684c42', '', 'RoleDataProperty', 0, '2019-11-23 00:19:30', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'Category', 'DtCode', '');
INSERT INTO "public"."relevance" VALUES ('1acec4c4-0136-4e2b-a839-8676dbd6594a', '', 'ProcessUser', 0, '2016-09-14 11:38:23', '0', '6c6afe3c-349c-4198-8710-cf19c90f3afd', '3b64b643-cb9a-4654-81e4-6dd9b2f8a6f7', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('1ced1564-2fea-4c04-8aea-f071fa5bb293', '', 'UserModule', 0, '2016-09-05 16:24:55', '0', 'ea25646b-964b-4d41-ab03-d8964e1494fb', '069475e3-c997-487a-9f29-e6a864c5c1d4', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('1cf19b35-e2c2-436f-99b9-03ac2b232cc6', '', 'RoleElement', 0, '2016-09-04 23:21:04', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '44075557-496e-4dde-bb75-7b69f51ab4fe', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('1dca9a35-06e8-4275-8902-13c619880357', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'ScheduledInboundTime', '');
INSERT INTO "public"."relevance" VALUES ('1e84dafd-3f4d-4b13-a738-2cf0c98e2351', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'Resource', 'AppId', '');
INSERT INTO "public"."relevance" VALUES ('1fb6b802-2a1f-49a8-b2fa-c5d223a8538c', '', 'RoleDataProperty', 0, '2019-11-23 00:51:40', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', 'Resource', 'UpdateTime', '');
INSERT INTO "public"."relevance" VALUES ('2014027e-0cff-41cf-974b-56126d6eaa9a', '', 'RoleElement', 0, '2016-09-05 09:22:11', '0', '4980a85b-e3db-4607-bc2c-0baf0140d7df', 'c4c1acbb-9cbf-4b1e-9cc0-ccf5ff544ec2', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('224fa0b0-cdd6-47cf-89c5-45ad2a64bfd5', '', 'RoleDataProperty', 0, '2019-11-23 01:05:44', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'WmsInboundOrderTbl', 'OrderType', '');
INSERT INTO "public"."relevance" VALUES ('23339fa0-94f4-4d35-a775-bda84d152841', '', 'RoleModule', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '069475e3-c997-487a-9f29-e6a864c5c1d4', '', '');
INSERT INTO "public"."relevance" VALUES ('242e9543-3343-41d4-8816-15ffeeaef551', '', 'UserElement', 0, '2016-09-07 15:31:16', '0', 'ea25646b-964b-4d41-ab03-d8964e1494fb', '584c7a3b-d28a-47b4-8648-7797d05d83d1', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('24dbc2ce-8474-463f-871b-96cb5edb9800', '', 'RoleElement', 0, '2020-04-25 11:49:36', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', '4770af29-1375-4d27-ab0c-fdbeab87b710', '', '');
INSERT INTO "public"."relevance" VALUES ('27c4d50c-32da-4dbc-88a1-84b343cdd649', '', 'UserElement', 0, '2016-10-20 17:01:00', '0', '3a95e392-07d4-4af3-b30d-140ca93340f5', '6839a297-350b-4215-b680-4e5dfdae5615', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('29b06cd6-af0c-4c63-9aba-e5431c5d62ec', '', 'UserOrg', 0, '2017-10-12 09:13:38', '', '3eacdedd-e93a-4816-b49c-99ba3d5323c2', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('2a36a2b7-41aa-4190-b88c-75d44a56ad6e', '', 'UserModule', 0, '2017-02-06 00:14:18', '0', '3a95e392-07d4-4af3-b30d-140ca93340f5', '92b00259-2d15-43e7-9321-adffb29e8bf2', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('2a818d22-1ca8-48e2-a2ed-3dbc3d05cc8b', '', 'RoleElement', 0, '2020-04-25 11:49:11', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '5fba6316-5599-4245-822c-48ff33299868', '', '');
INSERT INTO "public"."relevance" VALUES ('2a8a790f-0b9a-4ab3-8e4f-aae4bfddc609', '', 'RoleDataProperty', 0, '2019-11-23 01:05:44', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'WmsInboundOrderTbl', 'PurchaseNo', '');
INSERT INTO "public"."relevance" VALUES ('2bb3fddb-0f51-442e-8dbf-236beb47d8a6', '', 'RoleOrg', 0, '2018-04-14 13:16:45', '', '77e6d0c3-f9e1-4933-92c3-c1c6eef75593', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('2c67ac44-5b67-4942-b457-2212e9a5dbf9', '', 'RoleModule', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'e8dc5db6-4fc4-4795-a1cc-681cbcceec91', '', '');
INSERT INTO "public"."relevance" VALUES ('2ca288a6-d222-4328-951e-c01c3e77a0c7', '', 'RoleElement', 0, '2016-09-04 23:21:00', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '7f071c63-1620-4486-9264-5806b2e63218', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('2d0fcc88-a7c0-4d33-8a08-1d688e9dde83', '', 'RoleModule', 0, '2016-09-02 17:03:39', '0', '211e12c7-e466-496e-8d26-0660a38e24cc', 'a94d5648-c2a9-405e-ba6f-f1602ec9b807', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('2d15e438-cc3a-41e9-9b13-325bfd5c804a', '', 'RoleElement', 0, '2016-09-04 23:21:09', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '84e38920-f6e5-499c-bf52-a3c6f8499ff7', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('2e1d286c-b771-43b0-947e-eeab185cc014', '', 'RoleModule', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '4abafc83-c8f5-452f-9882-e113a86e7a3e', '', '');
INSERT INTO "public"."relevance" VALUES ('2ebff9a4-b2d5-4a35-a7dd-2cfa2f5b0522', '', 'ProcessUser', 0, '2016-09-07 17:33:39', '0', '52cc7933-a045-4dcc-8c17-1b618bfa772b', '3b64b643-cb9a-4654-81e4-6dd9b2f8a6f7', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('30c82d18-7892-4e5f-9aee-e4f483a858c2', '', 'UserModule', 0, '2016-09-05 16:24:55', '0', 'ea25646b-964b-4d41-ab03-d8964e1494fb', '9486ff22-b696-4d7f-8093-8a3e53c45453', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('3225a4dc-c988-410c-8bcd-9afbccbafc09', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '584c7a3b-d28a-47b4-8648-7797d05d83d1', '', '');
INSERT INTO "public"."relevance" VALUES ('332a373c-f485-4f85-9af9-7792f7462bf1', '', 'RoleModule', 0, '2016-09-02 17:03:47', '0', '648b04c4-4ac2-4d69-bef6-07081ef27871', '89c3bfbe-246f-4112-8eb1-b6789da54202', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('333771cf-7eab-4d57-988a-8bd934575558', '', 'RoleDataProperty', 0, '2019-11-23 01:05:44', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'WmsInboundOrderTbl', 'OwnerId', '');
INSERT INTO "public"."relevance" VALUES ('336b16ba-8313-4cb3-87d7-4370ff175c14', '', 'RoleDataProperty', 0, '2019-11-23 01:05:44', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'Resource', 'Id', '');
INSERT INTO "public"."relevance" VALUES ('33fa12d8-8e48-4d1c-9c84-50f533b682ec', '', 'RoleDataProperty', 0, '2019-11-23 01:05:44', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'WmsInboundOrderTbl', 'CreateTime', '');
INSERT INTO "public"."relevance" VALUES ('340c60fe-8b95-474c-aa04-9197903998d2', '', 'RoleModule', 0, '2016-09-04 23:20:34', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '7580672f-a390-4bb6-982d-9a4570cb5199', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('361feb63-bde2-49c7-86ec-6df3ec6f0fe3', '', 'RoleElement', 0, '2016-09-04 23:21:13', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '1c870438-4260-43a5-8996-a6e1dc8bbf6a', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('388f792e-dbd1-40a1-8374-9339e7e60d9e', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'UpdateTime', '');
INSERT INTO "public"."relevance" VALUES ('3905b8a3-ed7e-4fe0-9e6d-747f6bc79235', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'Resource', 'TypeName', '');
INSERT INTO "public"."relevance" VALUES ('392dc41e-7186-4efb-a8e5-b5317e4122fb', '', 'RoleResource', 0, '2018-09-10 12:54:14', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'OPENAUTH_DELETEACCOUNT', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('3931d5b7-dde2-4530-bb2d-79b73f76e19b', '', 'RoleDataProperty', 0, '2019-11-23 00:19:30', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'Category', 'Name', '');
INSERT INTO "public"."relevance" VALUES ('3aa0cdcb-ec57-420e-b1b0-eb4d77b8a8d5', '', 'UserOrg', 0, '2020-03-19 21:20:04', '', '49df1602-f5f3-4d52-afb7-3802da619558', '86449128-d5ac-44bf-b999-f7735b7458fd', '', '');
INSERT INTO "public"."relevance" VALUES ('3b4845a5-d7a2-4da7-b95c-43ad03980fda', '', 'UserOrg', 0, '2020-03-19 21:20:04', '', '49df1602-f5f3-4d52-afb7-3802da619558', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', '', '');
INSERT INTO "public"."relevance" VALUES ('3bcaab20-e096-480e-a9bb-0fdb70686714', '', 'RoleElement', 0, '2016-09-04 23:21:00', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', 'cf7388be-2677-427c-ad78-8f00f1062b96', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('3de0359b-6331-4dc7-a00e-751f71dbadb5', '', 'ProcessUser', 0, '2016-09-28 09:23:30', '0', '68295d2a-4dfd-4c5e-81e3-9c787e2603bc', '3b64b643-cb9a-4654-81e4-6dd9b2f8a6f7', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('4190f00a-11a0-4814-849b-cc5232fa4dd4', '', 'RoleResource', 0, '2018-09-12 00:15:54', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'OPENAUTH_DELETEACCOUNT', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('42ba8a59-5493-4e11-b61b-d87000092767', '', 'RoleModule', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '4abafc83-c8f5-452f-9882-e113a86e7a3e', '', '');
INSERT INTO "public"."relevance" VALUES ('4459ffd7-446b-456b-aee5-48e67ca000f8', '', 'UserOrg', 0, '2019-10-31 21:51:45', '', '6ba79766-faa0-4259-8139-a4a6d35784e0', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', '', '');
INSERT INTO "public"."relevance" VALUES ('456ddfed-6607-41e9-9c46-0d4c7c9c38d4', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'Status', '');
INSERT INTO "public"."relevance" VALUES ('45744773-1b85-4913-bc1b-2f00b95a8198', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '9e2c6754-f258-4b14-96a0-b9d981196a65', '', '');
INSERT INTO "public"."relevance" VALUES ('45dee058-6b62-4005-a134-dcf7c2781851', '', 'RoleElement', 0, '2020-04-25 11:50:18', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'a6b61073-9e76-40ef-88ad-15c8789e2033', '', '');
INSERT INTO "public"."relevance" VALUES ('45e97612-46d8-4c36-b89e-ce6572ed7988', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'Resource', 'Id', '');
INSERT INTO "public"."relevance" VALUES ('460d1c98-2a68-43cf-8d38-d40ceb89916f', '', 'UserOrg', 0, '2017-10-12 09:13:38', '', '3eacdedd-e93a-4816-b49c-99ba3d5323c2', '86449128-d5ac-44bf-b999-f7735b7458fd', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('465b8bc0-b817-410d-849e-55f66b2a3211', '', 'RoleModule', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '98a949e8-8704-40a7-b9a1-c0e8801e4057', '', '');
INSERT INTO "public"."relevance" VALUES ('471e98ee-9cc5-4dc7-8762-a452e855dbd5', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'CreateTime', '');
INSERT INTO "public"."relevance" VALUES ('4757bb30-e4bc-4c2d-a824-947ef151d341', '', 'UserRole', 0, '2016-09-07 20:21:16', '0', '3b64b643-cb9a-4654-81e4-6dd9b2f8a6f7', '4980a85b-e3db-4607-bc2c-0baf0140d7df', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('4ba3982b-f0ae-4f9a-980e-1eaedc3b5f2e', '', 'UserElement', 0, '2016-09-07 17:48:34', '0', '3b64b643-cb9a-4654-81e4-6dd9b2f8a6f7', '584c7a3b-d28a-47b4-8648-7797d05d83d1', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('4c2fb006-53d6-4041-8cf6-e5d74d788897', '', 'UserModule', 0, '2018-04-06 09:48:19', '', '6ba79766-faa0-4259-8139-a4a6d35784e0', '9486ff22-b696-4d7f-8093-8a3e53c45453', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('4c69794b-9957-4f6b-b0fb-6455fe643565', '', 'UserElement', 0, '2018-04-06 14:50:41', '', '49df1602-f5f3-4d52-afb7-3802da619558', '826b12b3-e916-446d-a2fa-329cfd13c831', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('4daccce5-cb7b-46aa-8bed-3c85c72436be', '', 'RoleOrg', 0, '2018-09-12 00:08:37', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('4e613188-0387-4d17-a60d-703b4a606d75', '', 'RoleModule', 0, '2016-09-04 23:20:34', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', 'bc80478d-0547-4437-9cff-be4b40144bdf', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('4e665304-9f05-410e-b68f-44d45281b788', '', 'RoleOrg', 0, '2018-09-12 00:08:47', '', '3e761e88-ddf7-4a62-b219-9a315b4564f2', 'c36e43df-3a99-45da-80d9-3ac5d24f4014', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('4e693bbd-8ddb-42af-b888-30885612c154', '', 'UserOrg', 0, '2019-10-31 21:58:43', '', '96f63f9d-e8c8-4258-963e-3327ed7d6f56', '3d2ad14c-2c56-4a90-a2db-6bde26b0b8b3', '', '');
INSERT INTO "public"."relevance" VALUES ('4ec39ee9-9ee9-4aa9-a0db-eb0fdf8d2f00', '', 'UserElement', 0, '2018-04-06 09:48:27', '', '6ba79766-faa0-4259-8139-a4a6d35784e0', 'b3e23ebc-0ff2-41b3-bff0-fd5e93f6828a', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('4ee89c07-55e2-4ca6-9ef1-449cfe0a2c3c', '', 'RoleResource', 0, '2018-09-12 00:15:54', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'OPENAUTH_LOGIN', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('76a5b31b-f855-416c-b7ce-4b9ff1cdb4bc', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'Resource', 'CreateUserName', '');
INSERT INTO "public"."relevance" VALUES ('4fde1dc6-9d73-4c7c-9238-28981858c5a6', '', 'RoleModule', 0, '2016-09-05 09:21:56', '0', '4980a85b-e3db-4607-bc2c-0baf0140d7df', '89c3bfbe-246f-4112-8eb1-b6789da54202', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('5167dbcd-3a32-4ae8-827e-6f381cc58fa2', '', 'RoleElement', 0, '2016-09-04 23:21:00', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', 'fa816af1-a28d-47b5-9b8b-c46e18f902e9', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('51c56567-bbf8-466e-8678-9b6bfb38c493', '', 'RoleElement', 0, '2020-04-25 11:49:11', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '5fba6316-5599-4245-822c-48ff33299868', '', '');
INSERT INTO "public"."relevance" VALUES ('526d6f39-e75a-402b-8ba6-9bb08731da1e', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'Resource', 'CreateTime', '');
INSERT INTO "public"."relevance" VALUES ('53a4be87-4fa8-415b-97b5-2298ce8b17c8', '', 'UserResource', 0, '2018-04-14 14:38:04', '', '49df1602-f5f3-4d52-afb7-3802da619558', 'XXX_LOGIN', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('54b2e9b6-1f7c-4a39-92c9-98f58429c1fc', '', 'RoleModule', 0, '2016-09-02 17:03:39', '0', '211e12c7-e466-496e-8d26-0660a38e24cc', 'bc80478d-0547-4437-9cff-be4b40144bdf', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('54eadc62-a77e-4baa-aa6d-34f5af2d6774', '', 'RoleElement', 0, '2020-04-25 11:49:36', '', '77e6d0c3-f9e1-4933-92c3-c1c6eef75593', '4770af29-1375-4d27-ab0c-fdbeab87b710', '', '');
INSERT INTO "public"."relevance" VALUES ('55b10ecc-3fb3-4127-b69e-e7a3467d7a1a', '', 'RoleElement', 0, '2016-09-05 09:22:11', '0', '4980a85b-e3db-4607-bc2c-0baf0140d7df', '6db928fe-93df-460f-9472-8bb0b6cae52c', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('5725ff79-43c6-4778-bbff-131cf364dab6', '', 'UserElement', 0, '2016-10-20 17:01:01', '0', '3a95e392-07d4-4af3-b30d-140ca93340f5', 'cf7388be-2677-427c-ad78-8f00f1062b96', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('575221eb-0e4d-4cfa-9cd8-59607784d43d', '', 'UserRole', 0, '2019-10-31 21:59:41', '', '6ba79766-faa0-4259-8139-a4a6d35784e0', '3e761e88-ddf7-4a62-b219-9a315b4564f2', '', '');
INSERT INTO "public"."relevance" VALUES ('5965ae4d-c718-421f-9895-fdf6255a002e', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'ReturnBoxNum', '');
INSERT INTO "public"."relevance" VALUES ('59c8b633-167e-47c1-bb63-837780ea93dc', '', 'RoleModule', 0, '2020-04-25 11:48:20', '', '77e6d0c3-f9e1-4933-92c3-c1c6eef75593', '5c55f7eb-4552-4610-a584-d72685f8d064', '', '');
INSERT INTO "public"."relevance" VALUES ('5a20d59c-6ee6-4fe2-98fe-7b35b11026ae', '', 'UserElement', 0, '2016-09-07 15:30:20', '0', '3b64b643-cb9a-4654-81e4-6dd9b2f8a6f7', '68484265-7802-4f06-b024-33e8b2f2edcf', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('5aa8ae27-e5b1-4f46-9342-73f1ba11c14c', '', 'RoleElement', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '826b12b3-e916-446d-a2fa-329cfd13c831', '', '');
INSERT INTO "public"."relevance" VALUES ('5b2d5db8-d603-4be3-add2-c85ef3c53ddc', '', 'UserResource', 0, '2018-04-14 14:38:05', '', '49df1602-f5f3-4d52-afb7-3802da619558', 'OPENAUTH_LOGIN', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('5ccce632-f8f0-452b-8faf-4a5372004e85', '', 'RoleResource', 0, '2018-09-12 00:15:54', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'XXX_CHECKUSER', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('5f616264-84f0-42de-a84a-61d11f2f4786', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '4bfa8ea0-6b0d-426f-8687-b654575ca780', '', '');
INSERT INTO "public"."relevance" VALUES ('5f8ac964-c87d-44c0-b780-c4c1382800ea', '', 'RoleElement', 0, '2020-03-19 22:31:02', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', '6c814946-db5c-48bd-84dd-b1c38196ad74', '', '');
INSERT INTO "public"."relevance" VALUES ('620b368a-7b56-4c74-ab85-8bc91d08ddc9', '', 'RoleElement', 0, '2016-09-04 23:20:42', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '1c9acc3e-a40d-4d07-b495-6e60eb9b71b9', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('635779b1-f223-41f2-b9a4-7f35633008d7', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '18cc3217-28a6-49b2-9a20-080230065984', '', '');
INSERT INTO "public"."relevance" VALUES ('6431a464-6f1f-4ffc-8157-89212b70f09a', '', 'RoleOrg', 0, '2016-09-05 00:00:00', '0', '4980a85b-e3db-4607-bc2c-0baf0140d7df', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('64e4f5aa-28ef-4690-9b20-5f0b543964f6', '', 'UserElement', 0, '2016-09-07 15:30:20', '0', '3b64b643-cb9a-4654-81e4-6dd9b2f8a6f7', '816b12b3-e916-446d-a2fa-329cfd13c831', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('6532f9c1-3067-4952-b008-e766f833050e', '', 'UserRole', 0, '2019-11-23 00:48:41', '', '96f63f9d-e8c8-4258-963e-3327ed7d6f56', '77e6d0c3-f9e1-4933-92c3-c1c6eef75593', '', '');
INSERT INTO "public"."relevance" VALUES ('6552d053-69b3-4ae9-b1f2-497582dcb8aa', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'c7d7daf0-3669-4a22-8bed-b092617deb9c', '', '');
INSERT INTO "public"."relevance" VALUES ('6645b6fb-efcf-4e48-9c13-84f79bc5be34', '', 'RoleOrg', 0, '2018-04-14 13:16:45', '', '77e6d0c3-f9e1-4933-92c3-c1c6eef75593', '86449128-d5ac-44bf-b999-f7735b7458fd', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('66e25fc5-093d-42ab-85dc-a38f6600889b', '', 'UserOrg', 0, '2016-09-02 13:57:32', '0', 'ea25646b-964b-4d41-ab03-d8964e1494fb', 'c36e43df-3a99-45da-80d9-3ac5d24f4014', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('67c502cf-c9bf-4ad3-b749-eda1c7f388e7', '', 'RoleElement', 0, '2020-04-25 11:50:18', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'a6b61073-9e76-40ef-88ad-15c8789e2033', '', '');
INSERT INTO "public"."relevance" VALUES ('68912e65-256e-45b6-b48e-036382598d32', '', 'RoleOrg', 0, '2016-10-17 10:03:49', '0', '2eb423d6-6ad9-4efe-b423-872478a2a434', '990cb229-cc18-41f3-8e2b-13f0f0110798', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('68984a83-ce96-4144-9e23-0e0f2249fb45', '', 'UserOrg', 0, '2019-10-31 21:51:30', '', 'de8be521-f1ec-4483-b124-0be342890507', 'c36e43df-3a99-45da-80d9-3ac5d24f4014', '', '');
INSERT INTO "public"."relevance" VALUES ('6a0d3b61-67d0-4090-a622-08d5643e1af8', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'Resource', 'Name', '');
INSERT INTO "public"."relevance" VALUES ('6a427baa-c54c-4830-a2fe-34e206f471c5', '', 'RoleElement', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '2d595a2a-5de5-479e-a331-b53c799a6b10', '', '');
INSERT INTO "public"."relevance" VALUES ('6b9c4789-042c-4f6f-a749-ee68ee87462d', '', 'ProcessUser', 0, '2016-10-27 16:47:52', '0', '054ff054-d8ae-4911-a596-8fb1f66b348f', '3a95e392-07d4-4af3-b30d-140ca93340f5', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('6d6eb70e-0caf-485f-943c-671be021a588', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'Resource', 'AppName', '');
INSERT INTO "public"."relevance" VALUES ('6da6d662-8cef-47cd-80b3-fa885b2dca7a', '', 'RoleOrg', 0, '2018-04-14 13:16:45', '', '77e6d0c3-f9e1-4933-92c3-c1c6eef75593', '990cb229-cc18-41f3-8e2b-13f0f0110798', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('6db5666b-6f8c-4e83-bada-0b45054bd9a4', '', 'RoleElement', 0, '2016-09-04 23:20:42', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '0d25438e-1436-48e0-aedf-0f1690693282', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('6fe52499-f800-47ce-96fc-a2b5b43505d5', '', 'UserElement', 0, '2018-04-06 09:48:22', '', '6ba79766-faa0-4259-8139-a4a6d35784e0', '584c7a3b-d28a-47b4-8648-7797d05d83d1', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('7024c6fa-28d2-494f-93af-0651c690e063', '', 'RoleModule', 0, '2020-04-25 11:48:20', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', '5c55f7eb-4552-4610-a584-d72685f8d064', '', '');
INSERT INTO "public"."relevance" VALUES ('7082bc48-535e-4b92-9dc0-c58340a8239d', '', 'RoleDataProperty', 0, '2019-11-23 01:05:44', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'Resource', 'Name', '');
INSERT INTO "public"."relevance" VALUES ('715d017a-68b6-468d-aa3f-32ca4cfd4b9e', '', 'RoleModule', 0, '2016-09-04 23:20:34', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', 'bedb41a2-f310-4775-af99-01be08adda93', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('71fa1d0c-1928-4a16-aa94-c92e6f671581', '', 'RoleDataProperty', 0, '2019-11-23 00:51:40', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', 'Resource', 'AppName', '');
INSERT INTO "public"."relevance" VALUES ('72bf4729-af60-42f5-b0d7-717362ffad7f', '', 'RoleElement', 0, '2016-09-04 23:21:00', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '2feefce1-e3d8-42ac-b811-2352679628da', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('736141c8-330b-4600-a781-8d0e7cdc01e5', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'SupplierId', '');
INSERT INTO "public"."relevance" VALUES ('736e90f7-3747-472e-816d-dbb7fdf3b0bb', '', 'RoleOrg', 0, '2018-09-12 00:08:42', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('744da0ee-6c57-4bfc-9937-5ab799112996', '', 'RoleModule', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '7bc7e527-478d-49fd-868d-5f31951586f5', '', '');
INSERT INTO "public"."relevance" VALUES ('7475b0c3-f204-4f95-a22f-80591fe76bc7', '', 'ProcessUser', 0, '2016-10-31 11:52:39', '0', 'b8bcdf59-1e29-4d97-a364-12ac8e8c5c61', '3b64b643-cb9a-4654-81e4-6dd9b2f8a6f7', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('75340ad3-fb80-4646-b1de-ba801688ddc2', '', 'RoleElement', 0, '2016-09-04 23:21:04', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '5ed1681c-13d2-4c87-8675-a8d95c0b40ae', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('759c09ce-f93a-4de7-96fc-cffabc1cd1ac', '', 'RoleDataProperty', 0, '2019-11-23 01:05:44', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'Resource', 'AppName', '');
INSERT INTO "public"."relevance" VALUES ('76e6629f-764f-4761-afd3-c41e0e9e4310', '', 'RoleElement', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '6c814946-db5c-48bd-84dd-b1c38196ad74', '', '');
INSERT INTO "public"."relevance" VALUES ('77824f78-792b-4661-b7d9-653f6e0a443c', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '9c96e485-84a6-45f0-b6a7-f01dab94b0c6', '', '');
INSERT INTO "public"."relevance" VALUES ('77ac794c-9142-443f-b19c-3b9d960c8ba4', '', 'UserOrg', 0, '2019-10-31 21:51:45', '', '6ba79766-faa0-4259-8139-a4a6d35784e0', '86449128-d5ac-44bf-b999-f7735b7458fd', '', '');
INSERT INTO "public"."relevance" VALUES ('77bd93da-2c2b-4ba8-bf05-3a1382811a6a', '', 'RoleModule', 0, '2016-09-02 17:03:39', '0', '211e12c7-e466-496e-8d26-0660a38e24cc', 'e8dc5db6-4fc4-4795-a1cc-681cbcceec91', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('77d25c9e-4773-4f95-8048-8d59398835f6', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '3dc0ec4d-bf86-4bae-9ec0-1d6c2403fb99', '', '');
INSERT INTO "public"."relevance" VALUES ('77eec82a-f713-4584-872c-761fdbcdb456', '', 'UserElement', 0, '2018-04-06 14:50:37', '', '49df1602-f5f3-4d52-afb7-3802da619558', '68484265-7802-4f06-b024-33e8b2f2edcf', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('77fc08e6-98ae-4d33-b294-bd9fed5b14ed', '', 'UserElement', 0, '2018-04-06 14:50:36', '', '49df1602-f5f3-4d52-afb7-3802da619558', '816b12b3-e916-446d-a2fa-329cfd13c831', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('797c6e5f-7f3c-4891-89b9-a054e10f6c00', '', 'UserModule', 0, '2018-04-06 09:48:01', '', '49df1602-f5f3-4d52-afb7-3802da619558', '37bb9414-19a0-4223-9056-71f8c758a930', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('7a22ccfc-5f4a-472b-850b-61b9552d7e67', '', 'UserRole', 0, '2019-11-23 00:48:10', '', '229f3a49-ab27-49ce-b383-9f10ca23a9d5', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', '', '');
INSERT INTO "public"."relevance" VALUES ('7ab6db05-1098-4134-b228-3329792dc6db', '', 'RoleDataProperty', 0, '2019-11-23 00:51:40', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', 'Resource', 'UpdateUserName', '');
INSERT INTO "public"."relevance" VALUES ('7b177a26-efdd-406b-8873-24f6565b121f', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '054e9699-7828-4b8b-a28b-d7ae45ed3306', '', '');
INSERT INTO "public"."relevance" VALUES ('7c0e613e-2e8e-43e2-93af-cf38bfd56dcb', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'StockId', '');
INSERT INTO "public"."relevance" VALUES ('7d929ccc-4185-41d0-a81f-42fc0f27a85c', '', 'RoleModule', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '15a3a401-e8eb-4d8b-9035-ecd5f53ed0c9', '', '');
INSERT INTO "public"."relevance" VALUES ('7d995d7b-5967-4bd0-a601-180925fe4a77', '', 'RoleModule', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '7580672f-a390-4bb6-982d-9a4570cb5199', '', '');
INSERT INTO "public"."relevance" VALUES ('7dcc9577-f27b-429f-8552-d223d4b48617', '', 'UserRole', 0, '2019-10-31 21:59:41', '', '6ba79766-faa0-4259-8139-a4a6d35784e0', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '', '');
INSERT INTO "public"."relevance" VALUES ('7e54557a-5f1d-494c-90c1-509525dd5c08', '', 'RoleModule', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '9486ff22-b696-4d7f-8093-8a3e53c45453', '', '');
INSERT INTO "public"."relevance" VALUES ('7e8ce905-fa6e-490d-9d33-bde6b6529804', '', 'RoleDataProperty', 0, '2019-11-23 00:19:30', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'Category', 'Description', '');
INSERT INTO "public"."relevance" VALUES ('7f25286f-246b-4143-98eb-c3e574fe7455', '', 'ProcessUser', 0, '2016-09-07 17:33:39', '0', '52cc7933-a045-4dcc-8c17-1b618bfa772b', '3a95e392-07d4-4af3-b30d-140ca93340f5', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('7faeac11-cf1f-40aa-a6ad-2c7768106b9a', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '4f2737db-633f-4946-8a71-b08b9885f151', '', '');
INSERT INTO "public"."relevance" VALUES ('7fd7f976-f10e-44aa-a7ba-7ca40d2e8f90', '', 'RoleOrg', 0, '2016-10-17 10:03:30', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('80310629-5e52-482c-9a0f-5c5bdfabcd9e', '', 'RoleOrg', 0, '2016-09-05 00:00:00', '0', '4980a85b-e3db-4607-bc2c-0baf0140d7df', '990cb229-cc18-41f3-8e2b-13f0f0110798', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('832f4a8f-7791-4aa6-bcd2-20dcb6f5ef37', '', 'UserElement', 0, '2016-09-02 14:53:04', '0', '3a95e392-07d4-4af3-b30d-140ca93340f5', '15a4f88c-4fae-4cab-ba2f-0cbd2cca8736', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('84a52091-08a0-4a46-b661-3cd206771c29', '', 'RoleModule', 0, '2016-09-04 23:20:34', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '0031262c-689c-4b96-bae2-2c9d67076ade', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('854e0658-ab8a-4869-b157-9941955acdc6', '', 'RoleElement', 0, '2016-09-04 23:21:09', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '1a473afd-cbd4-41e9-9471-81f9435aaabe', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('85b5f9e0-a4d2-4224-9488-c0fb98149f0b', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'c3d7b478-21e9-4c1e-b866-a3c80be7909b', '', '');
INSERT INTO "public"."relevance" VALUES ('88a4c966-d042-4a2e-b133-ff7eded1c5de', '', 'RoleElement', 0, '2016-09-04 23:21:13', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '7b2b1ffb-398b-4f7b-83da-8f484e1bcea0', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('89ea1898-7649-4c3d-ae68-ace9bd9a316b', '', 'RoleModule', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'a94d5648-c2a9-405e-ba6f-f1602ec9b807', '', '');
INSERT INTO "public"."relevance" VALUES ('8adae84f-6516-4d87-a476-353bc48ae597', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'Category', 'Description', '');
INSERT INTO "public"."relevance" VALUES ('8af3581e-257f-4655-bac2-5b5afb85ef88', '', 'UserOrg', 0, '2019-10-31 21:59:08', '', '758a34c7-5a31-438c-bdf7-02fdd846b901', 'b2083488-64e5-44cc-b8f4-929ffa6f2f72', '', '');
INSERT INTO "public"."relevance" VALUES ('8b633f3c-965b-4e35-8496-c364890d7760', '', 'RoleElement', 0, '2016-09-04 23:21:09', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', 'c3d7b478-21e9-4c1e-b866-a3c80be7909b', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('8c93cb3c-b535-4ab1-af9e-b3ad50847423', '', 'RoleDataProperty', 0, '2019-11-23 00:51:40', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', 'Resource', 'Id', '');
INSERT INTO "public"."relevance" VALUES ('8e229d71-3b25-4efe-a2fe-829be732a1c6', '', 'RoleElement', 0, '2020-04-25 11:49:11', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', '5fba6316-5599-4245-822c-48ff33299868', '', '');
INSERT INTO "public"."relevance" VALUES ('8f741d9e-e7f5-4b73-95f4-4b55e0cf6605', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'UpdateUserId', '');
INSERT INTO "public"."relevance" VALUES ('8fa4a52f-9c0a-43c9-9b7e-b378efb4e1df', '', 'RoleResource', 0, '2018-09-10 12:54:14', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'OPENAUTH_LOGIN', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('90f19c4e-609f-4dc6-84f7-8b936be05568', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'Category', 'Name', '');
INSERT INTO "public"."relevance" VALUES ('928e8ddd-b990-471e-983d-f2dac77428d7', '', 'RoleElement', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '68484265-7802-4f06-b024-33e8b2f2edcf', '', '');
INSERT INTO "public"."relevance" VALUES ('92b2d699-9875-4978-af79-24c83ff4e212', '', 'UserOrg', 0, '2019-10-31 21:58:43', '', '96f63f9d-e8c8-4258-963e-3327ed7d6f56', 'df442c27-68a0-428e-a309-cba23a994a9d', '', '');
INSERT INTO "public"."relevance" VALUES ('92f0b297-96c1-47d4-84dd-571374431bc0', '', 'RoleElement', 0, '2016-09-04 23:21:04', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '84694ea5-d6e1-4a65-8a59-7b5b779688d4', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('93bcac7a-0ff1-488c-8d1c-3da7e44cbefc', '', 'RoleElement', 0, '2016-09-04 23:21:00', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', 'd1ba6a72-ba14-44c0-baba-46d0ad96fe8a', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('95b51b38-177e-4e69-9265-d2c9fcd8b09a', '', 'RoleElement', 0, '2020-04-25 11:50:18', '', '77e6d0c3-f9e1-4933-92c3-c1c6eef75593', 'a6b61073-9e76-40ef-88ad-15c8789e2033', '', '');
INSERT INTO "public"."relevance" VALUES ('960224e6-5910-472b-a5ef-b2aa9a8b106f', '', 'UserRole', 0, '2016-09-06 17:06:15', '0', '3b64b643-cb9a-4654-81e4-6dd9b2f8a6f7', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('962b278b-0894-4b36-b1a0-6c5c3d11d4c3', '', 'UserElement', 0, '2018-04-06 14:50:17', '', '49df1602-f5f3-4d52-afb7-3802da619558', 'b3e23ebc-0ff2-41b3-bff0-fd5e93f6828a', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('965f010b-2fd6-4b34-ba23-3e44c1af2877', '', 'RoleOrg', 0, '2016-09-08 16:19:18', '0', '36094f5d-07e7-40d5-91dc-ff60f98b496a', '990cb229-cc18-41f3-8e2b-13f0f0110798', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('98136fef-6d02-4823-bc12-6e5e619e1275', '', 'UserRole', 0, '2019-10-31 21:59:25', '', '758a34c7-5a31-438c-bdf7-02fdd846b901', '77e6d0c3-f9e1-4933-92c3-c1c6eef75593', '', '');
INSERT INTO "public"."relevance" VALUES ('9a6850d8-fc90-45fe-ab34-cfe0aa1b80ee', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '79dcd3eb-3aaf-4e08-83c9-713d8ff446fe', '', '');
INSERT INTO "public"."relevance" VALUES ('9a7648a6-12ac-4473-82ec-c2c845d9047e', '', 'RoleElement', 0, '2019-11-06 10:31:03', '', '3e761e88-ddf7-4a62-b219-9a315b4564f2', '054e9699-7828-4b8b-a28b-d7ae45ed3306', '', '');
INSERT INTO "public"."relevance" VALUES ('9ad706e3-8e6b-4bc7-a502-371b298ef062', '', 'RoleElement', 0, '2016-09-04 23:21:13', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', 'ef42721f-d223-4a00-a1d9-80b81121f21a', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('9ba32bd8-4406-43bf-aac5-0bb0dbd6d228', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'c35d8f5b-0d38-4f31-84f9-39e476eeab08', '', '');
INSERT INTO "public"."relevance" VALUES ('9bff1b59-f0fd-41db-9c55-e3275eccfc88', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'Resource', 'Description', '');
INSERT INTO "public"."relevance" VALUES ('9d568d6d-d78d-47d6-8fb6-b1327cdbe83a', '', 'RoleModule', 0, '2016-09-04 23:20:34', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', 'a94d5648-c2a9-405e-ba6f-f1602ec9b807', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('9ded6370-099c-4691-aecd-1ee09542c9d5', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'Resource', 'Disable', '');
INSERT INTO "public"."relevance" VALUES ('9e46a946-6e81-4f61-bcba-21e4f7fac3df', '', 'RoleModule', 0, '2016-09-02 17:03:39', '0', '211e12c7-e466-496e-8d26-0660a38e24cc', 'ef386d5d-cd58-43c0-a4ab-80afd0dbcd6c', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('9e57e1ff-e9cf-4600-a872-ac85f7845bb0', '', 'RoleOrg', 0, '2018-04-14 13:16:45', '', '77e6d0c3-f9e1-4933-92c3-c1c6eef75593', 'c36e43df-3a99-45da-80d9-3ac5d24f4014', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('9edc7b81-2b51-4193-8805-6062e596ccdc', '', 'UserOrg', 0, '2016-09-02 13:57:32', '0', 'ea25646b-964b-4d41-ab03-d8964e1494fb', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('9fa50449-5d87-4579-9f1f-9cdcd876976b', '', 'RoleElement', 0, '2016-09-04 23:21:00', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '6839a297-350b-4215-b680-4e5dfdae5615', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('a051aa08-38da-4b6d-8d90-10b3c2485e4b', '', 'RoleOrg', 0, '2016-09-05 00:00:00', '0', '4980a85b-e3db-4607-bc2c-0baf0140d7df', '543a9fcf-4770-4fd9-865f-030e562be238', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('a06fe8c6-3f5e-4085-9bbf-e366571a356c', '', 'RoleElement', 0, '2016-09-04 23:21:04', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', 'daddf3b9-71b5-45ac-b85d-5a11c522f2f4', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('a0904102-e26a-4bc5-9c95-ed5ef977586b', '', 'RoleModule', 0, '2016-09-02 17:03:39', '0', '211e12c7-e466-496e-8d26-0660a38e24cc', '6a9e1346-0c01-44d2-8eb1-f929fdab542a', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('a314a714-95f0-46e2-8341-5a29b9b4f321', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'ShipperId', '');
INSERT INTO "public"."relevance" VALUES ('a3876834-411d-4228-b7ba-230c29b76295', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'd352c8ee-3dff-4d28-a0de-903ae68f2533', '', '');
INSERT INTO "public"."relevance" VALUES ('a3c0d154-4bcc-47a4-9c0e-c0a406686167', '', 'RoleElement', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '9e2c6754-f258-4b14-96a0-b9d981196a65', '', '');
INSERT INTO "public"."relevance" VALUES ('a5bef7bf-ecdb-4480-ad64-b39a02269607', '', 'UserModule', 0, '2018-04-06 09:48:37', '', '49df1602-f5f3-4d52-afb7-3802da619558', '069475e3-c997-487a-9f29-e6a864c5c1d4', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('a6c7d18e-129f-4922-94bd-8306d1004480', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'Enable', '');
INSERT INTO "public"."relevance" VALUES ('a8094b46-de5a-40ea-a8ee-69ea905480ef', '', 'RoleModule', 0, '2016-09-05 09:21:56', '0', '4980a85b-e3db-4607-bc2c-0baf0140d7df', '069475e3-c997-487a-9f29-e6a864c5c1d4', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('a8123b37-ba70-4aab-aef6-1938733b5210', '', 'RoleElement', 0, '2016-09-04 23:20:42', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', 'c0d8505c-061a-467d-862a-c94f27caa208', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('a84c4bee-4bf6-4dd7-a0a4-3da64d366535', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'Remark', '');
INSERT INTO "public"."relevance" VALUES ('a9821db0-49bd-49be-a554-afa811c99760', '', 'RoleResource', 0, '2016-09-04 23:20:22', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', 'ec99f670-0eca-465c-9f64-d4d5dc510b83', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('aa051096-a23a-431d-9053-bb954f9453a7', '', 'RoleElement', 0, '2016-09-04 23:20:54', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '4bfa8ea0-6b0d-426f-8687-b654575ca780', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('aac9206e-a77b-421c-9c85-5f202fddeb31', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'TransferType', '');
INSERT INTO "public"."relevance" VALUES ('ab84b111-fb5d-4ddd-99d5-479954d9d521', '', 'RoleOrg', 0, '2016-09-08 16:19:18', '0', '36094f5d-07e7-40d5-91dc-ff60f98b496a', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('ab924ba7-8a74-4804-82b0-ecbbedf4c13e', '', 'RoleElement', 0, '2016-09-05 09:22:11', '0', '4980a85b-e3db-4607-bc2c-0baf0140d7df', '38109ca0-32ec-44bd-a243-017e591b532b', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('abbf150f-907d-450c-836c-6ad3d6885549', '', 'RoleModule', 0, '2020-04-25 11:48:20', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '5c55f7eb-4552-4610-a584-d72685f8d064', '', '');
INSERT INTO "public"."relevance" VALUES ('ac184827-9899-4b40-8939-61fe9d2b187c', '', 'UserElement', 0, '2016-09-07 17:48:49', '0', '3a95e392-07d4-4af3-b30d-140ca93340f5', '584c7a3b-d28a-47b4-8648-7797d05d83d1', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('acb4d37f-8b45-4a99-b364-99f3881dfcda', '', 'RoleElement', 0, '2016-09-04 23:21:13', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', 'f8dde22a-2a37-47c4-8e67-70fb3af5303e', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('acc51898-5335-4903-83b9-4701a782bc4d', '', 'UserElement', 0, '2016-10-20 17:01:02', '0', '3a95e392-07d4-4af3-b30d-140ca93340f5', 'fa816af1-a28d-47b5-9b8b-c46e18f902e9', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('ad267296-5eba-4d59-b821-8148d8cfb3c6', '', 'RoleModule', 0, '2016-09-04 23:20:34', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', 'e8dc5db6-4fc4-4795-a1cc-681cbcceec91', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('ad29467e-eeee-494c-ab82-f6be5d2619d5', '', 'RoleElement', 0, '2016-09-04 23:21:00', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '50c9df24-b233-42cb-9a0d-4ce158c75f86', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('ad30e13e-6b75-48f9-97e3-c723d3e36a28', '', 'RoleResource', 0, '2018-09-12 00:15:54', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'OPENAUTH_MODIFYACCOUNT', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('ad5bc7a6-e307-4fa8-a4ef-ce9e09f7e21b', '', 'RoleModule', 0, '2016-09-05 09:21:56', '0', '4980a85b-e3db-4607-bc2c-0baf0140d7df', '9486ff22-b696-4d7f-8093-8a3e53c45453', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('ad905aa6-d3d8-4fe9-99b4-5f8be7891d1e', '', 'RoleResource', 0, '2018-09-12 00:15:54', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'XXX_ADMIN', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('ae131c5a-084b-4932-9215-cf0f739ee969', '', 'RoleDataProperty', 0, '2019-11-23 01:05:44', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'WmsInboundOrderTbl', 'GoodsType', '');
INSERT INTO "public"."relevance" VALUES ('ae619801-1959-44fd-a75b-a8cca4d559b4', '', 'RoleOrg', 0, '2018-09-12 00:08:37', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '543a9fcf-4770-4fd9-865f-030e562be238', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('ae95e6e1-ae92-4c2e-b8d8-c32031f35805', '', 'RoleElement', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '79dcd3eb-3aaf-4e08-83c9-713d8ff446fe', '', '');
INSERT INTO "public"."relevance" VALUES ('af263192-daa8-4f29-99b9-1efb96e31627', '', 'RoleElement', 0, '2016-09-04 23:20:42', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '645b40ac-4223-44a7-aab4-66eb56cf9864', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('af47386e-142b-4afc-a42a-1ff138ac377c', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'CreateUserName', '');
INSERT INTO "public"."relevance" VALUES ('b0174f58-3f6c-431a-8bd8-0caba54fd848', '', 'RoleElement', 0, '2019-11-06 10:31:03', '', '77e6d0c3-f9e1-4933-92c3-c1c6eef75593', '054e9699-7828-4b8b-a28b-d7ae45ed3306', '', '');
INSERT INTO "public"."relevance" VALUES ('b08d7763-a725-406f-a7d5-d144f00d716e', '', 'UserOrg', 0, '2016-09-02 13:56:41', '0', '3a95e392-07d4-4af3-b30d-140ca93340f5', '543a9fcf-4770-4fd9-865f-030e562be238', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('b241dd3d-2965-44e4-929d-9dacb6444e09', '', 'RoleOrg', 0, '2018-04-14 13:16:45', '', '77e6d0c3-f9e1-4933-92c3-c1c6eef75593', '543a9fcf-4770-4fd9-865f-030e562be238', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('b246cd89-548c-4471-a43b-6f10b40c26b1', '', 'RoleOrg', 0, '2018-09-12 00:08:42', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '990cb229-cc18-41f3-8e2b-13f0f0110798', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('b2490ac0-ba16-48a2-b39d-49f6b87f9387', '', 'UserModule', 0, '2018-04-06 09:48:17', '', '6ba79766-faa0-4259-8139-a4a6d35784e0', '069475e3-c997-487a-9f29-e6a864c5c1d4', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('b2edfee4-f980-4aa5-b547-492d677e0674', '', 'RoleModule', 0, '2016-09-04 23:20:34', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', 'ef386d5d-cd58-43c0-a4ab-80afd0dbcd6c', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('b2f1a511-26ac-4b5b-bc3a-b7fc52297b41', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'Resource', 'UpdateUserName', '');
INSERT INTO "public"."relevance" VALUES ('b3245529-7cad-4130-bd2d-ac1129deb2f0', '', 'RoleDataProperty', 0, '2019-11-23 01:05:44', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'WmsInboundOrderTbl', 'UpdateTime', '');
INSERT INTO "public"."relevance" VALUES ('b3b8f695-a179-489b-90b4-7814ab048a69', '', 'UserElement', 0, '2018-04-06 09:48:21', '', '6ba79766-faa0-4259-8139-a4a6d35784e0', '816b12b3-e916-446d-a2fa-329cfd13c831', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('b3cb3391-4ff4-4071-910e-18c46362ab5d', '', 'RoleElement', 0, '2020-03-19 22:31:02', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', '18cc3217-28a6-49b2-9a20-080230065984', '', '');
INSERT INTO "public"."relevance" VALUES ('b4c2a294-125c-4768-9214-cea3ccf39a1c', '', 'RoleOrg', 0, '2018-09-12 00:08:42', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '543a9fcf-4770-4fd9-865f-030e562be238', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('b51345b9-325c-4a30-b147-5562c93c3ed3', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '816b12b3-e916-446d-a2fa-329cfd13c831', '', '');
INSERT INTO "public"."relevance" VALUES ('b55798b2-6768-4051-8cdc-9da72c73718d', '', 'RoleDataProperty', 0, '2019-11-23 00:51:40', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', 'Resource', 'Name', '');
INSERT INTO "public"."relevance" VALUES ('b5c0e181-5f32-4a92-846c-24ff6253b6df', '', 'RoleElement', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '054e9699-7828-4b8b-a28b-d7ae45ed3306', '', '');
INSERT INTO "public"."relevance" VALUES ('b647148b-21be-42b8-8811-1cb03a6fc349', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'ExternalType', '');
INSERT INTO "public"."relevance" VALUES ('b6712915-5fc8-4271-b651-6b467ec1d8a8', '', 'RoleModule', 0, '2020-03-19 22:31:02', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', '0031262c-689c-4b96-bae2-2c9d67076ade', '', '');
INSERT INTO "public"."relevance" VALUES ('b672a830-c3a5-408b-a746-65608534b24c', '', 'UserModule', 0, '2017-12-15 17:07:05', '', '49df1602-f5f3-4d52-afb7-3802da619558', '9486ff22-b696-4d7f-8093-8a3e53c45453', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('b918e504-ba39-4be7-8452-76cef09191d3', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '826b12b3-e916-446d-a2fa-329cfd13c831', '', '');
INSERT INTO "public"."relevance" VALUES ('b9e63d17-35c8-4456-abab-8f43a1c99adc', '', 'UserModule', 0, '2018-04-06 09:47:59', '', '49df1602-f5f3-4d52-afb7-3802da619558', '4abafc83-c8f5-452f-9882-e113a86e7a3e', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('ba5f4663-04e1-4b09-8e84-459507df2aeb', '', 'UserOrg', 0, '2019-10-31 21:50:51', '', '1df68dfd-3b6d-4491-872f-00a0fc6c5a64', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', '', '');
INSERT INTO "public"."relevance" VALUES ('bbca349a-5d29-4cce-9f7e-0d5d4ce65a54', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'OwnerId', '');
INSERT INTO "public"."relevance" VALUES ('bbdc3ea9-3f21-48b0-9d7a-39545d6183d0', '', 'UserElement', 0, '2018-04-06 09:48:25', '', '6ba79766-faa0-4259-8139-a4a6d35784e0', '826b12b3-e916-446d-a2fa-329cfd13c831', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('bc39df48-cbcf-4757-af8c-b023ad195721', '', 'RoleElement', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '816b12b3-e916-446d-a2fa-329cfd13c831', '', '');
INSERT INTO "public"."relevance" VALUES ('bc63b763-cdb8-4516-a3c4-fabe74d7dc56', '', 'RoleDataProperty', 0, '2019-11-23 00:19:30', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'Category', 'DtValue', '');
INSERT INTO "public"."relevance" VALUES ('bd783f53-23fa-41f4-8cec-7c61fab52072', '', 'UserOrg', 0, '2018-03-15 09:19:06', '', '0ceff0f8-f848-440c-bc26-d8605ac858cd', '86449128-d5ac-44bf-b999-f7735b7458fd', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('bd82fa18-2500-4e6b-920d-dc235b57f788', '', 'RoleModule', 0, '2020-04-25 11:48:20', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '5c55f7eb-4552-4610-a584-d72685f8d064', '', '');
INSERT INTO "public"."relevance" VALUES ('bda5f089-64d6-4fb8-9012-d7f3ff36902a', '', 'UserOrg', 0, '2017-10-12 13:59:09', '', 'ffd92ed2-5330-4ec2-a42d-6e0e9005db3b', '990cb229-cc18-41f3-8e2b-13f0f0110798', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('be17df2b-a4bb-4080-9d3f-465875a0bd52', '', 'RoleModule', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '9486ff22-b696-4d7f-8093-8a3e53c45453', '', '');
INSERT INTO "public"."relevance" VALUES ('bee6572d-8fb8-4e0e-af15-93aafc989717', '', 'RoleElement', 0, '2016-09-04 23:20:42', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '68fc793f-069f-43e1-a012-42ac2d7c585c', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('bef744ab-2323-4552-9a09-f529911f8c59', '', 'UserOrg', 0, '2019-10-31 21:58:43', '', '96f63f9d-e8c8-4258-963e-3327ed7d6f56', '60620558-89a2-4b28-8637-52f514773725', '', '');
INSERT INTO "public"."relevance" VALUES ('bfe7d15c-9b35-4735-b9a6-38ee8869b5ec', '', 'RoleDataProperty', 0, '2019-11-23 01:05:44', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'WmsInboundOrderTbl', 'CreateUserId', '');
INSERT INTO "public"."relevance" VALUES ('c14addeb-1812-4a78-9152-1f7115b22d89', '', 'UserRole', 0, '2016-09-05 00:00:47', '0', '3a95e392-07d4-4af3-b30d-140ca93340f5', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('c16e961d-e3b9-4b89-8cd4-de6fd23e4709', '', 'RoleDataProperty', 0, '2019-11-23 01:05:44', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'WmsInboundOrderTbl', 'Status', '');
INSERT INTO "public"."relevance" VALUES ('c25f0741-47bc-48a5-801c-902de87b7ab6', '', 'RoleDataProperty', 0, '2019-11-23 01:05:44', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'WmsInboundOrderTbl', 'CreateUserName', '');
INSERT INTO "public"."relevance" VALUES ('c2d3b7d6-b47d-4bd8-9dc6-d9134d86713f', '', 'RoleOrg', 0, '2016-10-17 10:03:30', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '86449128-d5ac-44bf-b999-f7735b7458fd', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('c3050d65-d26b-4e46-bece-a212b0cc00ec', '', 'RoleElement', 0, '2016-09-04 23:20:42', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '15a4f88c-4fae-4cab-ba2f-0cbd2cca8736', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('c3227c77-d60e-4157-9dd3-a8bcdb3af52b', '', 'RoleModule', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'e8dc5db6-4fc4-4795-a1cc-681cbcceec91', '', '');
INSERT INTO "public"."relevance" VALUES ('c4771ac5-3375-4de9-adb8-a603398f0d62', '', 'RoleElement', 0, '2016-09-04 23:21:09', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '2d595a2a-5de5-479e-a331-b53c799a6b10', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('c50fae2a-b36f-486f-9d53-e58406590101', '', 'ProcessUser', 0, '2016-10-27 16:47:52', '0', '054ff054-d8ae-4911-a596-8fb1f66b348f', '3b64b643-cb9a-4654-81e4-6dd9b2f8a6f7', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('c58cb482-6ab7-49eb-b5b0-e45424b6e502', '', 'RoleElement', 0, '2016-09-04 23:21:00', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '34730f5a-d307-457b-9041-5f7de30abfa9', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('c733cfbe-2f71-41e4-92a6-4ff97cf88dc4', '', 'UserModule', 0, '2018-04-06 09:48:19', '', '6ba79766-faa0-4259-8139-a4a6d35784e0', '4abafc83-c8f5-452f-9882-e113a86e7a3e', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('c9099371-8d4e-4f5b-9686-2c60a2c1c641', '', 'ProcessUser', 0, '2016-09-08 16:48:14', '0', '10cc09fb-d469-41e5-ae3f-fdd805a4bd4c', '3a95e392-07d4-4af3-b30d-140ca93340f5', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('c98b3d02-a76b-4ecc-94a5-cfeffd5e29fb', '', 'RoleModule', 0, '2016-09-02 17:03:39', '0', '211e12c7-e466-496e-8d26-0660a38e24cc', 'bedb41a2-f310-4775-af99-01be08adda93', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('cd500e9c-7599-42d5-94d8-0234369efd41', '', 'RoleModule', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '37bb9414-19a0-4223-9056-71f8c758a930', '', '');
INSERT INTO "public"."relevance" VALUES ('ce7a6891-361e-44a0-b543-e2a7d8ca0fc0', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'GoodsType', '');
INSERT INTO "public"."relevance" VALUES ('d060436e-4eac-4109-a4f2-9e5ffb3f843e', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'PurchaseNo', '');
INSERT INTO "public"."relevance" VALUES ('d1f194c3-3b20-41ee-805b-77c94ee40785', '', 'UserOrg', 0, '2020-03-19 21:20:04', '', '49df1602-f5f3-4d52-afb7-3802da619558', '543a9fcf-4770-4fd9-865f-030e562be238', '', '');
INSERT INTO "public"."relevance" VALUES ('d65f9601-b07e-4c89-8c35-ddc6c3edf3b1', '', 'UserRole', 0, '2019-11-23 00:48:02', '', '1df68dfd-3b6d-4491-872f-00a0fc6c5a64', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', '', '');
INSERT INTO "public"."relevance" VALUES ('d72b9de9-998b-432c-9ccf-d961d386d778', '', 'RoleModule', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'b19bce90-5508-43b6-93ed-cd9ff9e356a9', '', '');
INSERT INTO "public"."relevance" VALUES ('d892294d-2a2f-410e-bae9-86be3f6e3674', '', 'RoleDataProperty', 0, '2019-11-23 01:05:44', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'WmsInboundOrderTbl', 'StockId', '');
INSERT INTO "public"."relevance" VALUES ('d967ed9b-a083-4398-954b-ea73edcefa32', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'ExternalNo', '');
INSERT INTO "public"."relevance" VALUES ('da6c0645-0bf9-4ade-9dd3-1b09e91e504c', '', 'RoleElement', 0, '2016-09-05 09:22:07', '0', '4980a85b-e3db-4607-bc2c-0baf0140d7df', '816b12b3-e916-446d-a2fa-329cfd13c831', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('db621de5-12e0-4ff1-9532-4cd7a696cf65', '', 'RoleElement', 0, '2020-04-25 11:50:18', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', 'a6b61073-9e76-40ef-88ad-15c8789e2033', '', '');
INSERT INTO "public"."relevance" VALUES ('dbdd5bf2-5910-4644-b087-2f50711840df', '', 'UserRole', 0, '2019-11-23 00:48:35', '', '49df1602-f5f3-4d52-afb7-3802da619558', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '', '');
INSERT INTO "public"."relevance" VALUES ('dc7dd8ef-c8e6-414f-8e97-31774718654c', '', 'RoleDataProperty', 0, '2019-11-23 01:05:44', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'WmsInboundOrderTbl', 'Id', '');
INSERT INTO "public"."relevance" VALUES ('de4205b7-4832-40d4-b6ae-956f7b4997ba', '', 'RoleModule', 0, '2020-03-19 22:31:02', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', '7580672f-a390-4bb6-982d-9a4570cb5199', '', '');
INSERT INTO "public"."relevance" VALUES ('df2d90b3-4e2e-40e9-b406-220009726460', '', 'RoleModule', 0, '2016-09-04 23:20:34', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '6a9e1346-0c01-44d2-8eb1-f929fdab542a', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('dfd5430b-3422-465a-be79-05a1e06deed2', '', 'RoleElement', 0, '2016-09-04 23:20:54', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', 'c7d7daf0-3669-4a22-8bed-b092617deb9c', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('e12b77de-b7ce-4f38-b7a3-f3b2d285f33b', '', 'RoleOrg', 0, '2016-10-17 10:03:49', '0', '2eb423d6-6ad9-4efe-b423-872478a2a434', '08f41bf6-4388-4b1e-bd3e-2ff538b44b1b', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('e28c0dcd-168a-4b60-a514-7b6eb8026709', '', 'RoleOrg', 0, '2016-10-17 10:03:30', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '990cb229-cc18-41f3-8e2b-13f0f0110798', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('e4ccd68d-b31b-4d2d-b591-665818a7bd9f', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'Category', 'Id', '');
INSERT INTO "public"."relevance" VALUES ('e50d78ae-004d-4f89-95a2-bd5c6327d16c', '', 'RoleModule', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '0031262c-689c-4b96-bae2-2c9d67076ade', '', '');
INSERT INTO "public"."relevance" VALUES ('e5aa43b8-86df-43be-b5f1-9edd13dc07f8', '', 'RoleElement', 0, '2020-04-25 11:49:36', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '4770af29-1375-4d27-ab0c-fdbeab87b710', '', '');
INSERT INTO "public"."relevance" VALUES ('e619a82e-edfb-4542-94df-0b92850667ad', '', 'RoleResource', 0, '2018-04-14 14:39:56', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'OPENAUTH_MODIFYACCOUNT', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('e6bd480f-592a-46e0-9f83-2adefb12dca0', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '8966b04f-8e26-4046-8b03-0c64f9f833dd', '', '');
INSERT INTO "public"."relevance" VALUES ('e785147c-f46b-474f-8fad-73b14fa69822', '', 'UserRole', 0, '2016-09-06 17:06:29', '0', '3a95e392-07d4-4af3-b30d-140ca93340f5', '4980a85b-e3db-4607-bc2c-0baf0140d7df', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('e84f6b9c-716d-4e94-a1aa-7fd0d1a2e23e', '', 'RoleModule', 0, '2016-09-02 17:03:47', '0', '648b04c4-4ac2-4d69-bef6-07081ef27871', '069475e3-c997-487a-9f29-e6a864c5c1d4', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('e9cf3d63-6305-46c7-93b4-14053387c62c', '', 'UserModule', 0, '2018-04-06 09:48:18', '', '6ba79766-faa0-4259-8139-a4a6d35784e0', '37bb9414-19a0-4223-9056-71f8c758a930', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('ec72f6ae-09ee-4db9-99a1-bf15c8e35dda', '', 'ProcessUser', 0, '2016-09-14 11:38:23', '0', '6c6afe3c-349c-4198-8710-cf19c90f3afd', '3a95e392-07d4-4af3-b30d-140ca93340f5', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('ec9c80ce-dbdf-4ba5-9091-82f75392c3b0', '', 'UserElement', 0, '2016-09-07 15:30:43', '0', '3a95e392-07d4-4af3-b30d-140ca93340f5', '68484265-7802-4f06-b024-33e8b2f2edcf', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('ee1986a0-24cc-4dec-b5f5-68ef959ab650', '', 'UserElement', 0, '2018-04-06 14:50:40', '', '49df1602-f5f3-4d52-afb7-3802da619558', '79dcd3eb-3aaf-4e08-83c9-713d8ff446fe', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('ee4f39fd-4fbf-4f68-9a70-d6c7d7db9723', '', 'ProcessUser', 0, '2016-10-31 11:52:39', '0', 'b8bcdf59-1e29-4d97-a364-12ac8e8c5c61', '3a95e392-07d4-4af3-b30d-140ca93340f5', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('eec41fcb-61c0-4e56-a5c0-a9f8be6e6fdc', '', 'UserModule', 0, '2016-09-07 15:30:06', '0', '3b64b643-cb9a-4654-81e4-6dd9b2f8a6f7', '069475e3-c997-487a-9f29-e6a864c5c1d4', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('ef43a7a6-4a4c-46fe-82d4-1e1055fdac6d', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '17ae4fd4-ab4e-439e-ba1d-2a53b46d112b', '', '');
INSERT INTO "public"."relevance" VALUES ('ef8024e8-dab3-4b85-9952-821a005c1f2b', '', 'RoleDataProperty', 0, '2019-11-23 00:51:40', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', 'Resource', 'CascadeId', '');
INSERT INTO "public"."relevance" VALUES ('f012d886-f204-4599-a00d-7b9847cc0bb7', '', 'RoleModule', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '92b00259-2d15-43e7-9321-adffb29e8bf2', '', '');
INSERT INTO "public"."relevance" VALUES ('f125441c-f28c-4ffa-9183-c8168ab09afb', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'Category', 'TypeId', '');
INSERT INTO "public"."relevance" VALUES ('f163873c-2b44-4279-8b2c-498bcd01f05b', '', 'RoleElement', 0, '2020-04-25 11:49:36', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '4770af29-1375-4d27-ab0c-fdbeab87b710', '', '');
INSERT INTO "public"."relevance" VALUES ('f25d98ff-46bc-48e7-86a0-5eca5e6d98c2', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'UpdateUserName', '');
INSERT INTO "public"."relevance" VALUES ('f3671c95-a33f-4a11-89dd-00d734d4a230', '', 'RoleModule', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '15a3a401-e8eb-4d8b-9035-ecd5f53ed0c9', '', '');
INSERT INTO "public"."relevance" VALUES ('f4ba636a-9002-43e6-93eb-95132a3e68c5', '', 'ProcessUser', 0, '2016-09-28 09:23:30', '0', '68295d2a-4dfd-4c5e-81e3-9c787e2603bc', '3a95e392-07d4-4af3-b30d-140ca93340f5', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('f579a427-a9ed-4ebe-8411-72e8e6abd01d', '', 'UserElement', 0, '2016-09-05 16:25:26', '0', 'ea25646b-964b-4d41-ab03-d8964e1494fb', '816b12b3-e916-446d-a2fa-329cfd13c831', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('f61ee29b-7988-404d-b692-5a8f667684be', '', 'UserElement', 0, '2018-04-06 09:48:23', '', '6ba79766-faa0-4259-8139-a4a6d35784e0', '68484265-7802-4f06-b024-33e8b2f2edcf', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('f6367ca1-0486-46a4-b9c6-65c00936a516', '', 'RoleElement', 0, '2016-09-04 23:20:54', '0', 'db309d88-fd21-4b81-a4d9-ae6276a1d813', '9e2c6754-f258-4b14-96a0-b9d981196a65', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('f671f582-9111-4000-aadd-660449d0d4b0', '', 'RoleResource', 0, '2018-09-12 00:15:54', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'XXX_LOGIN', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('f714b860-447e-4d22-a206-1b545cc98fbb', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'InBondedArea', '');
INSERT INTO "public"."relevance" VALUES ('f8d157b4-12e3-4488-9e4c-b9670e11b4c6', '', 'RoleDataProperty', 0, '2019-11-23 01:05:44', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'WmsInboundOrderTbl', 'UpdateUserName', '');
INSERT INTO "public"."relevance" VALUES ('f8e65a18-a86a-47b1-be87-c437ba5e5fd9', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'Id', '');
INSERT INTO "public"."relevance" VALUES ('fa52d20f-204d-4cdd-a1e5-5b7faaac4cd7', '', 'RoleDataProperty', 0, '2019-11-23 00:51:40', '', 'd27ae3cf-135f-4d57-93a6-2120ddf98650', 'Resource', 'CreateUserName', '');
INSERT INTO "public"."relevance" VALUES ('fa7c4d39-b31a-4668-8716-d40a62aa722b', '', 'UserOrg', 0, '2017-10-12 13:59:49', '', '63c9c82a-e0d3-4bde-bbd2-057cda2f5283', '990cb229-cc18-41f3-8e2b-13f0f0110798', NULL, NULL);
INSERT INTO "public"."relevance" VALUES ('fa955d08-fe15-42d2-ae39-98e22e4f9b50', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'WmsInboundOrderTbl', 'OrderType', '');
INSERT INTO "public"."relevance" VALUES ('fa9ce486-4b1f-4630-bad3-7625744cb8e8', '', 'RoleDataProperty', 0, '2020-03-19 00:17:02', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', 'Resource', 'CascadeId', '');
INSERT INTO "public"."relevance" VALUES ('faf837f2-8ac3-4269-8a1c-b2af432bf7b5', '', 'RoleElement', 0, '2020-03-19 21:23:19', '', '0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', 'a7eea5dc-3b10-4550-9cf3-0dba9b9fc32c', '', '');
INSERT INTO "public"."relevance" VALUES ('fafcaba7-57fe-44dd-9343-6112db385dce', '', 'RoleElement', 0, '2020-04-25 11:49:11', '', '77e6d0c3-f9e1-4933-92c3-c1c6eef75593', '5fba6316-5599-4245-822c-48ff33299868', '', '');
INSERT INTO "public"."relevance" VALUES ('fdc16578-e4eb-474d-8cc8-4188693a7c12', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '6c814946-db5c-48bd-84dd-b1c38196ad74', '', '');
INSERT INTO "public"."relevance" VALUES ('feec44e3-3f88-4ac2-a4ad-a5bd3161f1bb', '', 'UserOrg', 0, '2019-10-31 21:59:08', '', '758a34c7-5a31-438c-bdf7-02fdd846b901', '66386671-0494-4e83-8346-fbcf73283f7b', '', '');
INSERT INTO "public"."relevance" VALUES ('fef68b50-ef7f-45a4-8f0e-38e8d8ecaaea', '', 'RoleElement', 0, '2020-03-19 00:16:55', '', '09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '68484265-7802-4f06-b024-33e8b2f2edcf', '', '');

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS "public"."role";
CREATE TABLE "public"."role" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "status" int4 NOT NULL,
  "createtime" timestamp(6) NOT NULL,
  "createid" varchar(50) COLLATE "pg_catalog"."default",
  "typename" varchar(20) COLLATE "pg_catalog"."default",
  "typeid" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."role"."id" IS 'Id';
COMMENT ON COLUMN "public"."role"."name" IS '角色名称';
COMMENT ON COLUMN "public"."role"."status" IS '当前状态';
COMMENT ON COLUMN "public"."role"."createtime" IS '创建时间';
COMMENT ON COLUMN "public"."role"."createid" IS '创建人ID';
COMMENT ON COLUMN "public"."role"."typename" IS '分类名称';
COMMENT ON COLUMN "public"."role"."typeid" IS '分类ID';
COMMENT ON TABLE "public"."role" IS '角色表';

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO "public"."role" VALUES ('09ee2ffa-7463-4938-ae0b-1cb4e80c7c13', '管理员', 0, '2018-04-09 22:48:24', '', '', '');
INSERT INTO "public"."role" VALUES ('0a7ebd0c-78d6-4fbc-8fbe-6fc25c3a932d', '测试', 0, '2018-04-09 22:48:29', '', '', '');
INSERT INTO "public"."role" VALUES ('77e6d0c3-f9e1-4933-92c3-c1c6eef75593', '神', 0, '2018-04-14 13:16:45', '', '', '');
INSERT INTO "public"."role" VALUES ('d27ae3cf-135f-4d57-93a6-2120ddf98650', '测试二组', 0, '2019-11-23 00:46:31', '', '', '');

-- ----------------------------
-- Table structure for stock
-- ----------------------------
DROP TABLE IF EXISTS "public"."stock";
CREATE TABLE "public"."stock" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "name" text COLLATE "pg_catalog"."default" NOT NULL,
  "prodcnt" int4 NOT NULL,
  "price" numeric(10,1) NOT NULL,
  "status" int4 NOT NULL,
  "viewable" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "createuser" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "time" timestamp(6) NOT NULL,
  "orgid" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."stock"."id" IS '数据ID';
COMMENT ON COLUMN "public"."stock"."name" IS '产品名称';
COMMENT ON COLUMN "public"."stock"."prodcnt" IS '产品数量';
COMMENT ON COLUMN "public"."stock"."price" IS '产品单价';
COMMENT ON COLUMN "public"."stock"."status" IS '出库/入库';
COMMENT ON COLUMN "public"."stock"."viewable" IS '可见范围';
COMMENT ON COLUMN "public"."stock"."createuser" IS '操作人';
COMMENT ON COLUMN "public"."stock"."time" IS '操作时间';
COMMENT ON COLUMN "public"."stock"."orgid" IS '组织ID';
COMMENT ON TABLE "public"."stock" IS '出入库信息表';

-- ----------------------------
-- Records of stock
-- ----------------------------

-- ----------------------------
-- Table structure for syslog
-- ----------------------------
DROP TABLE IF EXISTS "public"."syslog";
CREATE TABLE "public"."syslog" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "content" text COLLATE "pg_catalog"."default",
  "typename" varchar(20) COLLATE "pg_catalog"."default",
  "typeid" varchar(50) COLLATE "pg_catalog"."default",
  "href" varchar(200) COLLATE "pg_catalog"."default",
  "createtime" timestamp(6) NOT NULL,
  "createid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "createname" varchar(200) COLLATE "pg_catalog"."default",
  "ip" varchar(20) COLLATE "pg_catalog"."default",
  "result" int4 NOT NULL,
  "application" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."syslog"."id" IS 'Id';
COMMENT ON COLUMN "public"."syslog"."content" IS '日志内容';
COMMENT ON COLUMN "public"."syslog"."typename" IS '分类名称';
COMMENT ON COLUMN "public"."syslog"."typeid" IS '分类ID';
COMMENT ON COLUMN "public"."syslog"."href" IS '操作所属模块地址';
COMMENT ON COLUMN "public"."syslog"."createtime" IS '记录时间';
COMMENT ON COLUMN "public"."syslog"."createid" IS '操作人ID';
COMMENT ON COLUMN "public"."syslog"."createname" IS '操作人';
COMMENT ON COLUMN "public"."syslog"."ip" IS '操作机器的IP地址';
COMMENT ON COLUMN "public"."syslog"."result" IS '操作的结果：0：成功；1：失败；';
COMMENT ON COLUMN "public"."syslog"."application" IS '所属应用';
COMMENT ON TABLE "public"."syslog" IS '系统日志';

-- ----------------------------
-- Records of syslog
-- ----------------------------

-- ----------------------------
-- Table structure for sysmessage
-- ----------------------------
DROP TABLE IF EXISTS "public"."sysmessage";
CREATE TABLE "public"."sysmessage" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "typename" varchar(20) COLLATE "pg_catalog"."default",
  "typeid" varchar(50) COLLATE "pg_catalog"."default",
  "fromid" varchar(50) COLLATE "pg_catalog"."default",
  "toid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "fromname" varchar(50) COLLATE "pg_catalog"."default",
  "toname" varchar(50) COLLATE "pg_catalog"."default",
  "fromstatus" int4 NOT NULL,
  "tostatus" int4 NOT NULL,
  "href" varchar(200) COLLATE "pg_catalog"."default",
  "title" varchar(200) COLLATE "pg_catalog"."default",
  "content" text COLLATE "pg_catalog"."default",
  "createtime" timestamp(6) NOT NULL,
  "createid" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."sysmessage"."id" IS 'Id';
COMMENT ON COLUMN "public"."sysmessage"."typename" IS '分类名称';
COMMENT ON COLUMN "public"."sysmessage"."typeid" IS '分类ID';
COMMENT ON COLUMN "public"."sysmessage"."fromid" IS '消息源头';
COMMENT ON COLUMN "public"."sysmessage"."toid" IS '到达';
COMMENT ON COLUMN "public"."sysmessage"."fromname" IS '消息源头名称';
COMMENT ON COLUMN "public"."sysmessage"."toname" IS '消息到达名称';
COMMENT ON COLUMN "public"."sysmessage"."fromstatus" IS '-1:已删除；0:默认';
COMMENT ON COLUMN "public"."sysmessage"."tostatus" IS '-1:已删除；0:默认未读；1：已读';
COMMENT ON COLUMN "public"."sysmessage"."href" IS '点击消息跳转的页面等';
COMMENT ON COLUMN "public"."sysmessage"."title" IS '消息标题';
COMMENT ON COLUMN "public"."sysmessage"."content" IS '消息内容';
COMMENT ON COLUMN "public"."sysmessage"."createtime" IS '创建时间';
COMMENT ON COLUMN "public"."sysmessage"."createid" IS '创建人ID';
COMMENT ON TABLE "public"."sysmessage" IS '系统消息表';

-- ----------------------------
-- Records of sysmessage
-- ----------------------------
INSERT INTO "public"."sysmessage" VALUES ('62949f07-fc6e-4c81-9403-f4f5da396f14', '系统消息', 'SYS_MSG', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '系统管理员', 'System', 0, 0, '', '', '你的流程[所有人都可以审批的流程]已被admin处理。', '2025-04-11 15:15:07', '');
INSERT INTO "public"."sysmessage" VALUES ('78f239e2-af21-4c41-9d9f-948144eccc65', '系统消息', 'SYS_MSG', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '系统管理员', 'System', 0, 0, '', '', '你的流程[按角色执行的审批]已被admin处理。', '2025-04-11 15:15:00', '');
INSERT INTO "public"."sysmessage" VALUES ('8f66c6a6-c0f0-48c2-b920-b92ee73fea2a', '系统消息', 'SYS_MSG', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '系统管理员', 'System', 0, 0, '', '', '你的流程[所有人都可以审批的流程]已被admin处理。', '2025-04-11 15:15:07', '');
INSERT INTO "public"."sysmessage" VALUES ('ed02094b-6457-4cd2-b6d4-94cef4032794', '系统消息', 'SYS_MSG', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '系统管理员', 'System', 0, 0, '', '', '你的流程[会前审批1]已被超级管理员处理。', '2025-04-11 15:14:10', '');

-- ----------------------------
-- Table structure for sysprinterplan
-- ----------------------------
DROP TABLE IF EXISTS "public"."sysprinterplan";
CREATE TABLE "public"."sysprinterplan" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "sourcesql" text COLLATE "pg_catalog"."default",
  "columnview" varchar(255) COLLATE "pg_catalog"."default",
  "groupby" varchar(255) COLLATE "pg_catalog"."default",
  "plancontent" text COLLATE "pg_catalog"."default",
  "disable" int2 NOT NULL,
  "createtime" date NOT NULL,
  "createuser" varchar(50) COLLATE "pg_catalog"."default",
  "inparamcolumn" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."sysprinterplan"."id" IS '方案ID';
COMMENT ON COLUMN "public"."sysprinterplan"."name" IS '方案名称';
COMMENT ON COLUMN "public"."sysprinterplan"."sourcesql" IS '数据源;打印方案对应的数据来源SQL';
COMMENT ON COLUMN "public"."sysprinterplan"."columnview" IS '中文视图名;设计打印方案时，提供中文快捷按钮的视图来源';
COMMENT ON COLUMN "public"."sysprinterplan"."groupby" IS '分组字段';
COMMENT ON COLUMN "public"."sysprinterplan"."plancontent" IS '打印方案内容;打印方案JSON对象';
COMMENT ON COLUMN "public"."sysprinterplan"."disable" IS '是否可用';
COMMENT ON COLUMN "public"."sysprinterplan"."createtime" IS '创建日期';
COMMENT ON COLUMN "public"."sysprinterplan"."createuser" IS '创建人';
COMMENT ON COLUMN "public"."sysprinterplan"."inparamcolumn" IS '入口参数字段;入口参数字段数组，通过,分隔';
COMMENT ON TABLE "public"."sysprinterplan" IS '打印方案模板';

-- ----------------------------
-- Records of sysprinterplan
-- ----------------------------

-- ----------------------------
-- Table structure for sysresource
-- ----------------------------
DROP TABLE IF EXISTS "public"."sysresource";
CREATE TABLE "public"."sysresource" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "cascadeid" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "sortno" int4 NOT NULL,
  "description" text COLLATE "pg_catalog"."default" NOT NULL,
  "parentname" varchar(50) COLLATE "pg_catalog"."default",
  "parentid" varchar(50) COLLATE "pg_catalog"."default",
  "appid" varchar(50) COLLATE "pg_catalog"."default",
  "appname" varchar(50) COLLATE "pg_catalog"."default",
  "typename" varchar(20) COLLATE "pg_catalog"."default",
  "typeid" varchar(50) COLLATE "pg_catalog"."default",
  "disable" int2 NOT NULL,
  "createtime" timestamp(6) NOT NULL,
  "createuserid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "createusername" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "updatetime" timestamp(6),
  "updateuserid" varchar(50) COLLATE "pg_catalog"."default",
  "updateusername" varchar(200) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."sysresource"."id" IS '资源标识';
COMMENT ON COLUMN "public"."sysresource"."cascadeid" IS '节点语义ID';
COMMENT ON COLUMN "public"."sysresource"."name" IS '名称';
COMMENT ON COLUMN "public"."sysresource"."sortno" IS '排序号';
COMMENT ON COLUMN "public"."sysresource"."description" IS '描述';
COMMENT ON COLUMN "public"."sysresource"."parentname" IS '父节点名称';
COMMENT ON COLUMN "public"."sysresource"."parentid" IS '父节点流ID';
COMMENT ON COLUMN "public"."sysresource"."appid" IS '资源所属应用ID';
COMMENT ON COLUMN "public"."sysresource"."appname" IS '所属应用名称';
COMMENT ON COLUMN "public"."sysresource"."typename" IS '分类名称';
COMMENT ON COLUMN "public"."sysresource"."typeid" IS '分类ID';
COMMENT ON COLUMN "public"."sysresource"."disable" IS '是否可用';
COMMENT ON COLUMN "public"."sysresource"."createtime" IS '创建时间';
COMMENT ON COLUMN "public"."sysresource"."createuserid" IS '创建人ID';
COMMENT ON COLUMN "public"."sysresource"."createusername" IS '创建人';
COMMENT ON COLUMN "public"."sysresource"."updatetime" IS '最后更新时间';
COMMENT ON COLUMN "public"."sysresource"."updateuserid" IS '最后更新人ID';
COMMENT ON COLUMN "public"."sysresource"."updateusername" IS '最后更新人';
COMMENT ON TABLE "public"."sysresource" IS '资源表';

-- ----------------------------
-- Records of sysresource
-- ----------------------------
INSERT INTO "public"."sysresource" VALUES ('SYS_DEL_USER', '.0.2.', '删除用户', 0, '拥有删除OpenAuth.Net系统用户信息的权限', '根节点', NULL, '110', 'OpenAuth.Net', NULL, NULL, 0, '2019-11-23 00:27:58', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 00:27:58', '', '');
INSERT INTO "public"."sysresource" VALUES ('SYS_UPDATE_USER', '.0.1.', '更新用户信息', 0, '拥有更新OpenAuth.Net系统用户信息的权限', '根节点', NULL, '110', 'OpenAuth.Net', NULL, NULL, 0, '2019-11-23 00:27:17', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 00:27:12', '', '');
INSERT INTO "public"."sysresource" VALUES ('SYS_VIEW_USER', '.0.3.', '查看用户列表', 0, '查看OpenAuth.Net用户列表', '根节点', NULL, '110', 'OpenAuth.Net', NULL, NULL, 0, '2019-11-23 00:44:39', '6ba79766-faa0-4259-8139-a4a6d35784e0', 'test', '2019-11-23 00:44:39', '', '');
INSERT INTO "public"."sysresource" VALUES ('XXX_ADDORDER', '.0.6.', '创建订单', 0, '在XXX平台创建订单', '根节点', NULL, '119', 'XXX管理平台', NULL, NULL, 0, '2019-11-23 00:53:24', '6ba79766-faa0-4259-8139-a4a6d35784e0', 'test', '2019-11-23 00:53:24', '', '');
INSERT INTO "public"."sysresource" VALUES ('XXX_DEL_LOG', '.0.4.', '删除XXX平台日志', 0, '删除XXX平台日志', '根节点', NULL, '119', 'XXX管理平台', NULL, NULL, 0, '2019-11-23 00:45:02', '6ba79766-faa0-4259-8139-a4a6d35784e0', 'test', '2019-11-23 00:45:02', '', '');
INSERT INTO "public"."sysresource" VALUES ('XXX_LOGIN', '.0.7.', '登录', 0, '登录XXX平台', '根节点', NULL, '119', 'XXX管理平台', NULL, NULL, 0, '2019-11-23 00:55:20', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 00:55:20', '', '');
INSERT INTO "public"."sysresource" VALUES ('XXX_VIEW_USER', '.0.5.', '查看用户', 0, '查看XXX平台用户列表', '根节点', NULL, '119', 'XXX管理平台', NULL, NULL, 0, '2019-11-23 00:53:01', '6ba79766-faa0-4259-8139-a4a6d35784e0', 'test', '2019-11-23 00:53:01', '', '');

-- ----------------------------
-- Table structure for sysuser
-- ----------------------------
DROP TABLE IF EXISTS "public"."sysuser";
CREATE TABLE "public"."sysuser" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "account" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "password" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "sex" int4 NOT NULL,
  "status" int4 NOT NULL,
  "bizcode" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "createtime" timestamp(6) NOT NULL,
  "createid" varchar(50) COLLATE "pg_catalog"."default",
  "typename" varchar(20) COLLATE "pg_catalog"."default",
  "typeid" varchar(50) COLLATE "pg_catalog"."default",
  "parentid" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."sysuser"."id" IS '流水号';
COMMENT ON COLUMN "public"."sysuser"."account" IS '用户登录帐号';
COMMENT ON COLUMN "public"."sysuser"."password" IS '密码';
COMMENT ON COLUMN "public"."sysuser"."name" IS '用户姓名';
COMMENT ON COLUMN "public"."sysuser"."sex" IS '性别';
COMMENT ON COLUMN "public"."sysuser"."status" IS '用户状态';
COMMENT ON COLUMN "public"."sysuser"."bizcode" IS '业务对照码';
COMMENT ON COLUMN "public"."sysuser"."createtime" IS '经办时间';
COMMENT ON COLUMN "public"."sysuser"."createid" IS '创建人';
COMMENT ON COLUMN "public"."sysuser"."typename" IS '分类名称';
COMMENT ON COLUMN "public"."sysuser"."typeid" IS '分类ID';
COMMENT ON COLUMN "public"."sysuser"."parentid" IS '直属上级';
COMMENT ON TABLE "public"."sysuser" IS '用户基本信息表';

-- ----------------------------
-- Records of sysuser
-- ----------------------------
INSERT INTO "public"."sysuser" VALUES ('0ceff0f8-f848-440c-bc26-d8605ac858cd', 'test5', 'test5', 'test5', 1, 1, '', '2022-03-15 09:19:05', '', '', '', '6ba79766-faa0-4259-8139-a4a6d35784e0');
INSERT INTO "public"."sysuser" VALUES ('1df68dfd-3b6d-4491-872f-00a0fc6c5a64', 'test4', 'test4', 'test4', 1, 1, '', '2022-12-12 14:07:11', '', '', '', '6ba79766-faa0-4259-8139-a4a6d35784e0');
INSERT INTO "public"."sysuser" VALUES ('229f3a49-ab27-49ce-b383-9f10ca23a9d5', 'test3', 'test3', 'test3', 1, 0, '', '2022-12-12 14:07:05', '', '', '', '6ba79766-faa0-4259-8139-a4a6d35784e0');
INSERT INTO "public"."sysuser" VALUES ('49df1602-f5f3-4d52-afb7-3802da619558', 'admin', 'admin', 'admin', 1, 0, '', '2022-12-11 16:18:54', '', '', '', NULL);
INSERT INTO "public"."sysuser" VALUES ('6ba79766-faa0-4259-8139-a4a6d35784e0', 'test', 'test', 'test', 1, 0, '', '2022-12-11 16:19:00', '', '', '', '49df1602-f5f3-4d52-afb7-3802da619558');
INSERT INTO "public"."sysuser" VALUES ('758a34c7-5a31-438c-bdf7-02fdd846b901', 'test77', 'test77', 'test77', 0, 0, '', '2022-10-31 21:59:08', '00000000-0000-0000-0000-000000000000', '', '', NULL);
INSERT INTO "public"."sysuser" VALUES ('96f63f9d-e8c8-4258-963e-3327ed7d6f56', 'test66', 'test66', 'test66', 0, 0, '', '2022-10-31 21:58:43', '00000000-0000-0000-0000-000000000000', '', '', NULL);
INSERT INTO "public"."sysuser" VALUES ('de8be521-f1ec-4483-b124-0be342890507', 'test2', 'test2', 'test2', 1, 0, '', '2022-12-11 16:19:06', '', '', '', '49df1602-f5f3-4d52-afb7-3802da619558');

-- ----------------------------
-- Table structure for uploadfile
-- ----------------------------
DROP TABLE IF EXISTS "public"."uploadfile";
CREATE TABLE "public"."uploadfile" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "filename" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "filepath" text COLLATE "pg_catalog"."default" NOT NULL,
  "description" varchar(200) COLLATE "pg_catalog"."default",
  "filetype" varchar(20) COLLATE "pg_catalog"."default",
  "filesize" int4,
  "extension" varchar(20) COLLATE "pg_catalog"."default",
  "enable" int2 NOT NULL,
  "sortcode" int4 NOT NULL,
  "deletemark" int2 NOT NULL,
  "createuserid" char(36) COLLATE "pg_catalog"."default",
  "createusername" varchar(50) COLLATE "pg_catalog"."default",
  "createtime" timestamp(6) NOT NULL,
  "thumbnail" text COLLATE "pg_catalog"."default",
  "belongapp" varchar(200) COLLATE "pg_catalog"."default",
  "belongappid" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."uploadfile"."id" IS 'Id';
COMMENT ON COLUMN "public"."uploadfile"."filename" IS '文件名称';
COMMENT ON COLUMN "public"."uploadfile"."filepath" IS '文件路径';
COMMENT ON COLUMN "public"."uploadfile"."description" IS '描述';
COMMENT ON COLUMN "public"."uploadfile"."filetype" IS '文件类型';
COMMENT ON COLUMN "public"."uploadfile"."filesize" IS '文件大小';
COMMENT ON COLUMN "public"."uploadfile"."extension" IS '扩展名称';
COMMENT ON COLUMN "public"."uploadfile"."enable" IS '是否可用';
COMMENT ON COLUMN "public"."uploadfile"."sortcode" IS '排序';
COMMENT ON COLUMN "public"."uploadfile"."deletemark" IS '删除标识';
COMMENT ON COLUMN "public"."uploadfile"."createuserid" IS '上传人';
COMMENT ON COLUMN "public"."uploadfile"."createusername" IS '上传人姓名';
COMMENT ON COLUMN "public"."uploadfile"."createtime" IS '上传时间';
COMMENT ON COLUMN "public"."uploadfile"."thumbnail" IS '缩略图';
COMMENT ON COLUMN "public"."uploadfile"."belongapp" IS '所属应用';
COMMENT ON COLUMN "public"."uploadfile"."belongappid" IS '所属应用ID';
COMMENT ON TABLE "public"."uploadfile" IS '文件';

-- ----------------------------
-- Records of uploadfile
-- ----------------------------

-- ----------------------------
-- Table structure for wmsinboundorderdtbl
-- ----------------------------
DROP TABLE IF EXISTS "public"."wmsinboundorderdtbl";
CREATE TABLE "public"."wmsinboundorderdtbl" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "orderid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "price" numeric(18,6),
  "pricenotax" numeric(18,6),
  "instockstatus" int2 NOT NULL,
  "asnstatus" int4 NOT NULL,
  "goodsid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "goodsbatch" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "qualityflg" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "ordernum" numeric(18,2) NOT NULL,
  "innum" numeric(18,2) NOT NULL,
  "leavenum" numeric(18,2) NOT NULL,
  "holdnum" numeric(18,2) NOT NULL,
  "proddate" varchar(30) COLLATE "pg_catalog"."default",
  "expiredate" varchar(30) COLLATE "pg_catalog"."default",
  "taxrate" numeric(10,2),
  "ownerid" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "remark" varchar(128) COLLATE "pg_catalog"."default",
  "createtime" timestamp(6) NOT NULL,
  "createuserid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "createusername" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "updatetime" timestamp(6),
  "updateuserid" varchar(50) COLLATE "pg_catalog"."default",
  "updateusername" varchar(200) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."id" IS '入库通知单明细号';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."orderid" IS '入库通知单号';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."price" IS '含税单价';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."pricenotax" IS '无税单价';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."instockstatus" IS '是否收货中(0:非收货中,1:收货中)';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."asnstatus" IS '到货状况(SYS_GOODSARRIVESTATUS)';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."goodsid" IS '商品编号';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."goodsbatch" IS '商品批号';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."qualityflg" IS '品质(SYS_QUALITYFLAG)';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."ordernum" IS '通知数量';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."innum" IS '到货数量';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."leavenum" IS '剩余数量';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."holdnum" IS '占用数量';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."proddate" IS '生产日期';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."expiredate" IS '失效日期';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."taxrate" IS '税率';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."ownerid" IS '货主编号';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."remark" IS '备注';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."createtime" IS '创建时间';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."createuserid" IS '创建人ID';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."createusername" IS '创建人';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."updatetime" IS '最后更新时间';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."updateuserid" IS '最后更新人ID';
COMMENT ON COLUMN "public"."wmsinboundorderdtbl"."updateusername" IS '最后更新人';
COMMENT ON TABLE "public"."wmsinboundorderdtbl" IS '入库通知单明细';

-- ----------------------------
-- Records of wmsinboundorderdtbl
-- ----------------------------
INSERT INTO "public"."wmsinboundorderdtbl" VALUES ('09a939ad-7e40-42f2-b0b3-fa9b74f94897', '20190035RK0001', 77.000000, 73.210000, 0, 0, '', '10045', '', 32.00, 0.00, 0.00, 0.00, '', '', 0.00, '', '', '2019-11-06 10:37:38', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 01:29:59', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."wmsinboundorderdtbl" VALUES ('1e547556-9549-44d5-9da3-c07d98b5943e', '2019102203RK0003', 10.000000, 6.000000, 0, 0, '', '', '', 0.00, 0.00, 0.00, 0.00, '', '', 0.00, '', '', '2019-11-07 01:00:35', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 01:29:00', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."wmsinboundorderdtbl" VALUES ('2ae93007-1490-4e81-b410-957fc08e2371', '2019102203RK0001', 25.000000, 22.500000, 0, 0, '', '100011', '', 0.00, 0.00, 0.00, 0.00, '', '', 0.00, '', '', '2019-11-06 10:32:10', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 01:28:47', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."wmsinboundorderdtbl" VALUES ('30eb475b-ed86-4106-88f0-47a5a32ec8aa', 'TEST_002', 10.000000, 10.000000, 0, 1, '', 'CJ-334', '', 10.00, 8.00, 2.00, 0.00, '2019-11-22', '', 0.00, '', '', '2019-11-23 01:26:54', '6ba79766-faa0-4259-8139-a4a6d35784e0', 'test', '2019-11-23 01:26:54', '', '');
INSERT INTO "public"."wmsinboundorderdtbl" VALUES ('56b5612c-e048-4650-9710-4b235731d548', '20190035RK0001', 62.000000, 60.230000, 0, 0, '', '133521', '', 10.00, 0.00, 0.00, 0.00, '', '', 0.00, '', '', '2019-11-06 10:37:38', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 01:29:59', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."wmsinboundorderdtbl" VALUES ('5e7d6ef8-351a-4600-849e-3958588161a7', '20190035RK0001', 55.000000, 54.230000, 0, 0, '', 'FK85122', '', 14.00, 0.00, 0.00, 0.00, '', '', 0.00, '', '', '2019-11-06 10:37:38', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 01:29:59', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."wmsinboundorderdtbl" VALUES ('78c0a896-8341-47d4-b6d2-f241cec9fb58', 'TEST_001', 998.500000, 985.000000, 0, 1, '', 'CJ-P-4446', '', 500.00, 500.00, 0.00, 0.00, '2019-11-22', '2020-11-12', 6.00, '', '', '2019-11-23 01:27:49', '6ba79766-faa0-4259-8139-a4a6d35784e0', 'test', '2019-11-23 01:29:38', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."wmsinboundorderdtbl" VALUES ('95d6d2a8-0e17-426b-97f3-3c8a82bca313', '20190035RK0001', 15.000000, 13.220000, 0, 0, '', '10052', '', 52.00, 0.00, 0.00, 0.00, '', '', 0.00, '', '', '2019-11-06 10:37:38', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 01:29:59', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."wmsinboundorderdtbl" VALUES ('b195386a-4f09-4e31-9d72-8e94526f9419', '2019102203RK0133', 200.000000, 199.000000, 0, 0, '', '', '', 0.00, 0.00, 0.00, 0.00, '', '', 0.00, '', '', '2019-11-07 01:24:11', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-07 01:24:11', '', '');
INSERT INTO "public"."wmsinboundorderdtbl" VALUES ('ca470c60-9231-4c13-b51b-ad90c39633ae', '2019102203RK0187', 22.220000, 20.000000, 0, 0, '', '', '', 0.00, 0.00, 0.00, 0.00, '', '', 0.00, '', '', '2019-11-07 01:03:27', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 01:29:48', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."wmsinboundorderdtbl" VALUES ('d19df810-5c47-4a32-a3a5-c908da60bf8b', 'TEST_002', 6.670000, 6.000000, 0, 1, '', 'CJ-335', '', 54.00, 54.00, 0.00, 0.00, '', '', 0.00, '', '', '2019-11-23 01:26:54', '6ba79766-faa0-4259-8139-a4a6d35784e0', 'test', '2019-11-23 01:26:54', '', '');
INSERT INTO "public"."wmsinboundorderdtbl" VALUES ('dc0f9da2-0e0e-4dc3-9e59-2b0d51e53211', '2019102203RK0001', 10.000000, 8.000000, 0, 1, '', '100010', '', 0.00, 0.00, 0.00, 0.00, '', '', 0.00, '', '', '2019-11-06 10:32:10', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 01:28:47', '00000000-0000-0000-0000-000000000000', '超级管理员');
INSERT INTO "public"."wmsinboundorderdtbl" VALUES ('fcf051d3-5c00-4617-895f-e45891d975df', '2019102203RK0002', 22.520000, 18.990000, 0, 1, '', '100020', '', 10.00, 0.00, 0.00, 0.00, '', '', 0.00, '', '', '2019-11-06 10:32:45', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 01:28:53', '00000000-0000-0000-0000-000000000000', '超级管理员');

-- ----------------------------
-- Table structure for wmsinboundordertbl
-- ----------------------------
DROP TABLE IF EXISTS "public"."wmsinboundordertbl";
CREATE TABLE "public"."wmsinboundordertbl" (
  "id" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "externalno" varchar(50) COLLATE "pg_catalog"."default",
  "externaltype" varchar(50) COLLATE "pg_catalog"."default",
  "status" int4 NOT NULL,
  "ordertype" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "goodstype" varchar(50) COLLATE "pg_catalog"."default",
  "purchaseno" varchar(30) COLLATE "pg_catalog"."default",
  "stockid" varchar(12) COLLATE "pg_catalog"."default" NOT NULL,
  "ownerid" varchar(50) COLLATE "pg_catalog"."default",
  "shipperid" varchar(50) COLLATE "pg_catalog"."default",
  "supplierid" varchar(50) COLLATE "pg_catalog"."default",
  "scheduledinboundtime" timestamp(6),
  "remark" text COLLATE "pg_catalog"."default",
  "enable" int2 NOT NULL,
  "transfertype" varchar(50) COLLATE "pg_catalog"."default",
  "inbondedarea" int2 NOT NULL,
  "returnboxnum" numeric(8,0) NOT NULL,
  "createtime" timestamp(6) NOT NULL,
  "createuserid" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "createusername" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "updatetime" timestamp(6),
  "updateuserid" varchar(50) COLLATE "pg_catalog"."default",
  "updateusername" varchar(200) COLLATE "pg_catalog"."default",
  "orgid" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wmsinboundordertbl"."id" IS '入库通知单号';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."externalno" IS '相关单据号';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."externaltype" IS '相关单据类型';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."status" IS '入库通知单状态(SYS_INSTCINFORMSTATUS)';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."ordertype" IS '入库类型(SYS_INSTCTYPE)';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."goodstype" IS '商品类别';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."purchaseno" IS '采购单号';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."stockid" IS '仓库编号';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."ownerid" IS '货主编号(固定值CQM)';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."shipperid" IS '承运人编号';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."supplierid" IS '供应商编号';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."scheduledinboundtime" IS '预定入库时间';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."remark" IS '备注';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."enable" IS '有效标志';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."transfertype" IS '承运方式';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."inbondedarea" IS '是否入保税库(0:否,1:是)';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."returnboxnum" IS '销退箱数';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."createtime" IS '创建时间';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."createuserid" IS '创建人ID';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."createusername" IS '创建人';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."updatetime" IS '最后更新时间';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."updateuserid" IS '最后更新人ID';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."updateusername" IS '最后更新人';
COMMENT ON COLUMN "public"."wmsinboundordertbl"."orgid" IS '所属部门';
COMMENT ON TABLE "public"."wmsinboundordertbl" IS '入库通知单（入库订单）';

-- ----------------------------
-- Records of wmsinboundordertbl
-- ----------------------------
INSERT INTO "public"."wmsinboundordertbl" VALUES ('20190035RK0001', '20190035RK0001', '', 1, 'SYS_INBOUNDTYPE_SAMPLE', '不合格', '20190035RK0001', '', '', '', '', '2019-11-20 00:00:00', '', 1, 'SYS_SHIPTYPE_FREIGHT', 1, 0, '2019-11-06 10:33:17', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 01:29:59', '00000000-0000-0000-0000-000000000000', '超级管理员', NULL);
INSERT INTO "public"."wmsinboundordertbl" VALUES ('20190035RK0002', '20190035RK0002', '', 0, '样品入库', '特殊药品', '20190035RK0002', '', '', '', '', '2019-11-14 00:00:00', '', 1, 'SYS_SHIPTYPE_FREIGHT', 1, 0, '2019-11-06 10:34:58', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 01:30:07', '00000000-0000-0000-0000-000000000000', '超级管理员', NULL);
INSERT INTO "public"."wmsinboundordertbl" VALUES ('2019102203RK0001', '2019102203RK0001', '1', 1, '普通入库', '普通商品', '2019102203RK0001', 'BJ003', 'CDC001', 'SF', 'SF', '2019-10-10 00:00:00', '', 1, 'SYS_SHIPTYPE_FREIGHT', 0, 1, '2019-10-31 21:27:14', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 01:28:47', '00000000-0000-0000-0000-000000000000', '超级管理员', NULL);
INSERT INTO "public"."wmsinboundordertbl" VALUES ('2019102203RK0002', '2019102203RK0002', '1', 1, '普通入库', '普通商品', '2019102203RK0002', 'BJ003', 'CDC001', 'SF', 'SF', '2019-10-10 00:00:00', '', 1, 'SYS_SHIPTYPE_NORMAL', 1, 20, '2019-10-31 21:27:14', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 01:28:53', '00000000-0000-0000-0000-000000000000', '超级管理员', NULL);
INSERT INTO "public"."wmsinboundordertbl" VALUES ('2019102203RK0003', '2019102203RK0003', '1', 1, 'SYS_INBOUNDTYPE_RETURN', '普通商品', '2019102203RK0003', 'BJ003', 'CDC001', 'SF', 'SF', '2019-10-10 00:00:00', '', 1, 'SYS_SHIPTYPE_EMS', 0, 1, '2019-10-31 21:27:14', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 01:29:00', '00000000-0000-0000-0000-000000000000', '超级管理员', NULL);
INSERT INTO "public"."wmsinboundordertbl" VALUES ('2019102203RK0133', '2019102203RK0133', '', 0, 'SYS_INBOUNDTYPE_SAMPLE', 'SYS_GOODSTYPE_COMMON', '2019102203RK0133', '', '', '001', '', '2019-11-26 00:00:00', '', 1, 'SYS_SHIPTYPE_EMS', 1, 0, '2019-11-07 01:24:11', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-07 01:24:11', '', '', NULL);
INSERT INTO "public"."wmsinboundordertbl" VALUES ('2019102203RK0187', '2019102203RK0187', '', 1, 'SYS_INBOUNDTYPE_PURCHASE', 'SYS_GOODSTYPE_MEDINSTR', '2019102203RK0187', '', '', '', '', NULL, '', 1, 'SYS_SHIPTYPE_NORMAL', 1, 0, '2019-11-07 01:03:27', '00000000-0000-0000-0000-000000000000', '超级管理员', '2019-11-23 01:29:48', '00000000-0000-0000-0000-000000000000', '超级管理员', NULL);
INSERT INTO "public"."wmsinboundordertbl" VALUES ('TEST_001', 'TEST_001', NULL, 0, 'SYS_INBOUNDTYPE_PURCHASE', 'SYS_GOODSTYPE_BIOLPROD', 'TEST_001', '001', 'BJ02', NULL, NULL, NULL, NULL, 0, 'SYS_SHIPTYPE_NORMAL', 0, 0, '2019-11-23 01:25:08', '6ba79766-faa0-4259-8139-a4a6d35784e0', 'test', '2019-11-23 01:29:38', '00000000-0000-0000-0000-000000000000', '超级管理员', NULL);
INSERT INTO "public"."wmsinboundordertbl" VALUES ('TEST_002', 'TEST_002', '', 0, 'SYS_INBOUNDTYPE_PURCHASE', 'SYS_GOODSTYPE_COMMON', 'TEST_002', '002', '', '', '', '2019-11-12 00:00:00', '', 0, 'SYS_SHIPTYPE_EMS', 1, 0, '2019-11-23 01:26:54', '6ba79766-faa0-4259-8139-a4a6d35784e0', 'test', '2019-11-23 01:26:54', '', '', NULL);

-- ----------------------------
-- Primary Key structure for table application
-- ----------------------------
ALTER TABLE "public"."application" ADD CONSTRAINT "application_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table buildertable
-- ----------------------------
ALTER TABLE "public"."buildertable" ADD CONSTRAINT "buildertable_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table buildertablecolumn
-- ----------------------------
ALTER TABLE "public"."buildertablecolumn" ADD CONSTRAINT "buildertablecolumn_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table category
-- ----------------------------
ALTER TABLE "public"."category" ADD CONSTRAINT "category_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table categorytype
-- ----------------------------
ALTER TABLE "public"."categorytype" ADD CONSTRAINT "categorytype_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table dataprivilegerule
-- ----------------------------
ALTER TABLE "public"."dataprivilegerule" ADD CONSTRAINT "dataprivilegerule_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table externaldatasource
-- ----------------------------
ALTER TABLE "public"."externaldatasource" ADD CONSTRAINT "externaldatasource_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table flowapprover
-- ----------------------------
ALTER TABLE "public"."flowapprover" ADD CONSTRAINT "flowapprover_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table flowinstance
-- ----------------------------
ALTER TABLE "public"."flowinstance" ADD CONSTRAINT "flowinstance_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table flowinstanceoperationhistory
-- ----------------------------
ALTER TABLE "public"."flowinstanceoperationhistory" ADD CONSTRAINT "flowinstanceoperationhistory_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table flowinstancetransitionhistory
-- ----------------------------
ALTER TABLE "public"."flowinstancetransitionhistory" ADD CONSTRAINT "flowinstancetransitionhistory_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table flowscheme
-- ----------------------------
ALTER TABLE "public"."flowscheme" ADD CONSTRAINT "flowscheme_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table form
-- ----------------------------
ALTER TABLE "public"."form" ADD CONSTRAINT "form_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table frmleavereq
-- ----------------------------
ALTER TABLE "public"."frmleavereq" ADD CONSTRAINT "frmleavereq_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table module
-- ----------------------------
ALTER TABLE "public"."module" ADD CONSTRAINT "module_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table moduleelement
-- ----------------------------
ALTER TABLE "public"."moduleelement" ADD CONSTRAINT "moduleelement_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table openjob
-- ----------------------------
ALTER TABLE "public"."openjob" ADD CONSTRAINT "openjob_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table org
-- ----------------------------
ALTER TABLE "public"."org" ADD CONSTRAINT "org_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table relevance
-- ----------------------------
ALTER TABLE "public"."relevance" ADD CONSTRAINT "relevance_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table role
-- ----------------------------
ALTER TABLE "public"."role" ADD CONSTRAINT "role_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table stock
-- ----------------------------
ALTER TABLE "public"."stock" ADD CONSTRAINT "stock_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table syslog
-- ----------------------------
ALTER TABLE "public"."syslog" ADD CONSTRAINT "syslog_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table sysmessage
-- ----------------------------
ALTER TABLE "public"."sysmessage" ADD CONSTRAINT "sysmessage_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table sysprinterplan
-- ----------------------------
ALTER TABLE "public"."sysprinterplan" ADD CONSTRAINT "sysprinterplan_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table sysresource
-- ----------------------------
ALTER TABLE "public"."sysresource" ADD CONSTRAINT "sysresource_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table sysuser
-- ----------------------------
ALTER TABLE "public"."sysuser" ADD CONSTRAINT "sysuser_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table uploadfile
-- ----------------------------
ALTER TABLE "public"."uploadfile" ADD CONSTRAINT "uploadfile_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wmsinboundorderdtbl
-- ----------------------------
ALTER TABLE "public"."wmsinboundorderdtbl" ADD CONSTRAINT "wmsinboundorderdtbl_pkey" PRIMARY KEY ("id", "orderid");

-- ----------------------------
-- Primary Key structure for table wmsinboundordertbl
-- ----------------------------
ALTER TABLE "public"."wmsinboundordertbl" ADD CONSTRAINT "wmsinboundordertbl_pkey" PRIMARY KEY ("id");
