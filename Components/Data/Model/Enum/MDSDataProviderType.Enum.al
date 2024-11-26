namespace mds.mds;

enum 50102 "MDS Data Provider Type" implements "MDS IData Provider"
{
    Extensible = true;

    value(0; Website)
    {
        Caption = 'Website';
        Implementation = "MDS IData Provider" = "MDS Website Impl.";
    }

    value(1; OData)
    {
        Caption = 'OData';
        Implementation = "MDS IData Provider" = "MDS OData Impl.";
    }
    
    /* TODO:
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
    */
}
