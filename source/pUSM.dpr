program pUSM;

uses
  Vcl.Forms,
  uUSM in 'uUSM.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  uSteamCMDinstaller in 'uSteamCMDinstaller.pas' {frmsteamcmdinstaller};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Aqua Graphite');
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tfrmsteamcmdinstaller, frmsteamcmdinstaller);
  Application.Run;
end.
