﻿//------------------------------------------------------------------------------
// <autogenerated>
//     This code was generated by a CodeSmith Template.
//
//     DO NOT MODIFY contents of this file. Changes to this
//     file will be lost if the code is regenerated.
//     Author:Yubao Li
// </autogenerated>
//------------------------------------------------------------------------------
using System;
using System.Collections.Generic;
using System.Text;

namespace OpenAuth.Domain
{
    /// <summary>
	/// 
	/// </summary>
    public partial class WFProcessScheme :Entity
    {
        public WFProcessScheme()
        {
          this.SchemeContent= string.Empty;
          this.WFSchemeInfoId= string.Empty;
          this.SchemeVersion= string.Empty;
          this.ProcessType= 0;
        }

        /// <summary>
	    /// 
	    /// </summary>
        public string SchemeContent { get; set; }
        /// <summary>
	    /// 
	    /// </summary>
        public string WFSchemeInfoId { get; set; }
        /// <summary>
	    /// 
	    /// </summary>
        public string SchemeVersion { get; set; }
        /// <summary>
	    /// 
	    /// </summary>
        public int ProcessType { get; set; }

    }
}