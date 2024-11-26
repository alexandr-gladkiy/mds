namespace mds.mds;
using System.Security.Encryption;

codeunit 50110 "MDS Value Helper"
{
    Subtype = Normal;

    procedure ConvertStringToDateFormula(ChangeFreqText: Text) ChangeFreq: DateFormula
    begin
        //TODO: Make universal date formula return
        case ChangeFreqText of
            'weekly':
                Evaluate(ChangeFreq, '1W');
            'daily':
                Evaluate(ChangeFreq, '1D');
        end;
    end;

    procedure GetRandomHashString(HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512) ApiKey: Text
    var
        CryptMngnt: Codeunit "Cryptography Management";
        Secret: Text[1024];
    begin
        Secret := Format(CreateGuid());
        ApiKey := CryptMngnt.GenerateHashAsBase64String(Secret, HashAlgorithmType);
    end;

    procedure GetStringAsMD5(String: Text): Text
    var
        CryptMngnt: Codeunit "Cryptography Management";
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
    begin
        exit(CryptMngnt.GenerateHash(String, HashAlgorithmType::MD5));
    end;

    procedure GetValueFromJson(ValueKey: Text; JObject: JsonObject; DoTestValuExist: Boolean): Text
    var
        JToken: JsonToken;
        TokenExist: Boolean;
        ErrorTokenKeyIsNotValue: Label '%1 is not value';
        ErrorTokenKeyIsNull: Label '%1 is null';
        ErrorTokenKeyNotExist: Label '%1 not exist';
    begin
        TokenExist := JObject.Get(ValueKey, JToken);

        if DoTestValuExist and (not TokenExist) then
            Error(ErrorTokenKeyNotExist, ValueKey);

        if not TokenExist then
            exit;

        if not JToken.IsValue then
            Error(ErrorTokenKeyIsNotValue, ValueKey);

        if DoTestValuExist and JToken.AsValue().IsNull then
            Error(ErrorTokenKeyIsNull);

        if not JToken.AsValue().IsNull then
            exit(JToken.AsValue().AsText());
    end;

    procedure GetObjectFromJson(ObjectKey: Text; JObject: JsonObject; DoTestObjectExist: Boolean): JsonObject
    var
        JToken: JsonToken;
        ErrorTokenKeyIsNotObject: Label '%1 is not object';
        ErrorTokenKeyNotExist: Label '%1 not exist';
        TokenExist: Boolean;
    begin
        TokenExist := JObject.Get(ObjectKey, JToken);

        if DoTestObjectExist and (not TokenExist) then
            Error(ErrorTokenKeyNotExist, ObjectKey);

        if not TokenExist then
            exit;

        if not JToken.IsObject then
            Error(ErrorTokenKeyIsNotObject, ObjectKey);

        if not JToken.IsObject then
            exit;

        exit(JToken.AsObject);
    end;

    procedure GetDifferenceTime(TimeStart: Time; TimeEnd: Time): Decimal
    begin
        exit((TimeEnd - TimeStart) / 1000);
    end;
}
