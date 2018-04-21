unit uObjectSender;

interface

uses
  IdHTTP,
  Classes;

type
  TSenderObject = string;
  TSenderURL = string;
{$M+}
  TObjectSender = class
  private
    FoHTTP: TIdHttp;
    FoURL: TSenderURL;
    FObject: TSenderObject;
    FoOutputStream: TStringStream;

    procedure setObject(const Value: TSenderObject);
    procedure setURL(const Value: TSenderURL);
    function ConnectionFactory: TIdHttp;
    function getOutput: string;
  public
    function Send: integer;
    destructor Destroy; override;
  published
    property SenderObject: TSenderObject write setObject;
    property URL: TSenderURL write setUrl;
    property Output: string read getOutput;
  end;
{$M-}

implementation

uses
  SysUtils;

{ TObjectSender }

destructor TObjectSender.Destroy;
begin
  if Assigned(FoHTTP) then
    FreeAndNil(FoHTTP); //PC_OK
  if Assigned(FoOutputStream) then
    FreeAndNil(FoOutputStream);
  inherited;
end;

function TObjectSender.Send: integer;
var
  oInput: TStringStream;
begin
  oInput := TStringStream.Create(FObject);
  try
    FoHTTP.Put(FoURL, oInput, FoOutputStream);
    result := FoHTTP.ResponseCode;
  finally
    FreeAndNil(oInput);
  end;
end;

procedure TObjectSender.setObject(const Value: TSenderObject);
begin
  FObject := Value;
end;

procedure TObjectSender.setURL(const Value: TSenderURL);
begin
  if not assigned(FoHTTP) then
  begin
    FoHTTP := ConnectionFactory;
  end;
  FoURL := Value;
end;

function TObjectSender.ConnectionFactory: TIdHTTP;
begin
  result := TIdHTTP.Create(nil); //PC_OK

  result.Request.UserAgent := Self.ClassName;
  result.ProtocolVersion := pv1_1;
  result.Request.ContentType := 'application/json';
  result.Request.Accept := '*/*';
  result.Request.Connection := 'keep-alive';
  result.Request.CustomHeaders.AddValue('cache-control', 'no-cache');

  FoOutputStream := TStringStream.Create(''); //PC_OK
end;

function TObjectSender.getOutput: string;
begin
  FoOutputStream.position := 0;
  result := FoOutputStream.DataString;
end;

end.

