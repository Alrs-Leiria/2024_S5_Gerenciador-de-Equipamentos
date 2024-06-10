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
  TfrmRegisterEquipament = class(TfrmRegister)
    edtCodigo: TEdit;
    edtDescricao: TEdit;
    edtSenha: TEdit;
    edtTelefone: TEdit;
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
    DateEdit1: TDateEdit;
    cBoxAtivo: TCheckBox;
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRegisterEquipament: TfrmRegisterEquipament;

implementation

{$R *.fmx}

end.
