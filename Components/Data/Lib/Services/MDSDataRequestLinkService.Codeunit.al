namespace mds.mds;

codeunit 50113 "MDS Data Request Link Service"
{
    Subtype = Normal;

    var
        DataRequestLink: Record "MDS Data Request Link";
        HasDataRequestLink: Boolean;

    procedure "Set.ByPK"(RequestConfigNo: Code[20]; LinkId: Integer): Boolean
    begin
        if this.HasDataRequestLink and (this.DataRequestLink."Config No." = RequestConfigNo) and (this.DataRequestLink."Link ID" = LinkId) then
            exit(true);

        this.HasDataRequestLink := this.DataRequestLink.Get(RequestConfigNo, LinkId);
        exit(this.HasDataRequestLink);
    end;

    procedure "Get.LastLinkId"(ConfigCode: Code[20]): Integer
    var
        DataRequestLink: Record "MDS Data Request Link";
    begin
        if not this."GetSetOf.ByConfigCode"(ConfigCode, DataRequestLink) then
            exit;

        DataRequestLink.FindLast();
        exit(DataRequestLink."Link ID");
    end;

    procedure "GetSetOf.ByConfigCode"(ConfigCode: Code[20]; var DataRequestLink: Record "MDS Data Request Link"): Boolean
    begin
        DataRequestLink.Reset();
        DataRequestLink.SetCurrentKey("Config No.", "Link ID");
        DataRequestLink.SetRange("Config No.", ConfigCode);
        exit(not DataRequestLink.IsEmpty());
    end;

    local procedure TestHasDataRequestLink()
    var
        DataRequestLinkSetupError: Label 'Data Request Link is not setup. Use Set.ByPK function first';
    begin
        if not this.HasDataRequestLink then
            Error(DataRequestLinkSetupError);
    end;
}
