namespace mds.mds;
using AG.MDS.Attributes;

table 50107 "MDS Data Source Attribute"
{
    Caption = 'Data Source Attributes';
    DataClassification = CustomerContent;
    DrillDownPageId = "MDS Data Attr. List";
    LookupPageId = "MDS Data Attr. List";

    fields
    {
        field(1; "Data Provider No."; Code[20])
        {
            Caption = 'Data Provider No.';
        }
        field(2; "Request Config No"; Code[20])
        {
            Caption = 'Data Request Config No';
            TableRelation = "MDS Data Source"."No.";
        }
        field(3; "Attribute Code"; Code[10])
        {
            Caption = 'Attribute Code';
            TableRelation = "MDS Attribute".Code;
        }
        field(4; Status; enum "MDS Status")
        {
            Caption = 'Status';
        }
        field(100; "Data Request Config Name"; Text[50])
        {
            Caption = 'Data Request Config Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("MDS Data Source".Name where("No." = field("Request Config No")));
        }
        field(101; "Attribute Name"; Text[50])
        {
            Caption = 'Attribute Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("MDS Attribute".Name where(Code = field("Attribute Code")));
        }
        field(102; "Attribute Type"; Enum "MDS Attribute Type")
        {
            Caption = 'Attribute Type';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("MDS Attribute".Type where(Code = field("Attribute Code")));
        }
        field(103; "Attribute Rules"; Integer)
        {
            Caption = 'Attribute Rules';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MDS Data Parse Rule" where("Data Provider No." = field("Data Provider No."), "Request Config No." = field("Request Config No"), "Attribute Code" = field("Attribute Code")));
        }
    }
    keys
    {
        key(PK; "Data Provider No.", "Request Config No", "Attribute Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DrawDown; "Data Provider No.", "Request Config No", "Data Request Config Name", "Attribute Code", "Attribute Name", "Attribute Type", Status) { }
    }

    var
        mData: Codeunit "MDS Data Management";

    trigger OnInsert()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnInsert(Rec, IsHandled);
        if not IsHandled then
            mData."DataRequestAttribute.OnInsert"(Rec);
        OnAfterOnInsert(Rec, IsHandled)
    end;

    trigger OnModify()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnModify(Rec, xRec, IsHandled);
        if not IsHandled then
            mData."DataRequestAttribute.OnModify"(Rec, xRec);
        OnAfterOnModify(Rec, xRec, IsHandled);
    end;

    trigger OnDelete()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnDelete(Rec, IsHandled);
        if not IsHandled then
            mData."DataRequestAttribute.OnDelete"(Rec);
        OnAfterOnDelete(Rec, IsHandled);
    end;

    trigger OnRename()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnRename(Rec, xRec, IsHandled);
        if not IsHandled then
            mData."DataRequestAttribute.OnRename"(Rec, xRec);
        OnAfterOnRename(Rec, xRec, IsHandled);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnInsert(var Rec: Record "MDS Data Source Attribute"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnInsert(var Rec: Record "MDS Data Source Attribute"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnModify(var Rec: Record "MDS Data Source Attribute"; xRec: Record "MDS Data Source Attribute"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnModify(var Rec: Record "MDS Data Source Attribute"; xRec: Record "MDS Data Source Attribute"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnDelete(var Rec: Record "MDS Data Source Attribute"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnDelete(var Rec: Record "MDS Data Source Attribute"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnRename(var Rec: Record "MDS Data Source Attribute"; xRec: Record "MDS Data Source Attribute"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnRename(var Rec: Record "MDS Data Source Attribute"; xRec: Record "MDS Data Source Attribute"; IsHandled: Boolean)
    begin

    end;
}
