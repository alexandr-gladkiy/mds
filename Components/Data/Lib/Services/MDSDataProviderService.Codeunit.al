namespace mds.mds;

codeunit 50104 "MDS Data Provider Service"
{
    Subtype = Normal;

    var
        GlobalDataProvider: Record "MDS Data Provider"; //TODO: переделать на DataProvider, обращения переписать через this.
        sDataRequestConfig: Codeunit "MDS Data Source Service";
        IDataProvider: Interface "MDS IData Provider";
        IDataProviderIsInit: Boolean;
        GlobalIsSetup: Boolean;

    procedure "Set.ByPK"(No: Code[20]): Boolean
    begin
        if GlobalIsSetup and (GlobalDataProvider."No." = No) then
            exit(true);

        GlobalIsSetup := GlobalDataProvider.Get(No);
        exit(GlobalIsSetup);
    end;

    procedure "Get.No"(DoTestField: Boolean): Code[20]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataProvider.TestField("No.");
        exit(GlobalDataProvider."No.");
    end;

    procedure "Get.Name"(DoTestField: Boolean): Text[50]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataProvider.TestField(Name);
        exit(GlobalDataProvider.Name);
    end;

    procedure "Get.Description"(DoTestField: Boolean): Text[250]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataProvider.TestField(Description);
        exit(GlobalDataProvider.Description);
    end;

    procedure "Get.Type"(): Enum "MDS Data Provider Type"
    begin
        TestSetup();
        exit(GlobalDataProvider.Type);
    end;

    procedure "Get.Status"(): Enum "MDS Status"
    begin
        TestSetup();
        exit(GlobalDataProvider.Status);
    end;

    procedure "Get.WebBaseUrl"(DoTestField: Boolean): Text[250]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataProvider.TestField("Base URL");
        exit(GlobalDataProvider."Base URL");
    end;

    procedure "Get.WebSitemapURL"(DoTestField: Boolean): Text[250]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataProvider.TestField("Web Sitemap Url");
        exit(GlobalDataProvider."Web Sitemap Url");
    end;

    procedure IsSet(): Boolean
    begin
        exit(GlobalIsSetup);
    end;

    procedure IsDraft(): Boolean
    begin
        TestSetup();
        exit(GlobalDataProvider.Status = GlobalDataProvider.Status::Draft);
    end;

    procedure IsActive(): Boolean
    begin
        TestSetup();
        exit(GlobalDataProvider.Status = GlobalDataProvider.Status::Active);
    end;

    procedure IsInactive(): Boolean
    begin
        TestSetup();
        exit(GlobalDataProvider.Status = GlobalDataProvider.Status::Inactive);
    end;

    local procedure TestSetup()
    var
        DataProviderIsNotSetupError: Label 'Data Provider is not setup. \Use Set procedure first.';
    begin
        if not GlobalIsSetup then
            Error(DataProviderIsNotSetupError);
    end;

    //------ Interface Implementation ------
    procedure "Impl.TestConnect"(ShowMessage: Boolean) IsConnected: Boolean
    begin
        TestSetup();
        InitInterface("Get.Type"());
        if IDataProvider.SetDataProvider("Get.No"(true)) then
            IsConnected := IDataProvider.TestConnect(ShowMessage);
    end;

    procedure "Impl.SetDataProvider"() IsSet: Boolean
    begin
        TestSetup();
        InitInterface("Get.Type"());
        IsSet := IDataProvider.SetDataProvider("Get.No"(true));
    end;

    procedure "Impl.Call"(var DataRequestConfig: Record "MDS Data Source"; var ContentStream: InStream) IsCalled: Boolean
    begin
        "Set.ByPK"(DataRequestConfig."Data Provider No.");
        InitInterface("Get.Type"());
        if IDataProvider.SetDataProvider("Get.No"(true)) then
            IsCalled := IDataProvider.Call(DataRequestConfig, ContentStream);
    end;

    procedure "Impl.CreateDataRequestLinks"(var DataRequestConfig: Record "MDS Data Source"; var ContentStream: InStream) IsCalled: Boolean
    begin
        "Set.ByPK"(DataRequestConfig."Data Provider No.");
        InitInterface("Get.Type"());
        if not IDataProvider.SetDataProvider("Get.No"(true)) then
            exit;

        if IDataProvider.Call(DataRequestConfig, ContentStream) then
            IsCalled := IDataProvider.CreateRequestLinks(DataRequestConfig, ContentStream)
    end;

    procedure "Impl.DownloadContentRequestLink"(var DataRequestLink: Record "MDS Data Source Link"): Boolean
    begin
        sDataRequestConfig."Set.ByPK"(DataRequestLink."Config No.");
        "Set.ByPK"(sDataRequestConfig."Get.DataProviderNo"(true));
        InitInterface("Get.Type"());
        exit(IDataProvider.DownloadContentRequestLink(DataRequestLink))
    end;

    local procedure InitInterface(Type: Enum "MDS Data Provider Type")
    begin
        if IDataProviderIsInit and (GlobalDataProvider.Type = Type) then
            exit;

        IDataProvider := Type;
        IDataProviderIsInit := true;
    end;
}
