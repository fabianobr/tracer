unit uTracerTraceListImpl;

interface

uses
  Classes, uTracerAPI, uTracerBasicAPI, uTracerTraceAPI, uTracerSpanAPI, uTracerTraceListAPI;

type
  TTraceList = class(TInterfacedObject, ITraceList)
  private
    FoTrace: ITrace;
    function getCount: integer;
  public
    procedure Add(Value: ITrace);
    procedure Remove(Value: ITrace);

    property Count: integer read getCount;
  end;

implementation

{ TTraceList }

procedure TTraceList.Add(Value: ITrace);
begin
  FoTrace := Value;
end;

function TTraceList.getCount: integer;
begin
  if FoTrace = nil then
    result := 0
  else
    result := 1;
end;

procedure TTraceList.Remove(Value: ITrace);
begin
  FoTrace := nil;
end;

end.