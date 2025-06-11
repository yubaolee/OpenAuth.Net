// ***********************************************************************
// Assembly         : FundationAdmin
// Author           : yubaolee
// Created          : 03-09-2016
//
// Last Modified By : yubaolee
// Last Modified On : 03-09-2016
// ***********************************************************************
// <copyright file="PagedDynamicDataResp.cs" company="Microsoft">
//     版权所有(C) Microsoft 2015
// </copyright>
// <summary>layui datatable数据返回</summary>
// ***********************************************************************

using System.Collections.Generic;
using OpenAuth.Repository.Domain;

namespace OpenAuth.App.Response
{
    /// <summary>
    /// 返回动态数据类型的分页数据
    /// <para>带有列定义</para>
    /// </summary>
    public class PagedDynamicDataResp : Infrastructure.Response
    {
        /// <summary>
        /// 总记录条数
        /// </summary>
        public int Count { get; set; }

       
        /// <summary>
        ///  返回的表格列定义
        /// 该属性基于代码生成使用的列定义
        /// </summary>
        public List<BuilderTableColumn> ColumnFields{ get; set; }

        /// <summary>
        /// 数据内容
        /// </summary>
        public dynamic Data { get; set; }

        public PagedDynamicDataResp()
        {
            Code = 200;
            Message = "加载成功";
            ColumnFields = new List<BuilderTableColumn>();
        }
    }
}