namespace mds.mds;

codeunit 50104 "MDS Data Provider Service"
{
    Subtype = Normal;

    var
        DataProvider: Record "MDS Data Provider";
        sDataRequestConfig: Codeunit "MDS Data Source Service";
        IDataProvider: Interface "MDS IData Provider";
        IDataProviderIsInit: Boolean;
        IsSetup: Boolean;

    procedure "Set.ByPK"(No: Code[20]): Boolean
    begin
        if this.IsSetup and (this.DataProvider."No." = No) then
            exit(true);

        this.IsSetup := this.DataProvider.Get(No);
        exit(this.IsSetup);
    end;

    procedure "Get.No"(DoTestField: Boolean): Code[20]
    begin
        TestSetup();
        if DoTestField then
            this.DataProvider.TestField("No.");
        exit(this.DataProvider."No.");
    end;

    procedure "Get.Name"(DoTestField: Boolean): Text[50]
    begin
        TestSetup();
        if DoTestField then
            this.DataProvider.TestField(Name);
        exit(this.DataProvider.Name);
    end;

    procedure "Get.Description"(DoTestField: Boolean): Text[250]
    begin
        TestSetup();
        if DoTestField then
            this.DataProvider.TestField(Description);
        exit(this.DataProvider.Description);
    end;

    procedure "Get.Type"(): Enum "MDS Data Provider Type"
    begin
        TestSetup();
        exit(this.DataProvider.Type);
    end;

    procedure "Get.Status"(): Enum "MDS Status"
    begin
        TestSetup();
        exit(this.DataProvider.Status);
    end;

    procedure "Get.WebBaseUrl"(DoTestField: Boolean): Text[250]
    begin
        TestSetup();
        if DoTestField then
            this.DataProvider.TestField("Base URL");
        exit(this.DataProvider."Base URL");
    end;

    procedure IsSet(): Boolean
    begin
        exit(this.IsSetup);
    end;

    procedure IsDraft(): Boolean
    begin
        TestSetup();
        exit(this.DataProvider.Status = this.DataProvider.Status::Draft);
    end;

    procedure IsActive(): Boolean
    begin
        TestSetup();
        exit(this.DataProvider.Status = this.DataProvider.Status::Active);
    end;

    procedure IsInactive(): Boolean
    begin
        TestSetup();
        exit(this.DataProvider.Status = this.DataProvider.Status::Inactive);
    end;

    local procedure TestSetup()
    var
        DataProviderIsNotSetupError: Label 'Data Provider is not setup. \Use Set procedure first.';
    begin
        if not this.IsSetup then
            Error(DataProviderIsNotSetupError);
    end;

    //------ Interface Implementation ------
    procedure "Impl.TestConnect"(ShowMessage: Boolean) IsConnected: Boolean
    begin
        TestSetup();
        InitInterface("Get.Type"());
        if this.IDataProvider.SetDataProvider("Get.No"(true)) then
            IsConnected := this.IDataProvider.TestConnect(ShowMessage);
    end;

    procedure "Impl.SetDataProvider"() IsSet: Boolean
    begin
        TestSetup();
        InitInterface("Get.Type"());
        IsSet := this.IDataProvider.SetDataProvider("Get.No"(true));
    end;

    procedure "Impl.Call"(var DataRequestConfig: Record "MDS Data Source"; var ContentStream: InStream) IsCalled: Boolean
    begin
        "Set.ByPK"(DataRequestConfig."Data Provider No.");
        InitInterface("Get.Type"());
        if this.IDataProvider.SetDataProvider("Get.No"(true)) then
            IsCalled := this.IDataProvider.Call(DataRequestConfig, ContentStream);
    end;

    procedure "Impl.CreateDataRequestLinks"(var DataRequestConfig: Record "MDS Data Source"; var ContentStream: InStream) IsCalled: Boolean
    begin
        "Set.ByPK"(DataRequestConfig."Data Provider No.");
        InitInterface("Get.Type"());
        if not this.IDataProvider.SetDataProvider("Get.No"(true)) then
            exit;

        if this.IDataProvider.Call(DataRequestConfig, ContentStream) then
            IsCalled := this.IDataProvider.CreateRequestLinks(DataRequestConfig, ContentStream)
    end;

    procedure "Impl.DownloadContentRequestLink"(var DataRequestLink: Record "MDS Data Source Link"): Boolean
    begin
        this.sDataRequestConfig."Set.ByPK"(DataRequestLink."Data Source No.");
        "Set.ByPK"(this.sDataRequestConfig."Get.DataProviderNo"(true));
        InitInterface("Get.Type"());
        exit(this.IDataProvider.DownloadContentRequestLink(DataRequestLink))
    end;

    local procedure InitInterface(Type: Enum "MDS Data Provider Type")
    begin
        if this.IDataProviderIsInit and (this.DataProvider.Type = Type) then
            exit;

        this.IDataProvider := Type;
        this.IDataProviderIsInit := true;
    end;
}
