table 50102 "MDS Data Provider"
{
    Caption = 'Data Provider';
    DataClassification = CustomerContent;
    DrillDownPageId = "MDS Data Provider List";
    LookupPageId = "MDS Data Provider List";

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
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(4; Type; Enum "MDS Data Provider Type")
        {
            Caption = 'Type';
        }
        field(5; Status; Enum "MDS Status")
        {
            Caption = 'Status';
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
        fieldgroup(DrawDown; Code, Name, Description, Type, Status) { }
    }

    var
        DataProviderMgt: Codeunit "MDS Data Provider Managment";

    trigger OnInsert()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnInsert(Rec, IsHandled);
        if not IsHandled then
            DataProviderMgt.DataProviderOnInsert(Rec);
        OnAfterOnInsert(Rec, IsHandled)
    end;

    trigger OnModify()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnModify(Rec, xRec, IsHandled);
        if not IsHandled then
            DataProviderMgt.DataProviderOnModify(Rec, xRec);
        OnAfterOnModify(Rec, xRec, IsHandled);
    end;

    trigger OnDelete()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnDelete(Rec, IsHandled);
        if not IsHandled then
            DataProviderMgt.DataProviderOnDelete(Rec);
        OnAfterOnDelete(Rec, IsHandled);
    end;

    trigger OnRename()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnRename(Rec, xRec, IsHandled);
        if not IsHandled then
            DataProviderMgt.DataProviderOnRename(Rec, xRec);
        OnAfterOnRename(Rec, xRec, IsHandled);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnInsert(var Rec: Record "MDS Data Provider"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnInsert(var Rec: Record "MDS Data Provider"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnModify(var Rec: Record "MDS Data Provider"; xRec: Record "MDS Data Provider"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnModify(var Rec: Record "MDS Data Provider"; xRec: Record "MDS Data Provider"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnDelete(var Rec: Record "MDS Data Provider"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnDelete(var Rec: Record "MDS Data Provider"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnRename(var Rec: Record "MDS Data Provider"; xRec: Record "MDS Data Provider"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnRename(var Rec: Record "MDS Data Provider"; xRec: Record "MDS Data Provider"; IsHandled: Boolean)
    begin

    end;
}
