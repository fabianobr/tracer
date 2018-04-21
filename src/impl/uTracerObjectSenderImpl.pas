unit uTracerObjectSenderImpl;

interface

uses
  uTracerBasicAPI;

type
  TTracerObjectSender = class
  public
    class procedure SendSpan(poSpan: ISerializable);
  end;

implementation

uses
  Classes, uObjectSender, SysUtils;

var
  goSender: TObjectSender;

function getSender: TObjectSender;
begin
  if not Assigned(goSender) then
  begin
    goSender := TObjectSender.Create; //PC_OK
    // TO-DO: Decouple, put inside a thread
    goSender.URL := 'http://localhost:8126/v0.3/traces';
  end;
  result := goSender;
end;

procedure NewSender;
begin
  if Assigned(goSender) then
  begin
    goSender.Free; //PC_OK
    goSender := nil;
  end;
end;

{ TTracerObjectSender }

procedure SendJson(psJson: string);
var
  oSender: TObjectSender;
  sLine: string;

  procedure Send;
  begin
    oSender := getSender;
    oSender.SenderObject := '[[' + psJson + ']]';
    oSender.Send;
    sLine := oSender.Output;
    if sLine[1] <> 'O' then
      sLine := '';
  end;

begin
  try
    Send;
  except
    NewSender;
    try
      Send;
    except
      NewSender;
      sLine := '';
    end;
  end;
end;

class procedure TTracerObjectSender.SendSpan(poSpan: ISerializable);
var
  sLine: string;
  sBlock: string;
  oLista: TStringList;
begin
  oLista := poSpan.Serialize;
  try
    sBlock := '';
    while oLista.Count > 0 do
    begin
      sLine := oLista[0];
      oLista.Delete(0);

      sBlock := sBlock + sLine;
      if oLista.Count > 0 then
        sBlock := sBlock + ', ';
    end;
  finally
    oLista.Free; //PC_OK
  end;
  if sBlock = '' then
    exit;
  SendJson(sBlock);
end;

initialization
  goSender := nil;

finalization
  if assigned(goSender) then
    goSender.Free;

end.

