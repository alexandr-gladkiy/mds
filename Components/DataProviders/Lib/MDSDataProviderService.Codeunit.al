namespace mds.mds;

codeunit 50104 "MDS Data Provider Service"
{
    Subtype = Normal;

    var
        GlobalDataProvider: Record "MDS Data Provider";
        GlobalIsSetup: Boolean;

    procedure Set(Code: Code[20]): Boolean
    begin
        if GlobalIsSetup and (GlobalDataProvider.Code = Code) then
            exit(true);

        GlobalIsSetup := GlobalDataProvider.Get(Code);
    end;

    procedure GetCode(DoTestField: Boolean): Code[20]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataProvider.TestField(Code);
        exit(GlobalDataProvider.Code);
    end;

    procedure GetName(DoTestField: Boolean): Text[50]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataProvider.TestField(Name);
        exit(GlobalDataProvider.Name);
    end;

    procedure GetDescription(DoTestField: Boolean): Text[250]
    begin
        TestSetup();
        if DoTestField then
            GlobalDataProvider.TestField(Description);
        exit(GlobalDataProvider.Description);
    end;

    procedure GetType(): Enum "MDS Data Provider Type"
    begin
        TestSetup();
        exit(GlobalDataProvider.Type);
    end;

    procedure GetStatus(): Enum "MDS Status"
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
