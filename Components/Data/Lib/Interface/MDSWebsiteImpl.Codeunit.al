namespace mds.mds;
using System.RestClient;
using System.Xml;
using System.IO;
using System.Utilities;

codeunit 50108 "MDS Website Impl." implements "MDS IData Provider"
{
    Subtype = Normal;

    var
        sDataProvider: Codeunit "MDS Data Provider Service";
        sDataRequestConfig: Codeunit "MDS Data Request Conf. Service";
        sDataRequestLink: Codeunit "MDS Data Request Link Service";
        mData: Codeunit "MDS Data Management";
        hHttp: Codeunit "MDS Http Helper";
        hHtml: Codeunit "MDS Html Helper";
        hValue: Codeunit "MDS Value Helper";
        hRegex: Codeunit "MDS Regex Helper";

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

    procedure Call(var DataRequestConfig: Record "MDS Data Request Config"; var ContentStream: InStream) IsCalled: Boolean
    var
        IsHandled: Boolean;
    begin
        OnBeforeCall(DataRequestConfig, ContentStream, IsHandled, IsCalled);
        if not IsHandled then
            IsCalled := CallDataRequestContent(DataRequestConfig, ContentStream);
        OnAfterCall(DataRequestConfig, ContentStream, IsHandled, IsCalled);
    end;

    local procedure CallDataRequestContent(var DataRequestConfig: Record "MDS Data Request Config"; var ContentStream: InStream) ExistContent: Boolean
    var
        URL: Text;
    begin
        Clear(hHttp);
        DataRequestConfig.TestField("Data Provider No.");
        sDataProvider."Set.ByPK"(DataRequestConfig."Data Provider No.");
        URL := sDataProvider."Get.WebBaseUrl"(true) + DataRequestConfig.URI + DataRequestConfig."Query String";

        hHttp."Set.Method"("Http Method"::GET);
        hHttp."Set.Url"(URL);
        ExistContent := hHttp.Call();
        if ExistContent then
            exit(hHttp."Get.Content.As.Stream"(ContentStream));
    end;

    procedure CreateRequestLinks(var DataRequestConfig: Record "MDS Data Request Config"; var ContentStream: InStream) IsCreated: Boolean
    var
        IsHandled: Boolean;
    begin
        OnAfterCreateDataRequestLinks(DataRequestConfig, ContentStream, IsHandled, IsCreated);
        if not IsHandled then
            IsCreated := ParseDataRequestContent(DataRequestConfig, ContentStream);
        OnBeforeCreateDataRequestLinks(DataRequestConfig, ContentStream, IsHandled, IsCreated);
    end;

    local procedure ParseDataRequestContent(var DataRequestConfig: Record "MDS Data Request Config"; var ContentStream: InStream): Boolean
    var
        DataRequestLinkBuffer: Record "MDS Data Request Link" temporary;
        XmlStream: InStream;
        Document: XmlDocument;
        NodeList: XmlNodeList;
    begin
        XmlStream := hHtml.ConvertHtml2xHtml(ContentStream);
        XmlDocument.ReadFrom(XmlStream, Document);
        NodeList := Document.GetChildNodes();
        ProcessDataRequestContentXmlToBuffer(DataRequestConfig, NodeList, DataRequestLinkBuffer);
        mData."DataRequestLink.CreateOrModify.List"(DataRequestLinkBuffer, true);
    end;


    procedure ProcessDataRequestContentXmlToBuffer(DataRequestConfig: Record "MDS Data Request Config"; Nodes: XmlNodeList; var DataRequestLinkBuffer: Record "MDS Data Request Link")
    var
        SubNodes: XmlNodeList;
        Node: XmlNode;
        UrlPath: Text;
    begin
        foreach Node in Nodes do
            case Node.AsXmlElement().Name of
                ':loc':
                    begin
                        UrlPath := Node.AsXmlElement().InnerText;
                        if IsDataRequestUri(DataRequestConfig, UrlPath) then
                            CallSubSitemap(DataRequestConfig, UrlPath, DataRequestLinkBuffer)
                    end;
                ':url':
                    AddToSiteMapBuffer(DataRequestConfig, Node, DataRequestLinkBuffer);
                else begin
                    SubNodes := Node.AsXmlElement().GetChildElements();
                    ProcessDataRequestContentXmlToBuffer(DataRequestConfig, SubNodes, DataRequestLinkBuffer);
                end;
            end
    end;

    local procedure CallSubSitemap(DataRequestConfig: Record "MDS Data Request Config"; UrlPath: Text; var DataRequestLinkBuffer: Record "MDS Data Request Link")
    var
        Nodes: XmlNodeList;
        IStream: InStream;
        Content: XmlDocument;
    begin
        Clear(hHttp);
        // TODO: hHttp.SetEnableErrorMessage(true);
        hHttp."Set.Method"("Http Method"::GET);
        hHttp."Set.Url"(UrlPath);
        hHttp.Call();
        hHttp."Get.Content.As.Stream"(IStream);
        XmlDocument.ReadFrom(IStream, Content);
        Nodes := Content.GetChildElements();

        ProcessDataRequestContentXmlToBuffer(DataRequestConfig, Nodes, DataRequestLinkBuffer);
    end;

    local procedure AddToSiteMapBuffer(DataRequestConfig: Record "MDS Data Request Config"; Node: XmlNode; var DataRequestLinkBuffer: Record "MDS Data Request Link")
    var
        Nodes: XmlNodeList;
        LinkPath: Text;
        LinkPathAsMD5: Text;
        LinkLastModify: Text;
        LinkChangeFreq: DateFormula;
        LinkPriority: Decimal;
        Create: Boolean;
    begin
        //sCommon.TestTemporaryRecord(DataRequestLinkBuffer, 'SiteMapBuffer');
        if not Node.AsXmlElement().HasElements() then
            exit;

        //LinkChangeFreq := DataRequestLinkBuffer."Site Map Default Change Freq.";

        Nodes := Node.AsXmlElement().GetChildElements();
        foreach Node in Nodes do
            case Node.AsXmlElement().Name of
                ':loc':
                    LinkPath := Node.AsXmlElement().InnerText;
                ':lastmod':
                    LinkLastModify := Node.AsXmlElement().InnerText;
                ':changefreq':
                    LinkChangeFreq := hValue.ConvertStringToDateFormula(Node.AsXmlElement().InnerText);
                ':priority':
                    Evaluate(LinkPriority, ConvertStr(Node.AsXmlElement().InnerText, '.', ','));
            end;

        if LinkPath = '' then
            exit;

        LinkPathAsMD5 := hValue.GetStringAsMD5(LinkPath);

        DataRequestLinkBuffer.Reset();
        DataRequestLinkBuffer.SetCurrentKey("Link Path as MD5");
        DataRequestLinkBuffer.SetRange("Link Path as MD5", LinkPathAsMD5);
        DataRequestLinkBuffer.SetRange("Config No.", DataRequestConfig."No.");
        if not DataRequestLinkBuffer.FindFirst() then
            Create := true;

        if Create then begin
            DataRequestLinkBuffer.Init();
            DataRequestLinkBuffer."Link ID" := GetRequestLinkBufferLastLinkId(DataRequestConfig."No.", DataRequestLinkBuffer) + 1;
        end;
        DataRequestLinkBuffer."Config No." := DataRequestConfig."No.";
        DataRequestLinkBuffer."Link Path" := CopyStr(LinkPath, 1, MaxStrLen(DataRequestLinkBuffer."Link Path"));
        DataRequestLinkBuffer."Link Path as MD5" := CopyStr(LinkPathAsMD5, 1, MaxStrLen(DataRequestLinkBuffer."Link Path as MD5"));
        //TODO: DataRequestLinkBuffer."Link Last Modified" := hValue.ConvertDateStringToDateTime(LinkLastModify);
        DataRequestLinkBuffer."Link Change Freq." := LinkChangeFreq;
        DataRequestLinkBuffer."Link Priority" := LinkPriority;
        DataRequestLinkBuffer."Process Status" := DataRequestLinkBuffer."Process Status"::Open;
        if hRegex.IsRegexMatch(LinkPath, DataRequestConfig."Regex Filter URL") then begin
            DataRequestLinkBuffer.Status := DataRequestLinkBuffer.Status::Active;
            DataRequestLinkBuffer."Process Status" := DataRequestLinkBuffer."Process Status"::Open;
        end else begin
            DataRequestLinkBuffer.Status := DataRequestLinkBuffer.Status::Inactive;
            DataRequestLinkBuffer."Process Status" := DataRequestLinkBuffer."Process Status"::Skipped;
        end;

        if Create then
            DataRequestLinkBuffer.Insert(false)
        else
            DataRequestLinkBuffer.Modify(false);
    end;

    procedure IsDataRequestUri(DataRequestConfig: Record "MDS Data Request Config"; UrlPath: Text): Boolean
    var
        UriPath: Text;
    begin
        //sCommon.TestEmpty(UrlPath, StrSubstNo(ErrorParameterIsEmpty, 'Url Path'));
        DataRequestConfig.TestField("Data Provider No.");
        sDataProvider."Set.ByPK"(DataRequestConfig."Data Provider No.");
        UriPath := hHttp.GetRequestUriPath(sDataProvider."Get.WebBaseUrl"(true));
        if UrlPath.StartsWith(UriPath) then
            exit(true);
    end;

    local procedure GetRequestLinkBufferLastLinkId(RequestConfigNo: Code[20]; var DataRequestLinkBuffer: Record "MDS Data Request Link"): Integer
    begin
        DataRequestLinkBuffer.Reset();
        DataRequestLinkBuffer.SetRange("Config No.", RequestConfigNo);
        if DataRequestLinkBuffer.FindLast() then
            exit(DataRequestLinkBuffer."Link ID")
    end;

    procedure DownloadContentRequestLink(var DataRequestLink: Record "MDS Data Request Link") IsDownloaded: Boolean
    var
        IsHandled: Boolean;
    begin
        OnBeforeDownloadContentRequestLink(DataRequestLink, IsHandled, IsDownloaded);
        if not IsHandled then
            IsDownloaded := DownloadContent(DataRequestLink);
        OnAfterDownloadContentRequestLink(DataRequestLink, IsHandled, IsDownloaded);
    end;

    local procedure DownloadContent(var DataRequestLink: Record "MDS Data Request Link") IsDownloaded: Boolean
    var
        hPersistentBlob: Codeunit "MDS Persistent Blob Helper";
        IStream: InStream;
    begin
        Clear(hHttp);
        DataRequestLink.TestField("Link Path");
        DataRequestLink."Error Comment" := '';

        hHttp."Set.Method"("Http Method"::GET);
        hHttp."Set.Url"(DataRequestLink."Link Path");
        IsDownloaded := hHttp.Call();
        if not IsDownloaded then begin
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

    [IntegrationEvent(false, false)]
    procedure OnBeforeDownloadContentRequestLink(var DataRequestLink: Record "MDS Data Request Link"; var IsHandled: Boolean; var IsDownloaded: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterDownloadContentRequestLink(var DataRequestLink: Record "MDS Data Request Link"; IsHandled: Boolean; var IsDownloaded: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeCreateDataRequestLinks(var DataRequestConfig: Record "MDS Data Request Config"; var ContentStream: InStream; var IsHandled: Boolean; var IsCreated: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterCreateDataRequestLinks(var DataRequestConfig: Record "MDS Data Request Config"; var ContentStream: InStream; IsHandled: Boolean; var IsCreated: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeCall(var DataRequestConfig: Record "MDS Data Request Config"; var ContentStream: InStream; var IsHandled: Boolean; var IsCalled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterCall(var DataRequestConfig: Record "MDS Data Request Config"; var ContentStream: InStream; IsHandled: Boolean; var IsCalled: Boolean)
    begin
    end;
}
