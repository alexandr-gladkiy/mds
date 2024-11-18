namespace mds.mds;
using System.Security.Authentication;
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
        Method: Enum "Http Method";

    procedure Call(): Boolean
    begin
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


}
