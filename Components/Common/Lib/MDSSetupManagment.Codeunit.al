namespace mds.mds;

codeunit 50107 "MDS Setup Managment"
{
    Subtype = Normal;

    var
        GlobalSetup: Record "MDS Setup";

    procedure "Setup.OnInsert"(var Setup: Record "MDS Setup")
    begin

    end;

    procedure "Setup.OnModify"(var Setup: Record "MDS Setup"; xSetup: Record "MDS Setup")
    begin

    end;

    procedure "Setup.OnDelete"(var Setup: Record "MDS Setup")
    begin

    end;

    procedure "Setup.OnRename"(var Setup: Record "MDS Setup"; xSetup: Record "MDS Setup")
    begin

    end;

}
