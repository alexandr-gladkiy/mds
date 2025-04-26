namespace mds.mds;

enum 50106 "MDS Authorization Type"
{
    Extensible = true;

    value(0; "None")
    {
        Caption = 'None';
    }
    value(1; Basic)
    {
        Caption = 'Basic';
    }
    value(2; NTLM)
    {
        Caption = 'NTLM';
    }
}
