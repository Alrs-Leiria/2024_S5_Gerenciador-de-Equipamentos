unit uRegisterManutencao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uRegister, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.TabControl, FMX.Controls.Presentation, FMX.Edit,
  FMX.DateTimeCtrls, FMX.ListBox, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, uRegisterSolicitacoes, uRegisterEquipament, FMX.DialogService.Async,
  System.SyncObjs, FMX.DialogService;

type
  TManutencao = record
  codigo : integer;
  descricao, status : string;
  valor : Double;
  abertura, fechamento : TDate;
  equipamento : TEquipament;
  solicitacao : TSolicitacao;
  end;
  TfrmRegisterManutencao = class(TfrmRegister)
    Panel1: TPanel;
    lDescricao: TLabel;
    lEquipamento: TLabel;
    lStatus: TLabel;
    pManutencao: TPanel;
    lmEquipamento: TLabel;
    lmStatus: TLabel;
    ComboBox1: TComboBox;
    lmDataAbertura: TLabel;
    lmPrevisaoFechamento: TLabel;
    Edit1: TEdit;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    edtEquipamento: TEdit;
    mDescricao: TMemo;
    cbxStatus: TComboBox;
    lbHTipo: TListBoxGroupHeader;
    lbPendente: TListBoxItem;
    lbAndamento: TListBoxItem;
    lbConcluido: TListBoxItem;
    edtCodigo: TEdit;
    lCodigo: TLabel;
    dAbertura: TDateEdit;
    dFechamento: TDateEdit;
    lAbertura: TLabel;
    lPrevisao: TLabel;
    lvManutencao: TListView;
    edtValor: TEdit;
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnNewRegisterClick(Sender: TObject);
    procedure btnSaveRegisterClick(Sender: TObject);
    procedure btnCancelRegisterClick(Sender: TObject);
    procedure btnDeleteRegisterClick(Sender: TObject);
    procedure tcControleChange(Sender: TObject);
    procedure lvManutencaoItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  private
    { Private declarations }
  public
    { Public declarations }
    function  buscarNoBanco(manutec : TManutencao) : TManutencao;
    procedure inserirManutencaoNoBanco(manutec : TManutencao);
    procedure atualizarNoBanco(manutec : TManutencao);
    procedure removerNoBanco(cod_manutec : Integer);
    procedure listarDoBanco();

    function preencherObjeto(manutec : TManutencao) : TManutencao;
    function preencherParamFromQuery(manutec : TManutencao; query : TFDQuery) : TManutencao;
    function preencherFieldFromQuery(manutec : TManutencao; query : TFDQuery) : TManutencao;

    procedure inserirNaLista(manutec : TManutencao);

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
  frmRegisterManutencao: TfrmRegisterManutencao;
  frmRegisterEquipament: TfrmRegisterEquipament;

implementation


{$R *.fmx}

{ TfrmRegisterManutencao }
procedure TfrmRegisterManutencao.ajustarComponentes;
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
      cbxStatus.ItemIndex := 0;
    end else if operacao = 'editar' then
    begin

    end;
  end;
end;

procedure TfrmRegisterManutencao.limparEdits;
begin
  edtCodigo.Text := '';
  edtEquipamento.Text := '';
  edtValor.Text := '';
  mDescricao.Text := '';
  cbxStatus.ItemIndex := 1;
end;


procedure TfrmRegisterManutencao.finalizaAcao;
begin
  limparEdits();
  operacao := '';
  permitirTroca := True;
  tcControle.TabIndex := 0;
end;

procedure TfrmRegisterManutencao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  finalizaAcao;
end;

procedure TfrmRegisterManutencao.FormCreate(Sender: TObject);
begin
  inherited;
  ajustarComponentes;
  listarDoBanco;
  permitirTroca := True;
end;

procedure TfrmRegisterManutencao.tcControleChange(Sender: TObject);
begin
  inherited;
  ajustarComponentes;
  verificarOperacao;
  verificarPermissaoTroca;
end;

function TfrmRegisterManutencao.validarCampos: Boolean;
begin
  if (edtEquipamento.Text= '') or (edtValor.Text= '') or (mDescricao.Text= '') then
  begin
    ShowMessage('Há campos pendentes de preenchimento!');
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;

procedure TfrmRegisterManutencao.verificarOperacao;
begin
  if (tcControle.TabIndex = 1) and (operacao = '') then
  begin
    tcControle.TabIndex := 0;

    ShowMessage('Selecione a solicitacao');
  end
end;

procedure TfrmRegisterManutencao.verificarPermissaoTroca;
begin
    if (permitirTroca = False) and (tcControle.ActiveTab = tList) then
    begin
      if ConfirmDialogSync('Deseja cancelar a edição') then
      begin
        finalizaAcao;
      end
      else
      begin
        tcControle.TabIndex := 1;
      end;
    end;
end;

function TfrmRegisterManutencao.ConfirmDialogSync(
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

procedure TfrmRegisterManutencao.inserirNaLista(manutec: TManutencao);
begin
  with lvManutencao.Items.Add do
  begin
    TListItemText(Objects.FindDrawable('txtCodigo')).Text := IntToStr(manutec.codigo);
    TListItemText(Objects.FindDrawable('txtStatus')).Text := manutec.status;
    TListItemText(Objects.FindDrawable('txtEquipamento')).Text := manutec.equipamento.descricao;
    TListItemText(Objects.FindDrawable('txtPatrimonio')).Text := IntToStr(manutec.equipamento.patrimonio);
  end;
end;

procedure TfrmRegisterManutencao.btnCancelRegisterClick(Sender: TObject);
begin
  inherited;
  finalizaAcao;
end;

procedure TfrmRegisterManutencao.btnDeleteRegisterClick(Sender: TObject);
begin
  inherited;
  removerNoBanco(StrToInt(edtCodigo.Text));
  showMessage('Manutencao removida com sucesso!');
  finalizaAcao;
end;

procedure TfrmRegisterManutencao.btnNewRegisterClick(Sender: TObject);
begin
  inherited;
  limparEdits;
  operacao := 'inserir';
  tcControle.TabIndex := 1;
  permitirTroca := false;
end;

procedure TfrmRegisterManutencao.btnSaveRegisterClick(Sender: TObject);
var vManutencao : TManutencao;
begin
  inherited;
  if validarCampos() then
  begin
    vManutencao := preencherObjeto(vManutencao);

    if operacao = 'editar' then
    begin
      vManutencao.codigo := StrToInt(edtCodigo.Text);
      atualizarNoBanco(vManutencao);
      showMessage('Manutencao atualizado com sucesso!');
      finalizaAcao;
    end
    else if operacao = 'inserir' then
    begin
      inserirManutencaoNoBanco(vManutencao);
      showMessage('Manutencao cadastrado com sucesso!');
      finalizaAcao;
    end;
  end;
end;

procedure TfrmRegisterManutencao.atualizarNoBanco(manutec: TManutencao);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('UPDATE solicitacoes_manutencao SET');
  FDQueryRegister.SQL.Add('descricao = :descricao,');
  FDQueryRegister.SQL.Add('equipamento = :equipamento,');
  FDQueryRegister.SQL.Add('status = :status,');
  FDQueryRegister.SQL.Add('data_abertura = :data_abertura,');
  FDQueryRegister.SQL.Add('data_fechamento = :data_fechamento,');
  FDQueryRegister.SQL.Add('solicitacao = :solicitacao');
  FDQueryRegister.SQL.Add('WHERE codigo = :codigo');

  manutec := preencherParamFromQuery(manutec, FDQueryRegister);
  FDQueryRegister.ExecSQL;
end;

function TfrmRegisterManutencao.buscarNoBanco(
  manutec: TManutencao): TManutencao;
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('SELECT * FROM solicitacoes_manutencao');
  FDQueryRegister.SQL.Add('WHERE codigo = :codigo');
  FDQueryRegister.ParamByName('codigo').AsInteger := manutec.codigo;

  FDQueryRegister.Open();

  manutec := preencherFieldFromQuery(manutec, FDQueryRegister);

  Result := manutec;
end;

procedure TfrmRegisterManutencao.inserirManutencaoNoBanco(manutec: TManutencao);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('INSERT INTO solicitacoes_manutencao(equipamento, descricao, status, data_abertura, data_fechamento, solicitacao)');
  FDQueryRegister.SQL.Add('VALUES(:equipamento, :descricao, :status, :data_abertura, :data_fechamento, :solicitacao)');

  manutec.codigo := -1;
  manutec.status := 'Pendente';
  FDQueryRegister.ParamByName('equipamento');
  manutec := preencherParamFromQuery(manutec, FDQueryRegister);

  FDQueryRegister.ExecSQL;
end;

procedure TfrmRegisterManutencao.listarDoBanco;
var vManutencao : TManutencao;
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('SELECT * FROM solicitacoes_manutencao');

  FDQueryRegister.Open();

  FDQueryRegister.First;

  lvManutencao.Items.Clear;

  while not FDQueryRegister.Eof do
  begin
    vManutencao := preencherFieldFromQuery(vManutencao, FDQueryRegister);
    vManutencao.equipamento := frmRegisterEquipament.buscarEquipamentNoBanco(vManutencao.equipamento);
    inserirNaLista(vManutencao);

    FDQueryRegister.Next;
  end;
end;

procedure TfrmRegisterManutencao.lvManutencaoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var vManutencao : TManutencao;
begin
  inherited;
  vManutencao.codigo := StrToInt(TListItemText(lvManutencao.Items[ItemIndex].Objects.FindDrawable('txtCodigo')).Text);

  vManutencao := buscarNoBanco(vManutencao);

  edtCodigo.Text := IntToStr(vManutencao.codigo);
  edtEquipamento.Text := IntToStr(vManutencao.equipamento.codigo);
  edtValor.Text := FloatToStr(vManutencao.valor);
  mDescricao.Text := vManutencao.descricao;
  cbxStatus.ItemIndex := 1;

  operacao := 'editar';
  tcControle.TabIndex := 1;
  permitirTroca := False;
end;

procedure TfrmRegisterManutencao.removerNoBanco(cod_manutec: Integer);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;
  FDQueryRegister.SQL.Add('DELETE FROM solicitacoes_manutencao');
  FDQueryRegister.SQL.Add('WHERE codigo = :codigo');

  FDQueryRegister.ParamByName('codigo').AsInteger := cod_manutec;

  FDQueryRegister.ExecSQL;
end;

function TfrmRegisterManutencao.preencherFieldFromQuery(
  manutec: TManutencao; query: TFDQuery): TManutencao;
begin
  manutec.codigo :=  query.FieldByName('codigo').AsInteger;
  manutec.equipamento.codigo := query.FieldByName('equipamento').AsInteger;
  manutec.descricao := query.FieldByName('descricao').AsString;
  manutec.status := query.FieldByName('status').AsString;
  manutec.abertura :=  query.FieldByName('data_abertura').AsDateTime;
  manutec.fechamento :=  query.FieldByName('data_fechamento').AsDateTime;
  manutec.solicitacao.codigo :=  query.FieldByName('solicitacao').AsInteger;

  Result := manutec;
end;

function TfrmRegisterManutencao.preencherObjeto(
  manutec: TManutencao): TManutencao;
begin
  manutec.equipamento.codigo := StrToInt(edtEquipamento.Text);
  manutec.equipamento := frmRegisterEquipament.buscarEquipamentNoBanco(manutec.equipamento);
  manutec.descricao := mdescricao.Text;
  manutec.status :=  cbxStatus.Items[cbxStatus.ItemIndex];
  manutec.abertura := dAbertura.Date;
  manutec.fechamento := dFechamento.Date;
  manutec.solicitacao.codigo := 0;

  Result := manutec;
end;

function TfrmRegisterManutencao.preencherParamFromQuery(manutec: TManutencao;
  query: TFDQuery): TManutencao;
begin
  if manutec.codigo <> -1 then
  begin
    query.ParamByName('codigo').AsInteger := manutec.codigo;
  end;
  query.ParamByName('descricao').AsString := manutec.descricao;
  query.ParamByName('equipamento').AsInteger := manutec.equipamento.codigo;
  query.ParamByName('status').AsString := manutec.status;
  query.ParamByName('data_abertura').AsDateTime := manutec.abertura;
  query.ParamByName('data_fechamento').AsDateTime := manutec.fechamento;
  query.ParamByName('solicitacao').AsInteger := manutec.solicitacao.codigo;

  Result := manutec;
end;

end.
