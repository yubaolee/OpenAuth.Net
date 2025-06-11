using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Infrastructure;
using Infrastructure.Const;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using OpenAuth.App.Extensions;
using OpenAuth.App.Interface;
using OpenAuth.App.Request;
using OpenAuth.App.Response;
using OpenAuth.Repository.Domain;
using Quartz;
using SqlSugar;

namespace OpenAuth.App
{
    /// <summary>
    /// 系统定时任务管理
    /// </summary>
    public class OpenJobApp : SqlSugarBaseApp<OpenJob>
    {
        private SysLogApp _sysLogApp;
        private IScheduler _scheduler;
        private ILogger<OpenJobApp> _logger;

        /// <summary>
        /// 加载列表
        /// </summary>
        public async Task<PagedDynamicDataResp> Load(QueryOpenJobListReq request)
        {
            var result = new PagedDynamicDataResp();
            var objs = SugarClient.Queryable<OpenJob>();
            if (!string.IsNullOrEmpty(request.key))
            {
                objs = objs.Where(u => u.Id.Contains(request.key));
            }

            result.Data =await objs.OrderBy(u => u.Id)
                .Skip((request.page - 1) * request.limit)
                .Take(request.limit).ToListAsync();
            result.Count =await objs.CountAsync();
            return result;
        }

        /// <summary>
        /// 启动所有状态为正在运行的任务
        /// <para>通常应用在系统加载的时候</para>
        /// </summary>
        /// <returns></returns>
        public async Task StartAll()
        {
            var jobs = await SugarClient.Queryable<OpenJob>().Where(u => u.Status == (int) JobStatus.Running).ToListAsync();
            foreach (var job in jobs)
            {
                job.Start(_scheduler);
            }
            _logger.LogInformation("所有状态为正在运行的任务已启动");
        }

        public void Add(AddOrUpdateOpenJobReq req)
        {
            var obj = req.MapTo<OpenJob>();
            obj.CreateTime = DateTime.Now;
            var user = _auth.GetCurrentUser().User;
            obj.CreateUserId = user.Id;
            obj.CreateUserName = user.Name;
            SugarClient.Insertable(obj).ExecuteCommand();
        }

        public void Update(AddOrUpdateOpenJobReq obj)
        {
            var user = _auth.GetCurrentUser().User;
            Repository.Update(u => new OpenJob
            {
                JobName = obj.JobName,
                JobType = obj.JobType,
                JobCall = obj.JobCall,
                JobCallParams = obj.JobCallParams,
                Cron = obj.Cron,
                Status = obj.Status,
                Remark = obj.Remark,
                UpdateTime = DateTime.Now,
                UpdateUserId = user.Id,
                UpdateUserName = user.Name
            },u => u.Id == obj.Id);
        }

        #region 定时任务运行相关操作

        /// <summary>
        /// 返回系统的job接口
        /// </summary>
        /// <returns></returns>
        public List<string> QueryLocalHandlers()
        {
            var types = AppDomain.CurrentDomain.GetAssemblies()
                .SelectMany(a => a.GetTypes().Where(t => t.GetInterfaces()
                    .Contains(typeof(IJob))))
                .ToArray();
            //过滤掉httppost的定时任务
            var noHttpPostType = types.Where(u =>u.UnderlyingSystemType!=typeof(OpenAuth.App.Jobs.HttpPostJob));
            return noHttpPostType.Select(u => u.FullName).ToList();
        }

        public void ChangeJobStatus(ChangeJobStatusReq req)
        {
            var job = Repository.GetFirst(u => u.Id == req.Id);
            if (job == null)
            {
                throw new Exception("任务不存在");
            }


            if (req.Status == (int) JobStatus.NotRun) //停止
            {
                job.Stop(_scheduler);
            }
            else //启动
            {
                job.Start(_scheduler);
            }


            var user = _auth.GetCurrentUser().User;

            job.Status = req.Status;
            job.UpdateTime = DateTime.Now;
            job.UpdateUserId = user.Id;
            job.UpdateUserName = user.Name;
            Repository.Update(job);
        }
        /// <summary>
        /// 记录任务运行结果
        /// </summary>
        /// <param name="jobId"></param>
        public void RecordRun(string jobId)
        {
            var job = Repository.GetFirst(u => u.Id == jobId);
            if (job == null)
            {
                _sysLogApp.Add(new SysLog
                {
                    TypeName = "定时任务",
                    TypeId = "AUTOJOB",
                    Content = $"未能找到定时任务：{jobId}"
                });
                return;
            }

            job.RunCount++;
            job.LastRunTime = DateTime.Now;
            Repository.Update(job);

            _sysLogApp.Add(new SysLog
            {
                CreateName = "Quartz",
                CreateId = "Quartz",
                TypeName = "定时任务",
                TypeId = "AUTOJOB",
                Content = $"运行了自动任务：{job.JobName}"
            });
            _logger.LogInformation($"运行了自动任务：{job.JobName}");
        }

        #endregion


        public OpenJobApp(ISqlSugarClient client, IAuth auth, SysLogApp sysLogApp, IScheduler scheduler, ILogger<OpenJobApp> logger) : base(client, auth)
        {
            _sysLogApp = sysLogApp;
            _scheduler = scheduler;
            _logger = logger;
        }
    }
}