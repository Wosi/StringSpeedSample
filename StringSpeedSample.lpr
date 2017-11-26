program StringSpeedSample;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  SysUtils,
  uStringSpeedSample;

begin
  CreateAndCheckStrings;
end. 
