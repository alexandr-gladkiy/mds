interface "MDS IData Provider"
{
    procedure SetDataProvider(DataProviderNo: Code[20]): Boolean;
    procedure TestConnect(ShowMessage: Boolean): Boolean
    procedure Call(var Source: Record "MDS Data Request Config"; var ContentStream: InStream): Boolean


}