unit uLibrary;

interface

uses  IniFiles, System.SysUtils, Vcl.Forms;

  procedure setValorIni(pLocal, pSessao, pSubSessao, pValor:string);
  function getValorIni(pLocal, pSessao, pSubSessao:string): string;
implementation

uses
  System.IOUtils;

procedure setValorIni(pLocal, pSessao, pSubSessao:string; pValor:string);
var vArquivo : TIniFile;
begin
    {vArquivo := TIniFile.Create(ExtractFilePath(Application.ExeName));}
    {pLocal := TPath.Combine(TPath.GetDocumentsPath, 'config.ini'); }
    vArquivo := TIniFile.Create(pLocal);
    vArquivo.WriteString(pSessao, pSubSessao, pValor);

    vArquivo.Free;
end;

function getValorIni(pLocal, pSessao, pSubSessao:string): string;
var vArquivo : TIniFile;
begin
    vArquivo := TIniFile.Create(pLocal);

    Result := vArquivo.ReadString(pSessao, pSubSessao, '');

    vArquivo.Free;

end;
end.
