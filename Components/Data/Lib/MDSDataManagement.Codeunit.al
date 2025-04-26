namespace mds.mds;
using Microsoft.Foundation.NoSeries;

codeunit 50103 "MDS Data Management"
{
    Subtype = Normal;

    var
        GlobalDataProvider: Record "MDS Data Provider";
        GlobalDataRequestConfig: Record "MDS Data Request Config";
        DataRequestLink: Record "MDS Data Request Link";
        sSetup: Codeunit "MDS Setup Service";


    procedure "DataProvider.OnInsert"(var DataProvider: Record "MDS Data Provider")
    begin

    end;

    procedure "DataProvider.OnModify"(var DataProvider: Record "MDS Data Provider"; xDataProvider: Record "MDS Data Provider")
    begin

    end;

    procedure "DataProvider.OnDelete"(var DataProvider: Record "MDS Data Provider")
    begin

    end;

    procedure "DataProvider.OnRename"(var DataProvider: Record "MDS Data Provider"; xDataProvider: Record "MDS Data Provider")
    begin

    end;

    procedure "DataProvider.OnValidate.No"(var DataProvider: Record "MDS Data Provider"; xDataProvider: Record "MDS Data Provider")
    begin
        this."Set.DataProvider.No"(DataProvider);
    end;

    local procedure "Set.DataProvider.No"(var DataProvider: Record "MDS Data Provider")
    var
        NoSeries: Codeunit "No. Series";
    begin
        if DataProvider."No." = '' then
            DataProvider."No." := NoSeries.GetNextNo(this.sSetup."Get.SerialNo.DataProvider"());
    end;

    procedure "DataProvider.CreateOrModify.Single"(DataProvider: Record "MDS Data Provider"; RunTrigger: Boolean) RecordId: RecordId
    begin
        if GlobalDataProvider.Get(DataProvider."No.") then begin
            GlobalDataProvider.TransferFields(DataProvider, false);
            GlobalDataProvider.Modify(RunTrigger);
        end else begin
            GlobalDataProvider.Init();
            GlobalDataProvider.TransferFields(DataProvider, true);
            GlobalDataProvider.Insert(RunTrigger);
        end;

        RecordId := GlobalDataProvider.RecordId;
    end;

    procedure "DataProvider.CreateOrModify.List"(var DataProviderBuffer: Record "MDS Data Provider"; RunTrigger: Boolean) RecordIdList: List of [RecordId]
    var
        RecordId: RecordId;
    begin
        if DataProviderBuffer.FindSet(false) then
            repeat
                RecordId := "DataProvider.CreateOrModify.Single"(DataProviderBuffer, RunTrigger);
                RecordIdList.Add(RecordId);
            until DataProviderBuffer.Next() = 0;
    end;


    procedure "DataRequestConfig.OnInsert"(var DataRequestConfig: Record "MDS Data Request Config")
    begin
        DataRequestConfig.TestField("No.");
    end;

    procedure "DataRequestConfig.OnModify"(var DataRequestConfig: Record "MDS Data Request Config"; xDataRequestConfig: Record "MDS Data Request Config")
    begin

    end;

    procedure "DataRequestConfig.OnDelete"(var DataRequestConfig: Record "MDS Data Request Config")
    begin

    end;

    procedure "DataRequestConfig.OnRename"(var DataRequestConfig: Record "MDS Data Request Config"; xDataRequestConfig: Record "MDS Data Request Config")
    begin

    end;

    procedure "DataRequestConfig.OnValidate.No"(var DataRequestConfig: Record "MDS Data Request Config"; xDataRequestConfig: Record "MDS Data Request Config")
    begin
        this."Set.DataRequestConfig.No"(DataRequestConfig);
    end;

    local procedure "Set.DataRequestConfig.No"(var DataRequestConfig: Record "MDS Data Request Config")
    var
        NoSeries: Codeunit "No. Series";
    begin
        if DataRequestConfig."No." = '' then
            DataRequestConfig."No." := NoSeries.GetNextNo(this.sSetup."Get.SerialNo.DataRequestConfig"());
    end;

    procedure "DataRequestConfig.CreateOrModify.Single"(DataRequestConfig: Record "MDS Data Request Config"; RunTrigger: Boolean) RecordId: RecordId
    begin
        if GlobalDataRequestConfig.Get(DataRequestConfig."No.") then begin
            GlobalDataRequestConfig.TransferFields(DataRequestConfig, false);
            GlobalDataRequestConfig.Modify(RunTrigger);
        end else begin
            GlobalDataRequestConfig.Init();
            GlobalDataRequestConfig.TransferFields(DataRequestConfig, true);
            GlobalDataRequestConfig.Insert(RunTrigger);
        end;

        RecordId := GlobalDataRequestConfig.RecordId;
    end;

    procedure "Source.CreateOrModify.List"(var DataRequestConfigBuffer: Record "MDS Data Request Config"; RunTrigger: Boolean) RecordIdList: List of [RecordId]
    var
        RecordId: RecordId;
    begin
        if DataRequestConfigBuffer.FindSet(false) then
            repeat
                RecordId := "DataRequestConfig.CreateOrModify.Single"(DataRequestConfigBuffer, RunTrigger);
                RecordIdList.Add(RecordId);
            until DataRequestConfigBuffer.Next() = 0;
    end;


    procedure "DataHttpHeader.OnInsert"(var DataHttpHeader: Record "MDS Data Http Header")
    begin

    end;

    procedure "DataHttpHeader.OnModify"(var DataHttpHeader: Record "MDS Data Http Header"; xDataHttpHeader: Record "MDS Data Http Header")
    begin

    end;

    procedure "DataHttpHeader.OnDelete"(var DataHttpHeader: Record "MDS Data Http Header")
    begin

    end;

    procedure "DataHttpHeader.OnRename"(var DataHttpHeader: Record "MDS Data Http Header"; xDataHttpHeader: Record "MDS Data Http Header")
    begin

    end;



    procedure "DataRequestLink.OnInsert"(var DataRequestLink: Record "MDS Data Request Link")
    begin

    end;

    procedure "DataRequestLink.OnModify"(var DataRequestLink: Record "MDS Data Request Link"; xDataRequestLink: Record "MDS Data Request Link")
    begin

    end;

    procedure "DataRequestLink.OnDelete"(var DataRequestLink: Record "MDS Data Request Link")
    begin

    end;

    procedure "DataRequestLink.OnRename"(var DataRequestLink: Record "MDS Data Request Link"; xDataRequestLink: Record "MDS Data Request Link")
    begin

    end;

    procedure "DataRequestLink.CreateOrModify.List"(var DataRequestLinkBuffer: Record "MDS Data Request Link"; RunTrigger: Boolean) RecordIdList: List of [RecordId]
    var
        RecordId: RecordId;
    begin
        if DataRequestLinkBuffer.IsEmpty() then
            exit;

        DataRequestLinkBuffer.FindSet(false);
        repeat
            RecordId := this."DataRequestLink.CreateOrModify.Single"(DataRequestLinkBuffer, RunTrigger);
            RecordIdList.Add(RecordId);

        until DataRequestLinkBuffer.Next() = 0;
    end;

    procedure "DataRequestLink.CreateOrModify.Single"(DataRequestLink: Record "MDS Data Request Link"; RunTrigger: Boolean) RecordId: RecordId
    begin
        if this.DataRequestLink.Get(DataRequestLink."Config No.", DataRequestLink."Link ID") then begin
            this.DataRequestLink.TransferFields(DataRequestLink, false);
            this.DataRequestLink.Modify(RunTrigger);
        end else begin
            this.DataRequestLink.Init();
            this.DataRequestLink.TransferFields(DataRequestLink, true);
            this.DataRequestLink.Insert(RunTrigger);
        end;

        RecordId := this.DataRequestLink.RecordId;
    end;

    procedure "DataRequestAttribute.OnInsert"(var DataRequestAttribute: Record "MDS Data Request Attribute")
    begin

    end;

    procedure "DataRequestAttribute.OnModify"(var DataRequestAttribute: Record "MDS Data Request Attribute"; xDataRequestAttribute: Record "MDS Data Request Attribute")
    begin

    end;

    procedure "DataRequestAttribute.OnDelete"(var DataRequestAttribute: Record "MDS Data Request Attribute")
    begin

    end;

    procedure "DataRequestAttribute.OnRename"(var DataRequestAttribute: Record "MDS Data Request Attribute"; xDataRequestAttribute: Record "MDS Data Request Attribute")
    begin

    end;

    procedure "DataParseRule.OnInsert"(var DataParseRule: Record "MDS Data Parse Rule")
    begin

    end;

    procedure "DataParseRule.OnModify"(var DataParseRule: Record "MDS Data Parse Rule"; xDataParseRule: Record "MDS Data Parse Rule")
    begin

    end;

    procedure "DataParseRule.OnDelete"(var DataParseRule: Record "MDS Data Parse Rule")
    begin

    end;

    procedure "DataParseRule.OnRename"(var DataParseRule: Record "MDS Data Parse Rule"; xDataParseRule: Record "MDS Data Parse Rule")
    begin

    end;
}
