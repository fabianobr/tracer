unit uTracerImpl;

interface

uses
  Classes, uTracerAPI, uTracerBasicAPI, uTracerTraceAPI, uTracerSpanAPI, uTracerTraceListAPI;

type
  TTracer = class(TInterfacedObject, ITracer)
  private
    FoEventSendSpan: TEventSendSpan;
    FoActiveTraces: ITraceList;
  protected
    function GenerateNewTrace: ITrace;

    procedure setEventSendSpan(Value: TEventSendSpan);
    function getEventSendSpan: TEventSendSpan;

    procedure EndTrace(poTrace: ITrace);
  public
    constructor Create;
    destructor Destroy; override;

    property EventSendSpan: TEventSendSpan read getEventSendSpan write setEventSendSpan;
  end;

implementation

uses
  SysUtils, uTracerTraceImpl, uTracerTraceListImpl, uTracerBasicDataImpl;

{ TTracer }

constructor TTracer.Create;
begin
  FoActiveTraces := TTraceList.Create; //PC_OK
end;

destructor TTracer.Destroy;
begin
  if FoActiveTraces.Count > 0 then
    raise Exception.Create('Exitem traces ativos... FoActiveTraces.count>0');
  inherited;
end;

procedure TTracer.EndTrace(poTrace: ITrace);
begin
  FoActiveTraces.Remove(poTrace);
end;

function TTracer.GenerateNewTrace: ITrace;
var
  oTrace: ITrace;
begin
  oTrace := TTrace.Create; //PC_OK
  oTrace.EventSendSpan := FoEventSendSpan;
  oTrace.BasicData := TBasicData.Create; //PC_OK

  FoActiveTraces.Add(oTrace);
  result := oTrace;
end;

function TTracer.getEventSendSpan: TEventSendSpan;
begin
  result := FoEventSendSpan;
end;

procedure TTracer.setEventSendSpan(Value: TEventSendSpan);
begin
  FoEventSendSpan := Value;
end;

end.

