{
 ###                                                   #####  #######
  #  #    # ######  ####  #####   ####  ###### #####  #     # #
  #  ##   # #      #    # #    # #    # #      #    #       # #
  #  # #  # #####  #    # #    # #      #####  #    #  #####  ######
  #  #  # # #      #    # #####  #      #      #####  #             #
  #  #   ## #      #    # #   #  #    # #      #   #  #       #     #
 ### #    # #       ####  #    #  ####  ###### #    # #######  #####

 Follow me on Twitter for updates: https://twitter.com/inforcer25
 Subscribe to me on YouTube: https://www.youtube.com/Inforcer25
 GitHub: https://github.com/Inforcer25
 Donate to me: https://www.paypal.me/Inforcer25
}
unit uUSM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, uSteamCMDinstaller, DosCommand, ShellAPI,
  Tlhelp32, iniFiles;

type
  TForm1 = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    pgc1: TPageControl;
    tsserverconfig: TTabSheet;
    tsinstaller: TTabSheet;
    mmoinstaller: TMemo;
    btn1: TButton;
    img1: TImage;
    btn5: TButton;
    lbl1: TLabel;
    dscmnd1: TDosCommand;
    grp1: TGroupBox;
    lbledtloginname: TLabeledEdit;
    lbledtloginpass: TLabeledEdit;
    btn2: TButton;
    lbl2: TLabel;
    lbledtlogincode: TLabeledEdit;
    btnsubmitcode: TButton;
    lbl3: TLabel;
    btn3: TButton;
    btn4: TButton;
    procedure btn5Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure mmoinstallerChange(Sender: TObject);
    procedure btnsubmitcodeClick(Sender: TObject);
    function KillTask(ExeFileName: string): Integer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbledtlogincodeChange(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    settings_ini: string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
var
  loginname, loginpassword: string;
begin
  if FileExists('.\steamcmd\steamcmd.exe') then
    begin
      loginname := lbledtloginname.Text;
      loginpassword := lbledtloginpass.Text;

      dscmnd1.Stop;
      KillTask('steamcmd.exe');
      mmoinstaller.Lines.Add('Starting Server Installation...');
      dscmnd1.CommandLine := '.\steamcmd' + '\steamcmd.exe +login ' + loginname + ' ' + loginpassword + ' +force_install_dir "' + GetCurrentDir + '" +app_update 304930 +quit';
      dscmnd1.OutputLines := mmoinstaller.Lines;
      dscmnd1.Execute;
    end
  else
    begin
      ShowMessage('Please install SteamCMD first!');
    end;
end;

procedure TForm1.btn3Click(Sender: TObject);
var
  ini: TIniFile;
begin
  case MessageDlg('Are you sure you want to save your info? It will al be unencrypted!', mtConfirmation, [mbOK, mbCancel], 0) of
    mrOk:
      begin
        ini := TIniFile.Create(settings_ini);
        try
          ini.WriteString('Server Installer', 'login_name', lbledtloginname.Text);
          ini.WriteString('Server Installer', 'login_pass', lbledtloginpass.Text);
        finally
          ini.Free;
          ShowMessage('You info has been save in ' + settings_ini);
        end;
      end;
    mrCancel:
      begin
        ShowMessage('Your settings have not been saved.');
      end;
  end;
end;

procedure TForm1.btn5Click(Sender: TObject);
begin
  frmsteamcmdinstaller.ShowModal;
end;

procedure TForm1.btnsubmitcodeClick(Sender: TObject);
begin
  btnsubmitcode.Enabled := False;
  dscmnd1.SendLine(lbledtlogincode.Text, True);
  lbledtlogincode.Clear;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  KillTask('steamcmd.exe');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.Title := 'Unturned Server Manager';
  settings_ini := '.\settings.ini';
end;

procedure TForm1.mmoinstallerChange(Sender: TObject);
var
  lineNumber: integer;
begin
  for lineNumber := 0 to mmoinstaller.lines.count-1 do
    if Pos( 'Two-factor code:', mmoinstaller.lines[lineNumber] ) > 0 then
      begin
        btnsubmitcode.Enabled := True;
      end;
end;

function TForm1.KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(
                        OpenProcess(PROCESS_TERMINATE,
                                    BOOL(0),
                                    FProcessEntry32.th32ProcessID),
                                    0));
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

procedure TForm1.lbledtlogincodeChange(Sender: TObject);
begin
  lbledtlogincode.Text := UpperCase(lbledtlogincode.Text);
  lbledtlogincode.SelStart := Length(lbledtlogincode.Text);
end;

end.
