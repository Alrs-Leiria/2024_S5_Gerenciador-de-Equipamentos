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
    lNome: TLabel;
    edtNome: TEdit;
    lEmail: TLabel;
    lSenha: TLabel;
    lTipo: TLabel;
    lAtivo: TLabel;
    lDataCadastro: TLabel;
    edtEmail: TEdit;
    edtSenha: TEdit;
    cbxGrupo: TComboBox;
    dData: TDateEdit;
    checkAtivo: TCheckBox;
    lTelefone: TLabel;
    edtTelefone: TEdit;
    lvUsuarios: TListView;
    cbxDepartamento: TComboBox;
    lbDAlmoxarifado: TListBoxItem;
    DEPARTAMENTO: TLabel;
    lbAdm: TListBoxItem;
    lbGerente: TListBoxItem;
    lbAnalista: TListBoxItem;
    lbDTi: TListBoxItem;
    ListBoxItem1: TListBoxItem;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    ListBoxGroupHeader2: TListBoxGroupHeader;
    lbDAdm: TListBoxItem;
    procedure btnSaveRegisterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvUsuariosItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure tcControleChange(Sender: TObject);
    procedure btnNewRegisterClick(Sender: TObject);
    procedure btnDeleteRegisterClick(Sender: TObject);
    procedure btnCancelRegisterClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPesquisarClick(Sender: TObject);

  private
    { Private declarations }


  public
    { Public declarations }
    function  buscarUsuarioNoBanco( user : TUser) : TUser;
    procedure inserirUsuarioNoBanco( user : TUser);
    procedure editarUsuarioNoBanco( user : TUser);
    procedure removerUsuarioNoBanco(id_user : Integer);
    procedure listarUsuario();
    procedure pesquisarNoBanco(nome : String);

    function preencherObjetoUsario(user : TUser) : TUser;
    function PreencherUsuarioFieldFromQuery(user : TUser; query : TFDQuery) : TUser;
    function PreencherUsuarioParamFromQuery(user : TUser; query : TFDQuery) : TUser;

    procedure inserirUsuarionaLista( user : TUser);

    var operacao : string;
    var permitirTroca : Boolean;

    procedure limparEdits();

    procedure finalizaAcao();

    function validarCampos() : Boolean;
    procedure verificarOperacao();
    procedure verificarPermissaoTroca();
    function ConfirmDialogSync(const AMessage: String) : Boolean;

    procedure ajustarComponentes();
  end;

var
  frmRegisterUser: TfrmRegisterUser;

implementation

{$R *.fmx}

procedure TfrmRegisterUser.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  finalizaAcao;
end;

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

    btnQuit.Visible := True;
    btnQuit.Enabled := True;

    btnSaveRegister.Visible := False;
    btnSaveRegister.Enabled := False;

    btnCancelRegister.Visible := False;
    btnCancelRegister.Enabled := False;

    btnDeleteRegister.Visible := False;
    btnDeleteRegister.Enabled := False;
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

    btnQuit.Visible := False;
    btnQuit.Enabled := False;

    if operacao = 'inserir' then
    begin
      checkAtivo.Visible := False;
      checkAtivo.Enabled := False;
      lAtivo.Visible := False;
      cbxGrupo.ItemIndex := 0;
      cbxDepartamento.ItemIndex := 0;
    end else if operacao = 'editar' then
    begin
      checkAtivo.Visible := True;
      checkAtivo.Enabled := True;
      lAtivo.Visible := True;
    end;
  end;
end;

procedure TfrmRegisterUser.btnCancelRegisterClick(Sender: TObject);
begin
  inherited;
  finalizaAcao;
end;

procedure TfrmRegisterUser.btnDeleteRegisterClick(Sender: TObject);
begin
  inherited;
  removerUsuarioNoBanco(StrToInt(edtId.Text));
  showMessage('Usuario removido com sucesso!');
  finalizaAcao;
end;

procedure TfrmRegisterUser.btnNewRegisterClick(Sender: TObject);
begin
  inherited;
  operacao := 'inserir';
  tcControle.TabIndex := 1;
  permitirTroca := false;
end;

procedure TfrmRegisterUser.btnPesquisarClick(Sender: TObject);
begin
  inherited;
  if edtPesquisa.Text ='' then
  begin
    listarUsuario;
  end else
        pesquisarNoBanco(edtPesquisa.Text);
end;

procedure TfrmRegisterUser.btnSaveRegisterClick(Sender: TObject);
var vUsuario : TUser;
    tempUser : TUser;
begin
  inherited;

  if validarCampos() then
  begin
    vUsuario := preencherObjetoUsario(vUsuario);

    if operacao = 'editar' then
    begin
      vUsuario.id := StrToInt(edtId.Text);
      tempUser.id := StrToInt(edtId.Text);

      tempuser := buscarUsuarioNoBanco(tempUser);
      if (vUsuario.ativo = 0) and (tempUser.ativo = 1) then
      begin
        if ConfirmDialogSync('Deseja inativar o usuario') then
        begin
          vUsuario.data_excluido := Date;
        end
        else
        begin
          vUsuario.ativo := 1;
        end;
      end;
      editarUsuarioNoBanco(vUsuario);
      showMessage('Usuario atualizado com sucesso!');
      finalizaAcao;
    end
    else if operacao = 'inserir' then
    begin
      inserirUsuarioNoBanco(vUsuario);
      showMessage('Usuario cadastrado com sucesso!');
      finalizaAcao;
    end;
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

  vUser := PreencherUsuarioFieldFromQuery(vUser, FDQueryRegister);

  Result := vUser;
end;

procedure TfrmRegisterUser.finalizaAcao;
begin
  limparEdits();
  operacao := '';
  permitirTroca := True;
  tcControle.TabIndex := 0;
end;


procedure TfrmRegisterUser.editarUsuarioNoBanco(user: TUser);
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

  user := PreencherUsuarioParamFromQuery(user, FDQueryRegister);

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

    if user.ativo = 1 then
    begin
      TListItemText(Objects.FindDrawable('txtAtivo')).Text := 'Ativo';
    end
    else
    begin
      TListItemText(Objects.FindDrawable('txtAtivo')).Text := 'Inativo';
    end;

  end;
end;

procedure TfrmRegisterUser.inserirUsuarioNoBanco(user: TUser);
begin

  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;
  FDQueryRegister.SQL.Add('INSERT INTO usuario(nome, email, telefone, senha, grupo, data_cadastro, data_excluido, ativo, departamento)');
  FDQueryRegister.SQL.Add('VALUES (:nome, :email, :telefone, :senha, :grupo, :data_cadastro, :data_excluido, :ativo, :departamento)');

  user.id := -1;
  user.ativo := 1;
  user := PreencherUsuarioParamFromQuery(user, FDQueryRegister);

  FDQueryRegister.ExecSQL;
end;


procedure TfrmRegisterUser.limparEdits;
begin
  edtId.Text := '';
  edtNome.Text := '';
  edtEmail.Text := '';
  edtSenha.Text := '';
  edtTelefone.Text := '';
  cbxGrupo.ItemIndex := 0;
  cbxDepartamento.ItemIndex := 0;
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
    vUser := PreencherUsuarioFieldFromQuery(vUser, FDQueryRegister);

    inserirUsuarionaLista(vUser);

    FDQueryRegister.Next;
  end;
end;

procedure TfrmRegisterUser.lvUsuariosItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var vUser : TUser;
begin
  inherited;

  vUser.id := StrToInt(TListItemText(lvUsuarios.Items[ItemIndex].Objects.FindDrawable('txtId')).Text);

  vUser := buscarUsuarioNoBanco(vUser);

  edtId.Text := IntToStr(vUser.id);
  edtNome.Text := vUser.nome;
  edtEmail.Text := vUser.email;
  edtSenha.Text := vUser.senha;
  edtTelefone.Text := vUser.telefone;
  cbxGrupo.ItemIndex := vUser.grupo;
  cbxDepartamento.ItemIndex := vUser.departamento;
  dData.Date := vUser.data_cadastro;

  if vUser.ativo = 1 then
  begin
    checkAtivo.IsChecked := True;
  end
  else if vUser.ativo = 0  then
  begin
    checkAtivo.IsChecked := False;
  end;

  operacao := 'editar';
  tcControle.TabIndex := 1;
  permitirTroca := False;
end;

procedure TfrmRegisterUser.pesquisarNoBanco(nome: String);
var user : TUser;
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('SELECT * FROM usuario');
  FDQueryRegister.SQL.Add('WHERE nome LIKE :nome');
  FDQueryRegister.ParamByName('nome').AsString := '%' + nome + '%';

  FDQueryRegister.Open();

  FDQueryRegister.First;

  lvUsuarios.Items.Clear;

  while not FDQueryRegister.Eof do
  begin
    user := PreencherUsuarioFieldFromQuery(user, FDQueryRegister);

    inserirUsuarionaLista(user);

    FDQueryRegister.Next;
  end;
end;

function TfrmRegisterUser.preencherObjetoUsario(user: TUser): TUser;
begin

  user.nome := edtNome.Text;
  user.email := edtEmail.Text;
  user.senha := edtSenha.Text;
  user.telefone := edtTelefone.Text;
  user.data_cadastro := dData.Date;
  user.data_excluido := 0;
  user.grupo := cbxGrupo.ItemIndex;
  user.departamento := cbxDepartamento.ItemIndex;

  if checkAtivo.IsChecked = True then
  begin
    user.ativo := 1;
  end
  else if checkAtivo.IsChecked = False then
  begin
    user.ativo := 0;
  end;

  Result := user;
end;

function TfrmRegisterUser.PreencherUsuarioFieldFromQuery(user: TUser;
  query: TFDQuery): TUser;
begin
    user.id := query.FieldByName('id').AsInteger;
    user.nome := query.FieldByName('nome').AsString;
    user.email := query.FieldByName('email').AsString;
    user.telefone := query.FieldByName('telefone').AsString;
    user.senha := query.FieldByName('senha').AsString;
    user.grupo := query.FieldByName('grupo').AsInteger;
    user.departamento := query.FieldByName('departamento').AsInteger;
    user.data_cadastro := query.FieldByName('data_cadastro').AsDateTime;
    user.data_excluido := query.FieldByName('data_excluido').AsDateTime;
    user.ativo := query.FieldByName('ativo').AsInteger;

    Result := user;
end;

function TfrmRegisterUser.PreencherUsuarioParamFromQuery(user: TUser;
  query: TFDQuery): TUser;
begin
  if user.id <> -1 then
  begin
    query.ParamByName('id').AsInteger := user.id;
  end;

  query.ParamByName('nome').AsString := user.nome;
  query.ParamByName('email').AsString := user.email;
  query.ParamByName('telefone').AsString := user.telefone;
  query.ParamByName('senha').AsString := user.senha;
  query.ParamByName('grupo').AsInteger := user.grupo;
  query.ParamByName('departamento').AsInteger := user.departamento;
  query.ParamByName('data_cadastro').AsDate := user.data_cadastro;
  query.ParamByName('data_excluido').AsDate := user.data_excluido;
  query.ParamByName('ativo').AsInteger := user.ativo;
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

function TfrmRegisterUser.validarCampos() : Boolean;
begin
  if (edtNome.Text= '') or (edtEmail.Text= '') or (edtTelefone.Text= '') or (edtSenha.Text= '') then
  begin
    ShowMessage('H� campos pendentes de preenchimento!');
    Result := False;
  end
  else if cbxGrupo.ItemIndex = 0 then
  begin
    ShowMessage('Defina o grupo do usuario!');
    Result := False;
  end
  else if cbxDepartamento.ItemIndex = 0 then
  begin
    ShowMessage('Defina o departamento do usuario!');
    Result := False;
  end  else
  begin
    Result := True;
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
      if ConfirmDialogSync('Deseja cancelar a edi��o') then
      begin
        finalizaAcao;
      end
      else
      begin
        tcControle.TabIndex := 1;
      end;
    end;
end;

end.
