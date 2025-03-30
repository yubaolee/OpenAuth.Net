namespace OpenAuth.App.Request
{
    public class AddOrUpdateDynamicEntityReq
    {
        public string TableName { get; set; }

        public object Obj { get; set; }
    }
}
