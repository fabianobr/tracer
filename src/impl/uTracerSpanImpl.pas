unit uTracerSpanImpl;

interface

uses
  SysUtils, Classes, uTracerAPI, uTracerBasicAPI, uTracerTraceAPI, uTracerSpanAPI,
  uTracerBasicDataAPI;

type
  TSpan = class(TInterfacedObject, ISpan, ISerializable)
  private
    FoId: TTracerId;
    FoTraceId: TTracerId;
    FoParent: ISpan;
    FoName: TTracerName;
    FoStartTime: TTracerTime;
    FoFinalTime: TTracerTime;
    FoChildList: IInterfaceList;
    FoBasicData: IBasicData;
    FoObservedObject: TObject;
    FoException: Exception;
    FoMoreData: TTracerMoreData;
    FoIsError: boolean;
    FnMinimumDurationThreshold: int64;
  protected
    procedure setBasicData(const Value: IBasicData);
    function getBasicData: IBasicData;

    procedure setId(const Value: TTracerId);
    function getId: TTracerId;

    procedure setParent(const Value: ISpan);
    function getParent: ISpan;

    procedure setName(const Value: TTracerName);
    function getName: TTracerName;

    procedure setStartTime(const Value: TTracerTime);
    function getStartTime: TTracerTime;

    procedure setFinalTime(const Value: TTracerTime);
    function getFinalTime: TTracerTime;

    procedure setChildList(const Value: IInterfaceList);
    function getChildList: IInterfaceList;

    procedure setTraceId(const Value: TTracerId);
    function getTraceId: TTracerId;

    function Serialize: TSerialResult;

    procedure EnrichData;

    procedure GetExceptionData;

    procedure setObservedObject(const Value: TObject);
    function getObservedObject: TObject;

    procedure setException(const Value: Exception);
    function getException: Exception;

    procedure setError(const Value: boolean);
    function getError: boolean;

  public
    constructor Create;
    destructor Destroy; override;

    procedure PutMoreData(const psKey, psValue: string);
    procedure setMinimumDurationThreshold(pnNanoSeconds: int64);
    function isDurationRelevant: boolean;

    property id: TTracerID read getId write setId;
    property Parent: ISpan read getParent write setParent;
    property Name: TTracerName read getName write setName;
    property StartTime: TTracerTime read getStartTime write setStartTime;
    property FinalTime: TTracerTime read getFinalTime write setFinalTime;
    property ChildList: IInterfaceList read getChildList write setChildList;
    property BasicData: IBasicData read getBasicData write setBasicData;
    property TraceId: TTracerID read getTraceId write setTraceId;
    property ObservedObject: TObject read getObservedObject write setObservedObject;
    property GeneratedException: Exception read getException write setException;
    property isError: boolean read getError write setError;
  end;

implementation

uses
  uTracerTraceListImpl,
  uTracerUtilImpl,
  Math,
  System.JSON;

{ TSpan }

procedure TSpan.setMinimumDurationThreshold(pnNanoSeconds: int64);
begin
  FnMinimumDurationThreshold := pnNanoSeconds;
end;

constructor TSpan.Create;
begin
  id := TracerIdGenerator;
  StartTime := TracerNow;
  FoChildList := TInterfaceList.Create; //PC_OK
  FoMoreData := TStringList.Create; //PC_OK
end;

destructor TSpan.Destroy;
begin
  FreeAndNil(FoMoreData); //PC_OK
  inherited;
end;

procedure TSpan.EnrichData;
begin
  if (not Assigned(FoObservedObject)) or (FoObservedObject = nil) then
    exit;

end;

function TSpan.getBasicData: IBasicData;
begin
  result := FoBasicData;
end;

function TSpan.getChildList: IInterfaceList;
begin
  result := FoChildList;
end;

function TSpan.getError: boolean;
begin
  result := FoIsError;
end;

function TSpan.getException: Exception;
begin
  result := FoException;
end;

procedure TSpan.GetExceptionData;
begin
  if not isError then
    exit;
  FoMoreData.values['error_message'] := GeneratedException.Message;
end;

function TSpan.getFinalTime: TTracerTime;
begin
  result := FoFinalTime;
end;

function TSpan.getId: TTracerId;
begin
  result := FoId;
end;

function TSpan.getName: TTracerName;
begin
  result := FoName;
end;

function TSpan.getObservedObject: TObject;
begin
  result := FoObservedObject;
end;

function TSpan.getParent: ISpan;
begin
  result := FoParent;
end;

function TSpan.getStartTime: TTracerTime;
begin
  result := FoStartTime;
end;

function TSpan.getTraceId: TTracerId;
begin
  result := FoTraceId;
end;

function TSpan.isDurationRelevant: boolean;
var
  nDuration: int64;
begin
  nDuration := DateTimeToUnixNanoTime(FinalTime, starttime);

  result := nDuration >= FnMinimumDurationThreshold;
end;

function TSpan.Serialize: TSerialResult;
var
  i: integer;
  oSpan: ISpan;
  sLine: string;
  sParent: string;
  oChildSerial: TSerialResult;
  nStartTime: int64;
  nDuration: int64;
  oJson: TJsonObject;
  oJsonMeta: TJsonObject;
  oBasicData: TSerialResult;
begin
  result := TStringList.Create; //PC_OK
  oSpan := Self;

  if isDurationRelevant then
  begin
    nDuration := DateTimeToUnixNanoTime(oSpan.FinalTime, oSpan.starttime);
    nStartTime := DateTimeToUnixNanoTime(oSpan.starttime);

    sParent := 'null';
    if oSpan.Parent <> nil then
      sParent := IntToStr(oSpan.Parent.id);

    EnrichData;
    GetExceptionData;

    oBasicData := FoBasicData.Serialize;
    oJson := TJsonObject.Create; //PC_OK
    oJsonMeta := TJSONObject.Create;
    try
      for i := 0 to oBasicData.count-1 do
      begin
        oJson.AddPair(oBasicData.Names[i], oBasicData.ValueFromIndex[i]);
      end;

      oJson.AddPair('trace_id', TJSONNumber.Create(oSpan.TraceId) );
      oJson.AddPair('span_id', TJSONNumber.Create(oSpan.id) );
      if ospan.Parent = nil then
        oJson.AddPair('parent_id', TJSONNull.Create)
      else
        oJson.AddPair('parent_id', TJSONNumber.Create(oSpan.Parent.id) );
      oJson.AddPair('name', ospan.Name);
      oJson.AddPair('start', TJSONNumber.Create(nStartTime) );
      oJson.AddPair('duration', TJSONNumber.Create(nDuration) );
      if FoMoreData.Count>0 then
      begin
        for i := 0 to FoMoreData.count-1 do
        begin
          oJsonMeta.AddPair(FoMoreData.Names[i], FoMoreData.ValueFromIndex[i]);
        end;
        oJson.AddPair( TJsonPair.Create('meta', oJsonMeta) );
      end;

      sLine := oJson.toString;
    finally
      //FreeAndNil(oJsonMeta);
      //FreeAndNil(oJson);
    end;
    result.add(sLine);
  end;

  for i := 0 to ChildList.Count - 1 do
  begin
    oSpan := ChildList[i] as ISpan;
    oChildSerial := oSpan.Serialize;
    result.AddStrings(oChildSerial);
  end;
end;

procedure TSpan.PutMoreData(const psKey, psValue: string);
begin
  FoMoreData.Values[psKey] := psValue;
end;

procedure TSpan.setBasicData(const Value: IBasicData);
begin
  FoBasicData := Value;
end;

procedure TSpan.setChildList(const Value: IInterfaceList);
begin
  FoChildList := Value;
end;

procedure TSpan.setError(const Value: boolean);
begin
  FoIsError := Value;
end;

procedure TSpan.setException(const Value: Exception);
begin
  FoException := Value;
end;

procedure TSpan.setFinalTime(const Value: TTracerTime);
begin
  FoFinalTime := Value;
end;

procedure TSpan.setId(const Value: TTracerId);
begin
  FoId := Value;
end;

procedure TSpan.setName(const Value: TTracerName);
begin
  FoName := Value;
end;

procedure TSpan.setObservedObject(const Value: TObject);
begin
  FoObservedObject := Value;
end;

procedure TSpan.setParent(const Value: ISpan);
begin
  FoParent := Value;
  if (Parent <> nil) and (BasicData <> nil) then
  begin
    BasicData.Assign(Parent.BasicData);
  end;
end;

procedure TSpan.setStartTime(const Value: TTracerTime);
begin
  FoStartTime := Value;
end;

procedure TSpan.setTraceId(const Value: TTracerId);
begin
  FoTraceId := Value;
end;

end.

