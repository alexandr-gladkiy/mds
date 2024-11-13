namespace mds.mds;

codeunit 50105 "MDS Source Management"
{
    Subtype = Normal;

    var
        GlobalSource: Record "MDS Source";

    procedure "Source.OnInsert"(var Source: Record "MDS Source")
    begin
        Source.TestField("No.");
    end;

    procedure "Source.OnModify"(var Source: Record "MDS Source"; xSource: Record "MDS Source")
    begin

    end;

    procedure "Source.OnDelete"(var Source: Record "MDS Source")
    begin

    end;

    procedure "Source.OnRename"(var Source: Record "MDS Source"; xSource: Record "MDS Source")
    begin

    end;



    procedure "Source.CreateOrModify.Single"(Source: Record "MDS Source"; RunTrigger: Boolean) RecordId: RecordId
    begin
        if GlobalSource.Get(Source."No.") then begin
            GlobalSource.TransferFields(Source, false);
            GlobalSource.Modify(RunTrigger);
        end else begin
            GlobalSource.Init();
            GlobalSource.TransferFields(Source, true);
            GlobalSource.Insert(RunTrigger);
        end;

        RecordId := GlobalSource.RecordId;
    end;

    procedure "DataProvider.CreateOrModify.List"(var SourceBuffer: Record "MDS Source"; RunTrigger: Boolean) RecordIdList: List of [RecordId]
    var
        RecordId: RecordId;
    begin
        if SourceBuffer.FindSet(false) then
            repeat
                RecordId := "Source.CreateOrModify.Single"(SourceBuffer, RunTrigger);
                RecordIdList.Add(RecordId);
            until SourceBuffer.Next() = 0;
    end;

}
