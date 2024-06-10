unit uConfigDatabase;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, uLibrary, System.IOUtils,
  Data.DB, Data.SqlExpr;


type
  TfrmConfigDatabase = class(TForm)
    Image1: TImage;
    edtLocal: TEdit;
    Label1: TLabel;
    Button1: TButton;
    opnPastas: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure configuraIni();
  public
    { Public declarations }
  end;

var
  frmConfigDatabase: TfrmConfigDatabase;

implementation

{$R *.fmx}


{ TfrmConfigDatabase }

procedure TfrmConfigDatabase.Button1Click(Sender: TObject);
begin
  configuraIni;
end;

procedure TfrmConfigDatabase.configuraIni;
var
  vFileName: string;
begin
  if opnPastas.Execute then
  begin
    edtLocal.Text := opnPastas.FileName;
    vFileName := ExtractFilePath(ParamStr(0)) + 'config.ini';
    setValorIni(vFileName, 'CONFIGURACAO', 'LOCAL_DB', edtLocal.Text);
    ShowMessage('Pronto!');
    Self.Close;
  end;
end;

procedure TfrmConfigDatabase.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Application.Terminate;
end;

procedure TfrmConfigDatabase.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  Application.Terminate;
end;

end.
