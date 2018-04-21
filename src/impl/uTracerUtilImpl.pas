unit uTracerUtilImpl;

interface

uses
  uTracerBasicAPI;

function TracerIdGenerator: TTracerID;
function IncTime(ATime: TDateTime; Hours, Minutes, Seconds, MSecs: integer): TDateTime;
function IncHour(ATime: TDateTime; Delta: integer): TDateTime;
function TracerNow: TDateTime;
function DateTimeToUnixNanoTime(DTime: TDateTime; baseDate: TDateTime = 0): int64;

implementation

uses
  SysUtils, activex, comobj;

function IncTime(ATime: TDateTime; Hours, Minutes, Seconds, MSecs: integer): TDateTime;
begin
  result := ATime + (Hours div 24) + (((Hours mod 24) * 3600000 + Minutes * 60000 +
    Seconds * 1000 + MSecs) / MSecsPerDay);
  if result < 0 then
  begin
    result := result + 1;
  end;
end;

function IncHour(ATime: TDateTime; Delta: integer): TDateTime;
begin
  result := IncTime(ATime, Delta, 0, 0, 0);
end;

function TracerNow: TDateTime;
begin
  result := inchour(now, +3);
end;

function DateTimeToUnixNanoTime(DTime: TDateTime; baseDate: TDateTime = 0): int64;
const
  SecondsInDay = 60 * 60 * 24;
var
  newTime: TDateTime;
begin
  if baseDate = 0 then
    baseDate := EncodeDate(1970, 1, 1);
  newTime := DTime - baseDate;
  newTime := NewTime * SecondsInDay;
  result := Trunc(NewTime * 1000) * 1000 * 1000; //mili * micro * nano
end;

function TracerIdGenerator: TTracerID;
var
  Uid: TGuid;
begin
  CoCreateGuid(Uid);
  result := UID.D1 * UID.D2 * UID.D3;
end;

end.

