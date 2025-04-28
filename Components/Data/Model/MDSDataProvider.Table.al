table 50102 "MDS Data Provider"
{
    Caption = 'Data Provider';
    DataClassification = CustomerContent;
    DrillDownPageId = "MDS Data Provider List";
    LookupPageId = "MDS Data Provider List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
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

        field(10; "Base URL"; Text[250])
        {
            Caption = 'Base URL';
        }
        field(20; "Authorization Type"; Enum "MDS Authorization Type")
        {
            Caption = 'Authorization Type';
        }
        field(21; Login; Text[100])
        {
            Caption = 'Login';
        }
        field(22; Password; Text[100])
        {
            Caption = 'Password';
        }
        field(100; "Attribute Count"; Integer)
        {
            Caption = 'Attribute Rules';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MDS Data Source Attribute" where("Data Provider No." = field("No."), "Request Config No" = const('')));
        }
        field(101; "Source Count"; Integer)
        {
            Caption = 'Source Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MDS Data Source" where("Data Provider No." = field("No.")));
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DrawDown; "No.", Name, Description, Type, Status) { }
    }

    var
        mData: Codeunit "MDS Data Management";

    trigger OnInsert()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnInsert(Rec, IsHandled);
        if not IsHandled then
            mData."DataProvider.OnInsert"(Rec);
        OnAfterOnInsert(Rec, IsHandled)
    end;

    trigger OnModify()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnModify(Rec, xRec, IsHandled);
        if not IsHandled then
            mData."DataProvider.OnModify"(Rec, xRec);
        OnAfterOnModify(Rec, xRec, IsHandled);
    end;

    trigger OnDelete()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnDelete(Rec, IsHandled);
        if not IsHandled then
            mData."DataProvider.OnDelete"(Rec);
        OnAfterOnDelete(Rec, IsHandled);
    end;

    trigger OnRename()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnRename(Rec, xRec, IsHandled);
        if not IsHandled then
            mData."DataProvider.OnRename"(Rec, xRec);
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
