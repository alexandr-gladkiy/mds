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
        field(8; "Process Status"; Enum "MDS Process Status")
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
}
