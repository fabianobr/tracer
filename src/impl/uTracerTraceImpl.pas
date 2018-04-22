unit uTracerTraceImpl;

interface

uses
  Classes, SysUtils, uTracerBasicAPI, uTracerTraceAPI, uTracerSpanAPI, uTracerBasicDataAPI;

type
  TTrace = class(TInterfacedObject, ITrace)
  private
    FoID: TTracerID;
    FoActiveSpan: ISpan;
    FoEventSendSpan: TEventSendSpan;
    FoActiveSpanSerializable: ISerializable;
    FoBasicData: IBasicData;
    FnMinimumDurationThreshold: int64;
  protected
    procedure setBasicData(const Value: IBasicData);
    function getBasicData: IBasicData;
    procedure setId(const Value: TTracerId);
    function getId: TTracerId;
    procedure setActiveSpan(Value: ISpan);
    function getActiveSpan: ISpan;
    procedure setEventSendSpan(Value: TEventSendSpan);
    function getEventSendSpan: TEventSendSpan;
  public
    constructor Create;

    function GenerateNewSpan(poObservedObject: TObject = nil): ISpan;
    procedure EndSpan(Value: ISpan; poException: Exception);
    function EndActiveSpan(poException: Exception = nil): ISpan;

    procedure setMinimumDurationThreshold(pnNanoSeconds: int64);

    property id: TTracerID read getId write setId;
    property ActiveSpan: ISpan read getActiveSpan write setActiveSpan;
    property EventSendSpan: TEventSendSpan read getEventSendSpan write setEventSendSpan;
    property BasicData: IBasicData read getBasicData write setBasicData;
  end;

implementation

uses
  uTracerUtilImpl, uTracerSpanImpl, uTracerBasicDataImpl;

{ TTrace }

procedure TTrace.setMinimumDurationThreshold(pnNanoSeconds: int64);
begin
  FnMinimumDurationThreshold := pnNanoSeconds;
end;

constructor TTrace.Create;
begin
  id := TracerIdGenerator;
  ActiveSpan := nil;
  setMinimumDurationThreshold(100 * 1000 * 1000); //100 ms
end;

procedure TTrace.EndSpan(Value: ISpan; poException: Exception);
begin
  Value.FinalTime := TracerNow;
  Value.GeneratedException := poException;
  Value.isError := poException <> nil;

  ActiveSpan := Value.Parent;

  if (ActiveSpan = nil) and (FoActiveSpanSerializable <> nil) then
  begin
    FoEventSendSpan(FoActiveSpanSerializable);
    FoActiveSpanSerializable := nil;
  end;

  if ActiveSpan = nil then
  begin
    id := TracerIdGenerator;
  end;
end;

function TTrace.GenerateNewSpan(poObservedObject: TObject): ISpan;
var
  objSpan: TObject;
  oSpan: ISpan;
  oSerial: ISerializable;
begin
  objSpan := TSpan.Create; //PC_OK

  if not Supports(objSpan, ISpan, oSpan) then
    raise Exception.Create('Supports(oSpan, ISpan, result) then');

  if not Supports(objSpan, ISerializable, oSerial) then
    raise Exception.Create('Supports(oSpan, ISpan, result) then');

  oSpan.setMinimumDurationThreshold(FnMinimumDurationThreshold);
  oSpan.BasicData := TBasicData.Create; //PC_OK
  oSpan.BasicData.Assign(BasicData);

  oSpan.Parent := getActiveSpan;
  oSpan.TraceId := Self.id;

  if getActiveSpan <> nil then
    getActiveSpan.ChildList.Add(oSpan);

  if getActiveSpan = nil then
    FoActiveSpanSerializable := oSerial;

  ActiveSpan := oSpan;
  result := oSpan;

  oSpan.ObservedObject := poObservedObject;
end;

function TTrace.getActiveSpan: ISpan;
begin
  result := FoActiveSpan;
end;

function TTrace.getBasicData: IBasicData;
begin
  result := FoBasicData;
end;

function TTrace.getEventSendSpan: TEventSendSpan;
begin
  result := FoEventSendSpan;
end;

function TTrace.getId: TTracerId;
begin
  result := FoId;
end;

procedure TTrace.setActiveSpan(Value: ISpan);
begin
  FoActiveSpan := Value;
end;

procedure TTrace.setBasicData(const Value: IBasicData);
begin
  FoBasicData := Value;
end;

procedure TTrace.setEventSendSpan(Value: TEventSendSpan);
begin
  FoEventSendSpan := Value;
end;

procedure TTrace.setId(const Value: TTracerId);
begin
  FoId := Value;
end;

function TTrace.EndActiveSpan(poException: Exception): ISpan;
begin
  if ActiveSpan = nil then
    exit;
  result := ActiveSpan;
  Endspan(ActiveSpan, poException);
end;

end.

