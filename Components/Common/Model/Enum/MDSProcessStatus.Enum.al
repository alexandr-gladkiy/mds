namespace mds.mds;

enum 50104 "MDS Process Status"
{
    Extensible = true;
    
    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Processing)
    {
        Caption = 'Processing';
    }
    value(2; Completed)
    {
        Caption = 'Completed';
    }
    value(3; Canceled)
    {
        Caption = 'Canceled';
    }
}
