        unit uoptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, Menus, UConfig, DefaultTranslator;

type

  { TfOptions }

  TfOptions = class(TForm)
    BBrowseStartDatabase: TButton;
    BOk: TButton;
    BCancel: TButton;
    checkOpenAllTabs: TCheckBox;
    checkShowToolbar: TCheckBox;
    checkSaveBeforeRun: TCheckBox;
    ComboBoxLang: TComboBox;
    EditHelpURL: TEdit;
    EditStartDatabase: TEdit;
    GroupBoxEditor: TGroupBox;
    LabelLang: TLabel;
    LabelHelpURL: TLabel;
    LabelStartDatabase: TLabel;
    OpenDialogOptions: TOpenDialog;
    procedure BBrowseCompilerClick(Sender: TObject);
    procedure BBrowsePreprocessorClick(Sender: TObject);
    procedure BBrowseStartDatabaseClick(Sender: TObject);
    procedure ComboBoxLangChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SaveToConfig(var Config: TConfig);
  private
    procedure LoadFromConfig();
    var LanguageChanged : Boolean;
  public
    { public declarations }
  end;

var
  fOptions: TfOptions;

implementation

{$R *.lfm}

uses UMain, UGlobals;

{ TfOptions }

procedure TfOptions.LoadFromConfig();
begin
 checkShowToolbar.Checked :=  fMain.Config.ShowToolBar;
 checkSaveBeforeRun.Checked:=fMain.Config.SaveBeforeRun;
 checkOpenAllTabs.Checked:=fMain.Config.OpenAllTabs;

 EditHelpURL.Text:= fMain.Config.HelpBaseURL;
 EditStartDatabase.Text:= fMain.Config.StartDatabasePath;

 ComboBoxLang.ItemIndex := 0;
 if fMain.Config.Lang = 'es' then  ComboBoxLang.ItemIndex := 2 else if fMain.Config.Lang = 'en' then ComboBoxLang.ItemIndex := 1;

end;

procedure TfOptions.SaveToConfig(var Config: TConfig);
begin
  Config.ShowToolBar := checkShowToolbar.Checked;
  Config.SaveBeforeRun := checkSaveBeforeRun.Checked;
  Config.OpenAllTabs := checkOpenAllTabs.Checked;



   Config.HelpBaseURL := EditHelpURL.Text;
   Config.StartDatabasePath := EditStartDatabase.Text;

   if LanguageChanged then
      case ComboBoxLang.ItemIndex of
      0 : Config.Lang := '';
      1 : Config.Lang := 'en';
      2:  Config.Lang := 'es';
      end;

end;



procedure TfOptions.FormShow(Sender: TObject);
begin
  ComboBoxLang.Items.Text := S_LANGUAGES;
  LanguageChanged:=false;
  LoadFromConfig();
end;

procedure TfOptions.ComboBoxLangChange(Sender: TObject);
begin
  LanguageChanged:=true;
end;

procedure TfOptions.BBrowsePreprocessorClick(Sender: TObject);
begin
end;

procedure TfOptions.BBrowseStartDatabaseClick(Sender: TObject);
begin
  if OpenDialogOptions.Execute then EditStartDatabase.Text:=OpenDialogOptions.FileName;
end;

procedure TfOptions.BBrowseCompilerClick(Sender: TObject);
begin
end;


end.

