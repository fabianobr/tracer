unit uTracerAPI;

interface

uses
  uTracerSpanAPI, uTracerTraceAPI;

type
  ITracer = interface
    function GenerateNewTrace: ITrace;
    procedure EndTrace(poTrace: ITrace);

    procedure setEventSendSpan(Value: TEventSendSpan);
    function getEventSendSpan: TEventSendSpan;
    property EventSendSpan: TEventSendSpan read getEventSendSpan write setEventSendSpan;
  end;

implementation

end.