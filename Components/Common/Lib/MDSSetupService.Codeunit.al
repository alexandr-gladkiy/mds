namespace mds.mds;

codeunit 50112 "MDS Setup Service"
{
    Subtype = Normal;

    var
        Setup: Record "MDS Setup";
        mSetup: Codeunit "MDS Setup Management";
        IsHasSetup: Boolean;

    procedure "Get.SerialNo.DataProvider"(): Code[20]
    begin
        this."Get.Setup"();
        this.Setup.TestField("Data Provider Serial No.");
        exit(this.Setup."Data Provider Serial No.");
    end;

    procedure "Get.SerialNo.DataConfig"(): Code[20]
    begin
        this."Get.Setup"();
        this.Setup.TestField("Data Config Serial No.");
        exit(this.Setup."Data Config Serial No.");
    end;

    local procedure "Get.Setup"()
    begin
        if this.IsHasSetup then
            exit;

        this.IsHasSetup := this.Setup.Get();
        if not this.IsHasSetup then
            this.IsHasSetup := this.mSetup."Create.Setup"(this.Setup);
    end;
}
