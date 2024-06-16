unit uRegisterSolicitacoes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uRegister, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.TabControl, FMX.Controls.Presentation,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Memo.Types, FMX.ListBox, FMX.ScrollBox, FMX.Memo,
  FMX.DateTimeCtrls, FMX.Edit, FMX.DialogService.Async,
  System.SyncObjs, FMX.DialogService;

type
  TSolicitacao = record
    codigo, tipo : integer;
    assunto, detalhamento, situacao : string;
  end;
  TfrmRegisterSolicitacoes = class(TfrmRegister)
    lvSolicitacoes: TListView;
    Panel1: TPanel;
    lDetalhamento: TLabel;
    lAssunto: TLabel;
    lTipo: TLabel;
    pManutencao: TPanel;
    lmEquipamento: TLabel;
    lmStatus: TLabel;
    ComboBox1: TComboBox;
    lmDataAbertura: TLabel;
    lmPrevisaoFechamento: TLabel;
    Edit1: TEdit;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    edtAssunto: TEdit;
    mDetalhamento: TMemo;
    cbxTipo: TComboBox;
    lbHTipo: TListBoxGroupHeader;
    lbAlocacao: TListBoxItem;
    lbEmprestimo: TListBoxItem;
    lbManutencao: TListBoxItem;
    edtCodigo: TEdit;
    lSolicitacao: TLabel;
    procedure btnSaveRegisterClick(Sender: TObject);
    procedure lvSolicitacoesItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tcControleChange(Sender: TObject);
    procedure btnCancelRegisterClick(Sender: TObject);
    procedure btnNewRegisterClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    function  buscarNoBanco(solicitacao : TSolicitacao) : TSolicitacao;
    procedure inserirNoBanco(solicitacao : TSolicitacao);
    procedure atualizarNoBanco(solicitacao : TSolicitacao);
    procedure removerNoBanco(cod_solicitacao : Integer);
    procedure listarDoBanco();

    function preencherObjeto(solicitacao : TSolicitacao) : TSolicitacao;
    function preencherParamFromQuery(solicitacao : TSolicitacao; query : TFDQuery) : TSolicitacao;
    function preencherFieldFromQuery(solicitacao : TSolicitacao; query : TFDQuery) : TSolicitacao;

    procedure inserirNaLista(solicitacao : TSolicitacao);

    procedure ajustarComponentes();
    procedure limparEdits();
    procedure verificarOperacao();
    procedure verificarPermissaoTroca();
    procedure finalizaAcao();
    function validarCampos() : Boolean;
    function ConfirmDialogSync(const AMessage: String) : Boolean;

    var operacao : string;
    var permitirTroca : Boolean;
  end;

var
  frmRegisterSolicitacoes: TfrmRegisterSolicitacoes;

implementation

{$R *.fmx}
procedure TfrmRegisterSolicitacoes.ajustarComponentes;
begin
  inherited;

  if tcControle.ActiveTab = tList then
  begin
    listarDoBanco;
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
      cbxTipo.ItemIndex := 0;
    end else if operacao = 'editar' then
    begin

    end;
  end;
end;

procedure TfrmRegisterSolicitacoes.finalizaAcao;
begin
  limparEdits();
  operacao := '';
  permitirTroca := True;
  tcControle.TabIndex := 0;
end;
procedure TfrmRegisterSolicitacoes.atualizarNoBanco(solicitacao: TSolicitacao);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('UPDATE solicitacoes SET');
  FDQueryRegister.SQL.Add('assunto = :assunto,');
  FDQueryRegister.SQL.Add('detalhamento = :detalhamento,');
  FDQueryRegister.SQL.Add('situacao = :situacao,');
  FDQueryRegister.SQL.Add('tipo = :tipo');
  FDQueryRegister.SQL.Add('WHERE codigo = :codigo');

  solicitacao := preencherParamFromQuery(solicitacao, FDQueryRegister);
  FDQueryRegister.ExecSQL;
end;

procedure TfrmRegisterSolicitacoes.btnCancelRegisterClick(Sender: TObject);
begin
  inherited;
  finalizaAcao;
end;

procedure TfrmRegisterSolicitacoes.btnNewRegisterClick(Sender: TObject);
begin
  inherited;
  limparEdits;
  operacao := 'inserir';
  tcControle.TabIndex := 1;
  permitirTroca := false;
end;

procedure TfrmRegisterSolicitacoes.btnSaveRegisterClick(Sender: TObject);
var vSolicitacao : TSolicitacao;
begin
  inherited;
  if validarCampos() then
  begin
    vSolicitacao := preencherObjeto(vSolicitacao);

    if operacao = 'editar' then
    begin
      vSolicitacao.codigo := StrToInt(edtCodigo.Text);

      atualizarNoBanco(vSolicitacao);
      showMessage('Equipamento atualizado com sucesso!');
      finalizaAcao;
    end
    else if operacao = 'inserir' then
    begin
      inserirNoBanco(vSolicitacao);
      showMessage('Equipamento cadastrado com sucesso!');
      finalizaAcao;
    end;
  end;
end;

function TfrmRegisterSolicitacoes.buscarNoBanco(
  solicitacao: TSolicitacao): TSolicitacao;
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('SELECT * FROM solicitacoes');
  FDQueryRegister.SQL.Add('WHERE codigo = :codigo');
  FDQueryRegister.ParamByName('codigo').AsInteger := solicitacao.codigo;

  FDQueryRegister.Open();

  solicitacao := preencherFieldFromQuery(solicitacao, FDQueryRegister);

  Result := solicitacao;
end;

procedure TfrmRegisterSolicitacoes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  finalizaAcao;
end;

procedure TfrmRegisterSolicitacoes.FormCreate(Sender: TObject);
begin
  inherited;
  ajustarComponentes;
  listarDoBanco;
  permitirTroca := True;
end;

procedure TfrmRegisterSolicitacoes.inserirNaLista(solicitacao: TSolicitacao);
begin
  with lvSolicitacoes.Items.Add do
  begin
    TListItemText(Objects.FindDrawable('txtCodigo')).Text := IntToStr(solicitacao.codigo);
    TListItemText(Objects.FindDrawable('txtAssunto')).Text := solicitacao.assunto;
    TListItemText(Objects.FindDrawable('txtTipo')).Text := IntToStr(solicitacao.tipo);
    TListItemText(Objects.FindDrawable('txtSituacao')).Text := solicitacao.situacao;
  end;
end;

procedure TfrmRegisterSolicitacoes.inserirNoBanco(solicitacao: TSolicitacao);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('INSERT INTO solicitacoes');
  FDQueryRegister.SQL.Add('(assunto, detalhamento, situacao, tipo)');
  FDQueryRegister.SQL.Add('VALUES(:assunto, :detalhamento, :situacao, :tipo)');

  solicitacao.codigo := -1;
  solicitacao.situacao := 'Aberto';
  preencherParamFromQuery(solicitacao, FDQueryRegister);

  FDQueryRegister.ExecSQL;
end;

procedure TfrmRegisterSolicitacoes.limparEdits;
begin
  edtCodigo.Text := '';
  edtAssunto.Text := '';
  mDetalhamento.Text := '';
  cbxTipo.ItemIndex := 0;
end;

procedure TfrmRegisterSolicitacoes.listarDoBanco;
var vSolicitacao : TSolicitacao;
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('SELECT * FROM solicitacoes');

  FDQueryRegister.Open();

  FDQueryRegister.First;

  lvSolicitacoes.Items.Clear;

  while not FDQueryRegister.Eof do
  begin
    vSolicitacao := preencherFieldFromQuery(vSolicitacao, FDQueryRegister);

    inserirNaLista(vSolicitacao);

    FDQueryRegister.Next;
  end;
end;

procedure TfrmRegisterSolicitacoes.lvSolicitacoesItemClickEx(
  const Sender: TObject; ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var vSolicitacao : TSolicitacao;
begin
  inherited;
  vSolicitacao.codigo := StrToInt(TListItemText(lvSolicitacoes.Items[ItemIndex].Objects.FindDrawable('txtCodigo')).Text);

  vSolicitacao := buscarNoBanco(vSolicitacao);

  edtCodigo.Text := IntToStr(vSolicitacao.codigo);
  edtAssunto.Text := vSolicitacao.assunto ;
  cbxTipo.ItemIndex := vSolicitacao.tipo;
  mDetalhamento.Text := vSolicitacao.detalhamento;


  operacao := 'editar';
  tcControle.TabIndex := 1;
  permitirTroca := False;
end;

function TfrmRegisterSolicitacoes.preencherFieldFromQuery(
  solicitacao: TSolicitacao; query: TFDQuery): TSolicitacao;
begin
  solicitacao.codigo :=  query.FieldByName('codigo').AsInteger;
  solicitacao.assunto := query.FieldByName('assunto').AsString;
  solicitacao.detalhamento := query.FieldByName('detalhamento').AsString;
  solicitacao.situacao := query.FieldByName('situacao').AsString;
  solicitacao.tipo := query.FieldByName('tipo').AsInteger;

  Result := solicitacao;
end;

function TfrmRegisterSolicitacoes.preencherObjeto(
  solicitacao: TSolicitacao): TSolicitacao;
begin
  solicitacao.assunto := edtAssunto.Text;
  solicitacao.detalhamento := mDetalhamento.Text;
  solicitacao.situacao := 'Aberto';
  solicitacao.tipo := cbxTipo.itemIndex;

  Result := solicitacao;
end;

function TfrmRegisterSolicitacoes.preencherParamFromQuery(
  solicitacao: TSolicitacao; query: TFDQuery) : TSolicitacao;
begin
  if solicitacao.codigo <> -1 then
  begin
    query.ParamByName('codigo').AsInteger := solicitacao.codigo;
  end;
  query.ParamByName('assunto').AsString := solicitacao.assunto;
  query.ParamByName('detalhamento').AsString := solicitacao.detalhamento;
  query.ParamByName('situacao').AsString := solicitacao.situacao;
  query.ParamByName('tipo').AsInteger := solicitacao.tipo;

  Result := solicitacao;
end;

procedure TfrmRegisterSolicitacoes.removerNoBanco(cod_solicitacao: Integer);
begin

end;

procedure TfrmRegisterSolicitacoes.tcControleChange(Sender: TObject);
begin
  inherited;
  ajustarComponentes;
  verificarOperacao;
  verificarPermissaoTroca;
end;

function TfrmRegisterSolicitacoes.validarCampos: Boolean;
begin
  if (edtAssunto.Text= '') or (mDetalhamento.Text= '') then
  begin
    ShowMessage('H� campos pendentes de preenchimento!');
    Result := False;
  end
  else if cbxTipo.ItemIndex = 0 then
  begin
    ShowMessage('Defina o tipo da solicitacao!');
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;

procedure TfrmRegisterSolicitacoes.verificarOperacao;
begin
  if (tcControle.TabIndex = 1) and (operacao = '') then
  begin
    tcControle.TabIndex := 0;

    ShowMessage('Selecione a solicitacao');
  end
end;

procedure TfrmRegisterSolicitacoes.verificarPermissaoTroca;
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

function TfrmRegisterSolicitacoes.ConfirmDialogSync(
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

end.
