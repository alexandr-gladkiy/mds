namespace mds.mds;

codeunit 50106 "MDS Source Service"
{
    Subtype = Normal;

    var
        GlobalDataRequestConfig: Record "MDS Data Request Config";
        GlobalIsSetup: Boolean;
        sDataProvider: Codeunit "MDS Data Provider Service";

    procedure "Set.ByPK"(No: Code[20]): Boolean
    begin
        if GlobalIsSetup and (GlobalDataRequestConfig."No." = No) then
            exit(true);

        GlobalIsSetup := GlobalDataRequestConfig.Get(No);
    end;

    procedure "Get.No"(DoTestField: Boolean): Code[20]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataRequestConfig.TestField("No.");
        exit(GlobalDataRequestConfig."No.");
    end;

    procedure "Get.Name"(DoTestField: Boolean): Text[100]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataRequestConfig.TestField(Name);
        exit(GlobalDataRequestConfig.Name);
    end;

    procedure "Get.DataProviderNo"(DoTestField: Boolean): Code[20]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataRequestConfig.TestField("Data Provider No.");
        exit(GlobalDataRequestConfig."Data Provider No.");
    end;

    procedure "Get.Status"(): Enum "MDS Status"
    begin
        TestSetup();
        exit(GlobalDataRequestConfig.Status);
    end;

    procedure "Get.QueryString"(DoTestField: Boolean): Text[250]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataRequestConfig.TestField("Query String");
        exit(GlobalDataRequestConfig."Query String");
    end;

    procedure IsSet(): Boolean
    begin
        exit(GlobalIsSetup);
    end;

    procedure IsDraft(): Boolean
    begin
        TestSetup();
        exit(GlobalDataRequestConfig.Status = GlobalDataRequestConfig.Status::Draft);
    end;

    procedure IsActive(): Boolean
    begin
        TestSetup();
        exit(GlobalDataRequestConfig.Status = GlobalDataRequestConfig.Status::Active);
    end;

    procedure IsInactive(): Boolean
    begin
        TestSetup();
        exit(GlobalDataRequestConfig.Status = GlobalDataRequestConfig.Status::Inactive);
    end;

    local procedure TestSetup()
    var
        SourceIsNotSetupError: Label 'Data Provider Config is not setup. \Use Set procedure first.';
    begin
        if not GlobalIsSetup then
            Error(SourceIsNotSetupError);
    end;

    procedure Call(var DataRequestConfig: Record "MDS Data Request Config"): Boolean
    var
        ContentStream: InStream;
        FileName: Text;
    begin
        sDataProvider."Set.ByPK"("Get.DataProviderNo"(true));
        if not sDataProvider."Impl.Call"(GlobalDataRequestConfig, ContentStream) then
            exit(false);

        DownloadFromStream(ContentStream, 'Select folder for download', '', '', FileName);
    end;

}
