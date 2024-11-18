namespace mds.mds;

codeunit 50103 "MDS Data Managment"
{
    Subtype = Normal;

    var
        GlobalDataProvider: Record "MDS Data Provider";
        GlobalDataRequestConfig: Record "MDS Data Request Config";

    procedure "DataProvider.OnInsert"(var DataProvider: Record "MDS Data Provider")
    begin
        DataProvider.TestField("No.");
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

}
