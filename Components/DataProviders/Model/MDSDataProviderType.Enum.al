namespace mds.mds;

enum 50102 "MDS Data Provider Type"
{
    Extensible = true;

    value(0; Website)
    {
        Caption = 'Website';
    }
    value(1; oData)
    {
        Caption = 'oData';
    }
    value(2; SOAP)
    {
        Caption = 'SOAP';
    }
    value(3; FTP)
    {
        Caption = 'FTP';
    }
    value(4; Azure)
    {
        Caption = 'Azure';
    }
    value(5; Selectel)
    {
        Caption = 'Selectel';
    }
}
