namespace mds.mds;

codeunit 50113 "MDS Data Source Link Service"
{
    Subtype = Normal;

    var
        DataSourceLink: Record "MDS Data Source Link";
        mData: Codeunit "MDS Data Management";
        HasDataSourceLink: Boolean;

    procedure "Set.ByPK"(RequestConfigNo: Code[20]; LinkId: Integer): Boolean
    begin
        if this.HasDataSourceLink and (this.DataSourceLink."Config No." = RequestConfigNo) and (this.DataSourceLink."Link ID" = LinkId) then
            exit(true);

        this.HasDataSourceLink := this.DataSourceLink.Get(RequestConfigNo, LinkId);
        exit(this.HasDataSourceLink);
    end;

    procedure "Get.LastLinkId"(ConfigCode: Code[20]): Integer
    var
        DataRequestLink: Record "MDS Data Source Link";
    begin
        if not this."GetSetOf.ByConfigNo"(ConfigCode, DataRequestLink) then
            exit;

        DataRequestLink.FindLast();
        exit(DataRequestLink."Link ID");
    end;

    procedure "GetSetOf.ByConfigNo"(ConfigCode: Code[20]; var DataSourceLink: Record "MDS Data Source Link"): Boolean
    begin
        DataSourceLink.Reset();
        DataSourceLink.SetCurrentKey("Config No.", "Link ID");
        DataSourceLink.SetRange("Config No.", ConfigCode);
        exit(not DataSourceLink.IsEmpty());
    end;

    procedure "InitBuffer.Active.Open"(ConfigCode: Code[20]; var DataSourceLinkBuffer: Record "MDS Data Source Link"): Boolean
    var
        DataSourceLink: Record "MDS Data Source Link";
    begin
        //TODO: TestTemporaryRecord
        DataSourceLinkBuffer.Reset();
        if not DataSourceLinkBuffer.IsEmpty() then
            DataSourceLinkBuffer.DeleteAll(false);

        "GetSetOf.ByConfigNo"(ConfigCode, DataSourceLink);
        //DataRequestLink.SetCurrentKey()
        DataSourceLink.SetRange(Status, DataSourceLink.Status::Active);
        DataSourceLink.SetRange("Process Status", DataSourceLink."Process Status"::Open);

        if DataSourceLink.FindSet(false) then
            repeat
                DataSourceLinkBuffer.Init();
                DataSourceLinkBuffer.TransferFields(DataSourceLink, true);
                DataSourceLinkBuffer.Insert(false);
            until DataSourceLink.Next() = 0;
        exit(not DataSourceLinkBuffer.IsEmpty());
    end;

    procedure CreateOrModify(var DataSourceLinkBuffer: Record "MDS Data Source Link")
    begin
        mData."DataRequestLink.CreateOrModify.List"(DataSourceLinkBuffer, true);
    end;

    local procedure TestHasDataRequestLink()
    var
        DataSourceLinkSetupError: Label 'Data Source Link is not setup. Use Set.ByPK function first';
    begin
        if not this.HasDataSourceLink then
            Error(DataSourceLinkSetupError);
    end;
}
