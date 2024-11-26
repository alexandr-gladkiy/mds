namespace mds.mds;

codeunit 50106 "MDS Data Request Conf. Service"
{
    Subtype = Normal;

    var
        GlobalDataRequestConfig: Record "MDS Data Request Config";
        sDataProvider: Codeunit "MDS Data Provider Service";
        sDataRequestLink: Codeunit "MDS Data Request Link Service";
        GlobalIsSetup: Boolean;

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

    procedure "Get.RegexFilterURL"(DoTestField: Boolean): Text[250]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataRequestConfig.TestField("Regex Filter URL");
        exit(GlobalDataRequestConfig."Regex Filter URL");
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
    begin
        if not sDataProvider."Impl.Call"(DataRequestConfig, ContentStream) then
            exit(false);
    end;

    procedure CreateDataRequestLinks(var DataRequestConfig: Record "MDS Data Request Config"): Boolean
    var
        ContentStream: InStream;
    begin
        if not sDataProvider."Impl.CreateDataRequestLinks"(DataRequestConfig, ContentStream) then
            exit(false);
    end;

    procedure DownloadRequestContent(var DataRequestConfig: Record "MDS Data Request Config"): Boolean
    var
        DataRequestLinkBuffer: Record "MDS Data Request Link" temporary;
        Limit: Integer;
        I: Integer;
    begin
        if not sDataRequestLink."InitBuffer.Active.Open"(DataRequestConfig."No.", DataRequestLinkBuffer) then
            exit(false);

        Limit := 10;
        DataRequestLinkBuffer.FindSet(true);
        repeat
            if sDataProvider."Impl.DownloadContentRequestLink"(DataRequestLinkBuffer) then
                I += 1;
        until (I > 10) or (DataRequestLinkBuffer.Next() = 0);
        sDataRequestLink.CreateOrModify(DataRequestLinkBuffer)
    end;

}
