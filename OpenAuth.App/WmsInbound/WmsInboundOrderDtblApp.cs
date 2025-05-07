using System;
using System.Linq;
using System.Threading.Tasks;
using Infrastructure;
using OpenAuth.App.Interface;
using OpenAuth.App.Request;
using OpenAuth.App.Response;
using OpenAuth.Repository.Domain;

using SqlSugar;

namespace OpenAuth.App
{
    public class WmsInboundOrderDtblApp : SqlSugarBaseApp<WmsInboundOrderDtbl>
    {
        /// <summary>
        /// 加载列表
        /// </summary>
        public async Task<TableData> Load(QueryWmsInboundOrderDtblListReq request)
        {

            var loginContext = _auth.GetCurrentUser();
            if (loginContext == null)
            {
                throw new CommonException("登录已过期", Define.INVALID_TOKEN);
            }

            var properties = loginContext.GetTableColumns("WmsInboundOrderDtbl");
            if (properties == null || properties.Count == 0)
            {
                throw new Exception("请在代码生成界面配置WmsInboundOrderDtbl表的字段属性");
            }
            var result = new TableData();
            var objs = SugarClient.Queryable<WmsInboundOrderDtbl>();
            if (!string.IsNullOrEmpty(request.InboundOrderId))
            {
                objs = objs.Where(u => u.OrderId == request.InboundOrderId);
            }

            if (!string.IsNullOrEmpty(request.key))
            {
                objs = objs.Where(u => u.GoodsId.Contains(request.key));
            }

            var propertyStr = string.Join(',', properties.Select(u => u.ColumnName));
            result.columnFields = properties;
            result.data = objs.OrderBy(u => u.Id)
                .Skip((request.page - 1) * request.limit)
                .Take(request.limit).Select($"{propertyStr}").ToList();
            result.count = await objs.CountAsync();
            return result;
        }

        public void Add(AddOrUpdateWmsInboundOrderDtblReq req)
        {
            SugarClient.Ado.BeginTran();
            AddNoSave(req);
            SugarClient.Ado.CommitTran();
        }

        public void AddNoSave(AddOrUpdateWmsInboundOrderDtblReq req)
        {
            var obj = req.MapTo<WmsInboundOrderDtbl>();
            //todo:补充或调整自己需要的字段
            obj.CreateTime = DateTime.Now;
            var user = _auth.GetCurrentUser().User;
            obj.GenerateDefaultKeyVal();
            obj.CreateUserId = user.Id;
            obj.CreateUserName = user.Name;
            SugarClient.Insertable(obj).ExecuteCommand();
        }

        public void Update(AddOrUpdateWmsInboundOrderDtblReq obj)
        {
            var user = _auth.GetCurrentUser().User;
            Repository.Update(u => new WmsInboundOrderDtbl
            {
                Price = obj.Price,
                PriceNoTax = obj.PriceNoTax,
                InStockStatus = obj.InStockStatus,
                AsnStatus = obj.AsnStatus,
                GoodsId = obj.GoodsId,
                GoodsBatch = obj.GoodsBatch,
                QualityFlg = obj.QualityFlg,
                OrderNum = obj.OrderNum,
                InNum = obj.InNum,
                LeaveNum = obj.LeaveNum,
                HoldNum = obj.HoldNum,
                ProdDate = obj.ProdDate,
                ExpireDate = obj.ExpireDate,
                TaxRate = obj.TaxRate,
                OwnerId = obj.OwnerId,
                Remark = obj.Remark,
                UpdateTime = DateTime.Now,
                UpdateUserId = user.Id,
                UpdateUserName = user.Name
                //todo:补充或调整自己需要的字段
            }, u => u.Id == obj.Id);

        }

        public WmsInboundOrderDtblApp(ISqlSugarClient client, IAuth auth) : base(client, auth)
        {
        }
    }
}