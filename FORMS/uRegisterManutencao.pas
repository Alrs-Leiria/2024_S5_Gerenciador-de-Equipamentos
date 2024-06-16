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
    lvEquipamentos: TListView;
  private
    { Private declarations }
  public
    { Public declarations }
    function  buscarNoBanco(manutec : TManutencao) : TManutencao;
    procedure inserirNoBanco(manutec : TManutencao);
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

end;


procedure TfrmRegisterManutencao.finalizaAcao;
begin
  limparEdits();
  operacao := '';
  permitirTroca := True;
  tcControle.TabIndex := 0;
end;

function TfrmRegisterManutencao.validarCampos: Boolean;
begin

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

procedure TfrmRegisterManutencao.atualizarNoBanco(manutec: TManutencao);
begin

end;

function TfrmRegisterManutencao.buscarNoBanco(
  manutec: TManutencao): TManutencao;
begin

end;

procedure TfrmRegisterManutencao.inserirNaLista(manutec: TManutencao);
begin

end;

procedure TfrmRegisterManutencao.inserirNoBanco(manutec: TManutencao);
begin

end;

procedure TfrmRegisterManutencao.listarDoBanco;
begin

end;

function TfrmRegisterManutencao.preencherFieldFromQuery(manutec: TManutencao;
  query: TFDQuery): TManutencao;
begin

end;

function TfrmRegisterManutencao.preencherObjeto(
  manutec: TManutencao): TManutencao;
begin

end;

function TfrmRegisterManutencao.preencherParamFromQuery(manutec: TManutencao;
  query: TFDQuery): TManutencao;
begin

end;

procedure TfrmRegisterManutencao.removerNoBanco(cod_manutec: Integer);
begin

end;
end.
