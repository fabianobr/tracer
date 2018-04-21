unit uTracerBasicDataAPI;

interface

uses
  uTracerBasicAPI;

type
  IBasicData = interface
    ['{3D9BA523-71ED-44E7-BF87-A969710577CA}']
    procedure setServiceName(Value: TTracerName);
    function getServiceName: TTracerName;
    property ServiceName: TTracerName read getServiceName write setServiceName;

    procedure setTypeName(Value: TTracerName);
    function getTypeName: TTracerName;
    property TypeName: TTracerName read getTypeName write setTypeName;

    procedure setResourceName(Value: TTracerName);
    function getResourceName: TTracerName;
    property ResourceName: TTracerName read getResourceName write setResourceName;

    procedure Assign(poBasicData: IBasicData);

    function Serialize: TSerialResult;
  end;

implementation

end.

