unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.TabControl, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls,
  uLoading, uSession;

type
  TFrmLogin = class(TForm)
    Layout1: TLayout;
    Image1: TImage;
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabConta: TTabItem;
    rectLogin: TRectangle;
    Rectangle1: TRectangle;
    edtEmail: TEdit;
    edtSenha: TEdit;
    rectBtnLogin: TRectangle;
    btnLogin: TSpeedButton;
    lblConta: TLabel;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    edtContaNome: TEdit;
    EdtContaSenha: TEdit;
    Rectangle4: TRectangle;
    btnConta: TSpeedButton;
    lblLogin: TLabel;
    EdtContaEmail: TEdit;
    procedure btnLoginClick(Sender: TObject);
    procedure btnContaClick(Sender: TObject);
    procedure lblContaClick(Sender: TObject);
    procedure lblLoginClick(Sender: TObject);
  private
    procedure AbrirFormPrincipal;
    procedure ThreadLoginTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal, DataModule.Global;

procedure TFrmLogin.AbrirFormPrincipal;
begin
    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;
    FrmPrincipal.show;
    FrmLogin.Close;
end;

procedure TFrmLogin.ThreadLoginTerminate(Sender: TObject);
begin
    TLoading.Hide;

    if Sender is TThread then
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;

    AbrirFormPrincipal;
end;

procedure TFrmLogin.btnContaClick(Sender: TObject);
var
    t: TThread;
begin
    TLoading.Show(FrmLogin, '');

    t := TThread.CreateAnonymousThread(procedure
    begin
        DmGlobal.CriarContaOnline(edtContaNome.text, edtContaEmail.Text, edtContaSenha.Text);

        with DmGlobal.TabUsuario do
        begin
            DmGlobal.InserirUsuario(fieldbyname('id_usuario').asinteger,
                                    fieldbyname('nome').asstring,
                                    fieldbyname('email').asstring);

            TSession.ID_USUARIO := fieldbyname('id_usuario').asinteger;
            TSession.NOME := fieldbyname('nome').asstring;
            TSession.EMAIL := fieldbyname('email').asstring;
        end;
    end);

    t.OnTerminate := ThreadLoginTerminate;
    t.Start;
end;

procedure TFrmLogin.btnLoginClick(Sender: TObject);
var
    t: TThread;
begin
    TLoading.Show(FrmLogin, '');

    t := TThread.CreateAnonymousThread(procedure
    begin
        DmGlobal.LoginOnline(edtEmail.Text, edtSenha.Text);

        with DmGlobal.TabUsuario do
        begin
            DmGlobal.InserirUsuario(fieldbyname('id_usuario').asinteger,
                                    fieldbyname('nome').asstring,
                                    fieldbyname('email').asstring);

            TSession.ID_USUARIO := fieldbyname('id_usuario').asinteger;
            TSession.NOME := fieldbyname('nome').asstring;
            TSession.EMAIL := fieldbyname('email').asstring;
        end;
    end);

    t.OnTerminate := ThreadLoginTerminate;
    t.Start;
end;

procedure TFrmLogin.lblContaClick(Sender: TObject);
begin
    TabControl.GotoVisibleTab(1);
end;

procedure TFrmLogin.lblLoginClick(Sender: TObject);
begin
    TabControl.GotoVisibleTab(0);
end;

end.
