namespace mds.mds;
using System.RestClient;
using System.IO;
using System.Text;
using System.Utilities;

codeunit 50114 "MDS OData Impl." implements "MDS IData Provider"
{
    var
        sDataProvider: Codeunit "MDS Data Provider Service";
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
        mDataMgt: Codeunit "MDS Data Management";
        JText: Text;
        hPerBlob: Codeunit "MDS Persistent Blob Helper";
        BlobKey: BigInteger;
        TempBlob: Codeunit "Temp Blob";
        oStream: OutStream;
        JsonBuffer: Record "JSON Buffer" temporary;
        JsonMgt: Codeunit "JSON Management";
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
            hHttp."Get.Content.As.Text"(JText);

        Message(JText);

        TempBlob.CreateInStream(ContentStream);
        TempBlob.CreateOutStream(oStream);
        //ContentStream.Read(JText);
        oStream.Write(JText);

        JsonBuffer.ReadFromText(JText);
        Page.Run(Page::JBuffer, JsonBuffer);
    end;

    procedure CreateDataRequestLinks(var DataRequestConfig: Record "MDS Data Source"; var ContentStream: InStream) IsCreated: Boolean
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
    begin
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

    procedure CreateRequestLinks(var DataRequestConfig: Record "MDS Data Source"; var ContentStream: InStream) IsCreated: Boolean
    begin

    end;

    procedure DownloadContentRequestLink(var DataRequestLink: Record "MDS Data Source Link") IsDownload: Boolean
    begin

    end;
}
