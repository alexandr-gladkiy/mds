codeunit 50101 "MDS Attribute Service"
{
    Subtype = Normal;

    var
        GlobalAttribute: Record "MDS Attribute";
        GlobalIsSetup: Boolean;

    procedure Set(Code: Code[20]): Boolean
    begin
        if GlobalIsSetup and (GlobalAttribute.Code = Code) then
            exit(true);

        GlobalIsSetup := GlobalAttribute.Get(Code);
    end;

    procedure GetCode(DoTestField: Boolean): Code[20]
    begin
        TestSetup();
        if DoTestField then
            GlobalAttribute.TestField(Code);
        exit(GlobalAttribute.Code);
    end;

    procedure GetName(DoTestField: Boolean): Text[50]
    begin
        TestSetup();
        if DoTestField then
            GlobalAttribute.TestField(Name);
        exit(GlobalAttribute.Name);
    end;

    procedure GetType(): Enum "MDS Attribute Type"
    begin
        TestSetup();
        exit(GlobalAttribute.Type);
    end;

    procedure GetStatus(): Enum "MDS Status"
    begin
        TestSetup();
        exit(GlobalAttribute.Status);
    end;

    procedure IsSet(): Boolean
    begin
        exit(GlobalIsSetup);
    end;

    procedure IsDraft(): Boolean
    begin
        TestSetup();
        exit(GlobalAttribute.Status = GlobalAttribute.Status::Draft);
    end;

    procedure IsActive(): Boolean
    begin
        TestSetup();
        exit(GlobalAttribute.Status = GlobalAttribute.Status::Active);
    end;

    procedure IsInactive(): Boolean
    begin
        TestSetup();
        exit(GlobalAttribute.Status = GlobalAttribute.Status::Inactive);
    end;

    local procedure TestSetup()
    var
        AttributeIsNotSetupError: Label 'Attribute is not setup. \Use Set procedure first.';
    begin
        if not GlobalIsSetup then
            Error(AttributeIsNotSetupError);
    end;
    //TODO:
    /*
        Set
        IsSet
        IsActive
        GetStatus
        GetFieldValue(FieldNo):Variant - GetFieldValue From RecRef Helper

        Get<FieldName>(DoTestField)

        TestSet()

        SetFieldValue(FieldNo, Value, DoTestEmptyValue)

        Set<FieldName>(Value, DoTestEmptyValue)
    */
}
