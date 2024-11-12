namespace mds.mds;

codeunit 50102 "MDS Attribute Group Service"
{
    Subtype = Normal;

    var
        GlobalAttributeGroup: Record "MDS Attribute Group";
        GlobalIsSetup: Boolean;

    procedure Set(Code: Code[20]): Boolean
    begin
        if GlobalIsSetup and (GlobalAttributeGroup.Code = Code) then
            exit(true);

        GlobalIsSetup := GlobalAttributeGroup.Get(Code);
    end;

    procedure GetCode(DoTestField: Boolean): Code[20]
    begin
        TestSetup();
        if DoTestField then
            GlobalAttributeGroup.TestField(Code);
        exit(GlobalAttributeGroup.Code);
    end;

    procedure GetName(DoTestField: Boolean): Text[50]
    begin
        TestSetup();
        if DoTestField then
            GlobalAttributeGroup.TestField(Name);
        exit(GlobalAttributeGroup.Name);
    end;

    procedure GetStatus(): Enum "MDS Status"
    begin
        TestSetup();
        exit(GlobalAttributeGroup.Status);
    end;

    procedure IsSet(): Boolean
    begin
        exit(GlobalIsSetup);
    end;

    procedure IsDraft(): Boolean
    begin
        TestSetup();
        exit(GlobalAttributeGroup.Status = GlobalAttributeGroup.Status::Draft);
    end;

    procedure IsActive(): Boolean
    begin
        TestSetup();
        exit(GlobalAttributeGroup.Status = GlobalAttributeGroup.Status::Active);
    end;

    procedure IsInactive(): Boolean
    begin
        TestSetup();
        exit(GlobalAttributeGroup.Status = GlobalAttributeGroup.Status::Inactive);
    end;

    local procedure TestSetup()
    var
        AttributeIsNotSetupError: Label 'Attribute Group is not setup. \Use Set procedure first.';
    begin
        if not GlobalIsSetup then
            Error(AttributeIsNotSetupError);
    end;
}
