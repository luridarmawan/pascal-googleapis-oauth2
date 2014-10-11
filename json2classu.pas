unit JSON2Classu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,fpjson,jsonparser;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    sl:TStringList;
    sCoc:string;
    sAPI:string;
    function ConvertGoogleTags(s:string):string;
    function GetGoogleClassName(Item: TJSONData):string;
    procedure Iterator(Const AName : TJSONStringType; Item: TJSONData; Data: TObject; var Continue: Boolean);
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

const APIMASK='  T%sAPI =class'+LineEnding+
'  protected'+LineEnding+
'    FParent:TGoogle_calendarAPI;'+LineEnding+
'  public'+LineEnding+
'    function clear(calendarId: string): boolean;'+LineEnding+
'    function delete(calendarId: string): boolean;'+LineEnding+
'    function get(calendarId: string): %d;'+LineEnding+
'    function insert(Entry:%d):%d;'+LineEnding+
'    function update(calendarId:string;Entry:%d):%d;'+LineEnding+
'  end;'+LineEnding;



{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.Lines.Clear;
  Memo2.Lines.Clear;
end;

function TForm1.ConvertGoogleTags(s: string): string;
begin
  result:=stringreplace(s,' etag,',' "etag",',[rfReplaceAll]);
  result:=stringreplace(result,' string',' "string"',[rfReplaceAll]);
  result:=stringreplace(result,' boolean',' true',[rfReplaceAll]);
  result:=stringreplace(result,' integer',' 1',[rfReplaceAll]);
  result:=stringreplace(result,' datetime',' "datetime"',[rfReplaceAll]);
  result:=stringreplace(result,' date',' "date"',[rfReplaceAll]);
  result:=stringreplace(result,'(key)','"yourkey"',[rfReplaceAll]);
end;

function TForm1.GetGoogleClassName(Item: TJSONData): string;
begin
  if TJSONObject(Item).IndexOfName('kind')>=0 then
    result:= 'TGoogle_'+StringReplace(TJSONObject(Item).Strings['kind'],'#','_',[rfReplaceAll])
  else
    result:='TAuto'+IntToStr(sl.Count);
end;

procedure TForm1.Iterator(const AName: TJSONStringType; Item: TJSONData;
  Data: TObject; var Continue: Boolean);
var
  idx,inext:integer;
  myclassname,myclassname2:string;
  D:TJSONData;
begin
  Continue:=true;
  idx:=PtrUint(Data);
  if Item.JSONType =jtArray then
    begin
      // simple types or objects?
      D:=TJSONArray(Item)[0];
      case D.JSONType of
        jtNumber :sl[idx]:=sl[idx]+'    property '+AName+': TIntArr read F'+AName+' write F'+AName+';' +LineEnding;
        jtString :
          begin
          if D.AsString='datetime' then
            sl[idx]:=sl[idx]+'    property '+AName+': TDateTimeArr read F'+AName+' write F'+AName+';' +LineEnding
          else if D.AsString='date' then
            sl[idx]:=sl[idx]+'    property '+AName+': TDateArr read F'+AName+' write F'+AName+';' +LineEnding
          else
            sl[idx]:=sl[idx]+'    property '+AName+': TStringArr read F'+AName+' write F'+AName+';' +LineEnding;
          end;
        jtBoolean:sl[idx]:=sl[idx]+'    property '+AName+': TBoolArr read F'+AName+' write F'+AName+';' +LineEnding;
      else
        begin
        myclassname:=GetGoogleClassName(D);
        myclassname2:=GetGoogleClassName(D)+'Arr';
        sCoc:=sCoc+'  else if (ObjName='''+myclassname+''') or (ObjName='''+myclassname2+''') then'+LineEnding
           +'    result:='+myclassname+'.Create'+LineEnding;
        sl.Add('  '+myclassname2+ '= array of '+ myclassname +';'+ LineEnding);
        sl.Add('  '+myclassname+ '= class (TCleanObject)'+ LineEnding);
        inext:=sl.Count-1;
        TJSONObject(D).Iterate(@Iterator,TObject(inext));
        sl[inext]:=sl[inext]+'  end;'+LineEnding;
        sl[idx]:=sl[idx]+'    property '+AName+': '+ myclassname2 +' read F'+AName+' write F'+AName+';' +LineEnding
        end;
      end;
    end
  else if Item.JSONType =jtNumber then
    sl[idx]:=sl[idx]+'    property '+AName+': integer read F'+AName+' write F'+AName+';' +LineEnding
  else if Item.JSONType =jtString then
    begin
    if Item.AsString='datetime' then
      sl[idx]:=sl[idx]+'    property '+AName+': TDateTime read F'+AName+' write F'+AName+';' +LineEnding
    else if Item.AsString='date' then
      sl[idx]:=sl[idx]+'    property '+AName+': TDate read F'+AName+' write F'+AName+';' +LineEnding
    else
      sl[idx]:=sl[idx]+'    property '+AName+': string read F'+AName+' write F'+AName+';' +LineEnding;
    end
  else if Item.JSONType =jtBoolean then
    sl[idx]:=sl[idx]+'    property '+AName+': boolean read F'+AName+' write F'+AName+';' +LineEnding
  else if Item.JSONType =jtObject then
    begin
    myclassname:='T'+AName;
    sCoc:=sCoc+'  else if (ObjName='''+myclassname+''') then'+LineEnding
       +'    result:='+myclassname+'.Create'+LineEnding;
    sl.Add('  '+myclassname+ '= class (TCleanObject) '+ LineEnding);
    inext:=sl.Count-1;
    TJSONObject(Item).Iterate(@Iterator,TObject(inext));
    sl[inext]:=sl[inext]+'  end;'+LineEnding;
    sl[idx]:=sl[idx]+'    property '+AName+': '+ myclassname +' read F'+AName+' write F'+AName+';' +LineEnding
    end
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  parser: TJSONParser;
  D:TJSONObject;
  i:integer;
begin
  sCoc:='function CreateObjectCallback(ObjName:string):TObject;'+LineEnding+LineEnding+
    'begin'+LineEnding;
  sl:=TStringList.Create;
  parser:= TJSONParser.Create(ConvertGoogleTags(Memo1.Lines.Text));
  D:=TJSONObject(parser.Parse);
  try
    sl.Add('  '+GetGoogleClassName(D) +' = class (TCleanObject)'+LineEnding);
    i:=sl.Count-1;
    D.Iterate(@Iterator,TObject(i));
    sl[i]:=sl[i]+'  end;'+LineEnding;
    Memo2.Lines.Add('  TDateTimeArr=array of TDateTime;');
    Memo2.Lines.Add('  TDateArr=array of TDate;');
    Memo2.Lines.Add('  TIntArr=array of Integer;');
    Memo2.Lines.Add('  TBoolArr=array of Boolean;');
    Memo2.Lines.Add('  TStringArr=array of String;');
    for i:=sl.Count-1 downto 0 do
      Memo2.Lines.Add(sl[i]);
    Memo2.Lines.Add(#10#10#10+ sCoc+'end;'+LineEnding);
  finally
    D.free;
    parser.free;
    sl.Free;
  end;
end;

end.

