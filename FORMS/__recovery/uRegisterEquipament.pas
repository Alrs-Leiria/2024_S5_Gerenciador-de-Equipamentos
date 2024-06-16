unit uRegisterEquipament;

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
  System.SyncObjs, FMX.DialogService, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TEquipament = record
    codigo, patrimonio, tipo, departamento, ativo : Integer;
    descricao, marca, modelo, serie, observacao : string;
    data_cadastro, data_excluido : TDate;
    valor : Double;
  end;
  TfrmRegisterEquipament = class(TfrmRegister)
    edtCodigo: TEdit;
    edtDescricao: TEdit;
    edtSerie: TEdit;
    edtValor: TEdit;
    CODIGO: TLabel;
    MARCA: TLabel;
    SERIE: TLabel;
    DEPARTAMENTO: TLabel;
    lAtivo: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    DESCRICAO: TLabel;
    VALOR: TLabel;
    OBSERVACAO: TLabel;
    Label1: TLabel;
    cbxMarca: TComboBox;
    cbxModelo: TComboBox;
    cbxTipo: TComboBox;
    dDataCadastro: TDateEdit;
    checkAtivo: TCheckBox;
    Memo1: TMemo;
    PATRIMONIO: TLabel;
    edtPatrimonio: TEdit;
    lvEquipamentos: TListView;
    lbDell: TListBoxItem;
    lbHp: TListBoxItem;
    lbHMarca: TListBoxGroupHeader;
    lbModelo1: TListBoxItem;
    lbModelo2: TListBoxItem;
    lbHModelo: TListBoxGroupHeader;
    lbNotebook: TListBoxItem;
    lbImpressora: TListBoxItem;
    lbHTipo: TListBoxGroupHeader;
    cbxDepartamento: TComboBox;
    ListBoxGroupHeader2: TListBoxGroupHeader;
    lbDAdm: TListBoxItem;
    lbDTi: TListBoxItem;
    lbDAlmoxarifado: TListBoxItem;
    procedure btnSaveRegisterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tcControleChange(Sender: TObject);
    procedure btnNewRegisterClick(Sender: TObject);
    procedure btnCancelRegisterClick(Sender: TObject);
    procedure btnDeleteRegisterClick(Sender: TObject);
    procedure lvEquipamentosItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
  private
    { Private declarations }
    function  buscarEquipamentNoBanco( equip : TEquipament) : TEquipament;
    procedure inserirEquipamentNoBanco(equipament : TEquipament);
    procedure atualizarEquipamentNoBanco(equip : TEquipament);
    procedure removerEquipamentNoBanco(cod_equipamento : Integer);
    procedure listarEquipaments();

    function preencherObjetoEquipamento(equip : TEquipament) : TEquipament;
    function preencherEquipamentoFieldFromQuery(equip : TEquipament; query : TFDQuery) : TEquipament;
    function preencherEquipamentoParamFromQuery(equip : TEquipament; query : TFDQuery) : TEquipament;

    procedure inserirEquipamentoNaLista( equip : TEquipament);
    var operacao : string;
    var permitirTroca : Boolean;
  public
    { Public declarations }
    procedure limparEdits();

    procedure finalizaAcao();

    function validarCampos() : Boolean;
    procedure verificarOperacao();
    procedure verificarPermissaoTroca();
    function ConfirmDialogSync(const AMessage: String) : Boolean;
    procedure ajustarComponentes;
  end;

var
  frmRegisterEquipament: TfrmRegisterEquipament;

implementation

{$R *.fmx}
procedure TfrmRegisterEquipament.ajustarComponentes;
begin
  if tcControle.ActiveTab = tList then
  begin
    listarEquipaments;
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
      cbxMarca.ItemIndex := 0;
      cbxModelo.ItemIndex := 0;
      cbxTipo.ItemIndex := 0;
      cbxDepartamento.ItemIndex := 0;
    end else if operacao = 'editar' then
    begin
      checkAtivo.Visible := True;
      checkAtivo.Enabled := True;
      lAtivo.Visible := True;
    end;
  end;
end;

procedure TfrmRegisterEquipament.btnCancelRegisterClick(Sender: TObject);
begin
  inherited;
  finalizaAcao;
end;

procedure TfrmRegisterEquipament.btnDeleteRegisterClick(Sender: TObject);
begin
  inherited;
  removerEquipamentNoBanco(StrToInt(edtCodigo.Text));
  showMessage('Equipamento removido com sucesso!');
  finalizaAcao;
end;

procedure TfrmRegisterEquipament.btnNewRegisterClick(Sender: TObject);
begin
  inherited;
  operacao := 'inserir';
  tcControle.TabIndex := 1;
  permitirTroca := false;
end;

procedure TfrmRegisterEquipament.btnSaveRegisterClick(Sender: TObject);
var vEquip : TEquipament;
    tempEquip : TEquipament;
begin
  inherited;
  if validarCampos() then
  begin
    vEquip := preencherObjetoEquipamento(vEquip);

    if operacao = 'editar' then
    begin
      vEquip.codigo := StrToInt(edtCodigo.Text);
      tempEquip.codigo := StrToInt(edtCodigo.Text);

      tempEquip := buscarEquipamentNoBanco(tempEquip);
      if (vEquip.ativo = 0) and (tempEquip.ativo = 1) then
      begin
        if ConfirmDialogSync('Deseja inativar o equipamento') then
        begin
          vEquip.data_excluido := Date;
        end
        else
        begin
          vEquip.ativo := 1;
        end;
      end;
      atualizarEquipamentNoBanco(vEquip);
      showMessage('Equipamento atualizado com sucesso!');
      finalizaAcao;
    end
    else if operacao = 'inserir' then
    begin
      inserirEquipamentNoBanco(vEquip);
      showMessage('Equipamento cadastrado com sucesso!');
      finalizaAcao;
    end;
  end;
end;

function TfrmRegisterEquipament.buscarEquipamentNoBanco(
  equip: TEquipament): TEquipament;
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('SELECT * FROM equipamentos');
  FDQueryRegister.SQL.Add('WHERE codigo = :codigo');
  FDQueryRegister.ParamByName('codigo').AsInteger := equip.codigo;

  FDQueryRegister.Open();

  equip := preencherEquipamentoFieldFromQuery(equip, FDQueryRegister);

  Result := equip;
end;

function TfrmRegisterEquipament.ConfirmDialogSync(
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

procedure TfrmRegisterEquipament.atualizarEquipamentNoBanco(equip: TEquipament);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('UPDATE equipamentos SET');
  FDQueryRegister.SQL.Add('descricao = :descricao,');
  FDQueryRegister.SQL.Add('marca = :marca,');
  FDQueryRegister.SQL.Add('modelo = :modelo,');
  FDQueryRegister.SQL.Add('patrimonio = :patrimonio,');
  FDQueryRegister.SQL.Add('tipo = :tipo,');
  FDQueryRegister.SQL.Add('serie = :serie,');
  FDQueryRegister.SQL.Add('departamento = :departamento,');
  FDQueryRegister.SQL.Add('valor = :valor,');
  FDQueryRegister.SQL.Add('observacao = :observacao,');
  FDQueryRegister.SQL.Add('data_cadastro = :data_cadastro,');
  FDQueryRegister.SQL.Add('data_excluido = :data_excluido,');
  FDQueryRegister.SQL.Add('ativo = :ativo');

  FDQueryRegister.SQL.Add('WHERE codigo = :codigo');

  equip := preencherEquipamentoParamFromQuery(equip, FDQueryRegister);
  FDQueryRegister.ExecSQL;
end;

procedure TfrmRegisterEquipament.finalizaAcao;
begin
  limparEdits();
  operacao := '';
  permitirTroca := True;
  tcControle.TabIndex := 0;
end;

procedure TfrmRegisterEquipament.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  finalizaAcao;
end;

procedure TfrmRegisterEquipament.FormCreate(Sender: TObject);
begin
  inherited;
  ajustarComponentes;
  listarEquipaments;
  permitirTroca := True;
end;

procedure TfrmRegisterEquipament.inserirEquipamentNoBanco(
  equipament: TEquipament);
begin

  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('INSERT INTO equipamentos');
  FDQueryRegister.SQL.Add('(descricao, marca, modelo, patrimonio, tipo, serie, departamento, valor, observacao, data_cadastro, data_excluido, ativo)');
  FDQueryRegister.SQL.Add('VALUES(:descricao, :marca, :modelo, :patrimonio, :tipo, :serie, :departamento, :valor, :observacao, :data_cadastro, :data_excluido, :ativo)');

  equipament.codigo := -1;
  equipament.ativo := 1;
  preencherEquipamentoParamFromQuery(equipament, FDQueryRegister);

  FDQueryRegister.ExecSQL;
end;

procedure TfrmRegisterEquipament.inserirEquipamentoNaLista(equip: TEquipament);
begin
  with lvEquipamentos.Items.Add do
  begin
    TListItemText(Objects.FindDrawable('txtCodigo')).Text := IntToStr(equip.codigo);
    TListItemText(Objects.FindDrawable('txtDescricao')).Text := equip.descricao;
    TListItemText(Objects.FindDrawable('txtTipo')).Text := IntToStr(equip.tipo);
    TListItemText(Objects.FindDrawable('txtPatrimonio')).Text := IntToStr(equip.patrimonio);
    TListItemText(Objects.FindDrawable('txtSerie')).Text := equip.serie;
    TListItemText(Objects.FindDrawable('txtDepartamento')).Text := IntToStr(equip.departamento);

    if equip.ativo = 1 then
    begin
      TListItemText(Objects.FindDrawable('txtAtivo')).Text := 'Ativo';
    end
    else
    begin
      TListItemText(Objects.FindDrawable('txtAtivo')).Text := 'Inativo';
    end;

  end;
end;

procedure TfrmRegisterEquipament.limparEdits;
begin
  edtCodigo.Text := '';
  edtDescricao.Text := '';
  edtSerie.Text := '';
  edtPatrimonio.Text := '';
  edtValor.Text:= '';
  cbxMarca.ItemIndex := 0;
  cbxModelo.ItemIndex := 0;
  cbxTipo.ItemIndex := 0;
  cbxDepartamento.ItemIndex := 0;
  Memo1.Text := '';
end;

procedure TfrmRegisterEquipament.listarEquipaments;
var vEquip : TEquipament;
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('SELECT * FROM equipamentos');

  FDQueryRegister.Open();

  FDQueryRegister.First;

  lvEquipamentos.Items.Clear;

  while not FDQueryRegister.Eof do
  begin
    vEquip := preencherEquipamentoFieldFromQuery(vEquip, FDQueryRegister);

    inserirEquipamentoNaLista(vEquip);

    FDQueryRegister.Next;
  end;
end;

procedure TfrmRegisterEquipament.lvEquipamentosItemClickEx(
  const Sender: TObject; ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var vEquip : TEquipament;
begin
  inherited;
  vEquip.codigo := StrToInt(TListItemText(lvEquipamentos.Items[ItemIndex].Objects.FindDrawable('txtCodigo')).Text);

  vEquip := buscarEquipamentNoBanco(vEquip);

  edtCodigo.Text := IntToStr(vEquip.codigo);
  edtDescricao.Text := vEquip.descricao ;
  edtSerie.Text := vEquip.serie;
  edtPatrimonio.Text := IntToStr(vEquip.patrimonio);
  edtValor.Text:= FloatToStr(vEquip.valor);
  cbxTipo.ItemIndex := vEquip.tipo;
  cbxDepartamento.ItemIndex := vEquip.departamento;
  Memo1.Text := vEquip.observacao;

  if vEquip.marca = 'Dell' then
  begin
    cbxMarca.ItemIndex := 1;
  end
  else if vEquip.marca = 'Hp' then
  begin
    cbxMarca.ItemIndex := 2;
  end;

  if vEquip.modelo = 'Modelo 1' then
  begin
    cbxModelo.ItemIndex := 1;
  end
  else if vEquip.modelo = 'Modelo 2' then
  begin
    cbxModelo.ItemIndex := 2;
  end;

  if vEquip.ativo = 1 then
  begin
    checkAtivo.IsChecked := True;
  end
  else if vEquip.ativo = 0  then
  begin
    checkAtivo.IsChecked := False;
  end;

  operacao := 'editar';
  tcControle.TabIndex := 1;
  permitirTroca := False;
end;

function TfrmRegisterEquipament.preencherEquipamentoFieldFromQuery(
  equip: TEquipament; query: TFDQuery): TEquipament;
begin
  equip.codigo :=  query.FieldByName('codigo').AsInteger;
  equip.descricao := query.FieldByName('descricao').AsString;
  equip.marca := query.FieldByName('marca').AsString;
  equip.modelo := query.FieldByName('modelo').AsString;
  equip.serie := query.FieldByName('serie').AsString;
  equip.patrimonio := query.FieldByName('patrimonio').AsInteger;
  equip.valor := query.FieldByName('valor').AsInteger;
  equip.observacao := query.FieldByName('observacao').AsString;
  equip.tipo := query.FieldByName('tipo').AsInteger;;
  equip.departamento := query.FieldByName('departamento').AsInteger;
  equip.data_cadastro := query.FieldByName('data_cadastro').AsDateTime;
  equip.data_excluido := query.FieldByName('data_excluido').AsDateTime;
  equip.ativo := query.FieldByName('ativo').AsInteger;

  Result := equip;
end;

function TfrmRegisterEquipament.preencherEquipamentoParamFromQuery(
  equip: TEquipament; query: TFDQuery): TEquipament;
begin
  if equip.codigo <> -1 then
  begin
    query.ParamByName('codigo').AsInteger := equip.codigo;
  end;
  query.ParamByName('descricao').AsString := equip.descricao;
  query.ParamByName('marca').AsString := equip.marca;
  query.ParamByName('modelo').AsString := equip.modelo;
  query.ParamByName('patrimonio').AsInteger := equip.patrimonio;
  query.ParamByName('tipo').AsInteger := equip.tipo;
  query.ParamByName('serie').AsString := equip.serie;
  query.ParamByName('departamento').AsInteger := equip.departamento;
  query.ParamByName('valor').AsFloat := equip.valor;
  query.ParamByName('observacao').AsString := equip.observacao;
  query.ParamByName('data_cadastro').AsDate := equip.data_cadastro;
  query.ParamByName('data_excluido').AsDate := equip.data_excluido;
  query.ParamByName('ativo').AsInteger := equip.ativo;

  Result := equip;
end;

function TfrmRegisterEquipament.preencherObjetoEquipamento(
  equip: TEquipament): TEquipament;
begin
  equip.descricao := edtDescricao.Text;
  equip.serie := edtSerie.Text;
  equip.patrimonio := StrToInt(edtPatrimonio.Text);
  equip.valor := StrToFloat(edtValor.Text);
  equip.observacao := Memo1.Text;
  equip.tipo := 1;
  equip.departamento := 1;

  if cbxMarca.ItemIndex = 1 then
  begin
    equip.marca := 'Dell';
  end
  else if cbxMarca.ItemIndex = 2 then
  begin
    equip.marca := 'Hp';
  end;

  if cbxModelo.ItemIndex = 1 then
  begin
    equip.modelo := 'Modelo 1';
  end
  else if cbxModelo.ItemIndex = 2 then
  begin
    equip.modelo := 'Modelo 2';
  end;

  if checkAtivo.IsChecked = True then
  begin
    equip.ativo := 1;
  end
  else if checkAtivo.IsChecked = False then
  begin
    equip.ativo := 0;
  end;

  equip.data_cadastro := dDataCadastro.Date;
  equip.data_excluido := 0;

  Result := equip;
end;

procedure TfrmRegisterEquipament.removerEquipamentNoBanco(cod_equipamento : Integer);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;
  FDQueryRegister.SQL.Add('DELETE FROM equipamentos');
  FDQueryRegister.SQL.Add('WHERE codigo = :codigo');

  FDQueryRegister.ParamByName('codigo').AsInteger := cod_equipamento;

  FDQueryRegister.ExecSQL;
end;

procedure TfrmRegisterEquipament.tcControleChange(Sender: TObject);
begin
  inherited;
  ajustarComponentes;
  verificarOperacao;
  verificarPermissaoTroca;
end;

function TfrmRegisterEquipament.validarCampos: Boolean;
begin
  if (edtDescricao.Text= '') or (edtSerie.Text= '') or (edtPatrimonio.Text= '') or (edtValor.Text= '') then
  begin
    ShowMessage('Há campos pendentes de preenchimento!');
    Result := False;
  end
  else if cbxMarca.ItemIndex = 0 then
  begin
    ShowMessage('Defina a marca do equipamento!');
    Result := False;
  end
  else if cbxModelo.ItemIndex = 0 then
  begin
    ShowMessage('Defina o modelo do equipamento!');
    Result := False;
  end
  else if cbxTipo.ItemIndex = 0 then
  begin
    ShowMessage('Defina o tipo do equipamento!');
    Result := False;
  end
  else if cbxDepartamento.ItemIndex = 0 then
  begin
    ShowMessage('Defina o departamento do equipamento!');
    Result := False;
  end else
  begin
    Result := True;
  end;
end;

procedure TfrmRegisterEquipament.verificarOperacao;
begin
  if (tcControle.TabIndex = 1) and (operacao = '') then
  begin
    tcControle.TabIndex := 0;

    ShowMessage('Selecione o equipmento');
  end
end;

procedure TfrmRegisterEquipament.verificarPermissaoTroca;
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

end.
