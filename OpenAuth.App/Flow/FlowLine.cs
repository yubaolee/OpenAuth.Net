// <copyright file="FlowLine.cs" company="openauth.net.cn">
// Copyright (c) 2019 openauth.net.cn. All rights reserved.
// </copyright>
// <author>www.cnblogs.com/yubaolee</author>
// <date>2019-03-05</date>
// <summary>流程中的连线</summary>

using System.Collections.Generic;
using System.Linq;
using Infrastructure;
using Infrastructure.Extensions;
using Newtonsoft.Json.Linq;

namespace OpenAuth.App.Flow
{
    /// <summary>
    /// 流程连线
    /// </summary>
    public class FlowLine
    {
        public string id { get; set; }
        public string label { get; set; }
        public string type { get; set; }
        public string from { get; set; }
        public string to { get; set; }
        public string name { get; set; }
        public bool dash { get; set; }

        /// <summary> 分支条件 </summary>
        public List<DataCompare> Compares { get; set; }

        public bool Compare(JObject frmDataJson)
        {
            bool result = true;
            foreach (var compare in Compares)
            {
                object objVal = frmDataJson.GetValue(compare.FieldName.ToLower());
                string fieldVal = null;
                List<string> fieldVals = new List<string>();
                if(compare.FieldType == "checkbox")
                {
                    if (objVal is JArray jArray)
                    {
                        var tempvals = jArray.ToObject<List<string>>();
                        if (tempvals != null && tempvals.Any())
                        {
                            fieldVals.AddRange(tempvals);
                        }
                    }
                }
                else
                {
                    fieldVal = objVal?.ToString();
                }

                
                // 判断是否为空值操作符
                if (compare.Operation == DataCompare.IsNull || compare.Operation == DataCompare.IsNotNull)
                {
                    var fieldExists = objVal != null;
                    var fieldEmpty = !fieldExists || string.IsNullOrWhiteSpace(objVal.ToString());

                    if (compare.Operation == DataCompare.IsNull)
                    {
                        result &= fieldEmpty;
                    }
                    else
                    {
                        result &= !fieldEmpty;
                    }
                    continue;
                }

                // 确保字段存在且不为空
                if (objVal == null)
                {
                    result = false;
                    continue;
                }

                // checkbox类型特殊处理
                if (compare.FieldType == "checkbox")
                {
                    // 针对checkbox的IN和NOT IN操作
                    if (compare.Operation == DataCompare.In || compare.Operation == DataCompare.NotIn)
                    {
                        if (compare.ValueList == null || compare.ValueList.Length == 0)
                        {
                            result = false;
                            continue;
                        }

                        // 检查是否有交集
                        bool hasIntersection = fieldVals.Any(v => compare.ValueList.Contains(v));
                        result &= compare.Operation == DataCompare.In ? hasIntersection : !hasIntersection;
                        continue;
                    }
                    
                    // 针对checkbox的相等和不等操作
                    if (compare.Operation == DataCompare.Equal)
                    {
                        result &= fieldVals.Contains(compare.Value);
                        continue;
                    }
                    else if (compare.Operation == DataCompare.NotEqual)
                    {
                        result &= !fieldVals.Contains(compare.Value);
                        continue;
                    }
                    
                    // 其他操作不适用于checkbox，默认为false
                    result = false;
                    continue;
                }

                // 以下是非checkbox类型的处理逻辑
                // 范围操作符处理
                if (compare.Operation == DataCompare.In || compare.Operation == DataCompare.NotIn)
                {
                    if (compare.ValueList == null || compare.ValueList.Length == 0)
                    {
                        result = false;
                        continue;
                    }

                    bool inList = compare.ValueList.Contains(fieldVal);
                    result &= compare.Operation == DataCompare.In ? inList : !inList;
                    continue;
                }

                // Between操作符处理
                if (compare.Operation == DataCompare.Between)
                {
                    if (compare.ValueRange == null || compare.ValueRange.Length != 2)
                    {
                        result = false;
                        continue;
                    }

                    bool isDecimal = decimal.TryParse(fieldVal, out decimal fieldDecimal);
                    if (isDecimal)
                    {
                        decimal min = decimal.Parse(compare.ValueRange[0]);
                        decimal max = decimal.Parse(compare.ValueRange[1]);
                        result &= fieldDecimal >= min && fieldDecimal <= max;
                    }
                    else
                    {
                        string min = compare.ValueRange[0];
                        string max = compare.ValueRange[1];
                        result &= string.Compare(fieldVal, min, false) >= 0 && string.Compare(fieldVal, max, false) <= 0;
                    }
                    continue;
                }

                // 文本特殊操作符处理
                if (compare.Operation == DataCompare.Like || compare.Operation == DataCompare.NotLike ||
                    compare.Operation == DataCompare.StartWith || compare.Operation == DataCompare.EndWith)
                {
                    switch (compare.Operation)
                    {
                        case DataCompare.Like:
                            result &= fieldVal.Contains(compare.Value);
                            break;
                        case DataCompare.NotLike:
                            result &= !fieldVal.Contains(compare.Value);
                            break;
                        case DataCompare.StartWith:
                            result &= fieldVal.StartsWith(compare.Value);
                            break;
                        case DataCompare.EndWith:
                            result &= fieldVal.EndsWith(compare.Value);
                            break;
                    }
                    continue;
                }

                bool isDecimalValue = decimal.TryParse(compare.Value, out decimal value);

                if (isDecimalValue)  //如果是数字或小数
                {
                    decimal frmvalue = decimal.Parse(fieldVal);
                    switch (compare.Operation)
                    {
                        case DataCompare.Equal:
                            result &= frmvalue == value;
                            break;
                        case DataCompare.Larger:
                            result &= frmvalue > value;
                            break;
                        case DataCompare.Less:
                            result &= frmvalue < value;
                            break;
                        case DataCompare.LargerEqual:
                            result &= frmvalue >= value;
                            break;
                        case DataCompare.LessEqual:
                            result &= frmvalue <= value;
                            break;
                        case DataCompare.NotEqual:
                            result &= frmvalue != value;
                            break;
                    }
                }
                else //如果只是字符串
                {
                    switch (compare.Operation)
                    {
                        case DataCompare.Equal:
                            result &= compare.Value == fieldVal;
                            break;
                        case DataCompare.Larger:
                            result &= string.Compare(fieldVal, compare.Value, false) > 0;
                            break;
                        case DataCompare.Less:
                            result &= string.Compare(fieldVal, compare.Value, false) < 0;
                            break;
                        case DataCompare.LargerEqual:
                            result &= string.Compare(fieldVal, compare.Value, false) >= 0;
                            break;
                        case DataCompare.LessEqual:
                            result &= string.Compare(fieldVal, compare.Value, false) <= 0;
                            break;
                        case DataCompare.NotEqual:
                            result &= compare.Value != fieldVal;
                            break;
                    }
                }
            }

            return result;
        }
    }

    /// <summary>
    ///  分支条件
    /// </summary>
    public class DataCompare
    {
        // 基本比较操作符
        public const string Larger = ">";
        public const string Less = "<";
        public const string LargerEqual = ">=";
        public const string LessEqual = "<=";
        public const string NotEqual = "!=";
        public const string Equal = "=";

        // 文本操作符
        public const string Like = "LIKE";
        public const string NotLike = "NOT LIKE";
        public const string StartWith = "START_WITH";
        public const string EndWith = "END_WITH";

        // 范围操作符
        public const string In = "IN";
        public const string NotIn = "NOT IN";
        public const string Between = "BETWEEN";

        // 空值操作符
        public const string IsNull = "IS NULL";
        public const string IsNotNull = "IS NOT NULL";

        /// <summary>操作类型比如大于/等于/小于</summary>
        public string Operation { get; set; }

        /// <summary> form种的字段名称 </summary>
        public string FieldName { get; set; }

        /// <summary> 字段类型："form"：为表单中的字段，后期扩展系统表等. </summary>
        public string FieldType { get; set; }

        /// <summary>比较的值</summary>
        public string Value { get; set; }

        /// <summary> 值范围BETWEEN </summary>
        public string[] ValueRange { get; set; }

        /// <summary>  IN 和 NOT IN 操作符 </summary>
        public string[] ValueList { get; set; }
    }
}
