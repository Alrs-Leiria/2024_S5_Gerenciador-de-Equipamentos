unit uRegisterEquipament;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uRegister, FireDAC.Stan.Intf, FireDAC.Stan.Param, FireDAC.Phys.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.TabControl, FMX.Controls.Presentation, FMX.Edit,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.DateTimeCtrls, FMX.ListBox;

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
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    DESCRICAO: TLabel;
    VALOR: TLabel;
    OBSERVACAO: TLabel;
    Label1: TLabel;
    cbxMarca: TComboBox;
    cbxModelo: TComboBox;
    cbxTipo: TComboBox;
    cbxDepartamento: TComboBox;
    dDataCadastro: TDateEdit;
    cBoxAtivo: TCheckBox;
    Memo1: TMemo;
    PATRIMONIO: TLabel;
    edtPatrimonio: TEdit;
    procedure btnSaveRegisterClick(Sender: TObject);
  private
    { Private declarations }
    procedure inserirEquipamentNoBanco(equipament : TEquipament);
  public
    { Public declarations }
  end;

var
  frmRegisterEquipament: TfrmRegisterEquipament;

implementation

{$R *.fmx}

procedure TfrmRegisterEquipament.btnSaveRegisterClick(Sender: TObject);
var vEquipament : TEquipament;
begin
  inherited;

  {vEquipament.codigo := StrToInt(edtCodigo.Text);}
  vEquipament.descricao := edtDescricao.Text;
  vEquipament.marca := 'Marca';
  vEquipament.modelo := 'Modelo';
  vEquipament.patrimonio := 10;
  vEquipament.tipo := 1;
  vEquipament.serie := edtSerie.Text;
  vEquipament.departamento := 1;
  vEquipament.valor := StrToFloat(edtValor.Text);
  vEquipament.ativo := 1;
  vEquipament.observacao := Memo1.Text;
  vEquipament.data_cadastro := dDataCadastro.Date;
  vEquipament.data_excluido := dDataCadastro.Date;

  inserirEquipamentNoBanco(vEquipament);

end;

procedure TfrmRegisterEquipament.inserirEquipamentNoBanco(
  equipament: TEquipament);
begin

  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('INSERT INTO equipamentos');
  FDQueryRegister.SQL.Add('(descricao, marca, modelo, patrimonio, tipo_equipamento, serie, departamento, valor, observacao, data_cadastro, data_excluido, ativo)');
  FDQueryRegister.SQL.Add('VALUES(:descricao, :marca, :modelo, :patrimonio, :tipo_equipamento, :serie, :departamento, :valor, :observacao, :data_cadastro, :data_excluido, :ativo)');

  FDQueryRegister.ParamByName('descricao').AsString := equipament.descricao;
  FDQueryRegister.ParamByName('marca').AsString := equipament.marca;
  FDQueryRegister.ParamByName('modelo').AsString := equipament.modelo;
  FDQueryRegister.ParamByName('patrimonio').AsInteger := equipament.patrimonio;
  FDQueryRegister.ParamByName('tipo_equipamento').AsInteger := equipament.tipo;
  FDQueryRegister.ParamByName('serie').AsString := equipament.serie;
  FDQueryRegister.ParamByName('departamento').AsInteger := equipament.departamento;
  FDQueryRegister.ParamByName('valor').AsFloat := equipament.valor;
  FDQueryRegister.ParamByName('observacao').AsString := equipament.observacao;
  FDQueryRegister.ParamByName('data_cadastro').AsDate := equipament.data_cadastro;
  FDQueryRegister.ParamByName('data_excluido').AsDate := equipament.data_excluido;
  FDQueryRegister.ParamByName('ativo').AsInteger := equipament.ativo;

  FDQueryRegister.ExecSQL;
end;

end.
