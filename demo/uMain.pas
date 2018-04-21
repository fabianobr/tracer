unit uMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, uTracerBasicAPI;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    //    procedure SendSpan(poSpan: ISerializable);
  end;

var
  Form1: TForm1;

implementation

uses
  uObjectSender, uTracerTraceAPI, uTracerSpanAPI, uTracerAPI,
  uTracerImpl, uTracerObjectSenderImpl, DateUtils, Math;

{$R *.DFM}

const
  SecondsInDay = 60 * 60 * 24;

function DateTimeToUnixTime(DTime: TDateTime): int64;
var
  newTime: TDateTime;
begin
  newTime := DTime - EncodeDate(1970, 1, 1);
  newTime := NewTime * SecondsInDay;
  result := Trunc(NewTime * 1000) * 1000 * 1000; //mili * micro * nano
end;

procedure TForm1.Button1Click(Sender: TObject);
const
  msg = '[[{"trace_id": %d, "span_id": %d, "name": "%s", "resource": "%s", "service": "%s", "type": "%s", "start": %d, "duration": %d, "parent_id": %s}]]';
  UnixMilissegundos = 1000 * 1000;
  UnixSegundos = 1000 * UnixMilissegundos;
var
  obj: TSenderObject;
  nUnixDate: int64;
  nSpan: integer;
  nSpan2: integer;
  nTrace: integer;
  nSpanTime: TDateTime;
  oSender: TObjectSender;
begin
  nSpanTime := now;
  nSpanTime := IncHour(nSpanTime, +3);
  nUnixDate := DateTimeToUnixTime(nSpanTime);

  oSender := TObjectSender.Create;
  try
    Randomize;
    oSender.URL := 'http://localhost:8126/v0.3/traces';
    nSpan := Random(100000000);
    nTrace := Random(100000000);
    obj := Format(msg, [nTrace, nSpan, 'span' + IntToStr(nspan), 'res_name',
      'delphi5', 'server_app', nUnixDate, 1 * UnixSegundos, 'null']);
    oSender.SenderObject := obj;
    Memo1.Lines.add(obj);
    Memo1.Lines.add(IntToStr(oSender.Send) + ', ' + oSender.Output);

    nSpanTime := IncMilliSecond(nSpanTime, 500); // + 500ms
    nUnixDate := DateTimeToUnixTime(nSpanTime);
    nSpan2 := Random(100000000);
    obj := Format(msg, [nTrace, nspan2, 'span_child', 'res_name_child', 'delphi5',
      'server_app', nUnixDate, 100 * UnixMilissegundos, IntToStr(nSpan)]);
    oSender.SenderObject := obj;
    Memo1.Lines.add(obj);
    Memo1.Lines.add(IntToStr(oSender.Send) + ', ' + oSender.Output);

    nSpanTime := IncMilliSecond(nSpanTime, 50); // + 50ms
    nUnixDate := DateTimeToUnixTime(nSpanTime);
    obj := Format(msg, [nTrace, Random(100000000), 'span_neto1', 'res_name_neto',
      'delphi5', 'server_app', nUnixDate, 20 * UnixMilissegundos, IntToStr(nSpan2)]);
    oSender.SenderObject := obj;
    Memo1.Lines.add(obj);
    Memo1.Lines.add(IntToStr(oSender.Send) + ', ' + oSender.Output);

    nSpanTime := IncMilliSecond(nSpanTime, 100); // + 100ms
    nUnixDate := DateTimeToUnixTime(nSpanTime);
    nSpan2 := Random(100000000);
    obj := Format(msg, [nTrace, nspan2, 'span_child2', 'res_name_child2', 'delphi5',
      'server_app', nUnixDate, 100 * UnixMilissegundos, IntToStr(nSpan)]);
    oSender.SenderObject := obj;
    Memo1.Lines.add(obj);
    Memo1.Lines.add(IntToStr(oSender.Send) + ', ' + oSender.Output);

  finally
    oSender.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  oTracer: ITracer;
  oTrace: ITrace;
  oSpan4, oSpan3, oSpan1, oSpan2: ISpan;
begin
  oTracer := TTracer.Create; //PC_OK
  oTracer.EventSendSpan := TTracerObjectSender.SendSpan;

  oTrace := oTracer.GenerateNewTrace;
  oTrace.BasicData.ServiceName := 'pg5Servidor.exe';
  oTrace.BasicData.TypeName := 'server_app';
  oTrace.BasicData.ResourceName := 'delphi_rdm';

  oSpan1 := oTrace.GenerateNewSpan;
  oSpan1.Name := 'myMethodOne';
  sleep(100);

  oSpan2 := oTrace.GenerateNewSpan;
  oSpan2.Name := 'myMethodOneChildOne';
  oSpan2.putMoreData('sql','SELECT * FROM SAJ.ESAJFORO WHERE BLA LIKE "%adsad%"');
  oSpan2.basicData.ServiceName := 'bnmp_ws';
  oSpan2.basicData.TypeName := 'web';
  oSpan2.basicData.ResourceName := 'bigodes';
  sleep(50);

  oSpan3 := oTrace.GenerateNewSpan;
  oSpan3.Name := 'myMethodOneChildOneGrandsonOne';
  sleep(50);
  oTrace.EndSpan(oSpan3);

  sleep(50);
  oTrace.EndSpan(oSpan2);

  sleep(20);
  oSpan4 := oTrace.GenerateNewSpan;
  oSpan4.Name := 'myMethodOneChildTwo';
  sleep(60);
  oTrace.EndSpan(oSpan4);

  sleep(60);
  oSpan2 := oTrace.GenerateNewSpan;
  oSpan2.Name := 'get_pdf.myMethodOneChildThree';
  oSpan2.basicData.ServiceName := 'cas';
  oSpan2.basicData.TypeName := 'broker_app';
  oSpan2.basicData.ResourceName := 'get_pdf';
  oSpan2.PutMoreData('chavex', 'valorx');
  sleep(50);
  oTrace.EndSpan(oSpan2);

  sleep(150);

  oTrace.EndSpan(oSpan1);
{
  sleep(10);
  oSpan4 := oTrace.GenerateNewSpan;
  oSpan4.Name := 'myMethodTwo';
  sleep(40);

  oSpan2 := oTrace.GenerateNewSpan;
  oSpan2.Name := 'myMethodTwoChildOne';
  oSpan2.basicData.ServiceName := 'cas';
  oSpan2.basicData.TypeName := 'broker_app';
  oSpan2.basicData.ResourceName := 'get_pdf';
  sleep(50);
  oTrace.EndSpan(oSpan2);

  oSpan2 := oTrace.GenerateNewSpan;
  oSpan2.Name := 'myMethodThree';
  oSpan2.basicData.ServiceName := 'cas';
  oSpan2.basicData.TypeName := 'broker_app';
  oSpan2.basicData.ResourceName := 'get_pdf';
  sleep(50);
  oTrace.EndSpan(oSpan2);

  sleep(150);

  oTrace.EndSpan(oSpan4);
}

{
  sleep(100);

  oSpan2 := oTrace.GenerateNewSpan;
  oSpan2.Name := 'IsolatedMethod';
  oSpan2.basicData.ServiceName := 'cas';
  oSpan2.basicData.TypeName := 'usb';
  oSpan2.basicData.ResourceName := 'get_pdf';
  sleep(50);
  oTrace.EndSpan(oSpan2);
}

  sleep(50);
  oTracer.EndTrace(oTrace);

  oTrace := oTracer.GenerateNewTrace;
  oTrace.BasicData.ServiceName := 'xyz';
  oTrace.BasicData.TypeName := 'usb';
  oTrace.BasicData.ResourceName := 'abc';

  oSpan1 := oTrace.GenerateNewSpan;
  oSpan1.Name := 'SecondIsolatedMethod';
  oSpan1.basicData.ServiceName := 'protocoladora';
  oSpan1.basicData.TypeName := 'hardware';
  oSpan1.basicData.ResourceName := 'protocolar';
  sleep(50);
  oTrace.EndSpan(oSpan1);

  oTracer.EndTrace(oTrace);

  sleep(150);

  oTrace := oTracer.GenerateNewTrace;
  oTrace.BasicData.ServiceName := 'xyz';
  oTrace.BasicData.TypeName := 'usb';
  oTrace.BasicData.ResourceName := 'abc';

  oSpan1 := oTrace.GenerateNewSpan;
  oSpan1.putMoreData('sql','SELECT * FROM SAJ.ESAJFORO WHERE BLA LIKE "%adsad%"');
  oSpan1.Name := 'ThirdIsolatedMethod';
  oSpan1.basicData.ServiceName := 'protocoladora';
  oSpan1.basicData.TypeName := 'hardware';
  oSpan1.basicData.ResourceName := 'protocolar';
  sleep(50);
  oTrace.EndSpan(oSpan1);

  oTracer.EndTrace(oTrace);

end;

{
procedure TForm1.SendSpan(poSpan: ISerializable);
var
  oSender: TObjectSender;
  sLine: string;
  oLista: TStringList;
begin
  oLista := poSpan.Serialize;
  oSender := TObjectSender.Create;
  try
    oSender.URL := 'http://localhost:8126/v0.3/traces';
    while oLista.Count > 0 do
    begin
      sLine := oLista[0];
      oLista.Delete(0);
      oSender.SenderObject := sLine;
      memo1.Lines.add(sLine);
      Memo1.Lines.add(IntToStr(oSender.Send) + ', ' + oSender.Output);
    end;
  finally
    osender.Free;
    oLista.Free; //PC_OK
  end;
  memo1.Lines.add('--- batch end ---');
end;
}

end.

