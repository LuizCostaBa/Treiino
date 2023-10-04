unit UnitPerfilSenha;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TFrmPerfilSenha = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgFechar: TImage;
    Rectangle1: TRectangle;
    Edit1: TEdit;
    Edit2: TEdit;
    rectBtnLogin: TRectangle;
    btnLogin: TSpeedButton;
    procedure imgFecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPerfilSenha: TFrmPerfilSenha;

implementation

{$R *.fmx}

procedure TFrmPerfilSenha.imgFecharClick(Sender: TObject);
begin
    close;
end;

end.
