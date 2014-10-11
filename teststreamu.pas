unit Teststreamu;

{$mode objfpc}{$H+}
{ $M+}
interface

uses
  uProcMemMon,uProcMemdlg,Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,jsonstream;

type

  { TForm1 }

  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

  { TMy }

  { TMyEntry }

  TMyEntry= class(TCleanObject)
  private
    Fa: integer;
    Fb: string;
    Fblob: array[0..1000000] of byte;
  published
    property a:integer read Fa write Fa;
    property b:string read Fb write Fb;
  end;
  TMyEntries=array of TMyEntry;
  TMy=class(TCleanObject)
  private
    Fa: integer;
    Fb: string;
    Fc: boolean;
    Fd: TMyEntries;
    Fe: TMyEntry;
    Ff: TDateTime;
    Fblob: array[0..1000000] of byte;
  published
    property a:integer read Fa;
    property b:string read Fb;
    property c:boolean read Fc;
    property d:TMyEntries read Fd write Fd;
    property e:TMyEntry read Fe write Fe;
    property f:TDateTime read Ff write Ff;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

var
  My:TMy;

  function coc(ObjName:string):TObject;

  begin
    if (ObjName='TMyEntries') or (ObjName='TMyEntry') then
      result:=TMyEntry.Create;
  end;

{ TMy }

procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
  s:string;
begin
  ProcMemClearData;
  My:=TMy.Create;
  JSONToObject('{"a":3,"b":"test","c":true,"d":[{"a":1,"b":"test1"},{"a":2,"b":"test2"}],"e":{"a":11,"b":"test11"},"f":"2011-10-10T09:04:00.000+02:00"}',My,@coc);
  s:=DateTimeToStr(My.f);
  i:=length(My.d);
  s:='';
  ObjectToJSON(My,s);
  ProcMemShowDialog;
  My.Destroy;
  ProcMemShowDialog;
end;

end.

