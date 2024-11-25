namespace mds.mds;

codeunit 50107 "MDS Setup Management"
{
    Subtype = Normal;

    var
        Setup: Record "MDS Setup";

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

    procedure "Create.Setup"(var Setup: Record "MDS Setup"): Boolean
    begin
        if Setup.Get() then
            exit(true);

        Setup.Init();
        exit(Setup.Insert(true));
    end;

}
