unit GoogleCalendaru;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  GoogleCalenderApi, synautil, IniFiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    FGoogle:TGoogle_calendarAPI;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  calendarList:TGoogle_calendar_calendarList;
  Entry,NewEntry:TGoogle_calendar_calendarListEntry;
  List:TGoogle_calendar_calendarList;
  rem:TGoogle_calendar_calendarListEntry_defaultReminders;
  ini:TIniFile;
  i:integer;
  user:string;
begin
  FGoogle:=TGoogle_calendarAPI.Create;
  ini:=TIniFile.Create('google.ini');
  user:=ini.ReadString('Credentials','user','');
  FGoogle.ClientID:=ini.ReadString('Credentials','ClientID','');
  FGoogle.ClientSecret:=ini.ReadString('Credentials','ClientSecret','');
  FGoogle.RedirectUri:=ini.ReadString('Credentials','RedirectUri','urn:ietf:wg:oauth:2.0:oob');
  FGoogle.Scope:=ini.ReadString('Credentials','Scope','https://www.googleapis.com/auth/calendar');
  FGoogle.RefreshToken:=ini.ReadString('Credentials','RefreshToken','');
  List:=FGoogle.CalendarListAPI.list();
  if FGoogle.RefreshToken<>'' then
    ini.WriteString('Credentials','RefreshToken',FGoogle.RefreshToken);
  ini.Destroy;

  Entry:=FGoogle.CalendarListAPI.get(user);
  NewEntry:=FGoogle.CalendarListAPI.update(user,Entry);
  calendarList:=FGoogle.CalendarListAPI.list();
  if assigned(calendarList) then
    begin
      for i:= low(calendarList.items) to high(calendarList.items) do
        Memo1.Lines.Add(calendarList.items[i].description);
    end;
  if assigned(List) then
    List.Destroy;
  if assigned(Entry) then
    Entry.Destroy;
  if assigned(NewEntry) then
    NewEntry.Destroy;
  if assigned(calendarList) then
    calendarList.Destroy;
  FGoogle.Destroy;
end;

end.
