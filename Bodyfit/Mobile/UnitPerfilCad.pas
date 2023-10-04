unit UnitPerfilCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit;

type
  TFrmPerfilCad = class(TForm)
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
  FrmPerfilCad: TFrmPerfilCad;

implementation

{$R *.fmx}

procedure TFrmPerfilCad.imgFecharClick(Sender: TObject);
begin
    close;
end;

end.
