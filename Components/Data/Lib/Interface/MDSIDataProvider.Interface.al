interface "MDS IData Provider"
{
    procedure SetDataProvider(DataProviderNo: Code[20]): Boolean;
    procedure TestConnect(ShowMessage: Boolean): Boolean
    procedure Call(var DataRequestConfig: Record "MDS Data Source"; var ContentStream: InStream) IsCalled: Boolean
    procedure CreateRequestLinks(var DataRequestConfig: Record "MDS Data Source"; var ContentStream: InStream) IsCreated: Boolean
    procedure DownloadContentRequestLink(var DataRequestLink: Record "MDS Data Source Link") IsDownload: Boolean
}