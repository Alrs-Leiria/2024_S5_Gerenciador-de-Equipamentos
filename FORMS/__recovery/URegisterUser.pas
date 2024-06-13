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
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, FMX.DialogService.Async,
  System.SyncObjs, FMX.DialogService;

type
  TUser = record
    id, grupo, departamento, ativo: Integer;
    nome, email, telefone, senha : string;
    data_cadastro, data_excluido : TDate;
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
    Label6: TLabel;
    edtTelefone: TEdit;
    lvUsuarios: TListView;
    cbxDepartamento: TComboBox;
    lbAlmoxarifado: TListBoxItem;
    DEPARTAMENTO: TLabel;
    lbAdm: TListBoxItem;
    lbGerente: TListBoxItem;
    lbAnalista: TListBoxItem;
    lbTi: TListBoxItem;
    ListBoxItem1: TListBoxItem;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    procedure btnSaveRegisterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvUsuariosItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure tcControleChange(Sender: TObject);
    procedure btnNewRegisterClick(Sender: TObject);
    procedure btnDeleteRegisterClick(Sender: TObject);
    procedure btnCancelRegisterClick(Sender: TObject);
  private
    { Private declarations }
    function  preencherObjetoUsario(usuario : TUser) : TUser;

    function  buscarUsuarioNoBanco( user : TUser) : TUser;
    procedure inserirUsuarioNoBanco( usuario : TUser);
    procedure editarUsuarioNoBanco( usuario : TUser);
    procedure removerUsuarioNoBanco(id_user : Integer);
    procedure listarUsuario();




    procedure inserirUsuarionaLista( user : TUser);


    var operacao : string;
    var permitirTroca : Boolean;
  public
    { Public declarations }
    procedure preencherComboBoxGrupousuario();
    procedure limparEdits();

    procedure cancelarOperacao();

    procedure verificarOperacao();
    procedure verificarPermissaoTroca();
    function ConfirmDialogSync(const AMessage: String) : Boolean;

    procedure ajustarComponentes();

  end;

var
  frmRegisterUser: TfrmRegisterUser;

implementation

{$R *.fmx}

procedure TfrmRegisterUser.FormCreate(Sender: TObject);
begin
  inherited;
  ajustarComponentes;
  listarUsuario;
  permitirTroca := True;
end;

procedure TfrmRegisterUser.tcControleChange(Sender: TObject);
begin
  inherited;
  ajustarComponentes;
  verificarOperacao;
  verificarPermissaoTroca;

end;

procedure TfrmRegisterUser.ajustarComponentes;
begin
  if tcControle.ActiveTab = tList then
  begin
    listarUsuario;
    btnNewRegister.Visible := True;
    btnNewRegister.Enabled := True;

    btnSaveRegister.Visible := False;
    btnSaveRegister.Enabled := False;

    btnCancelRegister.Visible := False;
    btnCancelRegister.Enabled := False;

    btnDeleteRegister.Visible := False;
    btnDeleteRegister.Enabled := False;

    btnQuit.Text := 'Sair';
  end
  else if tcControle.ActiveTab = tAction then
  begin
    btnSaveRegister.Visible := True;
    btnSaveRegister.Enabled := True;

    btnCancelRegister.Visible := True;
    btnCancelRegister.Enabled := True;

    btnDeleteRegister.Visible := True;
    btnDeleteRegister.Enabled := True;

    btnNewRegister.Visible := False;
    btnNewRegister.Enabled := False;

    btnQuit.Text := 'Voltar';
  end;

end;

procedure TfrmRegisterUser.btnCancelRegisterClick(Sender: TObject);
begin
  inherited;
  cancelarOperacao;
end;

procedure TfrmRegisterUser.btnDeleteRegisterClick(Sender: TObject);
begin
  inherited;
  removerUsuarioNoBanco(StrToInt(edtId.Text));
end;

procedure TfrmRegisterUser.btnNewRegisterClick(Sender: TObject);
begin
  inherited;
  operacao := 'inserir';
  tcControle.TabIndex := 1;
  permitirTroca := false;
end;

procedure TfrmRegisterUser.btnSaveRegisterClick(Sender: TObject);
var vUsuario : TUser;
begin
  inherited;
  vUsuario := preencherObjetoUsario(vUsuario);

  if operacao = 'editar' then
  begin
    vUsuario.id := StrToInt(edtId.Text);
    editarUsuarioNoBanco(vUsuario);

  end
  else if operacao = 'inserir' then
  begin
    inserirUsuarioNoBanco(vUsuario);
  end;
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

procedure TfrmRegisterUser.cancelarOperacao;
begin
  limparEdits();
  operacao := '';
  permitirTroca := True;
  tcControle.TabIndex := 0;
end;


procedure TfrmRegisterUser.editarUsuarioNoBanco(usuario: TUser);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('UPDATE usuario SET');
  FDQueryRegister.SQL.Add('nome = :nome,');
  FDQueryRegister.SQL.Add('email = :email,');
  FDQueryRegister.SQL.Add('telefone = :telefone,');
  FDQueryRegister.SQL.Add('senha = :senha,');
  FDQueryRegister.SQL.Add('grupo = :grupo,');
  FDQueryRegister.SQL.Add('data_cadastro = :data_cadastro,');
  FDQueryRegister.SQL.Add('data_excluido = :data_excluido,');
  FDQueryRegister.SQL.Add('ativo = :ativo,');
  FDQueryRegister.SQL.Add('departamento = :departamento');
  FDQueryRegister.SQL.Add('WHERE id = :id');

  FDQueryRegister.ParamByName('id').AsInteger := usuario.id;
  FDQueryRegister.ParamByName('grupo').AsInteger := usuario.grupo;
  FDQueryRegister.ParamByName('departamento').AsInteger := usuario.departamento;
  FDQueryRegister.ParamByName('nome').AsString := usuario.nome;
  FDQueryRegister.ParamByName('email').AsString := usuario.email;
  FDQueryRegister.ParamByName('telefone').AsString := usuario.telefone;
  FDQueryRegister.ParamByName('senha').AsString := usuario.senha;
  FDQueryRegister.ParamByName('data_cadastro').AsDate := usuario.data_cadastro;
  FDQueryRegister.ParamByName('data_excluido').AsDate := usuario.data_excluido;
  FDQueryRegister.ParamByName('ativo').AsInteger := usuario.ativo;

  FDQueryRegister.ExecSQL;
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
  FDQueryRegister.SQL.Add('INSERT INTO usuario(nome, email, telefone, senha, grupo, data_cadastro, data_excluido, ativo, departamento)');
  FDQueryRegister.SQL.Add('VALUES (:nome, :email, :telefone, :senha, :grupo, :data_cadastro, :data_excluido, :ativo, :departamento)');

  FDQueryRegister.ParamByName('nome').AsString := usuario.nome;
  FDQueryRegister.ParamByName('email').AsString := usuario.email;
  FDQueryRegister.ParamByName('telefone').AsString := usuario.telefone;
  FDQueryRegister.ParamByName('senha').AsString := usuario.senha;
  FDQueryRegister.ParamByName('grupo').AsInteger := 1;
  FDQueryRegister.ParamByName('departamento').AsInteger := 1;
  FDQueryRegister.ParamByName('data_cadastro').AsDate := usuario.data_cadastro;
  FDQueryRegister.ParamByName('data_excluido').AsDate := usuario.data_excluido;
  FDQueryRegister.ParamByName('ativo').Asfloat := 1;

  FDQueryRegister.ExecSQL;
end;


procedure TfrmRegisterUser.limparEdits;
begin
  edtId.Text := '';
  edtNome.Text := '';
  edtEmail.Text := '';
  edtSenha.Text := '';
  edtTelefone.Text := '';
  cbGrupo.ItemIndex := 3;
end;

procedure TfrmRegisterUser.listarUsuario();
var vUser : TUser;
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('SELECT * FROM usuario');

  FDQueryRegister.Open();

  FDQueryRegister.First;

  lvUsuarios.Items.Clear;

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
  {checkAtivo := True;}
  operacao := 'editar';
  tcControle.TabIndex := 1;
  permitirTroca := False;
end;

procedure TfrmRegisterUser.preencherComboBoxGrupousuario;
begin


end;

function TfrmRegisterUser.preencherObjetoUsario(usuario: TUser): TUser;
begin

  usuario.nome := edtNome.Text;
  usuario.email := edtEmail.Text;
  usuario.senha := edtSenha.Text;
  usuario.telefone := edtTelefone.Text;
  usuario.data_cadastro := dData.Date;
  usuario.data_excluido := dData.Date;
  usuario.grupo := cbGrupo.ItemIndex;
  usuario.departamento := cbxDepartamento.ItemIndex;

  if checkAtivo.IsChecked = True then
  begin
    usuario.ativo := 1;
  end
  else if checkAtivo.IsChecked = False then
  begin
    usuario.ativo := 0;
  end;

  Result := usuario;
end;

procedure TfrmRegisterUser.removerUsuarioNoBanco(id_user: Integer);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;
  FDQueryRegister.SQL.Add('DELETE FROM usuario');
  FDQueryRegister.SQL.Add('WHERE id = :id');

  FDQueryRegister.ParamByName('id').AsInteger := id_user;

  FDQueryRegister.ExecSQL;
end;


function TfrmRegisterUser.ConfirmDialogSync(const AMessage : string) : Boolean;
var Event: TEvent;
var ResultValue: Boolean;
begin
  Event := TEvent.Create;
  try
    TDialogService.MessageDialog(AMessage, TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], TMsgDlgBtn.mbOK, 0,
      procedure(const AResult: TModalResult)
    begin
    ResultValue := AResult = mrOk;
    Event.SetEvent;
    end);
    Event.WaitFor(INFINITE);
    Result := ResultValue;

  finally
    Event.Free;
  end;
end;

procedure TfrmRegisterUser.verificarOperacao;

begin
  if (tcControle.TabIndex = 1) and (operacao = '') then
  begin
    tcControle.TabIndex := 0;

    ShowMessage('Selecione o usuario');
  end
end;

procedure TfrmRegisterUser.verificarPermissaoTroca;
begin
    if (permitirTroca = False) and (tcControle.ActiveTab = tList) then
    begin
      if ConfirmDialogSync('Deseja cancelar a edição') then
      begin
        cancelarOperacao;
      end
      else if True then
      begin
        tcControle.TabIndex := 1;
      end;
    end;
end;

end.
