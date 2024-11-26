table 50108 "MDS Data Request Link"
{
    Caption = 'Source Request Link';
    DataClassification = CustomerContent;
    LookupPageId = "MDS Data Request Link List";
    DrillDownPageId = "MDS Data Request Link List";

    fields
    {
        field(1; "Config No."; Code[20])
        {
            Caption = 'Config No.';
        }
        field(2; "Link ID"; Integer)
        {
            Caption = 'Link ID';
        }
        field(3; "Reference No."; Code[30])
        {
            Caption = 'Reference No.';
        }
        field(4; "Link Path"; Text[1024])
        {
            Caption = 'Url';
            ExtendedDatatype = URL;
        }
        field(5; "Link Path As MD5"; Text[32])
        {
            Caption = 'Url As MD5';
        }
        field(6; GTIN; Code[30])
        {
            Caption = 'GTIN';
        }
        field(7; Status; Enum "MDS Status")
        {
            Caption = 'Status';
        }
        field(8; "Process Status"; Enum "MDS Data Request Processing Status")
        {
            Caption = 'Process Status';
        }
        field(10; "Link Last Modified"; DateTime)
        {
            Caption = 'Link Last Modified';
        }
        field(11; "Link Change Freq."; DateFormula)
        {
            Caption = 'Link Change Freq.';
        }
        field(12; "Link Priority"; Integer)
        {
            Caption = 'Link Priority';
        }
    }
    keys
    {
        key(PK; "Config No.", "Link ID")
        {
            Clustered = true;
        }
        key(UK1; "Reference No.", "Link Path As MD5")
        {
            Unique = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DrawDown; "Config No.", "Link ID", "Link Path", "Reference No.", Status) { }
    }

    var
        mData: Codeunit "MDS Data Management";

    trigger OnInsert()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnInsert(Rec, IsHandled);
        if not IsHandled then
            mData."DataRequestLink.OnInsert"(Rec);
        OnAfterOnInsert(Rec, IsHandled)
    end;

    trigger OnModify()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnModify(Rec, xRec, IsHandled);
        if not IsHandled then
            mData."DataRequestLink.OnModify"(Rec, xRec);
        OnAfterOnModify(Rec, xRec, IsHandled);
    end;

    trigger OnDelete()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnDelete(Rec, IsHandled);
        if not IsHandled then
            mData."DataRequestLink.OnDelete"(Rec);
        OnAfterOnDelete(Rec, IsHandled);
    end;

    trigger OnRename()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnRename(Rec, xRec, IsHandled);
        if not IsHandled then
            mData."DataRequestLink.OnRename"(Rec, xRec);
        OnAfterOnRename(Rec, xRec, IsHandled);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnInsert(var Rec: Record "MDS Data Request Link"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnInsert(var Rec: Record "MDS Data Request Link"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnModify(var Rec: Record "MDS Data Request Link"; xRec: Record "MDS Data Request Link"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnModify(var Rec: Record "MDS Data Request Link"; xRec: Record "MDS Data Request Link"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnDelete(var Rec: Record "MDS Data Request Link"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnDelete(var Rec: Record "MDS Data Request Link"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnRename(var Rec: Record "MDS Data Request Link"; xRec: Record "MDS Data Request Link"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnRename(var Rec: Record "MDS Data Request Link"; xRec: Record "MDS Data Request Link"; IsHandled: Boolean)
    begin

    end;
}
