table 50105 "MDS Source Http Header"
{
    Caption = 'Data Source Http Header';
    DataClassification = CustomerContent;
    LookupPageId = "MDS Source Http Header List";
    DrillDownPageId = "MDS Source Http Header List";

    fields
    {
        field(1; "Data Povider No."; Code[20])
        {
            Caption = 'Data Povider No.';
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }
        field(3; "Http Header Code"; Code[20])
        {
            Caption = 'Http Header Code';
        }
    }
    keys
    {
        key(PK; "Data Povider No.", "Source No.", "Http Header Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DrawDown; "Data Povider No.", "Source No.", "Http Header Code") { }
    }


    var
        SourceMgt: Codeunit "MDS Source Management";

    trigger OnInsert()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnInsert(Rec, IsHandled);
        if not IsHandled then
            SourceMgt."SourceHttpHeader.OnInsert"(Rec);
        OnAfterOnInsert(Rec, IsHandled)
    end;

    trigger OnModify()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnModify(Rec, xRec, IsHandled);
        if not IsHandled then
            SourceMgt."SourceHttpHeader.OnModify"(Rec, xRec);
        OnAfterOnModify(Rec, xRec, IsHandled);
    end;

    trigger OnDelete()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnDelete(Rec, IsHandled);
        if not IsHandled then
            SourceMgt."SourceHttpHeader.OnDelete"(Rec);
        OnAfterOnDelete(Rec, IsHandled);
    end;

    trigger OnRename()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnRename(Rec, xRec, IsHandled);
        if not IsHandled then
            SourceMgt."SourceHttpHeader.OnRename"(Rec, xRec);
        OnAfterOnRename(Rec, xRec, IsHandled);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnInsert(var Rec: Record "MDS Source Http Header"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnInsert(var Rec: Record "MDS Source Http Header"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnModify(var Rec: Record "MDS Source Http Header"; xRec: Record "MDS Source Http Header"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnModify(var Rec: Record "MDS Source Http Header"; xRec: Record "MDS Source Http Header"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnDelete(var Rec: Record "MDS Source Http Header"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnDelete(var Rec: Record "MDS Source Http Header"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnRename(var Rec: Record "MDS Source Http Header"; xRec: Record "MDS Source Http Header"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnRename(var Rec: Record "MDS Source Http Header"; xRec: Record "MDS Source Http Header"; IsHandled: Boolean)
    begin

    end;
}
