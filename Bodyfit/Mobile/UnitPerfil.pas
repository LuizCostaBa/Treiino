unit UnitPerfil;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TFrmPerfil = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgFechar: TImage;
    rectPerfil: TRectangle;
    Label1: TLabel;
    Image4: TImage;
    Image1: TImage;
    rectSenha: TRectangle;
    Label3: TLabel;
    Image5: TImage;
    Image6: TImage;
    rectDesconectar: TRectangle;
    Label2: TLabel;
    Image2: TImage;
    Image3: TImage;
    Label4: TLabel;
    procedure rectPerfilClick(Sender: TObject);
    procedure rectSenhaClick(Sender: TObject);
    procedure imgFecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPerfil: TFrmPerfil;

implementation

{$R *.fmx}

uses UnitPerfilCad, UnitPerfilSenha;

procedure TFrmPerfil.imgFecharClick(Sender: TObject);
begin
    close;
end;

procedure TFrmPerfil.rectPerfilClick(Sender: TObject);
begin
    if NOT Assigned(FrmPerfilCad) then
        Application.CreateForm(tFrmPerfilCad, FrmPerfilCad);

    FrmPerfilCad.Show;
end;

procedure TFrmPerfil.rectSenhaClick(Sender: TObject);
begin
    if NOT Assigned(FrmPerfilSenha) then
        Application.CreateForm(TFrmPerfilSenha, FrmPerfilSenha);

    FrmPerfilSenha.Show;
end;

end.
