namespace mds.mds;
using System.Security.Authentication;

codeunit 50109 "MDS Http Helper"
{
    Subtype = Normal;

    var
        GlobalRequestHeaderDict: Dictionary of [Text, Text];
        GlobalRequestHeaderIsSet: Boolean;
        GlobalContentHeaderDict: Dictionary of [Text, Text];
        GlobalContentHeaderIsSet: Boolean;
        GlobalRequestContent: Text;
        GlobalRequestContentIsSet: Boolean;
        GlobalRequestContentInStream: InStream;
        GlobalRequestContentInStreamIsSet: Boolean;
        GlobalQueryParameters: Dictionary of [Text, Text];
        GlobalQueryParametersIsSet: Boolean;
        GlobalApiKeyName: Text;
        GlobalApiKeyValue: Text;
        GlobalApiKeyAuthIsSet: Boolean;
        GlobalBasicAuthLogin: Text;
        GlobalBasicAuthPass: Text;
        GlobalBasicAuthIsSet: Boolean;
        GlobalNtlmDomain: Text;
        GlobalNtlmAuthIsSet: Boolean;
        EnableErrorMessage: Boolean;
        GlobalResponceStatusCode: Integer;
        GlobalResponseReasonPhrase: Text;
        GlobalResponceContent: HttpContent;
        GlobalResponseHeaders: HttpHeaders;
        GlobalRequestType: Enum "Http Request Type";
        GlobalIsSuccessStatus: Boolean;
        ErrorDownloadFailed: Label 'Download from %1 failed. Responce Code: %2, Details: %3';

    /// <summary>
    /// HttpCall.
    /// </summary>
    /// <param name="RequestPath">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure Call(RequestPath: Text) IsSuccessStatus: Boolean
    var
        Client: HttpClient;
        Header: HttpHeaders;
        Response: HttpResponseMessage;
        Request: HttpRequestMessage;
        RequestContent: HttpContent;
    begin
        ApplyQueryParameters(RequestPath);
        ApplyAuthentication(Client);
        ApplyRequestHeaders(Client);
        ApplyContentHeaders(RequestContent, Header);
        ApplyRequestContent(RequestContent);

        Request.Method(Format(GlobalRequestType));
        Request.SetRequestUri(RequestPath);
        if GlobalRequestType = GlobalRequestType::POST then
            Request.Content(RequestContent);
        Client.Send(Request, Response);

        GlobalResponceContent := Response.Content;
        GlobalResponseReasonPhrase := Response.ReasonPhrase;
        GlobalResponceStatusCode := Response.HttpStatusCode;
        GlobalResponseHeaders := Response.Headers;

        if IsResponseStatusInInterval(GlobalResponceStatusCode, 500, 510) then
            GlobalIsSuccessStatus := true
        else
            GlobalIsSuccessStatus := Response.IsSuccessStatusCode;

        if (not GlobalIsSuccessStatus) and EnableErrorMessage then
            Error(ErrorDownloadFailed, RequestPath, Response.HttpStatusCode, GlobalResponseReasonPhrase);

        IsSuccessStatus := GlobalIsSuccessStatus;
    end;
    /// <summary>
    /// ClearSetups.
    /// </summary>
    procedure ClearSetups()
    begin
        ClearAll();
    end;

    local procedure ApplyQueryParameters(var EndpointUri: Text)
    begin
        if GlobalQueryParametersIsSet then begin
            EndpointUri := RemoveQueryParameters(EndpointUri);
            EndpointUri += CreateQueryParametersString(GlobalQueryParameters);
        end;
    end;

    local procedure ApplyAuthentication(var Client: HttpClient)
    begin
        // if GlobalBasicAuthIsSet then
        //     AddBasicAuthHeader(Client, GlobalBasicAuthLogin, GlobalBasicAuthPass);
        // if GlobalNtlmAuthIsSet then
        //     AddNtlmAuthHeader(Client, GlobalBasicAuthLogin, GlobalBasicAuthPass, GlobalNtlmDomain);
        // if GlobalApiKeyAuthIsSet then
            AddApiKeyAuthHeader(Client, GlobalApiKeyValue);
    end;

    // local procedure AddBasicAuthHeader(var Client: HttpClient; UserName: Text[100]; Password: Text[100]);
    // var
    //     AuthString: Text;
    //     /Base64: Codeunit "Base64 Convert";
    // begin
    //     // AuthString := StrSubstNo('%1:%2', UserName, Password);
    //     // AuthString := Base64.ToBase64(AuthString);
    //     // AuthString := StrSubstNo('Basic %1', AuthString);
    //     // Client.DefaultRequestHeaders().Add('Authorization', AuthString);
    // end;

    // [Scope('OnPrem')]
    // local procedure AddNtlmAuthHeader(var Client: HttpClient; UserName: Text[100]; Password: Text[100]; Domain: Text[150]);
    // var
    //     AuthString: Text;
    // begin
    //     Client.UseWindowsAuthentication(UserName, Password, Domain);
    // end;

    local procedure AddApiKeyAuthHeader(var Client: HttpClient; ApiKey: Text[1024]);
    begin
        Client.DefaultRequestHeaders().Add('X-API-Key', ApiKey); //TODO: Key for API-Key must be taken from the provider’s card
    end;

    local procedure ApplyContentHeaders(var Content: HttpContent; var Headers: HttpHeaders)
    var
        "Key": Text;
    begin
        if not GlobalContentHeaderIsSet then
            exit;

        Content.GetHeaders(Headers);
        foreach "Key" in GlobalContentHeaderDict.Keys() do begin
            if Headers.Contains("Key") then
                Headers.Remove("Key");
            Headers.TryAddWithoutValidation("Key", GlobalContentHeaderDict.Get("Key"));
        end;
    end;

    local procedure ApplyRequestHeaders(var Client: HttpClient)
    var
        "Key": Text;
    begin
        if GlobalRequestHeaderIsSet then
            foreach "Key" in GlobalRequestHeaderDict.Keys() do begin
                Client.DefaultRequestHeaders.Remove("Key");
                Client.DefaultRequestHeaders.Add("Key", GlobalRequestHeaderDict.Get("Key"));
            end;
    end;

    local procedure ApplyRequestContent(var Content: HttpContent)
    begin
        if GlobalRequestContentInStreamIsSet then
            Content.WriteFrom(GlobalRequestContentInStream);
        if GlobalRequestContentIsSet then
            Content.WriteFrom(GlobalRequestContent);
        Clear(GlobalRequestContentInStream);
        Clear(GlobalRequestContent);
    end;
    
    procedure SetApiKeyAuthentication(NewApiKeyName: Text; NewApiKeyValue: Text)
    begin
        GlobalApiKeyName := NewApiKeyName;
        GlobalApiKeyValue := NewApiKeyValue;
        GlobalApiKeyAuthIsSet := true;
    end;
    
    procedure SetBasicAuthentication(NewLogin: Text; NewPassword: Text)
    begin
        GlobalBasicAuthLogin := NewLogin;
        GlobalBasicAuthPass := NewPassword;
        GlobalBasicAuthIsSet := true;
    end;
    
    [Scope('OnPrem')]
    procedure SetNtlmAuthentication(NewLogin: Text; NewPassword: Text; NewDomain: Text)
    begin
        GlobalBasicAuthLogin := NewLogin;
        GlobalBasicAuthPass := NewPassword;
        GlobalNtlmDomain := NewDomain;
        GlobalNtlmAuthIsSet := true;
    end;
    
    procedure SetOAuth20Authentication()
    begin
        //TODO: Realise OAuth 2.0 Authentication 
    end;
    
    procedure SetEnableErrorMessage(Enable: Boolean)
    begin
        EnableErrorMessage := Enable;
    end;
    
    procedure SetRequestHeader("Key": Text; "Value": Text)
    begin
        GlobalRequestHeaderDict.Add("Key", "Value");
        GlobalRequestHeaderIsSet := true;
    end;
    
    procedure SetContentHeader("Key": Text; "Value": Text)
    begin
        GlobalContentHeaderDict.Add("Key", "Value");
        GlobalContentHeaderIsSet := true;
    end;
    
    procedure SetRequestContent(RequestContent: Text)
    begin
        GlobalRequestContent := RequestContent;
        GlobalRequestContentIsSet := true;
    end;
    
    procedure SetRequestContent(RequestContentInStrem: InStream)
    begin
        GlobalRequestContentInStream := RequestContentInStrem;
        GlobalRequestContentInStreamIsSet := true;
    end;
    
    procedure SetRequestType(RequestType: Enum "Http Request Type")
    begin
        GlobalRequestType := RequestType;
    end;
    
    procedure GetResponceStatusCode(): Integer
    begin
        exit(GlobalResponceStatusCode);
    end;
    
    procedure GetResponseReasonPhrase(): Text
    begin
        exit(GlobalResponseReasonPhrase);
    end;
    
    procedure GetResponceContentAsIStream(var iStream: InStream)
    begin
        GlobalResponceContent.ReadAs(iStream);
    end;
    
    procedure GetResponceContentAsText() ContentAsText: Text
    begin
        GlobalResponceContent.ReadAs(ContentAsText);
    end;
    
    procedure GetResponseHeaderValuesByKey("Key": Text) Values: array[10] of Text
    begin
        if not GlobalResponseHeaders.GetValues("Key", Values) then
            exit;
    end;

    // procedure GetRequestUriPath(URL: Text[250]) UriPath: Text[250]
    // var
    //     cUri: Codeunit Uri;
    //     ErrorEmptyUrlLabel: Label 'Empty Url';
    //     Scheme: Text[10];
    //     Host: Text[30];
    //     SegmentList: List of [Text];
    //     Segments: Text;
    //     NumberOfSegments: Integer;
    //     index: Integer;
    // begin
    //     if URL = '' then
    //         exit;

    //     cUri.Init(URL);
    //     Scheme := cUri.GetScheme() + '://';
    //     Host := cUri.GetHost();
    //     cUri.GetSegments(SegmentList);
    //     NumberOfSegments := SegmentList.Count;
    //     for index := 1 to NumberOfSegments - 1 do
    //         Segments += SegmentList.Get(index);
    //     UriPath := Scheme + Host + Segments;
    // end;

    procedure SetQueryParameters(QueryParameters: Dictionary of [Text, Text])
    begin
        GlobalQueryParameters := QueryParameters;
        GlobalQueryParametersIsSet := true;
    end;
    
    procedure SetQueryParameter(QueryParameter: Text; "Value": Text)
    begin
        GlobalQueryParameters.Set(QueryParameter, "Value");
        GlobalQueryParametersIsSet := true;
    end;
    
    procedure RemoveQueryParameter(QueryParameter: Text)
    begin
        GlobalQueryParameters.Remove(QueryParameter);
    end;
    
    procedure HasQueryParameters(EndpointUri: Text): Boolean
    begin
        exit(EndpointUri.Contains('?'));
    end;
    
    procedure GetQueryParameters(EndpointUri: Text): Dictionary of [Text, Text]
    var
        QueryParametersString: Text;
        QueryParametersList: List of [Text];
        Parameter: Text;
        KeyValuePair: List of [Text];
        Result: Dictionary of [Text, Text];
        ParameterKey: Text;
    begin
        if not HasQueryParameters(EndpointUri) then
            exit;
        QueryParametersString := EndpointUri.Split('?').Get(2);
        QueryParametersList := QueryParametersString.Split('&');
        foreach Parameter in QueryParametersList do begin
            KeyValuePair := Parameter.Split('=');
            ParameterKey := KeyValuePair.Get(1);
            KeyValuePair.RemoveAt(1);
            Result.Add(ParameterKey, JoinListOfText(KeyValuePair, '='));
        end;
        exit(Result);
    end;
    
    procedure RemoveQueryParameters(EndpointUri: Text): Text
    begin
        exit(EndpointUri.Split('?').Get(1));
    end;
    
    procedure RemoveQueryStringFromUrl(var Url: Text)
    var
        UrlComponents: List of [Text];
    begin
        UrlComponents := Url.Split('?');
        Url := UrlComponents.Get(1);
    end;
    
    procedure IsSuccessStatus(): Boolean
    begin
        exit(GlobalIsSuccessStatus);
    end;
    
    procedure IsResponseStatusInInterval(ResponseStatusCode: Integer; FromStatus: Integer; ToStatus: Integer): Boolean
    begin
        exit(GlobalResponceStatusCode in [FromStatus .. ToStatus]);
    end;
    
    procedure CreateQueryParametersString(QueryParameters: Dictionary of [Text, Text]): Text
    var
        Parameters: List of [Text];
        ParameterKey: Text;
    begin
        foreach ParameterKey in QueryParameters.Keys() do begin
            Parameters.Add(ParameterKey + '=' + QueryParameters.Get(ParameterKey));
        end;
        exit('?' + JoinListOfText(Parameters, '&'));
    end;

    local procedure JoinListOfText(TextList: List of [Text]; StringSeparator: Text): Text
    var
        Element: Text;
        Result: TextBuilder;
    begin
        foreach Element in TextList do begin
            Result.Append(Element + StringSeparator);
        end;
        exit(Result.ToText().TrimEnd(StringSeparator))
    end;
    
    // procedure UrlCall(Url: Text[250]; var ContentBlob: Codeunit "Temp Blob"; EnableError: Boolean): Boolean
    // var
    //     ContentInStream: InStream;
    //     ContentOutStream: OutStream;
    // begin
    //     SetEnableErrorMessage(EnableError);
    //     if Call(Url) then begin
    //         GetResponceContentAsIStream(ContentInStream);
    //         ContentBlob.CreateOutStream(ContentOutStream);
    //         CopyStream(ContentOutStream, ContentInStream);
    //         exit(true);
    //     end;
    //     if EnableError then
    //         Error(GetResponseReasonPhrase());
    // end;
}
