unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation;

type
  TfrmLogin = class(TForm)
    pLogin: TPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    lLogin: TLabel;
    Label1: TLabel;
    Nome: TLabel;
    lSenha: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

end.
