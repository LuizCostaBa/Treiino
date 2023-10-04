unit UnitExercicio;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.WebBrowser,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TFrmExercicio = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgFechar: TImage;
    WebBrowser1: TWebBrowser;
    lblDescricao: TLabel;
    procedure imgFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
  private
    Fid_exercicio: integer;
    procedure AjustarTamanhoVideo(browser: TWebBrowser);
    procedure LoadVideoYoutube(browser: TWebBrowser; video: string);
    procedure DadosExercicio;
    { Private declarations }
  public
    property id_exercicio: integer read Fid_exercicio write Fid_exercicio;
  end;

var
  FrmExercicio: TFrmExercicio;

const
  PROPORCAO = 0.5625;  // 1920x1080  (1080 dividido por 1920)


implementation

{$R *.fmx}

uses DataModule.Global;

procedure TFrmExercicio.AjustarTamanhoVideo(browser: TWebBrowser);
var
    w, h: integer;
begin
    w := Trunc(browser.width - 30);
    h := Trunc(w * PROPORCAO) + 10;

    browser.Height := h;
end;

procedure TFrmExercicio.LoadVideoYoutube(browser: TWebBrowser; video: string);
var
    html: string;
begin
    html := '<!DOCTYPE html>' +
      '<html>' +
      '<head>' +
      '<style>' +
      '.container {position: relative; overflow: hidden; width: 100%; padding-top: 56.25%;} ' +
      '.responsive-iframe {position: absolute; top: 0; left: 0; bottom: 0; right: 0; width: 100%; height: 100%;} ' +
      '</style>' +
      '<meta http-equiv="X-UA-Compatible" content="IE=edge"></meta>' + // compatibility mode
      '</head>' +
      '<body style="margin:0;height: 100%; overflow: hidden">' +
      //'<iframe width="' + inttostr(w) + '" height="' + inttostr(h) + '" ' +
      '<iframe class="responsive-iframe"  ' +
      'src="' + video +
      '?controls=0' +
      ' frameborder="0" ' +
      ' autoplay=1&rel=0&controls=0&showinfo=0" ' + // autoplay, no related videos, no info nor controls
      ' allow="autoplay" frameborder="0">' + // allow autoplay, no border
      '</iframe>' +
       '</body>' +
      '</html>';

    AjustarTamanhoVideo(browser);
    browser.LoadFromStrings(html, '');
end;

procedure TFrmExercicio.DadosExercicio;
begin
    DmGlobal.DetalheExercicio(id_exercicio);

    if DmGlobal.qryConsExercicio.FieldByName('url_video').AsString <> '' then
        LoadVideoYoutube(WebBrowser1, DmGlobal.qryConsExercicio.FieldByName('url_video').AsString)
    else
        WebBrowser1.Visible := false;

    lblTitulo.Text := DmGlobal.qryConsExercicio.FieldByName('exercicio').AsString;
    lblDescricao.Text := DmGlobal.qryConsExercicio.FieldByName('descr_exercicio').AsString;
end;


procedure TFrmExercicio.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmExercicio := nil;
end;

procedure TFrmExercicio.FormResize(Sender: TObject);
begin
    AjustarTamanhoVideo(WebBrowser1);
end;

procedure TFrmExercicio.FormShow(Sender: TObject);
begin
    DadosExercicio;
end;

procedure TFrmExercicio.imgFecharClick(Sender: TObject);
begin
    close;
end;

end.
