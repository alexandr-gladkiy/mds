interface "MDS IData Provider"
{
    procedure SetDataProvider(DataProviderNo: Code[20]): Boolean;
    procedure TestConnect(ShowMessage: Boolean): Boolean


}