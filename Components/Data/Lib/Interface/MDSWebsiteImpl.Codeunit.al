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
        ConnectionError: Label 'Connection Error! \Status Code: %1 \Error Message: %2';
        Uri: Text;
        ErrorMessage: Text;
        StatusCode: Integer;
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
        DataRequestConfig.TestField("Data Provider No.");
        DataRequestConfig.TestField("Query String");
        sDataProvider."Set.ByPK"(DataRequestConfig."Data Provider No.");
        URL := sDataProvider."Get.WebBaseUrl"(true) + DataRequestConfig."Query String";

        hHttp."Set.Method"("Http Method"::GET);
        hHttp."Set.Url"(URL);
        ExistContent := hHttp.Call();
        if ExistContent then
            exit(hHttp."Get.Content.As.Stream"(ContentStream));
    end;

    procedure CreateDataRequestLinks(var DataRequestConfig: Record "MDS Data Request Config"; var ContentStream: InStream) IsCreated: Boolean
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
        XmlStream: InStream;
        Document: XmlDocument;
        NodeList: XmlNodeList;
        DataRequestLinkBuffer: Record "MDS Data Request Link" temporary;
    begin
        XmlStream := hHtml.ConvertHtml2xHtml(ContentStream);
        XmlDocument.ReadFrom(XmlStream, Document);
        NodeList := Document.GetChildNodes();
        ProcessDataRequestContentXmlToBuffer(DataRequestConfig, NodeList, DataRequestLinkBuffer);
    end;


    procedure ProcessDataRequestContentXmlToBuffer(DataRequestConfig: Record "MDS Data Request Config"; Nodes: XmlNodeList; var DataRequestLinkBuffer: Record "MDS Data Request Link")
    var
        SubNodes: XmlNodeList;
        Node: XmlNode;
        UrlPath: Text;
    begin
        // TODO: Refactoring on union table for store content
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
        //DataRequestLinkBuffer."Link Last Modified" := hValue.ConvertDateStringToDateTime(LinkLastModify);
        DataRequestLinkBuffer."Link Change Freq." := LinkChangeFreq;
        DataRequestLinkBuffer."Link Priority" := LinkPriority;
        DataRequestLinkBuffer."Process Status" := DataRequestLinkBuffer."Process Status"::Completed;
        //if hRegex.IsRegexMatch(LinkPath, GetSiteMapRegexFilter(false)) then begin
        //     DataRequestLinkBuffer.Status := DataRequestLinkBuffer.Status::Active;
        //     if IsForSiteMapLinkCall(DataRequestLinkBuffer) then
        //         DataRequestLinkBuffer."Process Status" := DataRequestLinkBuffer."Process Status"::Open;
        // end else
        //     DataRequestLinkBuffer.Status := DataRequestLinkBuffer.Status::Inactive;

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
        UriPath := hHttp.GetRequestUriPath(sDataProvider."Get.WebSitemapURL"(true));
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

    [IntegrationEvent(false, false)]
    procedure OnBeforeCall(var DataRequestConfig: Record "MDS Data Request Config"; var ContentStream: InStream; var IsHandled: Boolean; var IsCalled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterCall(var DataRequestConfig: Record "MDS Data Request Config"; var ContentStream: InStream; IsHandled: Boolean; var IsCalled: Boolean)
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

}
