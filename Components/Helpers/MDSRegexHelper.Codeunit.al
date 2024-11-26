namespace mds.mds;
using System.Utilities;

codeunit 50111 "MDS Regex Helper"
{
    Subtype = Normal;

    procedure IsRegexMatch(String: Text; Pattern: Text): Boolean
    var
        Regex: Codeunit Regex;
    begin
        exit(Regex.IsMatch(String, Pattern));
    end;
}
