namespace mds.mds;

codeunit 50106 "MDS Data Source Service"
{
    Subtype = Normal;

    var
        DataSource: Record "MDS Data Source";
        sDataProvider: Codeunit "MDS Data Provider Service";
        sDataSourceLink: Codeunit "MDS Data Source Link Service";
        IsSetup: Boolean;

    procedure "Set.ByPK"(No: Code[20]): Boolean
    begin
        if this.IsSetup and (this.DataSource."No." = No) then
            exit(true);

        this.IsSetup := this.DataSource.Get(No);
    end;

    procedure "Get.No"(DoTestField: Boolean): Code[20]
    begin
        TestSetup();
        if DoTestField then
            this.DataSource.TestField("No.");
        exit(this.DataSource."No.");
    end;

    procedure "Get.Name"(DoTestField: Boolean): Text[100]
    begin
        TestSetup();
        if DoTestField then
            this.DataSource.TestField(Name);
        exit(this.DataSource.Name);
    end;

    procedure "Get.DataProviderNo"(DoTestField: Boolean): Code[20]
    begin
        TestSetup();
        if DoTestField then
            this.DataSource.TestField("Data Provider No.");
        exit(this.DataSource."Data Provider No.");
    end;

    procedure "Get.Status"(): Enum "MDS Status"
    begin
        TestSetup();
        exit(this.DataSource.Status);
    end;

    procedure "Get.QueryString"(DoTestField: Boolean): Text[250]
    begin
        TestSetup();
        if DoTestField then
            this.DataSource.TestField("Query String");
        exit(this.DataSource."Query String");
    end;

    procedure "Get.WebSitemapURL"(DoTestField: Boolean): Text[250]
    begin
        TestSetup();
        if DoTestField then
            this.DataSource.TestField("Web Sitemap Url");
        exit(this.DataSource."Web Sitemap Url");
    end;

    procedure "Get.RegexFilterURL"(DoTestField: Boolean): Text[250]
    begin
        TestSetup();
        if DoTestField then
            this.DataSource.TestField("Regex Filter URL");
        exit(this.DataSource."Regex Filter URL");
    end;

    procedure IsSet(): Boolean
    begin
        exit(this.IsSetup);
    end;

    procedure IsDraft(): Boolean
    begin
        TestSetup();
        exit(this.DataSource.Status = this.DataSource.Status::Draft);
    end;

    procedure IsActive(): Boolean
    begin
        TestSetup();
        exit(this.DataSource.Status = this.DataSource.Status::Active);
    end;

    procedure IsInactive(): Boolean
    begin
        TestSetup();
        exit(this.DataSource.Status = this.DataSource.Status::Inactive);
    end;

    local procedure TestSetup()
    var
        SourceIsNotSetupError: Label 'Data Provider is not setup. \Use Set procedure first.';
    begin
        if not this.IsSetup then
            Error(SourceIsNotSetupError);
    end;

    procedure Call(var DataSource: Record "MDS Data Source"): Boolean
    var
        ContentStream: InStream;
    begin
        if not this.sDataProvider."Impl.Call"(DataSource, ContentStream) then
            exit(false);
    end;

    procedure CreateDataSourceLinks(var DataSource: Record "MDS Data Source"): Boolean
    var
        ContentStream: InStream;
    begin
        if not this.sDataProvider."Impl.CreateDataRequestLinks"(DataSource, ContentStream) then
            exit(false);
    end;

    procedure DownloadSourceLinkContent(var DataSource: Record "MDS Data Source"): Boolean
    var
        TempDataSourceLinkBuffer: Record "MDS Data Source Link" temporary;
        Limit: Integer;
        I: Integer;
    begin
        if not this.sDataSourceLink."InitBuffer.Active.Open"(DataSource."No.", TempDataSourceLinkBuffer) then
            exit(false);

        Limit := 10;
        TempDataSourceLinkBuffer.FindSet(true);
        repeat
            if this.sDataProvider."Impl.DownloadContentRequestLink"(TempDataSourceLinkBuffer) then
                I += 1;
        until (I > Limit) or (TempDataSourceLinkBuffer.Next() = 0);
        this.sDataSourceLink.CreateOrModify(TempDataSourceLinkBuffer)
    end;

}
