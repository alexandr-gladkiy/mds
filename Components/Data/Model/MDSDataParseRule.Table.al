table 50109 "MDS Data Parse Rule"
{
    Caption = 'Data Parse Rule';
    DataClassification = CustomerContent;
    LookupPageId = "MDS Data Parse Rule";
    DrillDownPageId = "MDS Data Parse Rule";

    fields
    {
        field(1; "Data Provider No."; Code[20])
        {
            Caption = 'Data Provider No.';
        }
        field(2; "Request Config No."; Code[20])
        {
            Caption = 'Request Config No.';
        }
        field(3; "Attribute Code"; Code[10])
        {
            Caption = 'Attribute Code';
        }
        field(4; "Exec. Step"; Integer)
        {
            Caption = 'Exec. Step';
        }
        field(5; "Action Type"; Integer)
        {
            Caption = 'Action Type';
        }
        field(6; "Node Value Name"; Text[50])
        {
            Caption = 'Node Value Name';
        }
        field(7; "Node Value Path"; Text[250])
        {
            Caption = 'Node Value Path';
        }
        field(8; "Node Value Filter"; Text[250])
        {
            Caption = 'Node Value Filter';
        }
        field(9; "Tag Filter"; Text[250])
        {
            Caption = 'Tag Filter';
        }
    }
    keys
    {
        key(PK; "Data Provider No.", "Request Config No.", "Attribute Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DrawDown; "Exec. Step", "Attribute Code", "Action Type", "Node Value Name") { }
    }

    var
        mData: Codeunit "MDS Data Management";

    trigger OnInsert()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnInsert(Rec, IsHandled);
        if not IsHandled then
            mData."DataParseRule.OnInsert"(Rec);
        OnAfterOnInsert(Rec, IsHandled)
    end;

    trigger OnModify()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnModify(Rec, xRec, IsHandled);
        if not IsHandled then
            mData."DataParseRule.OnModify"(Rec, xRec);
        OnAfterOnModify(Rec, xRec, IsHandled);
    end;

    trigger OnDelete()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnDelete(Rec, IsHandled);
        if not IsHandled then
            mData."DataParseRule.OnDelete"(Rec);
        OnAfterOnDelete(Rec, IsHandled);
    end;

    trigger OnRename()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnRename(Rec, xRec, IsHandled);
        if not IsHandled then
            mData."DataParseRule.OnRename"(Rec, xRec);
        OnAfterOnRename(Rec, xRec, IsHandled);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnInsert(var Rec: Record "MDS Data Parse Rule"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnInsert(var Rec: Record "MDS Data Parse Rule"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnModify(var Rec: Record "MDS Data Parse Rule"; xRec: Record "MDS Data Parse Rule"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnModify(var Rec: Record "MDS Data Parse Rule"; xRec: Record "MDS Data Parse Rule"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnDelete(var Rec: Record "MDS Data Parse Rule"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnDelete(var Rec: Record "MDS Data Parse Rule"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnRename(var Rec: Record "MDS Data Parse Rule"; xRec: Record "MDS Data Parse Rule"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnRename(var Rec: Record "MDS Data Parse Rule"; xRec: Record "MDS Data Parse Rule"; IsHandled: Boolean)
    begin

    end;
}
