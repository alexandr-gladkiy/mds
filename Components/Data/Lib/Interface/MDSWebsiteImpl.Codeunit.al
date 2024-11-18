namespace mds.mds;
using System.RestClient;

codeunit 50108 "MDS Website Impl." implements "MDS IData Provider"
{
    Subtype = Normal;

    var
        sDataProvider: Codeunit "MDS Data Provider Service";
        HttpHelper: Codeunit "MDS Http Helper";
        HttpMethod: Enum "Http Method";

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

    procedure Call(var Source: Record "MDS Source"; var ContentStream: InStream): Boolean
    var
    begin

    end;
}
