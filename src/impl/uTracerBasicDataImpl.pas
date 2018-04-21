unit uTracerBasicDataImpl;

interface

uses
  uTracerBasicAPI, uTracerBasicDataAPI;

type
  TBasicData = class(TInterfacedObject, IBasicData, ISerializable)
  private
    FoServiceName: TTracerName;
    FoResourceName: TTracerName;
    FoTypeName: TTracerName;
  protected
    procedure setServiceName(Value: TTracerName);
    function getServiceName: TTracerName;
    procedure setTypeName(Value: TTracerName);
    function getTypeName: TTracerName;
    procedure setResourceName(Value: TTracerName);
    function getResourceName: TTracerName;
    function Serialize: TSerialResult;
    procedure Assign(poBasicData: IBasicData);
  public
    property ServiceName: TTracerName read getServiceName write setServiceName;
    property TypeName: TTracerName read getTypeName write setTypeName;
    property ResourceName: TTracerName read getResourceName write setResourceName;
  end;

implementation

uses
  Classes, SysUtils;

{ TBasicData }

function TBasicData.Serialize: TSerialResult;
//const
//  msg = '"service": "%s", "type": "%s", "resource": "%s"';
begin
  result := TStringList.Create; //PC_OK
  result.Values['service'] := ServiceName;
  result.Values['type'] := TypeName;
  result.Values['resource'] := ResourceName;
//  result.Append(format(msg, [ServiceName, TypeName, ResourceName]));
end;

function TBasicData.getResourceName: TTracerName;
begin
  result := FoResourceName;
end;

function TBasicData.getServiceName: TTracerName;
begin
  result := FoServiceName;
end;

function TBasicData.getTypeName: TTracerName;
begin
  result := FoTypeName;
end;

procedure TBasicData.setResourceName(Value: TTracerName);
begin
  FoResourceName := Value;
end;

procedure TBasicData.setServiceName(Value: TTracerName);
begin
  FoServiceName := Value;
end;

procedure TBasicData.setTypeName(Value: TTracerName);
begin
  FoTypeName := Value;
end;

procedure TBasicData.Assign(poBasicData: IBasicData);
begin
  ServiceName := poBasicData.ServiceName;
  TypeName := poBasicData.TypeName;
  ResourceName := poBasicData.ResourceName;
end;

end.

