program prjGerenciador;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in '..\FORMS\uMain.pas' {frmMain},
  uDataModule in '..\FORMS\uDataModule.pas' {dmData: TDataModule},
  uLibrary in '..\CLASSES\uLibrary.pas',
  uConfigDatabase in '..\FORMS\uConfigDatabase.pas' {frmConfigDatabase},
  uRegister in '..\FORMS\uRegister.pas' {frmRegister},
  URegisterUser in '..\FORMS\URegisterUser.pas' {frmRegisterUser};


{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmData, dmData);
  Application.CreateForm(TfrmConfigDatabase, frmConfigDatabase);
  Application.CreateForm(TfrmRegister, frmRegister);
  Application.CreateForm(TfrmRegisterUser, frmRegisterUser);
  Application.Run;
end.
