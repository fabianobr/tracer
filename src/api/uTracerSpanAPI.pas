unit uTracerSpanAPI;

interface

uses
  SysUtils, Classes, uTracerBasicAPI, uTracerBasicDataAPI;

type
  TEventSendSpan = procedure(poSpan: ISerializable) of object;

  ISpan = interface
    ['{436365B4-780B-43D8-B365-F6CB2E768524}']

    procedure setBasicData(const Value: IBasicData);
    function getBasicData: IBasicData;
    property BasicData: IBasicData read getBasicData write setBasicData;

    procedure setTraceId(const Value: TTracerId);
    function getTraceId: TTracerId;
    property TraceId: TTracerID read getTraceId write setTraceId;

    procedure setId(const Value: TTracerId);
    function getId: TTracerId;
    property id: TTracerID read getId write setId;

    procedure setParent(const Value: ISpan);
    function getParent: ISpan;
    property Parent: ISpan read getParent write setParent;

    procedure setName(const Value: TTracerName);
    function getName: TTracerName;
    property Name: TTracerName read getName write setName;

    procedure setStartTime(const Value: TTracerTime);
    function getStartTime: TTracerTime;
    property StartTime: TTracerTime read getStartTime write setStartTime;

    procedure setFinalTime(const Value: TTracerTime);
    function getFinalTime: TTracerTime;
    property FinalTime: TTracerTime read getFinalTime write setFinalTime;

    procedure setChildList(const Value: IInterfaceList);
    function getChildList: IInterfaceList;
    property ChildList: IInterfaceList read getChildList write setChildList;

    function Serialize: TSerialResult;

    procedure EnrichData;

    procedure GetExceptionData;

    procedure setObservedObject(const Value: TObject);
    function getObservedObject: TObject;
    property ObservedObject: TObject read getObservedObject write setObservedObject;

    procedure setException(const Value: Exception);
    function getException: Exception;
    property GeneratedException: Exception read getException write setException;

    procedure setError(const Value: boolean);
    function getError: boolean;
    property isError: boolean read getError write setError;

    procedure PutMoreData(const psKey, psValue: string);

    procedure setMinimumDurationThreshold(pnNanoSeconds: int64);    
  end;

implementation

end.

