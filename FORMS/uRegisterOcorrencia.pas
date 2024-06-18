unit uRegisterOcorrencia;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uRegister, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Edit, FMX.TabControl, FMX.Controls.Presentation,
  uRegisterEquipament, URegisteruser;

type
  TOcorrencia = record
    codigo : Integer;
    equipamento : TEquipament;
    autor : TUser;
    tipo : String;
    data : TDate;
  end;
  TfrmRegisterOcorrencia = class(TfrmRegister)
  private
    { Private declarations }
  public
    { Public declarations }
    function  buscarNoBanco(ocorr : TOcorrencia) : TOcorrencia;
    procedure inserirNoBanco(ocorr : TOcorrencia);
    procedure atualizarNoBanco(ocorr : TOcorrencia);
    procedure removerNoBanco(cod_ocorr : Integer);
    procedure listarDoBanco();

    function preencherObjeto(ocorr : TOcorrencia) : TOcorrencia;
    function preencherParamFromQuery(ocorr : TOcorrencia; query : TFDQuery) : TOcorrencia;
    function preencherFieldFromQuery(ocorr : TOcorrencia; query : TFDQuery) : TOcorrencia;

  end;

var
  frmRegisterOcorrencia: TfrmRegisterOcorrencia;

implementation

{$R *.fmx}

{ TfrmRegister1 }

procedure TfrmRegisterOcorrencia.atualizarNoBanco(ocorr: TOcorrencia);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('UPDATE ocorrencia SET');
  FDQueryRegister.SQL.Add('equipamento = :equipamento,');
  FDQueryRegister.SQL.Add('autor = :autor,');
  FDQueryRegister.SQL.Add('data = :data,');
  FDQueryRegister.SQL.Add('tipo = :tipo');
  FDQueryRegister.SQL.Add('WHERE codigo = :codigo');

  ocorr := preencherParamFromQuery(ocorr, FDQueryRegister);
  FDQueryRegister.ExecSQL;
end;

function TfrmRegisterOcorrencia.buscarNoBanco(ocorr: TOcorrencia): TOcorrencia;
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('SELECT * FROM ocorrencia');
  FDQueryRegister.SQL.Add('WHERE codigo = :codigo');
  FDQueryRegister.ParamByName('codigo').AsInteger := ocorr.codigo;

  FDQueryRegister.Open();

  ocorr := preencherFieldFromQuery(ocorr, FDQueryRegister);

  Result := ocorr;

end;

procedure TfrmRegisterOcorrencia.inserirNoBanco(ocorr: TOcorrencia);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('INSERT INTO ocorrencia(equipamento, tipo, autor, data)');
  FDQueryRegister.SQL.Add('VALUES(:equipamento, :tipo, :autor, :data)');

  ocorr.codigo := -1;

  ocorr := preencherParamFromQuery(ocorr, FDQueryRegister);

  FDQueryRegister.ExecSQL;
end;

procedure TfrmRegisterOcorrencia.listarDoBanco;
var ocorr : TOcorrencia;
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;

  FDQueryRegister.SQL.Add('SELECT * FROM ocorrencia');

  FDQueryRegister.Open();

  FDQueryRegister.First;


  if not assigned(frmRegisterEquipament) then
    Application.CreateForm(TfrmRegisterEquipament,frmRegisterEquipament);
  while not FDQueryRegister.Eof do
  begin
    ocorr := preencherFieldFromQuery(ocorr, FDQueryRegister);
    ocorr.equipamento := frmRegisterEquipament.buscarEquipamentNoBanco(ocorr.equipamento);
    ocorr.autor := frmRegisterUser.buscarUsuarioNoBanco(ocorr.autor);

    {inserirNaLista(ocorr);}
    FDQueryRegister.Next;
  end;
end;

function TfrmRegisterOcorrencia.preencherFieldFromQuery(ocorr: TOcorrencia;
  query: TFDQuery): TOcorrencia;
begin

end;

function TfrmRegisterOcorrencia.preencherObjeto(ocorr: TOcorrencia): TOcorrencia;
begin

end;

function TfrmRegisterOcorrencia.preencherParamFromQuery(ocorr: TOcorrencia;
  query: TFDQuery): TOcorrencia;
begin
  if ocorr.codigo <> -1 then
  begin
    query.ParamByName('codigo').AsInteger := ocorr.codigo;
  end;

  query.ParamByName('equipamento').AsInteger := ocorr.equipamento.codigo;
  query.ParamByName('autor').AsInteger := ocorr.autor.id;
  query.ParamByName('data').AsDateTime := ocorr.data;
  query.ParamByName('tipo').AsString := ocorr.tipo;

  Result := ocorr;
end;

procedure TfrmRegisterOcorrencia.removerNoBanco(cod_ocorr: Integer);
begin
  FDQueryRegister.Close;
  FDQueryRegister.SQL.Clear;
  FDQueryRegister.SQL.Add('DELETE FROM ocorrencia');
  FDQueryRegister.SQL.Add('WHERE codigo = :codigo');

  FDQueryRegister.ParamByName('codigo').AsInteger := cod_ocorr;

  FDQueryRegister.ExecSQL;
end;

end.
