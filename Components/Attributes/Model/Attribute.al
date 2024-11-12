table 50100 "MDS Attribute"
{
    Caption = 'MDS Attribute';
    DataClassification = CustomerContent;

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
        field(3; "Type"; Integer)
        {
            Caption = 'Type';
        }
        field(4; Status; Integer)
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
}
