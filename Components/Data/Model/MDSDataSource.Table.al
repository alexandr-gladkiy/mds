namespace mds.mds;
using System.RestClient;
using System.IO;
using System.Utilities;

table 50103 "MDS Data Source"
{
    Caption = 'Source';
    DataClassification = CustomerContent;
    DrillDownPageId = "MDS Data Source List";
    LookupPageId = "MDS Data Source List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(3; "Data Provider No."; Code[20])
        {
            Caption = 'Data Provider No.';
            TableRelation = "MDS Data Provider"."No.";
            NotBlank = true;
        }
        field(4; Status; Enum "MDS Status")
        {
            Caption = 'Status';
        }
        field(5; "Http Method"; Enum "Http Method")
        {
            Caption = 'Http Method';
        }
        field(10; Path; Text[100])
        {
            Caption = 'Path';
        }
        field(11; "Web Sitemap URL"; Text[250])
        {
            Caption = 'Web Sitemap Url';
        }
        field(12; "Regex Filter URL"; Text[250])
        {
            Caption = 'Regex Filter URL';
        }
        field(13; "Query String"; Text[250])
        {
            Caption = 'Query String';
        }
        field(14; "Request Content"; Text[1024])
        {
            Caption = 'Request Content';
        }
        field(15; "Pattern For Item Link"; Text[1024])
        {
            Caption = 'Patten for item link';
        }
        field(100; "Data Provider Name"; Text[50])
        {
            Caption = 'Data Provider Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("MDS Data Provider".Name where("No." = field("Data Provider No.")));
        }
        field(101; "Data Provider Base Url"; Text[250])
        {
            Caption = 'Data Provider Base Url';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("MDS Data Provider"."Base URL" where("No." = field("Data Provider No.")));
        }
        field(102; "Data Provider Type"; Enum "MDS Data Provider Type")
        {
            Caption = 'Data Provider Type';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("MDS Data Provider".Type where("No." = field("Data Provider No.")));
        }
        field(104; "Attribute Count"; Integer)
        {
            Caption = 'Attribute Rules';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MDS Data Parse Rule" where("Data Provider No." = field("No."), "Data Source No." = field("No.")));
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
        fieldgroup(DrawDown; "No.", Name, "Data Provider No.", Status) { }
    }

    var
        mData: Codeunit "MDS Data Management";

    trigger OnInsert()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnInsert(Rec, IsHandled);
        if not IsHandled then
            mData."DataRequestConfig.OnInsert"(Rec);
        OnAfterOnInsert(Rec, IsHandled)
    end;

    trigger OnModify()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnModify(Rec, xRec, IsHandled);
        if not IsHandled then
            mData."DataRequestConfig.OnModify"(Rec, xRec);
        OnAfterOnModify(Rec, xRec, IsHandled);
    end;

    trigger OnDelete()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnDelete(Rec, IsHandled);
        if not IsHandled then
            mData."DataRequestConfig.OnDelete"(Rec);
        OnAfterOnDelete(Rec, IsHandled);
    end;

    trigger OnRename()
    var
        IsHandled: Boolean;
    begin
        OnBeforeOnRename(Rec, xRec, IsHandled);
        if not IsHandled then
            mData."DataRequestConfig.OnRename"(Rec, xRec);
        OnAfterOnRename(Rec, xRec, IsHandled);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnInsert(var Rec: Record "MDS Data Source"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnInsert(var Rec: Record "MDS Data Source"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnModify(var Rec: Record "MDS Data Source"; xRec: Record "MDS Data Source"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnModify(var Rec: Record "MDS Data Source"; xRec: Record "MDS Data Source"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnDelete(var Rec: Record "MDS Data Source"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnDelete(var Rec: Record "MDS Data Source"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnRename(var Rec: Record "MDS Data Source"; xRec: Record "MDS Data Source"; IsHandled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnRename(var Rec: Record "MDS Data Source"; xRec: Record "MDS Data Source"; IsHandled: Boolean)
    begin

    end;
}
