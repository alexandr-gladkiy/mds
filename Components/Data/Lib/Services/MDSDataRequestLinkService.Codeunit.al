namespace mds.mds;

codeunit 50113 "MDS Data Request Link Service"
{
    Subtype = Normal;

    var
        DataRequestLink: Record "MDS Data Request Link";
        mData: Codeunit "MDS Data Management";
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
        if not this."GetSetOf.ByConfigNo"(ConfigCode, DataRequestLink) then
            exit;

        DataRequestLink.FindLast();
        exit(DataRequestLink."Link ID");
    end;

    procedure "GetSetOf.ByConfigNo"(ConfigCode: Code[20]; var DataRequestLink: Record "MDS Data Request Link"): Boolean
    begin
        DataRequestLink.Reset();
        DataRequestLink.SetCurrentKey("Config No.", "Link ID");
        DataRequestLink.SetRange("Config No.", ConfigCode);
        exit(not DataRequestLink.IsEmpty());
    end;

    procedure "InitBuffer.Active.Open"(ConfigCode: Code[20]; var DataRequestLinkBuffer: Record "MDS Data Request Link"): Boolean
    var
        DataRequestLink: Record "MDS Data Request Link";
    begin
        //TODO: TestTemporaryRecord
        DataRequestLinkBuffer.Reset();
        if not DataRequestLinkBuffer.IsEmpty() then
            DataRequestLinkBuffer.DeleteAll(false);

        "GetSetOf.ByConfigNo"(ConfigCode, DataRequestLink);
        //DataRequestLink.SetCurrentKey()
        DataRequestLink.SetRange(Status, DataRequestLink.Status::Active);
        DataRequestLink.SetRange("Process Status", DataRequestLink."Process Status"::Open);

        if DataRequestLink.FindSet(false) then
            repeat
                DataRequestLinkBuffer.Init();
                DataRequestLinkBuffer.TransferFields(DataRequestLink, true);
                DataRequestLinkBuffer.Insert(false);
            until DataRequestLink.Next() = 0;
        exit(not DataRequestLinkBuffer.IsEmpty());
    end;

    procedure CreateOrModify(var DataRequestLinkBuffer: Record "MDS Data Request Link")
    begin
        mData."DataRequestLink.CreateOrModify.List"(DataRequestLinkBuffer, true);
    end;

    local procedure TestHasDataRequestLink()
    var
        DataRequestLinkSetupError: Label 'Data Request Link is not setup. Use Set.ByPK function first';
    begin
        if not this.HasDataRequestLink then
            Error(DataRequestLinkSetupError);
    end;
}
