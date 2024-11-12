namespace AG.MDS.Attributes;
using mds.mds;

table 50100 "MDS Attribute"
{
    Caption = 'MDS Attribute';
    DataClassification = CustomerContent;
    DrillDownPageId = "MDS Attribute List";
    LookupPageId = "MDS Attribute List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; "Type"; Enum "MDS Attribute Type")
        {
            Caption = 'Type';
        }
        field(4; "Group Code"; Code[20])
        {
            Caption = 'Group Code';
            TableRelation = "MDS Attribute Group".Code;
        }
        field(5; Status; Enum "MDS Status")
        {
            Caption = 'Status';
        }
        field(10; "Parent Code"; Code[20])
        {
            Caption = 'Parent Code';
            TableRelation = "MDS Attribute" where("Group Code" = field("Group Code"));
        }
        field(50; "Indent Level"; Integer)
        {
            Caption = 'Indent Level';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DrawDown; "Group Code", Code, Name, Type, Status)
        { }
    }

    var
        AttributeMgt: Codeunit "MDS Attribute Management";

    trigger OnInsert()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnInsert(Rec, IsHandled);
        if not IsHandled then
            AttributeMgt.AttributeOnInsert(Rec);
        OnAfterOnInsert(Rec, IsHandled)
    end;

    trigger OnModify()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnModify(Rec, xRec, IsHandled);
        if not IsHandled then
            AttributeMgt.AttributeOnModify(Rec, xRec);
        OnAfterOnModify(Rec, xRec, IsHandled);
    end;

    trigger OnDelete()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnDelete(Rec, IsHandled);
        if not IsHandled then
            AttributeMgt.AttributeOnDelete(Rec);
        OnAfterOnDelete(Rec, IsHandled);
    end;

    trigger OnRename()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnRename(Rec, xRec, IsHandled);
        if not IsHandled then
            AttributeMgt.AttributeOnRename(Rec, xRec);
        OnAfterOnRename(Rec, xRec, IsHandled);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnInsert(var Rec: Record "MDS Attribute"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnInsert(var Rec: Record "MDS Attribute"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnModify(var Rec: Record "MDS Attribute"; xRec: Record "MDS Attribute"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnModify(var Rec: Record "MDS Attribute"; xRec: Record "MDS Attribute"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnDelete(var Rec: Record "MDS Attribute"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnDelete(var Rec: Record "MDS Attribute"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnRename(var Rec: Record "MDS Attribute"; xRec: Record "MDS Attribute"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnRename(var Rec: Record "MDS Attribute"; xRec: Record "MDS Attribute"; IsHandled: Boolean)
    begin

    end;
}