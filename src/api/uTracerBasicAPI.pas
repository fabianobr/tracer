unit uTracerBasicAPI;

interface

uses
  Classes;

type
  TTracerID = int64;
  TTracerName = string;
  //TTracerTime = int64; //Unix epoch format in nanosecs (remember; nanosecs < microsecs < milisecs...)
  TTracerTime = TDateTime;
  TSerialResult = TStringList;
  TTracerMoreData = TStringList;
  TPreSerialData = string;

  ISerializable = interface
    ['{763FA94B-F5DC-42A5-B89E-9668A4F01B43}']
    function Serialize: TSerialResult;
  end;

implementation

end.

