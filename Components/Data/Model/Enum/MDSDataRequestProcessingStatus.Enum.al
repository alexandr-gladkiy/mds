namespace mds.mds;

enum 50105 "MDS Data Request Processing Status"
{
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Downloaded)
    {
        Caption = 'Downloaded';
    }
    value(2; Parsed)
    {
        Caption = 'Parsed';
    }
    value(3; Error)
    {
        Caption = 'Error';
    }
    value(4; "Not Found")
    {
        Caption = 'Not Found';
    }
    value(5; Skipped)
    {
        Caption = 'Skipped';
    }
}
