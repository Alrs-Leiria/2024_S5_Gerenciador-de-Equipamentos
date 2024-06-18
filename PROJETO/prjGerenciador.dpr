program prjGerenciador;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in '..\FORMS\uMain.pas' {frmMain},
  uDataModule in '..\FORMS\uDataModule.pas' {dmData: TDataModule},
  uLibrary in '..\CLASSES\uLibrary.pas',
  uConfigDatabase in '..\FORMS\uConfigDatabase.pas' {frmConfigDatabase},
  uRegister in '..\FORMS\uRegister.pas' {frmRegister},
  URegisterUser in '..\FORMS\URegisterUser.pas' {frmRegisterUser},
  uRegisterEquipament in '..\FORMS\uRegisterEquipament.pas' {frmRegisterEquipament},
  uRegisterSolicitacoes in '..\FORMS\uRegisterSolicitacoes.pas' {frmRegisterSolicitacoes},
  uRegisterManutencao in '..\FORMS\uRegisterManutencao.pas' {frmRegisterManutencao},
  uRegisterLiberacao in '..\FORMS\uRegisterLiberacao.pas' {frmRegisterLiberacao},
  uLogin in '..\FORMS\uLogin.pas' {frmLogin},
  uRegisterAlocacao in '..\FORMS\uRegisterAlocacao.pas' {frmRegisterAlocacao},
  uRegisterOcorrencia in '..\FORMS\uRegisterOcorrencia.pas' {frmRegisterOcorrencia};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TdmData, dmData);
  Application.CreateForm(TfrmConfigDatabase, frmConfigDatabase);
  Application.CreateForm(TfrmRegister, frmRegister);
  Application.CreateForm(TfrmRegisterUser, frmRegisterUser);
  Application.CreateForm(TfrmRegisterEquipament, frmRegisterEquipament);
  Application.CreateForm(TfrmRegisterSolicitacoes, frmRegisterSolicitacoes);
  Application.CreateForm(TfrmRegisterManutencao, frmRegisterManutencao);
  Application.CreateForm(TfrmRegisterLiberacao, frmRegisterLiberacao);
  Application.CreateForm(TfrmRegisterAlocacao, frmRegisterAlocacao);
  Application.CreateForm(TfrmRegisterOcorrencia, frmRegisterOcorrencia);
  Application.Run;
end.
