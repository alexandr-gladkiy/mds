namespace mds.mds;
using System.Security.Authentication;
using System.Text;
using System.RestClient;
using System.Utilities;

codeunit 50109 "MDS Http Helper"
{
    Subtype = Normal;

    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Url: Text;
        RequestContent: Text;
        Method: Enum "Http Method";
        Login: Text;
        Password: Text;
        Token: Text;
        AuthType: Enum "MDS Authorization Type";

    procedure Call(): Boolean
    begin
        this."Apply.Authentication"(this.Client);
        this.Request.Method(Format(this.Method));
        this.Request.SetRequestUri(this.Url);


        this.Client.Send(this.Request, this.Response);
        exit(this.Response.IsSuccessStatusCode);
    end;

    procedure "Set.Method"(Method: Enum "Http Method")
    begin
        this.Method := Method;
    end;

    procedure "Set.Url"(Url: Text)
    begin
        this.Url := Url;
    end;

    procedure "Set.RequestContent"(RequestContent: Text)
    begin
        this.RequestContent := RequestContent;
    end;

    procedure "Set.AuthorizationType"(AuthType: Enum "MDS Authorization Type")
    begin
        this.AuthType := AuthType;
    end;

    procedure "Set.Login"(Login: Text)
    begin
        this.Login := Login;
    end;

    procedure "Set.Password"(Password: Text)
    begin
        this.Password := Password;
    end;

    procedure "Get.Response.StatusCode"(): Integer
    begin
        exit(this.Response.HttpStatusCode);
    end;

    procedure "Get.Response.ReasonPhrase"(): Text
    begin
        exit(this.Response.ReasonPhrase());
    end;

    procedure "Get.Content.As.Stream"(var ContentStream: InStream): Boolean
    begin
        exit(this.Response.Content.ReadAs(ContentStream));
    end;

    procedure "Get.Content.As.Text"(var ContentText: Text): Boolean
    begin
        exit(this.Response.Content.ReadAs(ContentText));
    end;

    procedure "Get.Content.As.TempBlob"(var ContentBlob: Codeunit "Temp Blob"): Boolean
    var
        ContentStream: InStream;
    begin
        if not this."Get.Content.As.Stream"(ContentStream) then
            exit(false);

        ContentBlob.CreateInStream(ContentStream);
        exit(ContentBlob.HasValue());
    end;

    procedure GetRequestUriPath(URL: Text) UriPath: Text
    var
        cUri: Codeunit Uri;
        Scheme: Text;
        Host: Text;
        SegmentList: List of [Text];
        Segments: Text;
        NumberOfSegments: Integer;
        index: Integer;
    begin
        if URL = '' then
            exit;

        cUri.Init(URL);
        Scheme := cUri.GetScheme() + '://';
        Host := cUri.GetHost();
        cUri.GetSegments(SegmentList);
        NumberOfSegments := SegmentList.Count;
        for index := 1 to NumberOfSegments - 1 do
            Segments += SegmentList.Get(index);
        UriPath := Scheme + Host + Segments;
    end;

    local procedure "Apply.Authentication"(var Client: HttpClient)
    begin
        case this.AuthType of
            this.AuthType::Basic:
                this.AddBasicAuthHeader(Client, this.Login, this.Password);
        end;
    end;

    local procedure AddBasicAuthHeader(var Client: HttpClient; UserName: Text; Password: Text);
    var
        Base64: Codeunit "Base64 Convert";
        AuthString: Text;
    begin
        AuthString := StrSubstNo('%1:%2', UserName, Password);
        AuthString := Base64.ToBase64(AuthString);
        AuthString := StrSubstNo('Basic %1', AuthString);
        Client.DefaultRequestHeaders().Add('Authorization', AuthString);
    end;
}
