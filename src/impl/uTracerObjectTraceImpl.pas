unit uTracerObjectTraceImpl;

interface

uses
  uTracerAPI, uTracerTraceAPI;

function ThreadTracer: ITracer;
function ThreadTrace: ITrace;
procedure CleanThreadTrace;

implementation

uses
  uTracerImpl, uTracerTraceImpl, uTracerObjectSenderImpl, SysUtils;

threadvar
  goTracer: ITracer;
  goTrace: ITrace;

procedure CleanThreadTrace;
begin
  goTrace := nil;
end;

function ThreadTracer: ITracer;
begin
  if goTracer = nil then
  begin
    goTracer := TTracer.Create; //PC_OK
    goTracer.EventSendSpan := TTracerObjectSender.SendSpan;
  end;
  result := goTracer;
end;

function ThreadTrace: ITrace;
begin
  if goTrace = nil then
  begin
    goTrace := ThreadTracer.GenerateNewTrace;
    goTrace.BasicData.TypeName := 'desktop_app';
    goTrace.BasicData.ServiceName := ExtractFileName(ParamStr(0));
    goTrace.BasicData.ResourceName := 'delphi_app';
  end;
  result := goTrace;
end;

end.

