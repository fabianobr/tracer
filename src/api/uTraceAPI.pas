unit uTraceAPI;

interface

uses
  uTracerBasicAPI, uTracerSpanAPI;

type
  ITrace = interface
    procedure setId(const Value: TTracerId);
    function getId: TTracerId;
    property id: TTracerID read getId write setId;

    function GenerateNewSpan: ISpan;
    procedure EndSpan(Value: ISpan);

    procedure setActiveSpan(Value: ISpan);
    function getActiveSpan: ISpan;
    property ActiveSpan: ISpan read getActiveSpan write setActiveSpan;

    procedure setEventSendSpan(Value: TEventSendSpan);
    function getEventSendSpan: TEventSendSpan;
    property EventSendSpan: TEventSendSpan read getEventSendSpan write setEventSendSpan;

    procedure setPreSerialData(const Value: TPreSerialData);
    function getPreSerialData: TPreSerialData;
    property PreSerialData: TPreSerialData read getPreSerialData write setPreSerialData;
  end;

implementation

end.

