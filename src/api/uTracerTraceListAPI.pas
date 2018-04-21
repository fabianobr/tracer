unit uTracerTraceListAPI;

interface

uses
  uTracerTraceAPI;

type
  ITraceList = interface
    procedure Add(Value: ITrace);
    procedure Remove(Value: ITrace);

    function getCount: integer;
    property Count: integer read getCount;
  end;

implementation

end.