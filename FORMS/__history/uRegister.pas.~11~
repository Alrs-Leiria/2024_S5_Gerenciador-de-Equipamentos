unit uRegister;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, uDataModule, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.Client, Data.DB, FireDAC.Comp.DataSet, FMX.Menus, FMX.TabControl;

type
  TfrmRegister = class(TForm)
    pnHead: TPanel;
    btnNewRegister: TButton;
    btnSaveRegister: TButton;
    btnDeleteRegister: TButton;
    btnCancelRegister: TButton;
    btnQuit: TButton;
    tcControle: TTabControl;
    tList: TTabItem;
    tAction: TTabItem;
    FDQueryRegister: TFDQuery;
    procedure btnNewRegisterClick(Sender: TObject);
    procedure btnSaveRegisterClick(Sender: TObject);
    procedure btnCancelRegisterClick(Sender: TObject);
    procedure btnDeleteRegisterClick(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRegister: TfrmRegister;

implementation

{$R *.fmx}

procedure TfrmRegister.btnNewRegisterClick(Sender: TObject);
begin
  if not(FDQueryRegister.State in [dsEdit, dsInsert]) then
  begin
    FDQueryRegister.Insert;
  end;

end;

procedure TfrmRegister.btnSaveRegisterClick(Sender: TObject);
begin
{
  if not(FDQueryRegister.State in [dsEdit, dsInsert]) then
  begin
    FDTransactionRegister.StartTransaction;
    FDQueryRegister.Post;
    FDTransactionRegister.RollbackRetaining;
  end;}
end;

procedure TfrmRegister.FormCreate(Sender: TObject);
begin
  FDQueryRegister.Open()
end;

procedure TfrmRegister.btnDeleteRegisterClick(Sender: TObject);
begin
  FDQueryRegister.Edit;
  FDQueryRegister.FieldByName('DT_EXCLUIDO').AsDateTime := Date;
  {FDTransactionRegister.StartTransaction;}
  FDQueryRegister.Post;
  {FDTransactionRegister.CommitRetaining;}
end;

procedure TfrmRegister.btnCancelRegisterClick(Sender: TObject);
begin
  if FDQueryRegister.State in [dsinserT, dsEdit] then
  begin
    FDQueryRegister.Cancel;
    {FDTransactionRegister.RollbackRetaining;}
  end;

end;

procedure TfrmRegister.btnQuitClick(Sender: TObject);
begin
  Self.Close;
end;

end.
