unit uRegisterLiberacao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uRegister, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.TabControl, FMX.Controls.Presentation,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Memo.Types, FMX.DateTimeCtrls, FMX.ListBox, FMX.ScrollBox,
  FMX.Memo, FMX.Edit, URegisteruser, uRegisterEquipament,
  uRegisterSolicitacoes, FMX.DialogService.Async,
  System.SyncObjs, FMX.DialogService;

type
TLiberacao = record
  codigo : Integer;
  descricao, status : string;
  abertura, fechamento : TDate;
  usuario : TUser;
  equipamento : TEquipament;
  solicitacao : TSolicitacao;
end;
  TfrmRegisterLiberacao = class(TfrmRegister)
    lvEquipamentos: TListView;
    Panel1: TPanel;
    lDescricao: TLabel;
    lEquipamento: TLabel;
    lStatus: TLabel;
    edtEquipamento: TEdit;
    mDescricao: TMemo;
    cbxStatus: TComboBox;
    lbPendente: TListBoxItem;
    lbHTipo: TListBoxGroupHeader;
    lbAndamento: TListBoxItem;
    lbConcluido: TListBoxItem;
    edtCodigo: TEdit;
    lCodigo: TLabel;
    dAbertura: TDateEdit;
    dFechamento: TDateEdit;
    lAbertura: TLabel;
    lPrevisao: TLabel;
    edtUsuario: TEdit;
    lUsuario: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    function  buscarNoBanco(liberacao : TLiberacao) : TLiberacao;
    procedure inserirNoBanco(liberacao : TLiberacao);
    procedure atualizarNoBanco(liberacao : TLiberacao);
    procedure removerNoBanco(cod_liberacao : Integer);
    procedure listarDoBanco();

    function preencherObjeto(liberacao : TLiberacao) : TLiberacao;
    function preencherParamFromQuery(liberacao : TLiberacao; query : TFDQuery) : TLiberacao;
    function preencherFieldFromQuery(liberacao : TLiberacao; query : TFDQuery) : TLiberacao;

    procedure inserirNaLista(liberacao : TLiberacao);

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
  frmRegisterLiberacao: TfrmRegisterLiberacao;

implementation

{$R *.fmx}

{ TfrmRegister1 }
procedure TfrmRegisterLiberacao.ajustarComponentes;
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

procedure TfrmRegisterLiberacao.limparEdits;
begin
  edtCodigo.Text := '';

end;


procedure TfrmRegisterLiberacao.finalizaAcao;
begin
  limparEdits();
  operacao := '';
  permitirTroca := True;
  tcControle.TabIndex := 0;
end;

function TfrmRegisterLiberacao.validarCampos: Boolean;
begin

end;

procedure TfrmRegisterLiberacao.verificarOperacao;
begin
  if (tcControle.TabIndex = 1) and (operacao = '') then
  begin
    tcControle.TabIndex := 0;

    ShowMessage('Selecione a solicitacao');
  end
end;

procedure TfrmRegisterLiberacao.verificarPermissaoTroca;
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

function TfrmRegisterLiberacao.ConfirmDialogSync(
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


procedure TfrmRegisterLiberacao.atualizarNoBanco(liberacao: TLiberacao);
begin

end;

function TfrmRegisterLiberacao.buscarNoBanco(liberacao: TLiberacao): TLiberacao;
begin

end;

procedure TfrmRegisterLiberacao.inserirNaLista(liberacao: TLiberacao);
begin

end;

procedure TfrmRegisterLiberacao.inserirNoBanco(liberacao: TLiberacao);
begin

end;

procedure TfrmRegisterLiberacao.listarDoBanco;
begin

end;

function TfrmRegisterLiberacao.preencherFieldFromQuery(liberacao: TLiberacao;
  query: TFDQuery): TLiberacao;
begin

end;

function TfrmRegisterLiberacao.preencherObjeto(liberacao: TLiberacao): TLiberacao;
begin

end;

function TfrmRegisterLiberacao.preencherParamFromQuery(liberacao: TLiberacao;
  query: TFDQuery): TLiberacao;
begin

end;

procedure TfrmRegisterLiberacao.removerNoBanco(cod_liberacao: Integer);
begin

end;
end.
