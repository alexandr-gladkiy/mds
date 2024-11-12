codeunit 50100 "MDS Attribute Management"
{
    Subtype = Normal;

    var
        GlobalAttribute: Record "MDS Attribute";

    procedure AttributeOnInsert(var Attribute: Record "MDS Attribute")
    begin
        Attribute.TestField(Code);
    end;

    procedure AttributeOnModify(var Attribute: Record "MDS Attribute"; xAttribute: Record "MDS Attribute")
    begin

    end;

    procedure AttributeOnDelete(var Attribute: Record "MDS Attribute")
    begin

    end;

    procedure AttributeOnRename(var Attribute: Record "MDS Attribute"; xAttribute: Record "MDS Attribute")
    begin

    end;

    procedure AttributeGroupOnInsert(var AttributeGroup: Record "MDS Attribute Group")
    begin
        AttributeGroup.TestField(Code);
    end;

    procedure AttributeGroupOnModify(var AttributeGroup: Record "MDS Attribute Group"; xAttributeGroup: Record "MDS Attribute Group")
    begin

    end;

    procedure AttributeGroupOnDelete(var AttributeGroup: Record "MDS Attribute Group")
    begin

    end;

    procedure AttributeGroupOnRename(var AttributeGroup: Record "MDS Attribute Group"; xAttributeGroup: Record "MDS Attribute Group")
    begin

    end;

}
