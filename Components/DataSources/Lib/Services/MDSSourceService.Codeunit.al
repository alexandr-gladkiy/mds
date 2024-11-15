namespace mds.mds;

codeunit 50106 "MDS Source Service"
{
    Subtype = Normal;

    var
        GlobalSource: Record "MDS Source";
        GlobalIsSetup: Boolean;

    procedure "Set.ByPK"(No: Code[20]): Boolean
    begin
        if GlobalIsSetup and (GlobalSource."No." = No) then
            exit(true);

        GlobalIsSetup := GlobalSource.Get(No);
    end;

    procedure "Get.No"(DoTestField: Boolean): Code[20]
    begin
        TestSetup();
        if DoTestField then
            GlobalSource.TestField("No.");
        exit(GlobalSource."No.");
    end;

    procedure "Get.Name"(DoTestField: Boolean): Text[100]
    begin
        TestSetup();
        if DoTestField then
            GlobalSource.TestField(Name);
        exit(GlobalSource.Name);
    end;

    procedure "Get.DataProviderNo"(): Code[20]
    begin
        TestSetup();
        exit(GlobalSource."Data Provider No.");
    end;

    procedure "Get.Status"(): Enum "MDS Status"
    begin
        TestSetup();
        exit(GlobalSource.Status);
    end;

    procedure IsSet(): Boolean
    begin
        exit(GlobalIsSetup);
    end;

    procedure IsDraft(): Boolean
    begin
        TestSetup();
        exit(GlobalSource.Status = GlobalSource.Status::Draft);
    end;

    procedure IsActive(): Boolean
    begin
        TestSetup();
        exit(GlobalSource.Status = GlobalSource.Status::Active);
    end;

    procedure IsInactive(): Boolean
    begin
        TestSetup();
        exit(GlobalSource.Status = GlobalSource.Status::Inactive);
    end;

    local procedure TestSetup()
    var
        SourceIsNotSetupError: Label 'Source is not setup. \Use Set procedure first.';
    begin
        if not GlobalIsSetup then
            Error(SourceIsNotSetupError);
    end;

}
