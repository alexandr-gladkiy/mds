namespace mds.mds;
enum 50100 "MDS Attribute Type"
{
    Extensible = true;

    value(0; Single)
    {
        Caption = 'Single';
    }
    value(1; "Array")
    {
        Caption = 'Array';
    }
    value(2; "List")
    {
        Caption = 'List';
    }
}
