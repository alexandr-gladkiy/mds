namespace mds.mds;
using System.Utilities;

codeunit 50115 "MDS Persistent Blob Helper"
{
    Subtype = Normal;

    var
        PersistentBlob: Codeunit "Persistent Blob";
        GlobalOutStream: OutStream;
        GlobalnIStream: InStream;
        GlobalTempBlob: Codeunit "Temp Blob";
        ErrorParameterIsEmpty: Label '%1 parameter is empty';
        ErrorBlobDoesNotExist: Label 'Persistent Blob does not exist %1';


    procedure "Upload.AsStream"(var FileInstream: InStream; var BlobKey: BigInteger)
    begin
        if BlobKey = 0 then
            BlobKey := PersistentBlob.Create();

        if not PersistentBlob.Exists(BlobKey) then
            Error(ErrorBlobDoesNotExist, BlobKey);

        PersistentBlob.CopyFromInStream(BlobKey, FileInstream);
    end;

    procedure "Upload.AsXML"(ContentAsXml: XmlDocument; var BlobKey: BigInteger)
    begin
        Upload(ContentAsXml, BlobKey);
    end;

    procedure "Upload.AsJSON"(ContentAsJson: JsonObject; var BlobKey: BigInteger)
    begin
        Upload(ContentAsJson, BlobKey);
    end;

    procedure "Upload.AsText"(ContentAsText: Text; var BlobKey: BigInteger)
    begin
        Upload(ContentAsText, BlobKey);
    end;

    local procedure Upload(ContentVariant: Variant; var BlobKey: BigInteger)
    var
        ContentAsJson: JsonObject;
        ContentAsXml: XmlDocument;
        ContentAsText: Text;
        IsSetContent: Boolean;
    begin
        ClearAll();
        if Format(ContentVariant) = '' then
            exit;

        GlobalTempBlob.CreateOutStream(GlobalOutStream);

        if ContentVariant.IsJsonObject then begin
            ContentAsJson := ContentVariant;
            IsSetContent := ContentAsJson.WriteTo(GlobalOutStream);
        end;

        if ContentVariant.IsXmlDocument then begin
            ContentAsXml := ContentVariant;
            IsSetContent := ContentAsXml.WriteTo(GlobalOutStream);
        end;

        if ContentVariant.IsText then begin
            IsSetContent := Evaluate(ContentAsText, ContentVariant);
            GlobalOutStream.WriteText(ContentAsText);
        end;

        if not IsSetContent then
            exit;

        GlobalTempBlob.CreateInStream(GlobalnIStream);
        "Upload.AsStream"(GlobalnIStream, BlobKey);
    end;

    procedure "Download.ToFile"(BlobKey: BigInteger; FileName: Text)
    begin
        //sCommon.TestEmpty(FileName, StrSubstNo(ErrorParameterIsEmpty, 'FileName'));
        "Init.AsInstream"(BlobKey);
        DownloadFromStream(GlobalnIStream, '', '', '', FileName);
    end;

    procedure "Get.AsStream"(BlobKey: BigInteger; var IStream: InStream)
    begin
        Init(BlobKey);
        GlobalTempBlob.CreateInStream(IStream);
    end;

    procedure "Get.AsText"(BlobKey: BigInteger) BlobText: Text
    begin
        "Init.AsInstream"(BlobKey);
        GlobalnIStream.Read(BlobText, MaxStrLen(BlobText));
    end;

    procedure "Get.AsJson"(BlobKey: BigInteger) Content: JsonObject
    begin
        "Init.AsInstream"(BlobKey);
        Content.ReadFrom(GlobalnIStream);
    end;

    procedure "Get.AsXML"(BlobKey: BigInteger) Content: XmlDocument
    begin
        "Init.AsInstream"(BlobKey);
        XmlDocument.ReadFrom(GlobalnIStream, Content);
    end;

    procedure "Get.AsBlob"(BlobKey: BigInteger; var TempBlob: Codeunit "Temp Blob")
    begin
        //sCommon.TestEmpty(BlobKey, StrSubstNo(ErrorParameterIsEmpty, 'BlobKey'));
        ClearAll();
        if not PersistentBlob.Exists(BlobKey) then
            Error(ErrorBlobDoesNotExist);
        TempBlob.CreateOutStream(GlobalOutStream);
        PersistentBlob.CopyToOutStream(BlobKey, GlobalOutStream);
    end;

    local procedure Init(BlobKey: BigInteger)
    begin
        //sCommon.TestEmpty(BlobKey, StrSubstNo(ErrorParameterIsEmpty, 'BlobKey'));
        ClearAll();
        if not PersistentBlob.Exists(BlobKey) then
            Error(ErrorBlobDoesNotExist);
        GlobalTempBlob.CreateOutStream(GlobalOutStream);
        PersistentBlob.CopyToOutStream(BlobKey, GlobalOutStream);
    end;

    local procedure "Init.AsInstream"(BlobKey: BigInteger)
    begin
        Init(BlobKey);
        GlobalTempBlob.CreateInStream(GlobalnIStream);
    end;

    procedure Delete(BlobKey: BigInteger)
    begin
        if BlobKey = 0 then
            exit;

        if not PersistentBlob.Exists(BlobKey) then
            Error(ErrorBlobDoesNotExist, BlobKey);

        PersistentBlob.Delete(BlobKey);
    end;
}
