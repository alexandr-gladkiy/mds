codeunit 50101 "MDS Attribute Service"
{
    Subtype = Normal;

    var
        GlobalAttribute: Record "MDS Attribute";
        GlobalIsSetup: Boolean;

    procedure "Set.ByPK"(Code: Code[20]): Boolean
    begin
        if GlobalIsSetup and (GlobalAttribute.Code = Code) then
            exit(true);

        GlobalIsSetup := GlobalAttribute.Get(Code);
    end;

    procedure "Get.Code"(DoTestField: Boolean): Code[20]
    begin
        TestSetup();
        if DoTestField then
            GlobalAttribute.TestField(Code);
        exit(GlobalAttribute.Code);
    end;

    procedure "Get.Name"(DoTestField: Boolean): Text[50]
    begin
        TestSetup();
        if DoTestField then
            GlobalAttribute.TestField(Name);
        exit(GlobalAttribute.Name);
    end;

    procedure "Get.Type"(): Enum "MDS Attribute Type"
    begin
        TestSetup();
        exit(GlobalAttribute.Type);
    end;

    procedure "Get.Status"(): Enum "MDS Status"
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

    procedure "GetSetOf.ByGroupCode"(GroupCode: Code[20]; var Attribute: Record "MDS Attribute"): Boolean
    begin
        Attribute.Reset();
        Attribute.SetCurrentKey("Group Code");
        Attribute.SetRange("Group Code", GroupCode);
        exit(not Attribute.IsEmpty());
    end;

    procedure "GetSetOf.ByParentCode"(ParentCode: Code[20]; var Attribute: Record "MDS Attribute"): Boolean
    begin
        Attribute.Reset();
        Attribute.SetCurrentKey("Parent Code");
        Attribute.SetRange("Group Code", ParentCode);
        exit(not Attribute.IsEmpty());
    end;

    local procedure TestSetup()
    var
        AttributeIsNotSetupError: Label 'Attribute is not setup. \Use Set procedure first.';
    begin
        if not GlobalIsSetup then
            Error(AttributeIsNotSetupError);
    end;
}
