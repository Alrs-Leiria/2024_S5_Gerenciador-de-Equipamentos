unit uResgusterEquipament;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uRegister, FireDAC.Stan.Intf, FireDAC.Stan.Param, FireDAC.Phys.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.TabControl, FMX.Controls.Presentation;

type
  TfrmRegisterEquipament = class(TfrmRegister)
    procedure btnSaveRegisterClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRegisterEquipament: TfrmRegisterEquipament;

implementation

{$R *.fmx}

procedure TfrmRegisterEquipament.btnSaveRegisterClick(Sender: TObject);
begin
  inherited;

end;

end.
