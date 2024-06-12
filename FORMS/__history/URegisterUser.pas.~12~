unit URegisteruser;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uRegister, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, FMX.Controls.Presentation, FMX.Menus, FMX.TabControl,
  FMX.Edit, FMX.DateTimeCtrls, FMX.ListBox, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

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
    lvUsuarios: TListView;
    procedure btnSaveRegisterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvUsuariosItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  private
    { Private declarations }
    function buscarUsuarioNoBanco( user : TUser) : TUser;
    procedure inserirUsuarioNoBanco( usuario : TUser);
    procedure listarUsuario();

    procedure inserirUsuarionaLista( user : TUser);
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

function TfrmRegisterUser.buscarUsuarioNoBanco(user: TUser) : TUser;
var vUser : TUser;
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('SELECT * FROM usuario');
  FDQueryRegister.SQL.Add('WHERE id = :id');
  FDQueryRegister.ParamByName('id').AsInteger := user.id;

  FDQueryRegister.Open();

  vUser.id := FDQueryRegister.FieldByName('id').AsInteger;
  vUser.nome := FDQueryRegister.FieldByName('nome').AsString;
  vUser.email := FDQueryRegister.FieldByName('email').AsString;
  vUser.telefone := FDQueryRegister.FieldByName('telefone').AsString;
  vUser.grupo := FDQueryRegister.FieldByName('grupo').AsInteger;
  vUser.departamento := FDQueryRegister.FieldByName('departamento').AsInteger;

  Result := vUser;
end;

procedure TfrmRegisterUser.FormCreate(Sender: TObject);
begin
  inherited;
  listarUsuario;
end;

procedure TfrmRegisterUser.inserirUsuarionaLista(user: TUser);
begin
  with lvUsuarios.Items.Add do
  begin
    TListItemText(Objects.FindDrawable('txtId')).Text := IntToStr(user.id);
    TListItemText(Objects.FindDrawable('txtNome')).Text := user.nome;
    TListItemText(Objects.FindDrawable('txtEmail')).Text := user.email;
    TListItemText(Objects.FindDrawable('txtTelefone')).Text := user.telefone;
    TListItemText(Objects.FindDrawable('txtGrupo')).Text := IntToStr(user.grupo);
    TListItemText(Objects.FindDrawable('txtDepartamento')).Text := IntToStr(user.departamento);
  end;
end;

procedure TfrmRegisterUser.inserirUsuarioNoBanco(usuario: TUser);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;
  FDQueryRegister.SQL.Add('INSERT INTO usuario(id, nome, email, telefone, senha, grupo, data_cadastro, data_excluido, ativo, departamento)');
  FDQueryRegister.SQL.Add('VALUES (:id, :nome, :email, :telefone, :senha, :grupo, :data_cadastro, :data_excluido, :ativo, :departamento)');

  FDQueryRegister.ParamByName('id').AsInteger := usuario.id;
  FDQueryRegister.ParamByName('grupo').AsInteger := 1;
  FDQueryRegister.ParamByName('departamento').AsInteger := 1;
  FDQueryRegister.ParamByName('nome').AsString := usuario.nome;
  FDQueryRegister.ParamByName('email').AsString := usuario.email;
  FDQueryRegister.ParamByName('telefone').AsString := usuario.telefone;
  FDQueryRegister.ParamByName('senha').AsString := usuario.senha;
  FDQueryRegister.ParamByName('data_cadastro').AsDate := usuario.data_cadastro;
  FDQueryRegister.ParamByName('data_excluido').AsDate := usuario.data_excluido;
  FDQueryRegister.ParamByName('ativo').AsBoolean := usuario.ativo;

  FDQueryRegister.ExecSQL;
end;


procedure TfrmRegisterUser.listarUsuario();
var vUser : TUser;
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('SELECT * FROM usuario');

  FDQueryRegister.Open();

  FDQueryRegister.First;

  {lvUsuarios.Items.Clear;}

  while not FDQueryRegister.Eof do
  begin
    vUser.id := FDQueryRegister.FieldByName('id').AsInteger;
    vUser.nome := FDQueryRegister.FieldByName('nome').AsString;
    vUser.email := FDQueryRegister.FieldByName('email').AsString;
    vUser.telefone := FDQueryRegister.FieldByName('telefone').AsString;
    vUser.grupo := FDQueryRegister.FieldByName('grupo').AsInteger;
    vUser.departamento := FDQueryRegister.FieldByName('departamento').AsInteger;
    vUser.senha := FDQueryRegister.FieldByName('senha').AsString;

    inserirUsuarionaLista(vUser);

    FDQueryRegister.Next;
  end;


end;

procedure TfrmRegisterUser.lvUsuariosItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var vUser : TUser;
    id_user : Integer;
begin
  inherited;

  vUser.id := StrToInt(TListItemText(lvUsuarios.Items[ItemIndex].Objects.FindDrawable('txtId')).Text);

  vUser := buscarUsuarioNoBanco(vUser);

  edtId.Text := IntToStr(vUser.id);
  edtNome.Text := vUser.nome;
  edtEmail.Text := vUser.email;
  edtSenha.Text := vUser.senha;
  edtTelefone.Text := vUser.telefone;
  cbGrupo.ItemIndex := vUser.grupo;
  dData.Date := vUser.data_cadastro;
  dData.Date := vUser.data_excluido;
{  checkAtivo := True;}
  tcControle.TabIndex := 1;

end;

end.
