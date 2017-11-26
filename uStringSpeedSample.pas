unit uStringSpeedSample;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

procedure CreateAndCheckStrings;

implementation

uses
  {$IFNDEF FPC}
    Winapi.Windows,
  {$ENDIF}
  sysutils;

const
  CHARS_IN_ALPHABET = 26;
  FIRST_CHARACTER_ID = 65;
  WORD_LENGTH = 5;

type
  TCharNumbers = array[0..WORD_LENGTH - 1] of Integer;
  TPalindromeChecker = function(const CharNumbers: TCharNumbers): Boolean;

function IncCharNumber(var CharNumbers: TCharNumbers; const NumberIndex: Integer): Boolean;
begin
  if CharNumbers[NumberIndex] + 1 = CHARS_IN_ALPHABET then
  begin
    if NumberIndex = Low(CharNumbers) then
      Exit(False);

    CharNumbers[NumberIndex] := 0;
    Exit(IncCharNumber(CharNumbers, NumberIndex - 1));
  end
  else
  begin
    Inc(CharNumbers[NumberIndex]);
    Exit(True);
  end;
end;

procedure InitCharNumbers(out CharNumbers: TCharNumbers);
var
  I: Integer;
begin
  for I := Low(CharNumbers) to High(CharNumbers) do
    CharNumbers[I] := 0;
end;

function MakeString(const CharNumbers: TCharNumbers): String;
var
  Number: Integer;
begin
  Result := '';
  for Number in CharNumbers do
    Result := Result + Char(FIRST_CHARACTER_ID + Number);
end;

function RevertCharNumbers(const CharNumbers: TCharNumbers): TCharNumbers;
var
  I: Integer;
begin
  for I := Low(CharNumbers) to High(CharNumbers) do
    Result[I] := CharNumbers[High(CharNumbers) - I];
end;

function IsPalindrome_StringBased(const CharNumbers: TCharNumbers): Boolean;
var
  OriginString, RevertedString: String;
  RevertedCharNumbers: TCharNumbers;
begin
  OriginString := MakeString(CharNumbers);
  RevertedCharNumbers := RevertCharNumbers(CharNumbers);
  RevertedString := MakeString(RevertedCharNumbers);
  Result := OriginString = RevertedString;
end;

function IsPalindrome_IntegerBased(const CharNumbers: TCharNumbers): Boolean;
var
  RevertedCharNumbers: TCharNumbers;
  I: Integer;
begin
  RevertedCharNumbers := RevertCharNumbers(CharNumbers);
  for I := Low(CharNumbers) to High(CharNumbers) do
    if CharNumbers[I] <> RevertedCharNumbers[I] then
      Exit(False);

  Exit(True);
end;

procedure CreateAndCheckStrings;
var
  Chars: TCharNumbers;
  Ticks: LongWord;
  PalindromeCount: Integer;
  PalindromeChecker: TPalindromeChecker;
begin
  InitCharNumbers(Chars);

  if ParamStr(1) = 'integer' then
    PalindromeChecker := IsPalindrome_IntegerBased
  else
    PalindromeChecker := IsPalindrome_StringBased;

  PalindromeCount := 0;
  Ticks := GetTickCount;

  repeat
    if PalindromeChecker(Chars) then
      Inc(PalindromeCount);
  until not IncCharNumber(Chars, High(Chars));

  WriteLn(PalindromeCount, ' palindromes found');
  WriteLn(GetTickCount - Ticks, ' ticks');
end;

end.