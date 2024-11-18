table 50106 "MDS Http Header"
{
    Caption = 'Http Header';
    DataClassification = CustomerContent;
    LookupPageId = "MDS Http Header List";
    DrillDownPageId = "MDS Http Header List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Type; Integer)
        {
            Caption = 'Type';
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(4; Value; Text[1024])
        {
            Caption = 'Value';
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
        fieldgroup(DrawDown; Code, Name, Value, Type, Status) { }
    }
}
