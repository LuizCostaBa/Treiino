unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo;

type
  TFrmPrincipal = class(TForm)
    memo: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses Horse,
     Horse.Jhonson,
     Horse.BasicAuthentication,
     Horse.CORS,
     DataSet.Serialize.Config,
     Controllers.Global;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    THorse.Use(Jhonson());
    THorse.Use(CORS);

    THorse.Use(HorseBasicAuthentication(
    function(const AUsername, APassword: string): Boolean
    begin
        Result := AUsername.Equals('99coders') and APassword.Equals('112233');
    end));


    // Registro das rotas...
    Controllers.Global.RegistrarRotas;


    // Subir a aplicacao...
    THorse.Listen(3000, procedure(Horse: THorse)
    begin
        memo.Lines.Add('Servidor executando na porta 3000');
    end);
end;

end.
