table 50107 "MDS Source Request Params"
{
    Caption = 'Source Request Params';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }
        field(2; "Query String"; Text[250])
        {
            Caption = 'Query String';
        }
        field(3; Method; Enum "Http Method")
        {
            Caption = 'Method';
        }
        field(10; "Next Page URL"; Text[1024])
        {
            Caption = 'Next Page URL';
        }
        field(20; "Last Query Datetime"; Datetime)
        {
            Caption = 'Last Query Datetime';
        }
    }
    keys
    {
        key(PK; "Source No.")
        {
            Clustered = true;
        }
    }
}
