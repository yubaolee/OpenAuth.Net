using System;
using OpenAuth.Repository;
using OpenAuth.Repository.Domain;
using OpenAuth.Repository.Interface;
using Infrastructure;

namespace OpenAuth.App
{
    public class FormFactory
    {
        public static IForm CreateForm(Form form, IUnitWork<OpenAuthDBContext> unitWork)
        {
            if (form.FrmType == Define.FORM_TYPE_DYNAMIC)
            {
                return new LeipiForm(unitWork);
            }else if (form.FrmType == Define.FORM_TYPE_DEVELOP)
            {
                throw new Exception("自定义表单不需要创建数据库表");
            }
            else 
            {
                return new DragForm(unitWork);
            }
        }
    }
}