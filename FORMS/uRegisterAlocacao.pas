unit uRegisterAlocacao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uRegister, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FMX.Edit, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.TabControl, FMX.Controls.Presentation,
  FMX.DateTimeCtrls, FMX.DialogService.Async,  System.SyncObjs, FMX.DialogService,
  URegisteruser, uRegisterEquipament, FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TAlocacao = record
    codigo, emprestimo : integer;
    usuario : TUser;
    equipamento : TEquipament;
    tipo : string;
    devolucao : TDate;
  end;
  TfrmRegisterAlocacao = class(TfrmRegister)
    checkEmprestimo: TCheckBox;
    dDevolucao: TDateEdit;
    edtEquipamento: TEdit;
    edtId: TEdit;
    edtUser: TEdit;
    edtDescricao: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lDevolucao: TLabel;
    lUsuario: TLabel;
    lvAlocacao: TListView;
    edtCodigo: TEdit;
    lCodigo: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure tcControleChange(Sender: TObject);
    procedure btnNewRegisterClick(Sender: TObject);
    procedure btnSaveRegisterClick(Sender: TObject);
    procedure btnCancelRegisterClick(Sender: TObject);
    procedure btnDeleteRegisterClick(Sender: TObject);
    procedure edtIdChange(Sender: TObject);
    procedure edtEquipamentoChange(Sender: TObject);
    procedure lvAlocacaoItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure checkEmprestimoChange(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
  private
    procedure inserirNaLista(aloca: TAlocacao);
    procedure inserirAlocacaoNoBanco(aloca: TAlocacao);
    { Private declarations }
  public
    { Public declarations }
    procedure ajustarComponentes();
    procedure limparEdits();
    procedure verificarOperacao();
    procedure verificarPermissaoTroca();
    procedure finalizaAcao();
    function validarCampos() : Boolean;
    function ConfirmDialogSync(const AMessage: String) : Boolean;

    function  buscarNoBanco(aloca : TAlocacao) : TAlocacao;
    procedure inserirNoBanco(aloca : TAlocacao);
    procedure atualizarNoBanco(aloca : TAlocacao);
    procedure removerNoBanco(cod_aloca : Integer);
    procedure listarDoBanco();

    function preencherObjeto(aloca : TAlocacao) : TAlocacao;
    function preencherParamFromQuery(aloca : TAlocacao; query : TFDQuery) : TAlocacao;
    function preencherFieldFromQuery(aloca : TAlocacao; query : TFDQuery) : TAlocacao;

    var operacao, tipo : string;
    var permitirTroca : Boolean;
  end;

var
  frmRegisterAlocacao: TfrmRegisterAlocacao;

implementation

{$R *.fmx}
{ TfrmRegisterAlocacao }
procedure TfrmRegisterAlocacao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  finalizaAcao;
end;

procedure TfrmRegisterAlocacao.FormCreate(Sender: TObject);
begin
  inherited;
  ajustarComponentes;
  listarDoBanco;
  permitirTroca := True;
end;

procedure TfrmRegisterAlocacao.tcControleChange(Sender: TObject);
begin
  inherited;
  ajustarComponentes;
  verificarOperacao;
  verificarPermissaoTroca;

end;

procedure TfrmRegisterAlocacao.ajustarComponentes;
begin
  if tcControle.ActiveTab = tList then
  begin
    listarDoBanco;

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

    btnDeleteRegister.Visible := False;
    btnDeleteRegister.Enabled := False;

    btnNewRegister.Visible := False;
    btnNewRegister.Enabled := False;

    btnQuit.Visible := False;
    btnQuit.Enabled := False;
  end;
end;

procedure TfrmRegisterAlocacao.finalizaAcao;
begin
  limparEdits();
  operacao := '';
  permitirTroca := True;
  tcControle.TabIndex := 0;
end;

procedure TfrmRegisterAlocacao.limparEdits;
begin
  edtId.Text := '';
  edtuser.Text := '';
  edtCodigo.Text := '';
  edtEquipamento.Text := '';
  edtDescricao.Text := '';
  checkEmprestimo.IsChecked := False;
end;

function TfrmRegisterAlocacao.ConfirmDialogSync(
  const AMessage: String): Boolean;
var Event : TEvent;
var ResultValue : Boolean;
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

procedure TfrmRegisterAlocacao.edtEquipamentoChange(Sender: TObject);
var vEquip : TEquipament;
begin
  inherited;
  if edtEquipamento.Text <> '' then
  begin
    vEquip.codigo := StrToInt(edtEquipamento.Text);

    if not assigned(frmRegisterEquipament) then
        Application.CreateForm(TfrmRegisterEquipament,frmRegisterEquipament);
    vEquip := frmRegisterEquipament.buscarEquipamentNoBanco(vEquip);
    if vEquip.descricao <> '' then
    begin
      edtDescricao.Text := vEquip.descricao;
    end
    else if vEquip.descricao = '' then
    begin
      ShowMessage('Equipamento nao encontrado!');
      limparEdits;
    end;
  end;
end;

procedure TfrmRegisterAlocacao.edtIdChange(Sender: TObject);
var vUser : TUSer;
begin
  inherited;
  if edtId.Text <> '' then
  begin
    vUser.id := StrToInt(edtId.Text);
    vUser := frmRegisterUser.buscarUsuarioNoBanco(vUser);
    if vUser.nome <> '' then
    begin
      edtUser.Text := vUser.nome;
    end
    else if vUser.nome = '' then
    begin
      ShowMessage('Usuario nao encontrado!');
      limparEdits;
    end;
  end;
end;


function TfrmRegisterAlocacao.validarCampos: Boolean;
begin
  if (edtEquipamento.Text= '') or (edtId.Text= '') then
  begin
    ShowMessage('H� campos pendentes de preenchimento!');
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;

procedure TfrmRegisterAlocacao.verificarOperacao;
begin
  if (tcControle.TabIndex = 1) and (operacao = '') then
  begin
    tcControle.TabIndex := 0;

    ShowMessage('Selecione um registro');
  end;
end;

procedure TfrmRegisterAlocacao.verificarPermissaoTroca;
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

procedure TfrmRegisterAlocacao.inserirNaLista(aloca: TAlocacao);
begin
  with lvAlocacao.Items.Add do
  begin
    TListItemText(Objects.FindDrawable('txtCodigo')).Text := IntToStr(aloca.codigo);
    TListItemText(Objects.FindDrawable('txtUsuario')).Text := aloca.usuario.nome;
    TListItemText(Objects.FindDrawable('txtEquipamento')).Text := aloca.equipamento.descricao;
    TListItemText(Objects.FindDrawable('txtTipo')).Text := aloca.tipo;
  end;
end;

procedure TfrmRegisterAlocacao.inserirNoBanco(aloca: TAlocacao);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('INSERT INTO alocacao(usuario, equipamento, emprestimo, devolucao, tipo)');
  FDQueryRegister.SQL.Add('VALUES(:usuario, :equipamento, :emprestimo, :devolucao, :tipo)');

  aloca.codigo := -1;
  aloca.tipo := 'Alocacao';
  aloca := preencherParamFromQuery(aloca, FDQueryRegister);

  FDQueryRegister.ExecSQL;
end;

procedure TfrmRegisterAlocacao.btnCancelRegisterClick(Sender: TObject);
begin
  inherited;
  self.Close;
end;

procedure TfrmRegisterAlocacao.btnDeleteRegisterClick(Sender: TObject);
begin
  inherited;
  removerNoBanco(StrToInt(edtCodigo.Text));
  showMessage('Alocacao removida com sucesso!');
  finalizaAcao;
end;

procedure TfrmRegisterAlocacao.btnNewRegisterClick(Sender: TObject);
begin
  inherited;
  limparEdits;
  operacao := 'inserir';
  tcControle.TabIndex := 1;
  permitirTroca := false;
end;

procedure TfrmRegisterAlocacao.btnQuitClick(Sender: TObject);
begin
  inherited;
  finalizaAcao;
end;

procedure TfrmRegisterAlocacao.btnSaveRegisterClick(Sender: TObject);
var vAlocacao : TAlocacao;
begin
  inherited;
  if validarCampos() then
  begin
    vAlocacao := preencherObjeto(vAlocacao);

    if operacao = 'editar' then
    begin
      vAlocacao.codigo := StrToInt(edtCodigo.Text);
      atualizarNoBanco(vAlocacao);
      showMessage('Alocacao atualizado com sucesso!');
      finalizaAcao;
    end
    else if operacao = 'inserir' then
    begin
      inserirNoBanco(vAlocacao);
      showMessage('Alocacao cadastrado com sucesso!');
      self.Close;
    end;
  end;
end;

procedure TfrmRegisterAlocacao.atualizarNoBanco(aloca: TAlocacao);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('UPDATE alocacao SET');
  FDQueryRegister.SQL.Add('usuario = :usuario,');
  FDQueryRegister.SQL.Add('equipamento = :equipamento,');
  FDQueryRegister.SQL.Add('emprestimo = :emprestimo,');
  FDQueryRegister.SQL.Add('devolucao = :devolucao,');
  FDQueryRegister.SQL.Add('tipo = :tipo');
  FDQueryRegister.SQL.Add('WHERE codigo = :codigo');

  aloca := preencherParamFromQuery(aloca, FDQueryRegister);
  FDQueryRegister.ExecSQL;
end;

function TfrmRegisterAlocacao.buscarNoBanco(
  aloca: TAlocacao): TAlocacao;
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('SELECT * FROM alocacao');
  FDQueryRegister.SQL.Add('WHERE codigo = :codigo');
  FDQueryRegister.ParamByName('codigo').AsInteger := aloca.codigo;

  FDQueryRegister.Open();

  aloca := preencherFieldFromQuery(aloca, FDQueryRegister);

  Result := aloca;
end;

procedure TfrmRegisterAlocacao.checkEmprestimoChange(Sender: TObject);
begin
  inherited;
  if checkEmprestimo.IsChecked = True then
  begin
    dDevolucao.Visible := True;
    dDevolucao.Enabled := True;
    lDevolucao.Visible := True;
    lDevolucao.Enabled := True;
  end else
  if checkEmprestimo.IsChecked = False then
  begin
    dDevolucao.Visible := False;
    dDevolucao.Enabled := False;
    lDevolucao.Visible := False;
    lDevolucao.Enabled := False;
  end;


end;

procedure TfrmRegisterAlocacao.inserirAlocacaoNoBanco(aloca: TAlocacao);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('INSERT INTO alocacao(equipamento, usuario, emprestimo, devolucao, tipo)');
  FDQueryRegister.SQL.Add('VALUES(:equipamento, :usuario, :emprestimo, :devolucao, :tipo)');

  aloca.codigo := -1;
  aloca := preencherParamFromQuery(aloca, FDQueryRegister);

  FDQueryRegister.ExecSQL;
end;

procedure TfrmRegisterAlocacao.listarDoBanco;
var vAlocacao : TAlocacao;
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('SELECT * FROM alocacao');

  FDQueryRegister.Open();

  FDQueryRegister.First;

  lvAlocacao.Items.Clear;

  if not assigned(frmRegisterEquipament) then
    Application.CreateForm(TfrmRegisterEquipament,frmRegisterEquipament);
  while not FDQueryRegister.Eof do
  begin
    vAlocacao := preencherFieldFromQuery(vAlocacao, FDQueryRegister);
    vAlocacao.equipamento := frmRegisterEquipament.buscarEquipamentNoBanco(vAlocacao.equipamento);
    vAlocacao.usuario := frmRegisterUser.buscarUsuarioNoBanco(vAlocacao.usuario);

    inserirNaLista(vAlocacao);
    FDQueryRegister.Next;
  end;
end;

procedure TfrmRegisterAlocacao.lvAlocacaoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var vAlocacao : TAlocacao;
begin
  inherited;
  vAlocacao.codigo := StrToInt(TListItemText(lvAlocacao.Items[ItemIndex].Objects.FindDrawable('txtCodigo')).Text);

  vAlocacao := buscarNoBanco(vAlocacao);
  vAlocacao.usuario := frmRegisterUser.buscarUsuarioNoBanco(vAlocacao.usuario);
  vAlocacao.equipamento := frmRegisterEquipament.buscarEquipamentNoBanco(vAlocacao.equipamento);

  edtCodigo.Text := IntToStr(vAlocacao.codigo);
  edtEquipamento.Text := IntToStr(vAlocacao.equipamento.codigo);
  edtDescricao.Text := vAlocacao.equipamento.descricao;
  edtId.Text := FloatToStr(vAlocacao.usuario.id);
  edtUser.Text := vAlocacao.usuario.nome;

  if vAlocacao.emprestimo = 1 then
  begin
    checkEmprestimo.IsChecked := True;
  end
  else
  begin
      checkEmprestimo.IsChecked := False;
  end;

  operacao := 'editar';
  tcControle.TabIndex := 1;
  permitirTroca := False;
end;

procedure TfrmRegisterAlocacao.removerNoBanco(cod_aloca: Integer);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;
  FDQueryRegister.SQL.Add('DELETE FROM alocacao');
  FDQueryRegister.SQL.Add('WHERE codigo = :codigo');

  FDQueryRegister.ParamByName('codigo').AsInteger := cod_aloca;

  FDQueryRegister.ExecSQL;
end;



function TfrmRegisterAlocacao.preencherFieldFromQuery(
  aloca: TAlocacao; query: TFDQuery): TAlocacao;
begin
  aloca.codigo :=  query.FieldByName('codigo').AsInteger;
  aloca.equipamento.codigo := query.FieldByName('equipamento').AsInteger;
  aloca.usuario.id := query.FieldByName('usuario').AsInteger;
  aloca.emprestimo := query.FieldByName('emprestimo').AsInteger;
  aloca.devolucao := query.FieldByName('devolucao').AsDateTime;
  aloca.tipo :=  query.FieldByName('tipo').AsString;

  Result := aloca;
end;

function TfrmRegisterAlocacao.preencherObjeto(
  aloca: TAlocacao): TAlocacao;
begin
  aloca.equipamento.codigo := StrToInt(edtEquipamento.Text);
  aloca.equipamento := frmRegisterEquipament.buscarEquipamentNoBanco(aloca.equipamento);
  aloca.usuario     := frmRegisterUser.buscarUsuarioNoBanco(aloca.usuario);
  aloca.emprestimo := 1;
  aloca.tipo :=  tipo;

  Result := aloca;
end;

function TfrmRegisterAlocacao.preencherParamFromQuery(aloca: TAlocacao;
  query: TFDQuery): TAlocacao;
begin
  if aloca.codigo <> -1 then
  begin
    query.ParamByName('codigo').AsInteger := aloca.codigo;
  end;

  if checkEmprestimo.IsChecked = True then
  begin
    aloca.emprestimo := 1;
  end
  else if checkEmprestimo.IsChecked = False then
  begin
      aloca.emprestimo := 1;
  end;
  query.ParamByName('equipamento').AsInteger := aloca.equipamento.codigo;
  query.ParamByName('usuario').AsInteger := aloca.usuario.id;
  query.ParamByName('devolucao').AsDateTime := aloca.devolucao;
  query.ParamByName('tipo').AsString := aloca.tipo;
  query.ParamByName('emprestimo').AsInteger := aloca.emprestimo;

  Result := aloca;
end;
end.
