unit GoogleSimpleApi;

{$mode objfpc}{$H+}

{$define GOOGLEAPIDEBUG}
interface

uses
  Classes, SysUtils,HttpSend,windows,synacode,synautil,ssl_openssl,fpjson,jsonparser,jsonstream;

type

  // procedure that opens a browser and returns authorisation code
  TUserConsent = function (url:string):string of object;
  { TGoogleSimpleApi }

  TGoogleSimpleApi= class(THTTPSend)
  private
    FAccessToken: string;
    FAuthorised: boolean;
    FClientID: string;
    FClientSecret: string;
    FDeveloperKey: string;
    FExpires: TDateTime;
    FOnUserConsent: TUserConsent;
    FRedirectUri: string;
    FRefreshToken: string;
    FScope: string;
    FTokenType: string;
    FDebugFile:text;
    function Authorise:boolean;
    function DefUserConsent(url:string):string;
    procedure SetRefreshToken(AValue: string);
  public
    constructor Create;
    destructor Destroy; override;
    function HTTPMethod(const Method, URL: string): Boolean; reintroduce;
    function DoMethod(const Method, URL, params: string; ObjIn, ObjOut: TObject;
      CreateObject: TCreateObjectCallback): boolean;
    property ClientID:string read FClientID write FClientID;
    property ClientSecret:string read FClientSecret write FClientSecret;
    property DeveloperKey:string read FDeveloperKey write FDeveloperKey;
    property RedirectUri:string read FRedirectUri write FRedirectUri;
    property RefreshToken:string read FRefreshToken write SetRefreshToken;
    property Scope:string read FScope write FScope;
    property OnUserConsent:TUserConsent read FOnUserConsent write FOnUserConsent;
  end;

implementation

Const
  AUTHURL='https://accounts.google.com/o/oauth2/auth';
  TOKENURL='https://accounts.google.com/o/oauth2/token';

{ TGoogleSimpleApi }

function TGoogleSimpleApi.Authorise: boolean;
var
  HTTP:THTTPSend;
  body,code,reply,url:string;
  parser: TJSONParser;
  D:TJSONObject;
begin
  if not FAuthorised or (now>FExpires) then
    begin
    if not FAuthorised then
      begin
      //Get authorisation code
      url:=AUTHURL + '?'+ 'scope='+EncodeURLElement(FScope)+
        '&redirect_uri='+EncodeURLElement(FRedirectUri)+
        '&response_type=code&client_id='+EncodeURLElement(FClientID);
      code:=FOnUserConsent(url);
      end;
    if (code<> '') or (FRefreshToken<>'') then
      begin
      HTTP:=THTTPSend.Create;
      try
        //Get authorisation token
        url:=TOKENURL;
        HTTP.ProxyPort:=ProxyPort;
        HTTP.ProxyHost:=ProxyHost;
        HTTP.MimeType:='application/x-www-form-urlencoded';
        if FAuthorised then  //refresh token
          body:='client_id='+EncodeURLElement(FClientID)+
            '&client_secret='+ EncodeURLElement(FClientSecret)+
            '&refresh_token='+EncodeURLElement(FRefreshToken)+
            '&grant_type=refresh_token'
        else
          body:='code='+EncodeURLElement(code)+
            '&client_id='+EncodeURLElement(FClientID)+
            '&client_secret='+ EncodeURLElement(FClientSecret)+
            '&redirect_uri='+EncodeURLElement(FRedirectUri)+
            '&scope='+EncodeURLElement(FScope)+
            '&grant_type=authorization_code';
        StringToStream(body,HTTP.Document);
        FAuthorised:=false;
        {$ifdef GOOGLEAPIDEBUG}
        writeln(FDebugFile,'Auth attempt POST '+URL);
        writeln(FDebugFile,'Header: '+HTTP.Headers.Text);
        writeln(FDebugFile,'Body: '+StreamToString(HTTP.Document));
        {$endif GOOGLEAPIDEBUG}
        if HTTP.HTTPMethod('POST',url) and (HTTP.ResultCode=200) then
          begin
          reply:=ReadStrFromStream(HTTP.Document,HTTP.Document.Size);
          parser:= TJSONParser.Create(reply);
          D:=TJSONObject(parser.Parse);
          try
            if D.IndexOfName('access_token')>=0  then
              FAccessToken:=D.Strings['access_token'];
            if D.IndexOfName('refresh_token')>=0  then  //not included after refresh, keep the old.
              FRefreshToken:=D.Strings['refresh_token'];
            if D.IndexOfName('token_type')>=0  then
              FTokenType:=D.Strings['token_type'];
            if D.IndexOfName('expires_in')>=0  then
              FExpires:=now+(D.Integers['expires_in']-10.0) / (3600*24); //skim off 10 secs to avoid race conditions
            FAuthorised:=true;
          finally
            D.free;
            parser.free;
          end;
          end;
        {$ifdef GOOGLEAPIDEBUG}
        writeln(FDebugFile,'Result Code '+IntTostr(HTTP.ResultCode));
        writeln(FDebugFile,'Return Header: '+HTTP.Headers.Text);
        writeln(FDebugFile,'Return Body: '+StreamToString(HTTP.Document));
        {$endif GOOGLEAPIDEBUG}
      finally
        HTTP.Free;
      end;
      end;
    end;
  result:=FAuthorised;
end;

function TGoogleSimpleApi.DefUserConsent(url: string): string;
begin
  ShellExecute(0, 'open',pchar(url), nil, nil, SW_SHOWNORMAL);
  Write('Enter code: ');
  ReadLn(result);
end;

procedure TGoogleSimpleApi.SetRefreshToken(AValue: string);
begin
  if FRefreshToken=AValue then Exit;
  FRefreshToken:=AValue;
  FAuthorised:=true;
  FExpires:=now-1; //force refresh
end;

constructor TGoogleSimpleApi.Create;
begin
  inherited Create;
  FExpires:=now;
  FAuthorised:=false;
  FOnUserConsent:=@DefUserConsent;
  {$ifdef GOOGLEAPIDEBUG}
  AssignFile(FDebugFile,'googlelog.txt');
  Rewrite(FDebugFile);
  {$endif GOOGLEAPIDEBUG}
end;

destructor TGoogleSimpleApi.Destroy;
begin
  {$ifdef GOOGLEAPIDEBUG}
  CloseFile(FDebugFile);
  {$endif GOOGLEAPIDEBUG}
  inherited Destroy;
end;

function TGoogleSimpleApi.HTTPMethod(const Method, URL: string): Boolean;
var
  body:string;
begin
  FResultCode:=401; //in case Authorise fails.
  MimeType:='application/json';
  result:=false;
  if Authorise then
    begin
    body:=StreamToString(Document);
    Headers.Text:='Authorization: '+ FTokenType+ ' '+ EncodeURLElement(FAccessToken);
    {$ifdef GOOGLEAPIDEBUG}
    writeln(FDebugFile,'First attempt to call '+Method+ ' '+URL);
    writeln(FDebugFile,'Header: '+Headers.Text);
    writeln(FDebugFile,'Body: '+body);
    {$endif GOOGLEAPIDEBUG}
    result:=inherited HTTPMethod(Method,URL);
    {$ifdef GOOGLEAPIDEBUG}
    writeln(FDebugFile,'Result Code '+IntTostr(FResultCode));
    writeln(FDebugFile,'Return Header: '+Headers.Text);
    writeln(FDebugFile,'Return Body: '+StreamToString(Document));
    {$endif GOOGLEAPIDEBUG}
    if FResultCode=401 then //retry
      begin
      FExpires:=now-1;
      if Authorise then
        begin
        Headers.Text:='Authorization: '+ FTokenType+ ' '+ EncodeURLElement(FAccessToken);
        Document.Clear;
        StringToStream(body,Document);
        {$ifdef GOOGLEAPIDEBUG}
        writeln(FDebugFile,'Second attempt to call '+Method+ ' '+URL);
        writeln(FDebugFile,'Header: '+Headers.Text);
        writeln(FDebugFile,'Body: '+StreamToString(Document));
        {$endif GOOGLEAPIDEBUG}
        result:=inherited HTTPMethod(Method,URL);
        {$ifdef GOOGLEAPIDEBUG}
        writeln(FDebugFile,'Result Code '+IntTostr(FResultCode));
        writeln(FDebugFile,'Return Header: '+Headers.Text);
        writeln(FDebugFile,'Return Body: '+StreamToString(Document));
        {$endif GOOGLEAPIDEBUG}
        end;
      end;
    end;
end;

function TGoogleSimpleApi.DoMethod(const Method, URL, params: string; ObjIn,
  ObjOut: TObject;CreateObject:TCreateObjectCallback): boolean;
var
  s:string;
begin
  result:=false;
  Document.Clear;
  if assigned(ObjIn) and not ObjectToJSON(ObjIn,s) then
    exit;
  StringToStream(s,Document);
  if HTTPMethod(Method,URL+params)
    and (ResultCode=200)then
    begin
    if assigned(ObjOut) then
      JSONToObject(StreamToString(Document),ObjOut,CreateObject);
    result:=true;
    end;
end;

end.

