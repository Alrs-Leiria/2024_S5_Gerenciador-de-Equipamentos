unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  URegisterUser, uRegisterEquipament, uRegisterSolicitacoes,
  uRegisterManutencao, uRegisterAlocacao;

type
  TfrmMain = class(TForm)
    mMenu: TMainMenu;
    Cadastros: TMenuItem;
    Usuarios: TMenuItem;
    Equipamentos: TMenuItem;
    Operacional: TMenuItem;
    Solicitacoes: TMenuItem;
    Manutencao: TMenuItem;
    Gerencial: TMenuItem;
    Alocacao: TMenuItem;
    Realocacao: TMenuItem;
    procedure UsuariosClick(Sender: TObject);
    procedure EquipamentosClick(Sender: TObject);
    procedure SolicitacoesClick(Sender: TObject);
    procedure ManutencaoClick(Sender: TObject);
    procedure AlocacaoClick(Sender: TObject);
    procedure RealocacaoClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation


{$R *.fmx}


procedure TfrmMain.AlocacaoClick(Sender: TObject);
begin
  frmRegisterAlocacao.limparEdits;
  frmRegisterAlocacao.tcControle.Tabs[0].Visible := False;
  frmRegisterAlocacao.tcControle.Tabs[0].Enabled := False;
  frmRegisterAlocacao.dDevolucao.IsChecked := False;
  frmRegisterAlocacao.operacao := 'inserir';
  frmRegisterAlocacao.tcControle.TabIndex := 1;
  frmRegisterAlocacao.permitirTroca := false;
  frmRegisterAlocacao.Show;
end;

procedure TfrmMain.RealocacaoClick(Sender: TObject);
begin
  frmRegisterAlocacao.operacao := '';
  frmRegisterAlocacao.tcControle.Tabs[0].Visible := True;
  frmRegisterAlocacao.tcControle.Tabs[0].Enabled := True;
  frmRegisterAlocacao.tcControle.TabIndex := 0;
  frmRegisterAlocacao.Show;
end;

procedure TfrmMain.EquipamentosClick(Sender: TObject);
begin
  frmRegisterEquipament.tcControle.TabIndex := 0;
  frmRegisterEquipament.Show;
end;

procedure TfrmMain.ManutencaoClick(Sender: TObject);
begin
  frmRegisterManutencao.tcControle.TabIndex := 0;
  frmRegisterManutencao.Show;
end;

procedure TfrmMain.SolicitacoesClick(Sender: TObject);
begin
  frmRegisterSolicitacoes.tcControle.TabIndex := 0;
  frmRegisterSolicitacoes.Show;
end;

procedure TfrmMain.UsuariosClick(Sender: TObject);
begin
  frmRegisterUser.tcControle.TabIndex := 0;
  frmRegisterUser.Show;
end;

end.
