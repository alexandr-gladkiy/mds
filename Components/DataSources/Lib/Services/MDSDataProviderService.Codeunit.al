namespace mds.mds;

codeunit 50104 "MDS Data Provider Service"
{
    Subtype = Normal;

    var
        GlobalDataProvider: Record "MDS Data Provider"; //TODO: переделать на DataProvider, обращения переписать через this.
        IDataProvider: Interface "MDS IData Provider";
        IDataProviderIsInit: Boolean;
        GlobalIsSetup: Boolean;

    procedure "Set.ByPK"(No: Code[20]): Boolean
    begin
        if GlobalIsSetup and (GlobalDataProvider."No." = No) then
            exit(true);

        GlobalIsSetup := GlobalDataProvider.Get(No);
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
            GlobalDataProvider.TestField("Web Base URL");
        exit(GlobalDataProvider."Web Base URL");
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

    procedure "Impl.Call"(var Source: Record "MDS Source"; var ContentStream: InStream) IsConnected: Boolean
    begin
        TestSetup();
        InitInterface("Get.Type"());
        if IDataProvider.SetDataProvider("Get.No"(true)) then
            IsConnected := IDataProvider.Call(Source, ContentStream);
    end;

    local procedure InitInterface(Type: Enum "MDS Data Provider Type")
    begin
        if IDataProviderIsInit and (GlobalDataProvider.Type = Type) then
            exit;

        IDataProvider := Type;
        IDataProviderIsInit := true;
    end;
}
