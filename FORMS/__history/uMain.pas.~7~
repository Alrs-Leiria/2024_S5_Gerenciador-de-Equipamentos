unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  URegisterUser, uRegisterEquipament;

type
  TfrmMain = class(TForm)
    mMenu: TMainMenu;
    Cadastros: TMenuItem;
    Usuarios: TMenuItem;
    Equipamentos: TMenuItem;
    procedure UsuariosClick(Sender: TObject);
    procedure EquipamentosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}


procedure TfrmMain.EquipamentosClick(Sender: TObject);
begin
  frmRegisterEquipament.Show;
end;

procedure TfrmMain.UsuariosClick(Sender: TObject);
begin
  frmRegisterUser.tcControle.TabIndex := 0;
  frmRegisterUser.preencherComboBoxGrupousuario;
  frmRegisterUser.Show;
end;

end.
