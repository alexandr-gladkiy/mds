namespace mds.mds;
using System.RestClient;
using System.IO;
using System.Text;
using System.Utilities;

codeunit 50114 "MDS OData Impl." implements "MDS IData Provider"
{
    var
        sDataProvider: Codeunit "MDS Data Provider Service";
        mData: Codeunit "MDS Data Management";
        hHttp: Codeunit "MDS Http Helper";

    procedure SetDataProvider(DataProviderNo: Code[20]): Boolean
    begin
        if DataProviderNo = '' then
            exit;

        exit(sDataProvider."Set.ByPK"(DataProviderNo));
    end;

    procedure TestConnect(ShowMessage: Boolean): Boolean
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Uri: Text;
        ErrorMessage: Text;
        StatusCode: Integer;
        ConnectionError: Label 'Connection Error! \Status Code: %1 \Error Message: %2', Locked = true;
    begin
        Uri := sDataProvider."Get.WebBaseUrl"(true);
        Client.Get(Uri, Response);
        if Response.IsSuccessStatusCode() then begin
            if ShowMessage then
                Message('OK');
            exit(true);
        end;

        if ShowMessage then begin
            StatusCode := Response.HttpStatusCode;
            ErrorMessage := Response.ReasonPhrase;
            Error(ConnectionError, StatusCode, ErrorMessage)
        end;
    end;

    procedure Call(var DataRequestConfig: Record "MDS Data Source"; var ContentStream: InStream) IsCalled: Boolean
    var
        IsHandled: Boolean;
    begin
        OnBeforeCall(DataRequestConfig, ContentStream, IsHandled, IsCalled);
        if not IsHandled then
            IsCalled := CallDataRequestContent(DataRequestConfig, ContentStream);
        OnAfterCall(DataRequestConfig, ContentStream, IsHandled, IsCalled);
    end;

    local procedure CallDataRequestContent(var DataRequestConfig: Record "MDS Data Source"; var ContentStream: InStream) ExistContent: Boolean
    var
        URL: Text;
    begin
        Clear(hHttp);
        DataRequestConfig.TestField("Data Provider No.");
        if DataRequestConfig."Http Method" = DataRequestConfig."Http Method"::POST then
            DataRequestConfig.TestField("Request Content");
        sDataProvider."Set.ByPK"(DataRequestConfig."Data Provider No.");
        URL := sDataProvider."Get.WebBaseUrl"(true) + DataRequestConfig."Path" + DataRequestConfig."Query String";

        if DataRequestConfig."Http Method" = DataRequestConfig."Http Method"::POST then
            hHttp."Set.RequestContent"(DataRequestConfig."Request Content");
        hHttp."Set.Method"(DataRequestConfig."Http Method");
        hHttp."Set.Url"(URL);
        hHttp."Set.AuthorizationType"(sDataProvider."Get.AuthorizationType"(true));
        hHttp."Set.Login"(sDataProvider."Get.Login"(true));
        hHttp."Set.Password"(sDataProvider."Get.Password"(true));
        ExistContent := hHttp.Call();
        if ExistContent then
            exit(hHttp."Get.Content.As.Stream"(ContentStream));
    end;

    procedure CreateRequestLinks(var DataRequestConfig: Record "MDS Data Source"; var ContentStream: InStream) IsCreated: Boolean
    var
        IsHandled: Boolean;
    begin
        OnAfterCreateDataRequestLinks(DataRequestConfig, ContentStream, IsHandled, IsCreated);
        if not IsHandled then
            IsCreated := ParseDataRequestContent(DataRequestConfig, ContentStream);
        OnBeforeCreateDataRequestLinks(DataRequestConfig, ContentStream, IsHandled, IsCreated);
    end;

    local procedure ParseDataRequestContent(var DataRequestConfig: Record "MDS Data Source"; var ContentStream: InStream): Boolean
    var
        JsonBuffer: Record "JSON Buffer" temporary;
        JsonContent: Text;
        BlobKey: BigInteger;
        hPersistentBlob: Codeunit "MDS Persistent Blob Helper";
        DataSourceLinkBuffer: Record "MDS Data Source Link" temporary;
        sDataSourceLink: Codeunit "MDS Data Source Link Service";
        LinkId: Integer;
    begin
        hPersistentBlob."Upload.AsStream"(ContentStream, BlobKey);
        JsonContent := hPersistentBlob."Get.AsText"(BlobKey);
        hPersistentBlob.Delete(BlobKey);

        JsonBuffer.ReadFromText(JsonContent);
        JsonBuffer.SetRange("Token type", JsonBuffer."Token type"::String);
        JsonBuffer.SetFilter(Path, '*.SKU');
        if JsonBuffer.FindSet(false) then begin
            LinkId := sDataSourceLink."Get.LastLinkId"(DataRequestConfig."No.");
            repeat
                LinkId += 1;
                DataSourceLinkBuffer.Init();
                DataSourceLinkBuffer."Data Source No." := DataRequestConfig."No.";
                DataSourceLinkBuffer."Link ID" := LinkId;
                DataSourceLinkBuffer."Process Status" := DataSourceLinkBuffer."Process Status"::Open;
                DataSourceLinkBuffer.Status := DataSourceLinkBuffer.Status::Active;
                DataSourceLinkBuffer."Reference No." := JsonBuffer.Value;
                DataSourceLinkBuffer."Link Path" := StrSubstNo(DataRequestConfig."Pattern For Item Link", JsonBuffer.Value);
                DataSourceLinkBuffer."Link Last Modified" := CurrentDateTime();
                DataSourceLinkBuffer.Insert(false);
            until JsonBuffer.Next() = 0;
            mData."DataRequestLink.CreateOrModify.List"(DataSourceLinkBuffer, true);
        end;
        //Page.Run(Page::JBuffer, JsonBuffer);
    end;


    [IntegrationEvent(false, false)]
    procedure OnBeforeCall(var DataRequestConfig: Record "MDS Data Source"; var ContentStream: InStream; var IsHandled: Boolean; var IsCalled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterCall(var DataRequestConfig: Record "MDS Data Source"; var ContentStream: InStream; IsHandled: Boolean; var IsCalled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeCreateDataRequestLinks(var DataRequestConfig: Record "MDS Data Source"; var ContentStream: InStream; var IsHandled: Boolean; var IsCreated: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterCreateDataRequestLinks(var DataRequestConfig: Record "MDS Data Source"; var ContentStream: InStream; IsHandled: Boolean; var IsCreated: Boolean)
    begin
    end;


    procedure DownloadContentRequestLink(var DataRequestLink: Record "MDS Data Source Link") IsDownload: Boolean
    var
        hPersistentBlob: Codeunit "MDS Persistent Blob Helper";
        IStream: InStream;
        sDataSource: Codeunit "MDS Data Source Service";
        DataSource: Record "MDS Data Source";
    begin
        Clear(hHttp);
        DataRequestLink.TestField("Link Path");
        DataRequestLink."Error Comment" := '';

        sDataSource."Set.ByPK"(DataRequestLink."Data Source No.");
        DataSource.Get(DataRequestLink."Data Source No.");
        sDataProvider."Set.ByPK"(DataSource."Data Provider No.");
        if DataSource."Http Method" = DataSource."Http Method"::POST then
            hHttp."Set.RequestContent"(DataSource."Request Content");
        hHttp."Set.Method"(DataSource."Http Method");
        hHttp."Set.Url"(DataRequestLink."Link Path");
        hHttp."Set.AuthorizationType"(sDataProvider."Get.AuthorizationType"(true));
        hHttp."Set.Login"(sDataProvider."Get.Login"(true));
        hHttp."Set.Password"(sDataProvider."Get.Password"(true));
        IsDownload := hHttp.Call();
        if not IsDownload then begin
            DataRequestLink."Process Status" := DataRequestLink."Process Status"::Error;
            DataRequestLink."Error Comment" := CopyStr(hHttp."Get.Response.ReasonPhrase"(), 1, MaxStrLen(DataRequestLink."Error Comment"));
            DataRequestLink."Request Last Datetime" := CreateDateTime(Today(), Time());
        end;

        hHttp."Get.Content.As.Stream"(IStream);
        hPersistentBlob."Upload.AsStream"(IStream, DataRequestLink."Blob Key");
        DataRequestLink."Process Status" := DataRequestLink."Process Status"::Downloaded;
        DataRequestLink."Request Last Datetime" := CreateDateTime(Today(), Time());
        DataRequestLink.Modify(false);
        Commit();
    end;
}
