unit URegisteruser;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uRegister, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, FMX.Controls.Presentation, FMX.Menus, FMX.TabControl,
  FMX.Edit, FMX.DateTimeCtrls, FMX.ListBox;

type
  TUser = record
    id, grupo, departamento: Integer;
    nome, email, telefone, senha : string;
    data_cadastro, data_excluido : TDate;
    ativo : Boolean;
  end;

  TfrmRegisterUser = class(TfrmRegister)
    edtId: TEdit;
    ID: TLabel;
    Nome: TLabel;
    edtNome: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtEmail: TEdit;
    edtSenha: TEdit;
    cbGrupo: TComboBox;
    dData: TDateEdit;
    checkAtivo: TCheckBox;
    ListBoxItem1: TListBoxItem;
    Label6: TLabel;
    edtTelefone: TEdit;
    procedure btnSaveRegisterClick(Sender: TObject);
  private
    { Private declarations }

    procedure inserirUsuarioNoBanco( usuario : TUser);
  public
    { Public declarations }
  end;

var
  frmRegisterUser: TfrmRegisterUser;

implementation

{$R *.fmx}

procedure TfrmRegisterUser.btnSaveRegisterClick(Sender: TObject);
var vUsuario : TUser;
begin
  inherited;

  vUsuario.nome := edtNome.Text;
  vUsuario.email := edtEmail.Text;
  vUsuario.senha := edtSenha.Text;
  vUsuario.telefone := edtTelefone.Text;
  vUsuario.grupo := cbGrupo.ItemIndex;
  vUsuario.data_cadastro := dData.Date;
  vUsuario.data_excluido := dData.Date;
  vUsuario.ativo := true;
  vUsuario.email := edtEmail.Text;

  inserirUsuarioNoBanco(vUsuario);
end;

procedure TfrmRegisterUser.inserirUsuarioNoBanco(usuario: TUser);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;
  FDQueryRegister.SQL.Add('INSERT INTO usuario(id, nome, email, telefone, senha, grupo, data_cadastro, data_excluido, ativo, departamento)');
  FDQueryRegister.SQL.Add('VALUES (:id, :nome, :email, :telefone, :senha, :grupo, :data_cadastro, :data_excluido, :ativo, :departamento)');

  FDQueryRegister.ParamByName('id').AsInteger := usuario.id;
  FDQueryRegister.ParamByName('grupo').AsInteger := usuario.grupo;
  FDQueryRegister.ParamByName('departamento').AsInteger := usuario.departamento;
  FDQueryRegister.ParamByName('nome').AsString := usuario.nome;
  FDQueryRegister.ParamByName('email').AsString := usuario.email;
  FDQueryRegister.ParamByName('telefone').AsString := usuario.telefone;
  FDQueryRegister.ParamByName('senha').AsString := usuario.senha;
  FDQueryRegister.ParamByName('data_cadastro').AsDate := usuario.data_cadastro;
  FDQueryRegister.ParamByName('data_excluido').AsDate := usuario.data_excluido;
  FDQueryRegister.ParamByName('ativo').AsBoolean := usuario.ativo;

  FDQueryRegister.ExecSQL;
end;


end.
