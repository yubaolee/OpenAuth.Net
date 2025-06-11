using System;
using Infrastructure;
using log4net;
using Microsoft.Extensions.DependencyInjection;
using NUnit.Framework;

namespace OpenAuth.App.Test
{
    class TestDbExtension :TestBase
    {
        private ILog log = LogManager.GetLogger(typeof(TestDbExtension));
        
        [Test]
        public void TestGetTables()
        {
            var app = _autofacServiceProvider.GetService<DbExtension>();

            var result = app.GetDbTableStructure("application");
            Console.WriteLine(JsonHelper.Instance.Serialize(result));
        }
    }
}
