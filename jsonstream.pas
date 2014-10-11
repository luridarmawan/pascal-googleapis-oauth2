unit jsonstream;

{$mode objfpc}{$H+} {$M+}

interface

uses
  Classes, SysUtils,typinfo,fpjson,jsonparser,lresources;

type
  TCreateObjectCallback=function (ObjName:string):TObject;
type

  { TCleanObject }

  TCleanObject=class
    destructor Destroy; override;
  end;

function JSONToObject(JSON: string;AObject:TObject;CreateObject:TCreateObjectCallback):boolean;
function ObjectToJSON(AObject: TObject; var JSON: string): boolean;
function StreamToString(stream:TStream):string;
procedure StringToStream(str:string;stream:TStream);
function AddToUrlParam(s,param,val:string):string;

implementation
type
   pdynarray = ^tdynarray;
   tdynarray = packed record
      refcount : ptrint;
      high : tdynarrayindex;
   end;

function DateTimeToRFC3339(dt:TDateTime):string;
var
  Year, Month, Day: word;
  Hour, Minute, Second, MilliSecond: word;
  i:integer;
begin
  DecodeDate(dt, Year, Month, Day);
  DecodeTime(dt, Hour, Minute, Second, MilliSecond);
  Result:=format('%4d-%2d-%2dT%2d:%2d:%2d.%3dZ',
    [Year, Month, Day, Hour, Minute, Second, MilliSecond]);
  for i:=1 to length(result) do
    if result[i]=' ' then
      result[i]:='0';
end;

function RFC3339ToDateTime(s:string):TDateTime;
var
  i:integer;
  sval:string;
  ms:integer;
  bias:tdatetime;
begin
  result:=0;
  if uppercase(s[11])='T' then
    begin
    i:=20;
    ms:=0;
    if s[20]='.'then //millisecs
      begin
      i:=21;
      sval:='000';
      while s[i] in ['0'..'9'] do
        begin
        if (i-20)<4 then // don't overrun sms
          sval[i-20]:=s[i];
        i:=i+1;
        end;
      ms:=StrToInt(sval);
      end;
    result:=EncodeDate(StrToInt(copy(s,1,4)),StrToInt(copy(s,6,2)),StrToInt(copy(s,9,2)))+
      EncodeTime(StrToInt(copy(s,12,2)),StrToInt(copy(s,15,2)),StrToInt(copy(s,18,2)),ms);
    if s[i] in ['+','-'] then
      begin
      sval:=copy(s,i+1,length(s));
      bias:=EncodeTime(StrToInt(copy(sval,1,2)),StrToInt(copy(sval,4,2)),0,0);
      if s[i]='-' then
        result:=result+bias
      else
        result:=result-bias;
      end;
    end;
end;

function JSONToObject(D:TJSONObject;AObject: TObject;CreateObject:TCreateObjectCallback): boolean;
var
  PropList: PPropList;
  i,j,cnt:integer;
  propname,arrelement,val,typename:string;
  Kind : TTypeKind;
  DArr:TJSONArray;
  len:cardinal;
  p,parr:pointer;
  newClass:TObject;
  ext:extended;
begin
  cnt:=GetPropList(AObject,PropList);
  for i:=0 to cnt-1 do
    begin
    propname:=PropList^[i]^.Name;
    kind:=PropList^[i]^.PropType^.Kind;
     typename:=PropList^[i]^.PropType^.Name;
    if D.IndexOfName(propname)>=0 then
      case kind of
        tkInteger:PLongint(Pointer(AObject)+PtrUInt(PropList^[i]^.GetProc))^:=Longint(D.Integers[propname]);
        tkAString:PAnsiString(Pointer(AObject) + LongWord(PropList^[i]^.GetProc))^:=D.Strings[propname];
        tkBool:PByte(Pointer(AObject)+PtrUInt(PropList^[i]^.GetProc))^:=Byte(Ord(D.Booleans[propname]));
        tkFloat:begin  // this can be a lot including tdatetime
          val:=D.Strings[propname];
          ext:=0.0;
          if (typename='TDateTime')  then
            ext:=RFC3339ToDateTime(val)
          else
            TryStrToFloat(StringReplace(val,'.',DecimalSeparator,[]),ext);
          case GetTypeData(PropList^[i]^.PropType)^.FloatType of
            ftSingle:
              PSingle(Pointer(AObject)+PtrUInt(PropList^[i]^.GetProc))^:=ext;
            ftDouble:
              PDouble(Pointer(AObject)+PtrUInt(PropList^[i]^.GetProc))^:=ext;
            ftExtended:
              PExtended(Pointer(AObject)+PtrUInt(PropList^[i]^.GetProc))^:=ext;
            ftCurr:
              PCurrency(Pointer(AObject)+PtrUInt(PropList^[i]^.GetProc))^:=ext;
            end;
          end;
        tkDynArray:begin
          //set array length and store pointer to new array
          DArr:=D.Arrays[propname];
          len:=Darr.Count;
          parr:=nil; // only new objects. Caller destroys objects created here!!!
          DynArraySetLength(parr,PropList^[i]^.PropType,1, @len);
          ppointer(Pointer(AObject)+PtrUInt(PropList^[i]^.GetProc))^:=parr;
          //get array element type
          len:=pdynarraytypeinfo(PropList^[i]^.PropType)^.namelen;
          setlength(arrelement,pdynarraytypeinfo(PropList^[i]^.PropType)^.namelen);
          p:=@pdynarraytypeinfo(PropList^[i]^.PropType)^.namelen+1;
          move(p^,arrelement[1],length(arrelement));
          //assume object type for now
          for j:=0 to Darr.Count-1 do
            begin
            //create new element and fill in
            ppointer(parr)^:=CreateObject(arrelement);
            JSONToObject(TJSONObject(Darr[j]),TObject(ppointer(parr)^),CreateObject);
            parr:=parr+sizeof(pointer);
            end;
          end;
        tkClass:Begin
          //create new element and fill in
          newClass:=CreateObject(PropList^[i]^.PropType^.Name);
          ppointer(Pointer(AObject)+PtrUInt(PropList^[i]^.GetProc))^:=pointer(newClass);
          JSONToObject(TJSONObject(D.Objects[propname]),newClass,CreateObject);
          end;
        end;
    end;
  Freemem(PropList);
end;

function JSONToObject(JSON: string; AObject: TObject;CreateObject:TCreateObjectCallback): boolean;
var
  parser: TJSONParser;
  D:TJSONObject;
begin
  parser:= TJSONParser.Create(JSON);
  D:=TJSONObject(parser.Parse);
  try
    result:=JSONToObject(D,AObject,CreateObject);
  finally
    D.free;
    parser.free;
  end;
end;

function ObjectToJSON(AObject: TObject; var JSON: string): boolean;
var
  PropList: PPropList;
  i,j,cnt,arrcnt:integer;
  propname,typename:string;
  Kind : TTypeKind;
  bIsFirst,bArrIsFirst:boolean;
  p,parr:pointer;
begin
  JSON:=JSON+'{';
  cnt:=GetPropList(AObject,PropList);
  bIsFirst:=true;
  result:=true;
  for i:=0 to cnt-1 do
    begin
    if PropList^[i]^.SetProc=nil then // no read only properties.
      continue;
    kind:=PropList^[i]^.PropType^.Kind;
    if (kind=tkAString) and (GetStrProp(AObject,  PropList^[i])='') then // no empty strings
      continue;
    propname:=PropList^[i]^.Name;
    typename:=PropList^[i]^.PropType^.Name;
    if  bIsFirst then
      JSON:=JSON+'"'+propname+'":'
    else
      JSON:=JSON+',"'+propname+'":';
    bIsFirst:=false;
    case kind of
      tkInteger:JSON:=JSON+ IntToStr(GetOrdProp(AObject,  PropList^[i]));
      tkAString:JSON:=JSON+ '"'+ StringToJSONString(GetStrProp(AObject,  PropList^[i]))+'"';
      tkBool:if GetOrdProp(AObject,  PropList^[i])=0 then
          JSON:=JSON+'false'
        else
          JSON:=JSON+'true';
      tkFloat:begin  // this can be a lot including tdatetime
        if typename='TDateTime' then
          JSON:=JSON+'"'+DateTimeToRFC3339(GetFloatProp(AObject,  PropList^[i]))+'"'
        else
          JSON:=JSON+StringReplace(FLoatToStr(GetFloatProp(AObject,  PropList^[i])),DecimalSeparator,'.',[]);
        end;
      tkDynArray:begin
        JSON:=JSON+'[';
        bArrIsFirst:=true;
        parr:=pointer(GetOrdProp(AObject, PropList^[i]));
        //get array length
        if assigned(parr) then
          arrcnt:=pdynarray(parr-sizeof(tdynarray))^.high+1
        else
          arrcnt:=0;
        //array of objects only
        for j:=1 to arrcnt do
          begin
          if not bArrIsFirst then
            JSON:=JSON+',';
          bArrIsFirst:=false;
          result:=result and ObjectToJSON(TObject(parr^),JSON);
          parr:=parr+sizeof(pointer);
          end;
        JSON:=JSON+']';
        end;
      tkClass:Begin
        p:=pointer(GetOrdProp(AObject, PropList^[i]));
        if assigned(p) then
          result:=result and ObjectToJSON(TObject(p),JSON)
        else
          JSON:=JSON+'null';
        end;
      end;
    end;
  JSON:=JSON+'}';
  Freemem(PropList);
end;

function StreamToString(stream: TStream): string;
begin
  setlength(result,stream.Size);
  stream.Position:=0;
  stream.Read(result[1],stream.Size);
end;

procedure StringToStream(str: string; stream: TStream);
begin
  stream.Position:=0;
  stream.Write(str[1],length(str));
end;

{ TCleanObject }

destructor TCleanObject.Destroy;
// use rtti to completely destroy objects and "children"
var
  PropList: PPropList;
  i,j,cnt:integer;
  Kind : TTypeKind;
  p,parr:pointer;
  len:integer;
begin
  j:=GetPropList(Self,PropList);
  for i:=0 to j-1 do
    begin
    kind:=PropList^[i]^.PropType^.Kind;
    case kind of
      tkDynArray:begin
        parr:=pointer(GetOrdProp(Self, PropList^[i]));
        //get array length
        if assigned(parr) then
          cnt:=pdynarray(parr-sizeof(tdynarray))^.high+1
        else
          cnt:=0;
        //array of objects only
        for j:=1 to cnt do
          begin
          TCleanObject(parr^).Destroy;
          parr:=parr+sizeof(pointer);
          end;
        len:=0;
        parr:=pointer(GetOrdProp(Self, PropList^[i]));
        DynArraySetLength(parr,PropList^[i]^.PropType,1, @len);
        end;
      tkClass:Begin
        p:=pointer(GetOrdProp(Self, PropList^[i]));
        if assigned(p) then
          TCleanObject(p).Destroy;
        end;
      end;
    end;
  Freemem(PropList);
  inherited Destroy;
end;


function AddToUrlParam(s,param,val:string):string;
begin
  if val='' then exit;
  if s<>'' then s:=s+'&';
  result:=s+param+'='+val;
  if result[1]<>'?' then
    result:='?'+result;
end;

end.

