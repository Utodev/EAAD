unit UAbout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TfAbout }

  TfAbout = class(TForm)
    Image: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelDetails: TLabel;
    LabelDetails1: TLabel;
    LabelDetails2: TLabel;
    LabelnGithubSite: TLabel;
    procedure ImageClick(Sender: TObject);
    procedure LabelnGithubSiteClick(Sender: TObject);
    procedure LabelngPAWSSiteClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fAbout: TfAbout;

implementation

uses lclintf;

{$R *.lfm}

{ TfAbout }

procedure TfAbout.ImageClick(Sender: TObject);
begin

end;

procedure TfAbout.LabelnGithubSiteClick(Sender: TObject);
begin
  OpenURL(TLabel(Sender).Caption);
end;

procedure TfAbout.LabelngPAWSSiteClick(Sender: TObject);
begin
  OpenURL(TLabel(Sender).Caption);
end;

end.

