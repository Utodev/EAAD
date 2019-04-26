unit UConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils {$IFNDEF Windows}, BaseUnix {$ENDIF} ;


type TConfig = class
private
 FStartDatabasePath: String;
 FHelpBaseURL : String;
 FSaveBeforeRun : Boolean;
 FShowToolBar : Boolean;
 FOpenAllTabs : Boolean;
 FUseSCEDefault: Boolean;
 FLang : String;
 FRecentFiles: Array[0..9] of string;
 FExternalTool : String;

 FEditorFontSize: integer;
 FEditorBackgroundColor: Integer;
 FEditorSelectLineColor : Integer;
 FEditorFontName : String;

public
 property StartDatabasePath : String read FStartDatabasePath write FStartDatabasePath;
 property HelpBaseURL : String read FHelpBaseURL write FHelpBaseURL;
 property ExternalTool : String read FExternalTool write FExternalTool;

 property SaveBeforeRun : Boolean read FSaveBeforeRun write FSaveBeforeRun;
 property ShowToolBar : Boolean read FShowToolBar write FShowToolBar;
 property UseSCEDefault : Boolean read FUseSCEDefault write FUseSCEDefault;
 property OpenAllTabs : Boolean read  FOpenAllTabs write  FOpenAllTabs;

 property Lang: String read FLang write FLang;

 property EditorFontSize: integer read FEditorFontSize write FEditorFontSize;
 property EditorBackgroundColor: Integer read FEditorBackgroundColor write FEditorBackgroundColor;
 property EditorFontName : String read FEditorFontName write FEditorFontName;
 property EditorSelectLineColor : Integer read FEditorSelectLineColor write FEditorSelectLineColor;

 procedure LoadConfig();
 procedure SaveConfig();

 procedure LoadRecentFiles();
 procedure SaveRecentFiles();
 function GetRecentFile(i:integer) : string;
 procedure AddRecentFile(Filename:String);

 function FullPath(Path:String):String;
end;



implementation

uses Inifiles;


procedure TConfig.LoadConfig();
var IniFile : TIniFile;
    ConfigFilePath : String;
begin

  {$IFDEF Windows}
  ConfigFilePath:= ChangeFileExt(GetAppConfigFile(False), '.ini');
  {$ELSE}
  ConfigFilePath:= ChangeFileExt(GetAppConfigFile(False), '.conf');
  {$ENDIF}
  IniFile := TIniFile.Create(ConfigFilePath);

  FUseSCEDefault := IniFile.ReadBool('Options','UseSCEDefault',false);
  {$IFDEF Windows}
  FStartDatabasePath := IniFile.ReadString('Paths','StartDatabasePath','database.start');
  {$ELSE}
  FStartDatabasePath := IniFile.ReadString('Paths','StartDatabasePath',FullPath('database.start'));
  {$ENDIF}
  If not FUseSCEDefault THEN FStartDatabasePath := FStartDatabasePath + '.dsf';


  FHelpBaseURL :=  IniFile.ReadString('URLS','HelpBaseURL','https://github.com/Utodev/ngPAWS/wiki');

  FExternalTool := IniFile.ReadString('Paths','ExternalTool','');

  FSaveBeforeRun := IniFile.ReadBool('Options','SaveBeforeRun',true);
  FShowToolBar :=  IniFile.ReadBool('Options','ShowToolBar',true);
  FOpenAllTabs :=  IniFile.ReadBool('Options','OpenAllTabs',false);
  FUseSCEDefault := IniFile.ReadBool('Options','UseSCEDefault',false);

  {$IFDEF WINDOWS}
  FEditorFontName := IniFile.ReadString('Options','EditorFontName', 'Consolas');
  {$ELSE}
  FEditorFontName := IniFile.ReadString('Options','EditorFontName', 'Courier New');
  {$ENDIF}
  FEditorFontSize :=  IniFile.ReadInteger('Options','EditorFontSize',13);
  FEditorBackgroundColor:= IniFile.ReadInteger('Options','EditorBackgroundColor',$222827);
  FEditorSelectLineColor:= IniFile.ReadInteger('Options','EditorSelectedLineColor',$333333);


  FLang :=  IniFile.ReadString('Lang','Lang','');
  IniFile.Free();
  LoadRecentFiles();
end;



procedure TConfig.SaveConfig();
var IniFile : TIniFile;
    ConfigFilePath : String;
begin
  {$IFDEF Windows}
  ConfigFilePath:= ChangeFileExt(GetAppConfigFile(False), '.ini');
  {$ELSE}
  ConfigFilePath:= ChangeFileExt(GetAppConfigFile(False), '.conf');
  {$ENDIF}
  IniFile := TIniFile.Create(ConfigFilePath);

  IniFile.WriteString('Paths','StartDatabasePath', FullPath(FStartDatabasePath));
  IniFile.WriteString('Paths','ExternalTool',FExternalTool);

  IniFile.WriteString('URLS','HelpBaseURL', FHelpBaseURL);


  IniFile.WriteBool('Options','SaveBeforeRun', FSaveBeforeRun);
  IniFile.WriteBool('Options','ShowToolBar', FShowToolBar);
  IniFile.WriteBool('Options','OpenAllTabs', FOpenAllTabs);
  IniFile.WriteBool('Options','UseSCEDefault', FUseSCEDefault);

  IniFile.WriteInteger('Options','EditorFontSize',FEditorFontSize);

  IniFile.WriteString('Lang','Lang', FLang);
  IniFile.Free();
  SaveRecentFiles();
end;


procedure TConfig.LoadRecentFiles();
var i : integer;
    IniFile : TIniFile;
    ConfigFilePath : String;
begin
  {$IFDEF Windows}
  ConfigFilePath:= ChangeFileExt(GetAppConfigFile(False), '.ini');
  {$ELSE}
  ConfigFilePath:= ChangeFileExt(GetAppConfigFile(False), '.conf');
  {$ENDIF}
  IniFile := TIniFile.Create(ConfigFilePath);
  for i := 0 to 9 do FRecentFiles[i] :=  IniFile.ReadString('Recent files','File' + IntToStr(i), '');
  IniFile.Free();
end;

procedure TConfig.SaveRecentFiles();
var i : integer;
    IniFile : TIniFile;
    ConfigFilePath : String;
begin
  {$IFDEF Windows}
  ConfigFilePath:= ChangeFileExt(GetAppConfigFile(False), '.ini');
  {$ELSE}
  ConfigFilePath:= ChangeFileExt(GetAppConfigFile(False), '.conf');
  {$ENDIF}
  IniFile := TIniFile.Create(ConfigFilePath);
  for i := 0 to 9 do IniFile.WriteString('Recent files','File' + IntToStr(i), FRecentFiles[i]);
  IniFile.Free();
end;

function TConfig.GetRecentFile(i:integer) : string;
begin
  Result := FRecentFiles[i];
end;


procedure TConfig.AddRecentFile(Filename:String);
var i,j: integer;
    found : boolean;
begin
  found := false;
  for  i:= 0  to 9 do
   if FRecentFiles[i] = Filename then
    begin
      found := true;
      for j := i downto 1 do FRecentFiles[j] := FRecentFiles[j-1];
      FRecentFiles[0] := Filename;
    end;
  if not found then
   begin
     for i:= 9 downto 1 do FRecentFiles[i] := FRecentFiles[i-1];
     FRecentFiles[0] := Filename;
   end;
  SaveRecentFiles();
end;

function TConfig.FullPath(Path:String):String;
begin
  {$ifndef Windows}
    if (Pos('/',Path)=0) then Path := ExtractFilePath(fpReadLink('/proc/self/exe')) + Path;
  {$endif}
  Result := Path;

end;

end.

