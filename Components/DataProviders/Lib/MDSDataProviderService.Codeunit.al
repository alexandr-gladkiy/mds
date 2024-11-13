namespace mds.mds;

codeunit 50104 "MDS Data Provider Service"
{
    Subtype = Normal;

    var
        GlobalDataProvider: Record "MDS Data Provider";
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
}
