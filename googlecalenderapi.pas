unit GoogleCalenderApi;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils,GoogleSimpleApi,fpjson,jsonparser,jsonstream,synautil;

type
  TStringArr=array of String;

  { TGoogle_calendar_aclRule_scope }

  TGoogle_calendar_aclRule_scope= class (TCleanObject)
  private
    Ftype: string;
    Fvalue: string;
  published
    property type_: string read Ftype write Ftype;
    property value: string read Fvalue write Fvalue;
  end;

  { TGoogle_calendar_aclRule }

  TGoogle_calendar_aclRule= class (TCleanObject)
  private
    Fetag: string;
    Fid: string;
    Fkind: string;
    Frole: string;
    Fscope: TGoogle_calendar_aclRule_scope;
  published
    property kind: string read Fkind;
    property etag: string read Fetag;
    property id: string read Fid write Fid;
    property scope: TGoogle_calendar_aclRule_scope read Fscope write Fscope;
    property role: string read Frole write Frole;
  end;

  TGoogle_calendar_aclRuleArr= array of TGoogle_calendar_aclRule;

  TGoogle_calendar_acl = class (TCleanObject)
  private
    Fetag: string;
    Fitems: TGoogle_calendar_aclRuleArr;
    Fkind: string;
    FnextPageToken: string;
  published
    property kind: string read Fkind;
    property etag: string read Fetag;
    property nextPageToken: string read FnextPageToken;
    property items: TGoogle_calendar_aclRuleArr read Fitems;
  end;

  { TGoogle_calendar_calendar }

  TGoogle_calendar_calendar = class (TCleanObject)
  private
    Fdescription: string;
    Fetag: string;
    Fid: string;
    Fkind: string;
    Flocation: string;
    Fsummary: string;
    FtimeZone: string;
  published
    property kind: string read Fkind;
    property etag: string read Fetag;
    property id: string read Fid;
    property summary: string read Fsummary write Fsummary;
    property description: string read Fdescription write Fdescription;
    property location: string read Flocation write Flocation;
    property timeZone: string read FtimeZone write FtimeZone;
  end;

{ TGoogle_calendar_calendarListEntry_defaultReminder }

  TGoogle_calendar_calendarListEntry_defaultReminder= class
  private
    Fmethod: string;
    Fminutes: integer;
  published
    property method: string read Fmethod write Fmethod;
    property minutes: integer read Fminutes write Fminutes;
  end;

  TGoogle_calendar_calendarListEntry_defaultReminders= array of TGoogle_calendar_calendarListEntry_defaultReminder;

  { TGoogle_calendar_calendarListEntry }

  TGoogle_calendar_calendarListEntry= class (TCleanObject)
  private
    FaccessRole: string;
    FcolorId: string;
    FdefaultReminders: TGoogle_calendar_calendarListEntry_defaultReminders;
    Fdescription: string;
    Fetag: string;
    Fhidden: boolean;
    Fid: string;
    Fkind: string;
    Flocation: string;
    Fselected: boolean;
    Fsummary: string;
    FsummaryOverride: string;
    FtimeZone: string;
  published
    property kind: string read Fkind;
    property etag: string read Fetag;
    property id: string read Fid write Fid;
    property summary: string read Fsummary;
    property description: string read Fdescription;
    property location: string read Flocation;
    property timeZone: string read FtimeZone;
    property summaryOverride: string read FsummaryOverride write FsummaryOverride;
    property colorId: string read FcolorId write FcolorId;
    property hidden: boolean read Fhidden write Fhidden;
    property selected: boolean read Fselected write Fselected;
    property accessRole: string read FaccessRole;
    property defaultReminders: TGoogle_calendar_calendarListEntry_defaultReminders read FdefaultReminders write FdefaultReminders;
  end;

  TGoogle_calendar_calendarListEntryArr= array of TGoogle_calendar_calendarListEntry;

  TGoogle_calendar_calendarList = class (TCleanObject)
  private
    Fetag: string;
    Fitems: TGoogle_calendar_calendarListEntryArr;
    Fkind: string;
    FnextPageToken: string;
  published
    property kind: string read Fkind;
    property etag: string read Fetag;
    property nextPageToken: string read FnextPageToken;
    property items: TGoogle_calendar_calendarListEntryArr read Fitems write Fitems;
  end;

  { TGoogle_calendar_setting }

  TGoogle_calendar_setting= class (TCleanObject)
  private
    Fetag: string;
    Fid: string;
    Fkind: string;
    Fvalue: string;
  published
    property kind: string read Fkind write Fkind;
    property etag: string read Fetag write Fetag;
    property id: string read Fid write Fid;
    property value: string read Fvalue write Fvalue;
  end;

  TGoogle_calendar_settingArr= array of TGoogle_calendar_setting;

  { TGoogle_calendar_settings }

  TGoogle_calendar_settings = class (TCleanObject)
  private
    Fetag: string;
    Fitems: TGoogle_calendar_settingArr;
    Fkind: string;
  published
    property kind: string read Fkind;
    property etag: string read Fetag;
    property items: TGoogle_calendar_settingArr read Fitems write Fitems;
  end;

  { TGoogle_calendar_colors_value }

  TGoogle_calendar_colors_value= class (TCleanObject)
  private
    Fbackground: string;
    Fforeground: string;
    Fkey: string;
  published
    property key: string read Fkey write Fkey;
    property background: string read Fbackground;
    property foreground: string read Fforeground;
  end;

  TGoogle_calendar_colors_values= array of TGoogle_calendar_colors_value;

  TGoogle_calendar_colors = class (TCleanObject)
  private
    Fcalendar: TGoogle_calendar_colors_values;
    Fevent: TGoogle_calendar_colors_values;
    Fkind: string;
    Fupdated: TDateTime;
  published
    property kind: string read Fkind;
    property updated: TDateTime read Fupdated;
    property calendar: TGoogle_calendar_colors_values read Fcalendar;
    property event: TGoogle_calendar_colors_values read Fevent;
  end;

  { Treminders }

  Treminders= class (TCleanObject)
  private
    Foverrides: TGoogle_calendar_calendarListEntry_defaultReminder;
    FuseDefault: boolean;
  published
    property useDefault: boolean read FuseDefault write FuseDefault;
    property overrides: TGoogle_calendar_calendarListEntry_defaultReminder read Foverrides write Foverrides;
  end;

  { TextendedProperties_key }

  TextendedProperties_key= class (TCleanObject)
  private
    Fkey: string;
  published
    property key: string read Fkey write Fkey;
    property value: string read Fkey write Fkey;
  end;

  TextendedProperties_keys= array of TextendedProperties_key;
  { Tgadget }

  Tgadget= class (TCleanObject)
  private
    Fdisplay: string;
    Fheight: integer;
    FiconLink: string;
    Flink: string;
    Fpreferences: TextendedProperties_keys;
    Ftitle: string;
    Ftype: string;
    Fwidth: integer;
  published
    property type_: string read Ftype write Ftype;
    property title: string read Ftitle write Ftitle;
    property link: string read Flink write Flink;
    property iconLink: string read FiconLink write FiconLink;
    property width: integer read Fwidth write Fwidth;
    property height: integer read Fheight write Fheight;
    property display: string read Fdisplay write Fdisplay;
    property preferences: TextendedProperties_keys read Fpreferences write Fpreferences;
  end;


  TextendedProperties= class (TCleanObject)
  private
    Fprivate: TextendedProperties_keys;
    Fshared: TextendedProperties_keys;
  published
    property private_: TextendedProperties_keys read Fprivate write Fprivate;
    property shared: TextendedProperties_keys read Fshared write Fshared;
  end;

  { TGoogle_calendar_event_attendee }

  TGoogle_calendar_event_attendee= class (TCleanObject)
  private
    FadditionalGuests: integer;
    Fcomment: string;
    FdisplayName: string;
    Femail: string;
    Foptional: boolean;
    Forganizer: boolean;
    Fresource: boolean;
    FresponseStatus: string;
    Fself: boolean;
  published
    property email: string read Femail write Femail;
    property displayName: string read FdisplayName write FdisplayName;
    property organizer: boolean read Forganizer;
    property self: boolean read Fself;
    property resource: boolean read Fresource;
    property optional: boolean read Foptional write Foptional;
    property responseStatus: string read FresponseStatus write FresponseStatus;
    property comment: string read Fcomment write Fcomment;
    property additionalGuests: integer read FadditionalGuests write FadditionalGuests;
  end;

  TGoogle_calendar_event_attendees= array of TGoogle_calendar_event_attendee;

  { ToriginalStartTime }

  ToriginalStartTime= class (TCleanObject)
  private
    Fdate: TDate;
    FdateTime: TDateTime;
    FtimeZone: string;
  published
    property date: TDate read Fdate write Fdate;
    property dateTime: TDateTime read FdateTime write FdateTime;
    property timeZone: string read FtimeZone write FtimeZone;
  end;

  { Tstartend }

  Tstartend= class (TCleanObject)
  private
    Fdate: TDate;
    FdateTime: TDateTime;
    FtimeZone: string;
  published
    property date: TDate read Fdate write Fdate;
    property dateTime: TDateTime read FdateTime write FdateTime;
    property timeZone: string read FtimeZone write FtimeZone;
  end;

  { Torganizer }

  Torganizer= class (TCleanObject)
  private
    FdisplayName: string;
    Femail: string;
  published
    property email: string read Femail write Femail;
    property displayName: string read FdisplayName write FdisplayName;
  end;

  { Tcreator }

  Tcreator= class (TCleanObject)
  private
    FdisplayName: string;
    Femail: string;
  published
    property email: string read Femail;
    property displayName: string read FdisplayName;
  end;

  TGoogle_calendar_event= class (TCleanObject)
  private
    FanyoneCanAddSelf: boolean;
    Fattendees: TGoogle_calendar_event_attendees;
    FattendeesOmitted: boolean;
    FcolorId: string;
    Fcreated: TDateTime;
    Fcreator: Tcreator;
    Fdescription: string;
    Fend: Tstartend;
    Fetag: string;
    FextendedProperties: TextendedProperties;
    Fgadget: Tgadget;
    FguestsCanInviteOthers: boolean;
    FguestsCanModify: boolean;
    FguestsCanSeeOtherGuests: boolean;
    FhtmlLink: string;
    FiCalUID: string;
    Fid: string;
    Fkind: string;
    Flocation: string;
    Forganizer: Torganizer;
    ForiginalStartTime: ToriginalStartTime;
    FprivateCopy: boolean;
    Frecurrence: TStringArr;
    FrecurringEventId: string;
    Freminders: Treminders;
    Fsequence: integer;
    Fstart: Tstartend;
    Fstatus: string;
    Fsummary: string;
    Ftransparency: string;
    Fupdated: TDateTime;
    Fvisibility: string;
  published
    property kind: string read Fkind;
    property etag: string read Fetag;
    property id: string read Fid write Fid;
    property status: string read Fstatus write Fstatus;
    property htmlLink: string read FhtmlLink;
    property created: TDateTime read Fcreated;
    property updated: TDateTime read Fupdated;
    property summary: string read Fsummary write Fsummary;
    property description: string read Fdescription write Fdescription;
    property location: string read Flocation write Flocation;
    property colorId: string read FcolorId write FcolorId;
    property creator: Tcreator read Fcreator;
    property organizer: Torganizer read Forganizer write Forganizer;
    property start: Tstartend read Fstart write Fstart;
    property end_: Tstartend read Fend write Fend;
    property recurrence: TStringArr read Frecurrence write Frecurrence;
    property recurringEventId: string read FrecurringEventId;
    property originalStartTime: ToriginalStartTime read ForiginalStartTime;
    property transparency: string read Ftransparency write Ftransparency;
    property visibility: string read Fvisibility write Fvisibility;
    property iCalUID: string read FiCalUID write FiCalUID;
    property sequence: integer read Fsequence write Fsequence;
    property attendees: TGoogle_calendar_event_attendees read Fattendees write Fattendees;
    property attendeesOmitted: boolean read FattendeesOmitted write FattendeesOmitted;
    property extendedProperties: TextendedProperties read FextendedProperties;
    property gadget: Tgadget read Fgadget write Fgadget;
    property anyoneCanAddSelf: boolean read FanyoneCanAddSelf write FanyoneCanAddSelf;
    property guestsCanInviteOthers: boolean read FguestsCanInviteOthers write FguestsCanInviteOthers;
    property guestsCanModify: boolean read FguestsCanModify write FguestsCanModify;
    property guestsCanSeeOtherGuests: boolean read FguestsCanSeeOtherGuests write FguestsCanSeeOtherGuests;
    property privateCopy: boolean read FprivateCopy;
    property reminders: Treminders read Freminders write Freminders;
  end;

  TGoogle_calendar_eventArr= array of TGoogle_calendar_event;

  { TGoogle_calendar_events }

  TGoogle_calendar_events = class (TCleanObject)
  private
    FaccessRole: string;
    FdefaultReminders: TGoogle_calendar_calendarListEntry_defaultReminders;
    Fdescription: string;
    Fetag: string;
    Fitems: TGoogle_calendar_eventArr;
    Fkind: string;
    FnextPageToken: string;
    Fsummary: string;
    FtimeZone: string;
    Fupdated: TDateTime;
  published
    property kind: string read Fkind;
    property etag: string read Fetag;
    property summary: string read Fsummary;
    property description: string read Fdescription;
    property updated: TDateTime read Fupdated;
    property timeZone: string read FtimeZone;
    property accessRole: string read FaccessRole;
    property defaultReminders: TGoogle_calendar_calendarListEntry_defaultReminders read FdefaultReminders write FdefaultReminders;
    property nextPageToken: string read FnextPageToken;
    property items: TGoogle_calendar_eventArr read Fitems;
  end;

  { TGoogle_calendar_freeBusy_item }

  TGoogle_calendar_freeBusy_item= class (TCleanObject)
  private
    Fid: string;
  published
    property id: string read Fid write Fid;
  end;

  TGoogle_calendar_freeBusy_items= array of TGoogle_calendar_freeBusy_item;

  TGoogle_calendar_freeBusyQuery = class (TCleanObject)
  private
    FcalendarExpansionMax: integer;
    FgroupExpansionMax: integer;
    Fitems: TGoogle_calendar_freeBusy_items;
    FtimeMax: TDateTime;
    FtimeMin: TDateTime;
    FtimeZone: string;
  published
    property timeMin: TDateTime read FtimeMin write FtimeMin;
    property timeMax: TDateTime read FtimeMax write FtimeMax;
    property timeZone: string read FtimeZone write FtimeZone;
    property groupExpansionMax: integer read FgroupExpansionMax write FgroupExpansionMax;
    property calendarExpansionMax: integer read FcalendarExpansionMax write FcalendarExpansionMax;
    property items: TGoogle_calendar_freeBusy_items read Fitems write Fitems;
  end;

  { TGoogle_calendar_freeBusy_calendar_busy }

  TGoogle_calendar_freeBusy_calendar_busy= class (TCleanObject)
  private
    Fend: TDateTime;
    Fstart: TDateTime;
  published
    property start: TDateTime read Fstart;
    property end_: TDateTime read Fend;
  end;

  TGoogle_calendar_freeBusy_calendar_busyArr= array of TGoogle_calendar_freeBusy_calendar_busy;

  { TGoogle_calendar_freeBusy_error }

  TGoogle_calendar_freeBusy_error= class (TCleanObject)
  private
    Fdomain: string;
    Freason: string;
  published
    property domain: string read Fdomain;
    property reason: string read Freason;
  end;

  TGoogle_calendar_freeBusy_errors= array of TGoogle_calendar_freeBusy_error;

  TGoogle_calendar_freeBusy_calendar= class (TCleanObject)
  private
    Fbusy: TGoogle_calendar_freeBusy_calendar_busyArr;
    Ferrors: TGoogle_calendar_freeBusy_errors;
    Fkey: string;
  published
    property key: string read Fkey write Fkey;
    property errors: TGoogle_calendar_freeBusy_errors read Ferrors;
    property busy: TGoogle_calendar_freeBusy_calendar_busyArr read Fbusy;
  end;

  TGoogle_calendar_freeBusy_calendars= array of TGoogle_calendar_freeBusy_calendar;

  { TGoogle_calendar_freeBusy_group }

  TGoogle_calendar_freeBusy_group= class (TCleanObject)
  private
    Fcalendars: TStringArr;
    Ferrors: TGoogle_calendar_freeBusy_errors;
    Fkey: string;
  published
    property key: string read Fkey;
    property errors: TGoogle_calendar_freeBusy_errors read Ferrors;
    property calendars: TStringArr read Fcalendars;
  end;

  TGoogle_calendar_freeBusy_groups= array of TGoogle_calendar_freeBusy_group;

  TGoogle_calendar_freeBusy = class (TCleanObject)
  private
    Fcalendars: TGoogle_calendar_freeBusy_calendars;
    Fgroups: TGoogle_calendar_freeBusy_groups;
    Fkind: string;
    FtimeMax: TDateTime;
    FtimeMin: TDateTime;
  published
    property kind: string read Fkind;
    property timeMin: TDateTime read FtimeMin;
    property timeMax: TDateTime read FtimeMax;
    property groups: TGoogle_calendar_freeBusy_groups read Fgroups;
    property calendars: TGoogle_calendar_freeBusy_calendars read Fcalendars;
  end;

  TGoogle_calendarAPI=class; //forward

  { TGoogle_calendar_aclAPI }

  TGoogle_calendar_aclAPI = class
  protected
    FParent:TGoogle_calendarAPI;
  public
    function delete(calendarId,ruleId: string): boolean;
    function get(calendarId,ruleId: string): TGoogle_calendar_aclRule;
    function insert(calendarId: string;rule:TGoogle_calendar_aclRule):TGoogle_calendar_aclRule;
    function list(calendarId: string): TGoogle_calendar_acl;
    function update(calendarId,ruleId:string;rule:TGoogle_calendar_aclRule):TGoogle_calendar_aclRule;
  end;

  { TGoogle_calendar_calendarAPI }

  TGoogle_calendar_calendarAPI =class
  protected
    FParent:TGoogle_calendarAPI;
  public
    function clear(calendarId: string): boolean;
    function delete(calendarId: string): boolean;
    function get(calendarId: string): TGoogle_calendar_calendar;
    function insert(Entry:TGoogle_calendar_calendar):TGoogle_calendar_calendar;
    function update(calendarId:string;Entry:TGoogle_calendar_calendar):TGoogle_calendar_calendar;
  end;
  { TGoogle_calendar_calendarListAPI }

  TGoogle_calendar_calendarListAPI=class
  protected
    FParent:TGoogle_calendarAPI;
  public
    function delete(calendarId: string): boolean;
    function get(calendarId: string): TGoogle_calendar_calendarListEntry;
    function insert(Entry:TGoogle_calendar_calendarListEntry):TGoogle_calendar_calendarListEntry;
    function list(maxResults: integer=0; minAccessRole: string=''; pageToken: string
      =''; showHidden: boolean=false): TGoogle_calendar_calendarList;
    function update(calendarId:string;Entry:TGoogle_calendar_calendarListEntry):TGoogle_calendar_calendarListEntry;
  end;

  { TGoogle_calendar_colorsAPI }

  TGoogle_calendar_colorsAPI=class
  protected
    FParent:TGoogle_calendarAPI;
  public
    function get: TGoogle_calendar_colors;
  end;

  { TGoogle_calendar_eventsAPI }

  TGoogle_calendar_eventsAPI = class
  protected
    FParent:TGoogle_calendarAPI;
  public
    function delete(calendarId, eventid: string; sendNotifications: boolean=false
      ): boolean;
    function get(calendarId,eventid: string): TGoogle_calendar_event;
    function import(calendarId: string;Entry:TGoogle_calendar_event):TGoogle_calendar_event;
    function insert(calendarId: string; Entry: TGoogle_calendar_event;
      sendNotifications: boolean=false): TGoogle_calendar_event;
    function instances(calendarId, eventId: string): TGoogle_calendar_events;
    function list(calendarId: string): TGoogle_calendar_events;
    function move(calendarId,destination,eventid: string;sendNotifications:boolean=false): TGoogle_calendar_event;
    function quickAdd(calendarId,text: string;sendNotifications:boolean=false): TGoogle_calendar_event;
    function update(calendarId,eventid: string;Entry:TGoogle_calendar_event;sendNotifications:boolean=false):TGoogle_calendar_event;
  end;

  { TGoogle_calendar_settingsAPI }

  TGoogle_calendar_settingsAPI = class
  protected
    FParent:TGoogle_calendarAPI;
  public
    function get(setting: string): TGoogle_calendar_setting;
    function list: TGoogle_calendar_settings;
  end;


  { TGoogle_calendar_freeBusyAPI }

  TGoogle_calendar_freeBusyAPI= class
  protected
    FParent:TGoogle_calendarAPI;
  public
    function query(Entry:TGoogle_calendar_freeBusyQuery): TGoogle_calendar_freeBusy;
  end;

  { TGoogle_calendarAPI }

  TGoogle_calendarAPI= class(TGoogleSimpleApi)
  private
    FAclAPI: TGoogle_calendar_aclAPI;
    FCalendarAPI: TGoogle_calendar_calendarAPI;
    FCalendarListAPI: TGoogle_calendar_calendarListAPI;
    FColorsAPI: TGoogle_calendar_colorsAPI;
    FEventsAPI: TGoogle_calendar_eventsAPI;
    FSettingsAPI: TGoogle_calendar_settingsAPI;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property AclAPI:TGoogle_calendar_aclAPI read FAclAPI;
    property CalendarAPI:TGoogle_calendar_calendarAPI read FCalendarAPI;
    property CalendarListAPI:TGoogle_calendar_calendarListAPI read FCalendarListAPI;
    property ColorsAPI:TGoogle_calendar_colorsAPI read FColorsAPI;
    property EventsAPI:TGoogle_calendar_eventsAPI read FEventsAPI;
    property SettingsAPI: TGoogle_calendar_settingsAPI read FSettingsAPI;
  end;

implementation

Const
  BASEURI='https://www.googleapis.com/calendar/v3';

function CreateObjectCallback(ObjName:string):TObject;

begin
  if (ObjName='TGoogle_calendar_calendarListEntry') or (ObjName='TGoogle_calendar_calendarListEntryArr') then
    result:=TGoogle_calendar_calendarListEntry.Create
  else if (ObjName='TGoogle_calendar_calendarListEntry_defaultReminder') or (ObjName='TGoogle_calendar_calendarListEntry_defaultReminders') then
    result:=TGoogle_calendar_calendarListEntry_defaultReminder.Create
  else if (ObjName='TGoogle_calendar_setting') or (ObjName='TGoogle_calendar_settingArr') then
    result:=TGoogle_calendar_setting.Create
  else if (ObjName='TGoogle_calendar_aclRule') or (ObjName='TGoogle_calendar_aclRuleArr') then
    result:=TGoogle_calendar_aclRule.Create
  else if (ObjName='TGoogle_calendar_aclRule_scope') then
    result:=TGoogle_calendar_aclRule_scope.Create
  else if (ObjName='TGoogle_calendar_colors_values') or (ObjName='TGoogle_calendar_colors_value') then
    result:=TGoogle_calendar_colors_value.Create
  else if (ObjName='TGoogle_calendar_event') or (ObjName='TGoogle_calendar_eventArr') then
    result:=TGoogle_calendar_event.Create
  else if (ObjName='Tcreator') then
    result:=Tcreator.Create
  else if (ObjName='Torganizer') then
    result:=Torganizer.Create
  else if (ObjName='Tstartend') then
    result:=Tstartend.Create
  else if (ObjName='ToriginalStartTime') then
    result:=ToriginalStartTime.Create
  else if (ObjName='TGoogle_calendar_event_attendee') or (ObjName='TGoogle_calendar_event_attendees') then
    result:=TGoogle_calendar_event_attendee.Create
  else if (ObjName='TextendedProperties') then
    result:=TextendedProperties.Create
  else if (ObjName='TextendedProperties_key') or (ObjName='TextendedProperties_keys') then
    result:=TextendedProperties_key.Create
  else if (ObjName='Tgadget') then
    result:=Tgadget.Create
  else if (ObjName='Treminders') then
    result:=Treminders.Create
  else if (ObjName='TGoogle_calendar_freeBusy_item') or (ObjName='TGoogle_calendar_freeBusy_items') then
    result:=TGoogle_calendar_freeBusy_item.Create
  else if (ObjName='TGoogle_calendar_freeBusy_group') or (ObjName='TGoogle_calendar_freeBusy_groups') then
    result:=TGoogle_calendar_freeBusy_group.Create
  else if (ObjName='TGoogle_calendar_freeBusy_error') or (ObjName='TGoogle_calendar_freeBusy_errors') then
    result:=TGoogle_calendar_freeBusy_error.Create
  else if (ObjName='TGoogle_calendar_freeBusy_calendar') or (ObjName='TGoogle_calendar_freeBusy_calendars') then
    result:=TGoogle_calendar_freeBusy_calendar.Create
  else if (ObjName='TGoogle_calendar_freeBusy_calendar_busy') or (ObjName='TGoogle_calendar_freeBusy_calendar_busyArr') then
    result:=TGoogle_calendar_freeBusy_calendar_busy.Create
end;

{ TGoogle_calendar_freeBusyAPI }

function TGoogle_calendar_freeBusyAPI.query(
  Entry: TGoogle_calendar_freeBusyQuery): TGoogle_calendar_freeBusy;
begin
  result:=TGoogle_calendar_freeBusy.Create;
  if not FParent.DoMethod('POST ',BASEURI+'/freeBusy',
         '',Entry,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

{ TGoogle_calendar_events }

function TGoogle_calendar_eventsAPI.delete(calendarId, eventid: string;sendNotifications: boolean): boolean;
var
  param:string;
begin
  param:='';
  if sendNotifications then param:=AddToUrlParam(param,'sendNotifications','true');
  result:=FParent.DoMethod('DELETE',BASEURI+'/calendars/'+calendarId+'/events/'+eventid,
         param,nil,nil,@CreateObjectCallback);
end;

function TGoogle_calendar_eventsAPI.get(calendarId, eventid: string
  ): TGoogle_calendar_event;
begin
  result:=TGoogle_calendar_event.Create;
  if not FParent.DoMethod('GET',BASEURI+'/calendars/'+calendarId+'/events/'+eventid,
         '',nil,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

function TGoogle_calendar_eventsAPI.import(calendarId: string;
  Entry: TGoogle_calendar_event): TGoogle_calendar_event;
begin
  result:=TGoogle_calendar_event.Create;
  if not FParent.DoMethod('POST',BASEURI+'/calendars/'+calendarId+'/events/import',
         '',Entry,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

function TGoogle_calendar_eventsAPI.insert(calendarId: string;
  Entry: TGoogle_calendar_event;sendNotifications: boolean): TGoogle_calendar_event;
var
  param:string;
begin
  param:='';
  if sendNotifications then param:=AddToUrlParam(param,'sendNotifications','true');
  result:=TGoogle_calendar_event.Create;
  if not FParent.DoMethod('POST',BASEURI+'/calendars/'+calendarId+'/events',
         param,Entry,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

function TGoogle_calendar_eventsAPI.instances(calendarId,eventId: string
  ): TGoogle_calendar_events;
begin
  result:=TGoogle_calendar_events.Create;
  if not FParent.DoMethod('GET',BASEURI+'/calendars/'+calendarId+'/events/'+eventId+'/instances',
         '',nil,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

function TGoogle_calendar_eventsAPI.list(calendarId: string
  ): TGoogle_calendar_events;
begin
  result:=TGoogle_calendar_events.Create;
  if not FParent.DoMethod('GET',BASEURI+'/calendars/'+calendarId+'/events',
         '',nil,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

function TGoogle_calendar_eventsAPI.move(calendarId, destination, eventid: string;
  sendNotifications: boolean): TGoogle_calendar_event;
var
  param:string;
begin
  param:='';
  if sendNotifications then param:=AddToUrlParam(param,'sendNotifications','true');
  result:=TGoogle_calendar_event.Create;
  if not FParent.DoMethod('POST',BASEURI+'/calendars/'+calendarId+'/events/'+eventid+'/move',
         param,nil,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

function TGoogle_calendar_eventsAPI.quickAdd(calendarId, text: string;
  sendNotifications: boolean): TGoogle_calendar_event;
var
  param:string;
begin
  result:=nil;
  if text<>'' then
    begin
    param:=AddToUrlParam('','text',text);
    if sendNotifications then param:=AddToUrlParam(param,'sendNotifications','true');
    result:=TGoogle_calendar_event.Create;
    if not FParent.DoMethod('POST',BASEURI+'/calendars/'+calendarId+'/events/quickAdd',
                   param,nil,result,@CreateObjectCallback) then
      FreeAndNil(result);
    end;
end;

function TGoogle_calendar_eventsAPI.update(calendarId, eventid: string;
  Entry: TGoogle_calendar_event; sendNotifications: boolean
  ): TGoogle_calendar_event;
var
  param:string;
begin
  param:='';
  if sendNotifications then param:=AddToUrlParam(param,'sendNotifications','true');
  result:=TGoogle_calendar_event.Create;
  if not FParent.DoMethod('PUT',BASEURI+'/calendars/'+calendarId+'/events/'+eventid,
         param,Entry,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

{ TGoogle_calendar_colorsAPI }

function TGoogle_calendar_colorsAPI.get(): TGoogle_calendar_colors;
begin
  result:=TGoogle_calendar_colors.Create;
  if not FParent.DoMethod('GET',BASEURI+'/colors',
         '',nil,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

{ TGoogle_calendar_aclAPI }

function TGoogle_calendar_aclAPI.delete(calendarId, ruleId: string): boolean;
begin
  result:=FParent.DoMethod('DELETE',BASEURI+'/calendars/'+calendarId+'/acl/'+ruleId,
         '',nil,nil,@CreateObjectCallback);
end;

function TGoogle_calendar_aclAPI.get(calendarId, ruleId: string
  ): TGoogle_calendar_aclRule;
begin
  result:=TGoogle_calendar_aclRule.Create;
  if not FParent.DoMethod('GET',BASEURI+'/calendars/'+calendarId+'/acl/'+ruleId,
         '',nil,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

function TGoogle_calendar_aclAPI.insert(calendarId: string;
  rule: TGoogle_calendar_aclRule): TGoogle_calendar_aclRule;
begin
  result:=TGoogle_calendar_aclRule.Create;
  if not FParent.DoMethod('POST ',BASEURI+'/calendars/'+calendarId+'/acl',
         '',rule,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

function TGoogle_calendar_aclAPI.list(calendarId: string): TGoogle_calendar_acl;
begin
  result:=TGoogle_calendar_acl.Create;
  if not FParent.DoMethod('GET ',BASEURI+'/calendars/'+calendarId+'/acl',
         '',nil,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

function TGoogle_calendar_aclAPI.update(calendarId, ruleId: string;
  rule: TGoogle_calendar_aclRule): TGoogle_calendar_aclRule;
begin
  result:=TGoogle_calendar_aclRule.Create;
  if not FParent.DoMethod('PUT',BASEURI+'/calendars/'+calendarId+'/acl/'+ruleId,
         '',rule,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

{ TGoogle_calendar_calendarAPI }

function TGoogle_calendar_calendarAPI.clear(calendarId: string): boolean;
begin
  result:=FParent.DoMethod('DELETE',BASEURI+'/calendars/'+calendarId+'/clear',
         '',nil,nil,@CreateObjectCallback);
end;

function TGoogle_calendar_calendarAPI.delete(calendarId: string): boolean;
begin
  result:=FParent.DoMethod('DELETE',BASEURI+'/calendars/'+calendarId,
         '',nil,nil,@CreateObjectCallback);
end;

function TGoogle_calendar_calendarAPI.get(calendarId: string
  ): TGoogle_calendar_calendar;
begin
  result:=TGoogle_calendar_calendar.Create;
  if not FParent.DoMethod('GET',BASEURI+'/calendars/'+calendarId,
         '',nil,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

function TGoogle_calendar_calendarAPI.insert(Entry: TGoogle_calendar_calendar
  ): TGoogle_calendar_calendar;
begin
  result:=TGoogle_calendar_calendar.Create;
  if not FParent.DoMethod('POST ',BASEURI+'/calendars',
         '',Entry,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

function TGoogle_calendar_calendarAPI.update(calendarId: string;
  Entry: TGoogle_calendar_calendar): TGoogle_calendar_calendar;
begin
  result:=TGoogle_calendar_calendar.Create;
  if not FParent.DoMethod('PUT',BASEURI+'/calendars/'+calendarId,
         '',Entry,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

{ TGoogle_calendar_settingsAPI }

function TGoogle_calendar_settingsAPI.get(setting: string
  ): TGoogle_calendar_setting;
begin
  result:=TGoogle_calendar_setting.Create;
  if not FParent.DoMethod('GET',BASEURI+'/users/me/settings/'+setting,
         '',nil,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

function TGoogle_calendar_settingsAPI.list: TGoogle_calendar_settings;
begin
  result:=TGoogle_calendar_settings.Create;
  if not FParent.DoMethod('GET ',BASEURI+'/users/me/settings',
         '',nil,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

{ TGoogle_calendar_calendarListAPI }

function TGoogle_calendar_calendarListAPI.delete(calendarId: string): boolean;
begin
  result:=FParent.DoMethod('DELETE',BASEURI+'/users/me/calendarList/'+calendarId,
         '',nil,nil,@CreateObjectCallback);
end;

function TGoogle_calendar_calendarListAPI.get(calendarId: string
  ): TGoogle_calendar_calendarListEntry;
begin
  result:=TGoogle_calendar_calendarListEntry.Create;
  if not FParent.DoMethod('GET',BASEURI+'/users/me/calendarList/'+calendarId,
         '',nil,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

function TGoogle_calendar_calendarListAPI.insert(Entry: TGoogle_calendar_calendarListEntry
  ): TGoogle_calendar_calendarListEntry;
begin
  result:=TGoogle_calendar_calendarListEntry.Create;
  if not FParent.DoMethod('POST',BASEURI+'/users/me/calendarList',
         '',Entry,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

function TGoogle_calendar_calendarListAPI.list(maxResults:integer=0;minAccessRole:string='';
  pageToken:string='';showHidden:boolean=false): TGoogle_calendar_calendarList;
var
  param:string;

begin
  param:='';
  if maxResults<>0 then param:=AddToUrlParam(param,'maxResults',IntToStr(maxResults));
  param:=AddToUrlParam(param,'minAccessRole',minAccessRole);
  param:=AddToUrlParam(param,'pageToken',pageToken);
  if showHidden then param:=AddToUrlParam(param,'showHidden','true');
  result:=TGoogle_calendar_calendarList.Create;
  if not FParent.DoMethod('GET ',BASEURI+'/users/me/calendarList',
         param,nil,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;

function TGoogle_calendar_calendarListAPI.update(calendarId: string;
  Entry: TGoogle_calendar_calendarListEntry
  ): TGoogle_calendar_calendarListEntry;
var s:string;
begin
  result:=TGoogle_calendar_calendarListEntry.Create;
  if not FParent.DoMethod('PUT',BASEURI+'/users/me/calendarList/'+calendarId,
         '',Entry,result,@CreateObjectCallback) then
    FreeAndNil(result);
end;


{ TGoogle_calendarAPI }

constructor TGoogle_calendarAPI.Create;
begin
  inherited Create;
  FAclAPI:=TGoogle_calendar_aclAPI.Create;
  FAclAPI.FParent:=self;
  FCalendarAPI:=TGoogle_calendar_calendarAPI.Create;
  FCalendarAPI.FParent:=self;
  FCalendarListAPI:=TGoogle_calendar_calendarListAPI.Create;
  FCalendarListAPI.FParent:=self;
  FColorsAPI:=TGoogle_calendar_colorsAPI.Create;
  FColorsAPI.FParent:=self;
  FEventsAPI:=TGoogle_calendar_eventsAPI.Create;
  FEventsAPI.FParent:=self;
  FSettingsAPI:= TGoogle_calendar_settingsAPI.Create;
  FSettingsAPI.FParent:=self;
end;

destructor TGoogle_calendarAPI.Destroy;
begin
  FAclAPI.Destroy;
  FCalendarAPI.Destroy;
  FCalendarListAPI.Destroy;
  FSettingsAPI.Destroy;
  FColorsAPI.Destroy;
  FEventsAPI.Destroy;
  inherited Destroy;
end;

end.

