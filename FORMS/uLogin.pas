unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, URegisteruser, uMain;

type
  TfrmLogin = class(TForm)
    pLogin: TPanel;
    edtId: TEdit;
    edtNome: TEdit;
    edtSenha: TEdit;
    lLogin: TLabel;
    Label1: TLabel;
    Nome: TLabel;
    lSenha: TLabel;
    btnLogar: TButton;
    procedure btnLogarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function  validarCampos() : Boolean;
    procedure preencherObjeto();
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

procedure TfrmLogin.btnLogarClick(Sender: TObject);
var user : Tuser;
begin
  if validarCampos() then
  begin
    user.id := StrToInt(edtId.Text);
    user := frmRegisterUser.buscarUsuarioNoBanco(user);

    if  (user.nome <> '') and (user.senha = edtSenha.Text) then
    begin
      ShowMessage('Sucesso!');
{      if not Assigned(frmMain) then
        frmMain := TfrmMain.Create(Application);}
      Application.MainForm := frmMain;
      frmMain.Show;
      self.Close;
    end
    else if(user.nome <> '') and (user.senha <> edtSenha.Text) then
    begin
      ShowMessage('Senha incorreta!');
    end
    else
    begin
      ShowMessage('Usuario não encontrado!');
    end;
  end;
end;

procedure TfrmLogin.preencherObjeto;
var user : Tuser;
begin
  user.id := StrToInt(edtId.Text);
  user.nome := edtNome.Text;
  user.senha := edtSenha.Text;
end;

function TfrmLogin.validarCampos : Boolean;
begin
  if (edtId.Text = '') or (edtSenha.Text = '') then
  begin
    ShowMessage('Há campos pendentes de preenchimento');
    Result := False;
  end else
        Result := True;
end;

end.
