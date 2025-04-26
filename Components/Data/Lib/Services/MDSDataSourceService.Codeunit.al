namespace mds.mds;

codeunit 50106 "MDS Data Source Service"
{
    Subtype = Normal;

    var
        GlobalDataSource: Record "MDS Data Source";
        sDataProvider: Codeunit "MDS Data Provider Service";
        sDataSourceLink: Codeunit "MDS Data Source Link Service";
        GlobalIsSetup: Boolean;

    procedure "Set.ByPK"(No: Code[20]): Boolean
    begin
        if GlobalIsSetup and (GlobalDataSource."No." = No) then
            exit(true);

        GlobalIsSetup := GlobalDataSource.Get(No);
    end;

    procedure "Get.No"(DoTestField: Boolean): Code[20]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataSource.TestField("No.");
        exit(GlobalDataSource."No.");
    end;

    procedure "Get.Name"(DoTestField: Boolean): Text[100]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataSource.TestField(Name);
        exit(GlobalDataSource.Name);
    end;

    procedure "Get.DataProviderNo"(DoTestField: Boolean): Code[20]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataSource.TestField("Data Provider No.");
        exit(GlobalDataSource."Data Provider No.");
    end;

    procedure "Get.Status"(): Enum "MDS Status"
    begin
        TestSetup();
        exit(GlobalDataSource.Status);
    end;

    procedure "Get.QueryString"(DoTestField: Boolean): Text[250]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataSource.TestField("Query String");
        exit(GlobalDataSource."Query String");
    end;

    procedure "Get.RegexFilterURL"(DoTestField: Boolean): Text[250]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataSource.TestField("Regex Filter URL");
        exit(GlobalDataSource."Regex Filter URL");
    end;

    procedure IsSet(): Boolean
    begin
        exit(GlobalIsSetup);
    end;

    procedure IsDraft(): Boolean
    begin
        TestSetup();
        exit(GlobalDataSource.Status = GlobalDataSource.Status::Draft);
    end;

    procedure IsActive(): Boolean
    begin
        TestSetup();
        exit(GlobalDataSource.Status = GlobalDataSource.Status::Active);
    end;

    procedure IsInactive(): Boolean
    begin
        TestSetup();
        exit(GlobalDataSource.Status = GlobalDataSource.Status::Inactive);
    end;

    local procedure TestSetup()
    var
        SourceIsNotSetupError: Label 'Data Provider is not setup. \Use Set procedure first.';
    begin
        if not GlobalIsSetup then
            Error(SourceIsNotSetupError);
    end;

    procedure Call(var DataSource: Record "MDS Data Source"): Boolean
    var
        ContentStream: InStream;
    begin
        if not sDataProvider."Impl.Call"(DataSource, ContentStream) then
            exit(false);
    end;

    procedure CreateDataSourceLinks(var DataSource: Record "MDS Data Source"): Boolean
    var
        ContentStream: InStream;
    begin
        if not sDataProvider."Impl.CreateDataRequestLinks"(DataSource, ContentStream) then
            exit(false);
    end;

    procedure DownloadSourceLinkContent(var DataSource: Record "MDS Data Source"): Boolean
    var
        DataSourceLinkBuffer: Record "MDS Data Source Link" temporary;
        Limit: Integer;
        I: Integer;
    begin
        if not sDataSourceLink."InitBuffer.Active.Open"(DataSource."No.", DataSourceLinkBuffer) then
            exit(false);

        Limit := 10;
        DataSourceLinkBuffer.FindSet(true);
        repeat
            if sDataProvider."Impl.DownloadContentRequestLink"(DataSourceLinkBuffer) then
                I += 1;
        until (I > 10) or (DataSourceLinkBuffer.Next() = 0);
        sDataSourceLink.CreateOrModify(DataSourceLinkBuffer)
    end;

}
