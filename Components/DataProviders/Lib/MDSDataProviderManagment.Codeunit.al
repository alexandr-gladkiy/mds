namespace mds.mds;

codeunit 50103 "MDS Data Provider Managment"
{
    Subtype = Normal;

    var
        GlobalDataProvider: Record "MDS Data Provider";

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

}
