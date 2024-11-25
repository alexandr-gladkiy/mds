namespace mds.mds;

codeunit 50105 "MDS Html Helper"
{
    Subtype = Normal;

    procedure ConvertHtml2xHtml(var htmlStream: InStream) xhtmlStream: InStream
    var
        AzfnDomain: Label 'html-to-xhtml.azurewebsites.net', Locked = true;
        ContentHeaders: Dictionary of [Text, Text];
        ContentKey: Text;
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpHeader: HttpHeaders;
        HttpResponse: HttpResponseMessage;
        HttpResponseText: Text;

        ReportAskContent: Text;
        ErrorHtml2xHtmlFailed: Label 'Failed to convert html 2 xhtml. Responce Code: %1, Details: %2';
    begin
        HttpContent.GetHeaders(HttpHeader);
        HttpContent.WriteFrom(htmlStream);
        /*
        TODO: create Github repo for azfn & setup key authentication
        ContentHeaders.Add('x-functions-key', AzfnSharedKey);
        foreach ContentKey in ContentHeaders.Keys() do begin
            HttpHeader.TryAddWithoutValidation(ContentKey, ContentHeaders.Get(ContentKey));
        end;
        */
        HttpClient.Post('https://' + AzfnDomain + '/api/xhtml', HttpContent, HttpResponse);
        HttpContent := HttpResponse.Content;
        if not HttpResponse.IsSuccessStatusCode then begin
            HttpResponseText := HttpResponse.ReasonPhrase;
            Error(ErrorHtml2xHtmlFailed, HttpResponse.HttpStatusCode, HttpResponseText);
        end;

        HttpContent.ReadAs(xhtmlStream);
    end;
}
