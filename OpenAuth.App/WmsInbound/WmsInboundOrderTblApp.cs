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
    public class WmsInboundOrderTblApp : SqlSugarBaseApp<WmsInboundOrderTbl>
    {
        private WmsInboundOrderDtblApp _wmsInboundOrderDtblApp;
        /// <summary>
        /// 加载列表
        /// </summary>
        public async Task<TableData> Load(QueryWmsInboundOrderTblListReq request)
        {
            var loginContext = _auth.GetCurrentUser();
            if (loginContext == null)
            {
                throw new CommonException("登录已过期", Define.INVALID_TOKEN);
            }
            var columns = loginContext.GetTableColumns("WmsInboundOrderTbl");
            if (columns == null || columns.Count == 0)
            {
                throw new Exception("请在代码生成界面配置WmsInboundOrderTbl表的字段属性");
            }
            var result = new TableData();
            result.columnFields = columns;
            var objs = GetDataPrivilege("u");
            if (!string.IsNullOrEmpty(request.key))
            {
                objs = objs.Where(u => u.Id.Contains(request.key));
            }
            if (!string.IsNullOrEmpty(request.sqlWhere))
            {
                objs = objs.Where(request.sqlWhere);
            }
            var propertyStr = string.Join(',', columns.Select(u => u.ColumnName));
            result.data = objs.OrderBy(u => u.Id)
                .Skip((request.page - 1) * request.limit)
                .Take(request.limit).Select($"{propertyStr}").ToList();
            result.count = await objs.CountAsync();
            return result;
        }
        public void Add(AddOrUpdateWmsInboundOrderTblReq request)
        {
            var obj = request.MapTo<WmsInboundOrderTbl>();
            //todo:补充或调整自己需要的字段
            obj.CreateTime = DateTime.Now;
            var user = _auth.GetCurrentUser().User;
            obj.CreateUserId = user.Id;
            obj.CreateUserName = user.Name;
            if(obj.KeyIsNull())  //如果主键为空，则生成默认值
            {
                obj.GenerateDefaultKeyVal();
            }

            SugarClient.Ado.BeginTran();
            SugarClient.Insertable(obj).ExecuteCommand();
            if (request.WmsInboundOrderDtblReqs != null && request.WmsInboundOrderDtblReqs.Any())
            {
                foreach (var detail in request.WmsInboundOrderDtblReqs)
                {
                    detail.OrderId = obj.Id;
                    _wmsInboundOrderDtblApp.Add(detail);
                }
            }
            SugarClient.Ado.CommitTran();
        }
        public void Update(AddOrUpdateWmsInboundOrderTblReq request)
        {
            var user = _auth.GetCurrentUser().User;
            SugarClient.Ado.BeginTran();
            if (request.WmsInboundOrderDtblReqs != null && request.WmsInboundOrderDtblReqs.Any())
            {
                //id为空的添加
                foreach (var detail in request.WmsInboundOrderDtblReqs.Where(u => string.IsNullOrEmpty(u.Id)))
                {
                    detail.OrderId = request.Id;
                    _wmsInboundOrderDtblApp.Add(detail);
                }
                //id比数据库少的，删除
                var containids = request.WmsInboundOrderDtblReqs.Select(u => u.Id)
                    .Where(u => !string.IsNullOrEmpty(u)).ToList();
                if (containids.Any())
                {
                    SugarClient.Deleteable<WmsInboundOrderDtbl>(u => (!containids.Contains(u.Id)) && u.OrderId == request.Id).ExecuteCommand();
                }
                //更新id相同的
                foreach (var detail in request.WmsInboundOrderDtblReqs.Where(u => !string.IsNullOrEmpty(u.Id)))
                {
                    _wmsInboundOrderDtblApp.Update(detail);
                }
            }
            Repository.Update(u => new WmsInboundOrderTbl
            {
                ExternalNo = request.ExternalNo,
                ExternalType = request.ExternalType,
                Status = request.Status,
                OrderType = request.OrderType,
                GoodsType = request.GoodsType,
                PurchaseNo = request.PurchaseNo,
                StockId = request.StockId,
                OwnerId = request.OwnerId,
                ShipperId = request.ShipperId,
                SupplierId = request.SupplierId,
                ScheduledInboundTime = request.ScheduledInboundTime,
                Remark = request.Remark,
                Enable = request.Enable,
                TransferType = request.TransferType,
                InBondedArea = request.InBondedArea,
                ReturnBoxNum = request.ReturnBoxNum,
                UpdateTime = DateTime.Now,
                UpdateUserId = user.Id,
                UpdateUserName = user.Name
                //todo:补充或调整自己需要的字段
            }, u => u.Id == request.Id);
            SugarClient.Ado.CommitTran();
        }
        public WmsInboundOrderTblApp(ISqlSugarClient client, IAuth auth,
            WmsInboundOrderDtblApp wmsInboundOrderDtblApp) : base(client, auth)
        {
            _wmsInboundOrderDtblApp = wmsInboundOrderDtblApp;
        }
    }
}