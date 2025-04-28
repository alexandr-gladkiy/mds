namespace mds.mds;
codeunit 50100 "MDS Attribute Management"
{
    Subtype = Normal;

    var
        GlobalAttribute: Record "MDS Attribute";
        GlobalAttributeGroup: Record "MDS Attribute Group";

    procedure "Attribute.OnInsert"(var Attribute: Record "MDS Attribute")
    begin
        Attribute.TestField(Code);
    end;

    procedure "Attribute.OnModify"(var Attribute: Record "MDS Attribute"; xAttribute: Record "MDS Attribute")
    begin

    end;

    procedure "Attribute.OnDelete"(var Attribute: Record "MDS Attribute")
    begin

    end;

    procedure "Attribute.OnRename"(var Attribute: Record "MDS Attribute"; xAttribute: Record "MDS Attribute")
    begin

    end;

    procedure "AttributeGroup.OnInsert"(var AttributeGroup: Record "MDS Attribute Group")
    begin
        AttributeGroup.TestField(Code);
    end;

    procedure "AttributeGroup.OnModify"(var AttributeGroup: Record "MDS Attribute Group"; xAttributeGroup: Record "MDS Attribute Group")
    begin

    end;

    procedure "AttributeGroup.OnDelete"(var AttributeGroup: Record "MDS Attribute Group")
    begin

    end;

    procedure "AttributeGroup.OnRename"(var AttributeGroup: Record "MDS Attribute Group"; xAttributeGroup: Record "MDS Attribute Group")
    begin

    end;




    procedure "Attribute.CreateOrModify.Single"(Attribute: Record "MDS Attribute"; RunTrigger: Boolean) RecordId: RecordId
    begin
        if GlobalAttribute.Get(Attribute.Code) then begin
            GlobalAttribute.TransferFields(Attribute, false);
            GlobalAttribute.Modify(RunTrigger);
        end else begin
            GlobalAttribute.Init();
            GlobalAttribute.TransferFields(Attribute, true);
            GlobalAttribute.Insert(RunTrigger);
        end;

        RecordId := GlobalAttribute.RecordId;
    end;

    procedure "Attribute.CreateOrModify.List"(var AttributeBuffer: Record "MDS Attribute"; RunTrigger: Boolean) RecordIdList: List of [RecordId]
    var
        RecordId: RecordId;
    begin
        if AttributeBuffer.FindSet(false) then
            repeat
                RecordId := "Attribute.CreateOrModify.Single"(AttributeBuffer, RunTrigger);
                RecordIdList.Add(RecordId);
            until AttributeBuffer.Next() = 0;
    end;

    procedure "AttributeGroup.CreateOrModify.Single"(AttributeGroup: Record "MDS Attribute Group"; RunTrigger: Boolean) RecordId: RecordId
    begin
        if GlobalAttributeGroup.Get(AttributeGroup.Code) then begin
            GlobalAttributeGroup.TransferFields(AttributeGroup, false);
            GlobalAttributeGroup.Modify(RunTrigger);
        end else begin
            GlobalAttributeGroup.Init();
            GlobalAttributeGroup.TransferFields(AttributeGroup, true);
            GlobalAttributeGroup.Insert(RunTrigger);
        end;

        RecordId := GlobalAttributeGroup.RecordId;
    end;

    procedure "AttributeGroup.CreateOrModify.List"(var AttributeGroupBuffer: Record "MDS Attribute Group"; RunTrigger: Boolean) RecordIdList: List of [RecordId]
    var
        RecordId: RecordId;
    begin
        if AttributeGroupBuffer.FindSet(false) then
            repeat
                RecordId := "AttributeGroup.CreateOrModify.Single"(AttributeGroupBuffer, RunTrigger);
                RecordIdList.Add(RecordId);
            until AttributeGroupBuffer.Next() = 0;
    end;

}
