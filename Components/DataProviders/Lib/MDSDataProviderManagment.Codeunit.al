namespace mds.mds;

codeunit 50103 "MDS Data Provider Managment"
{
    Subtype = Normal;

    var
        GlobalDataProvider: Record "MDS Data Provider";

    procedure DataProviderOnInsert(var DataProvider: Record "MDS Data Provider")
    begin
        DataProvider.TestField(Code);
    end;

    procedure DataProviderOnModify(var DataProvider: Record "MDS Data Provider"; xDataProvider: Record "MDS Data Provider")
    begin

    end;

    procedure DataProviderOnDelete(var DataProvider: Record "MDS Data Provider")
    begin

    end;

    procedure DataProviderOnRename(var DataProvider: Record "MDS Data Provider"; xDataProvider: Record "MDS Data Provider")
    begin

    end;

}
