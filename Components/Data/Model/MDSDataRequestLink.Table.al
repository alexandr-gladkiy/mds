table 50108 "MDS Data Request Link"
{
    Caption = 'Source Request Link';
    DataClassification = CustomerContent;
    LookupPageId = "MDS Data Request Link List";
    DrillDownPageId = "MDS Data Request Link List";

    fields
    {
        field(1; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }
        field(2; "Link ID"; Integer)
        {
            Caption = 'Link ID';
        }
        field(3; "Reference No."; Code[30])
        {
            Caption = 'Reference No.';
        }
        field(4; Url; Text[1024])
        {
            Caption = 'Url';
        }
        field(5; "Url As MD5"; Text[32])
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
        field(8; "Processing Status"; Integer)
        {
            Caption = 'Processing Status';
        }
    }
    keys
    {
        key(PK; "Source No.", "Link ID")
        {
            Clustered = true;
        }
        key(UK1; "Reference No.", "Url As MD5")
        {
            Unique = true;
        }
    }
}
