unit uTracerTraceAPI;

interface

uses
  uTracerBasicAPI, uTracerSpanAPI, uTracerBasicDataAPI, SysUtils;

type
  ITrace = interface
    procedure setBasicData(const Value: IBasicData);
    function getBasicData: IBasicData;
    property BasicData: IBasicData read getBasicData write setBasicData;

    procedure setId(const Value: TTracerId);
    function getId: TTracerId;
    property id: TTracerID read getId write setId;

    function GenerateNewSpan(poObservedObject: TObject = nil): ISpan;
    procedure EndSpan(Value: ISpan; poException: Exception = nil);
    procedure EndActiveSpan(poException: Exception = nil);

    procedure setActiveSpan(Value: ISpan);
    function getActiveSpan: ISpan;
    property ActiveSpan: ISpan read getActiveSpan write setActiveSpan;

    procedure setEventSendSpan(Value: TEventSendSpan);
    function getEventSendSpan: TEventSendSpan;
    property EventSendSpan: TEventSendSpan read getEventSendSpan write setEventSendSpan;

    procedure setMinimumDurationThreshold(pnNanoSeconds: int64);
  end;

implementation

end.

