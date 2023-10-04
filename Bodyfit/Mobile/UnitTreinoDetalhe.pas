unit UnitTreinoDetalhe;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox;

type
  TFrmTreinoDetalhe = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgFechar: TImage;
    Label7: TLabel;
    lbExercicios: TListBox;
    rectBtnLogin: TRectangle;
    btnIniciar: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnIniciarClick(Sender: TObject);
    procedure lbExerciciosItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    Fid_treino: integer;
    Ftreino: string;
    procedure AddExercicio(id_exercicio: integer; titulo, subtitulo: string);
    procedure CarregarExercicios;
    { Private declarations }
  public
    property id_treino: integer read Fid_treino write Fid_treino;
    property treino: string read Ftreino write Ftreino;
  end;

var
  FrmTreinoDetalhe: TFrmTreinoDetalhe;

implementation

{$R *.fmx}

uses Frame.Treino, UnitTreinoCad, UnitExercicio, DataModule.Global;

procedure TFrmTreinoDetalhe.AddExercicio(id_exercicio: integer;
                                         titulo, subtitulo: string);
var
    item: TListBoxItem;
    frame: TFrameTreino;
begin
    item := TListBoxItem.Create(lbExercicios);
    item.Selectable := false;
    item.Text := '';
    item.Height := 90;
    item.Tag := id_exercicio;

    // Frame...
    frame := TFrameTreino.Create(item);
    frame.lblTitulo.Text := titulo;
    frame.lblSubtitulo.Text := subtitulo;

    item.AddObject(frame);

    lbExercicios.AddObject(item);
end;

procedure TFrmTreinoDetalhe.btnIniciarClick(Sender: TObject);
begin
    try
        DmGlobal.IniciarTreino(id_treino);

        if NOT Assigned(FrmTreinoCad) then
            application.CreateForm(TFrmTreinoCad, FrmTreinoCad);

        FrmTreinoCad.id_treino := id_treino;
        FrmTreinoCad.show;

    except on ex:exception do
        showmessage(ex.Message);
    end;
end;

procedure TFrmTreinoDetalhe.CarregarExercicios;
begin
    lbExercicios.Items.Clear;
    DmGlobal.ListarExercicios(id_treino);

    with DmGlobal.qryConsExercicio do
    begin
        while NOT EOF do
        begin
            AddExercicio(fieldbyname('id_exercicio').asinteger,
                         fieldbyname('exercicio').asstring,
                         fieldbyname('duracao').asstring);

            Next;
        end;
    end;
end;

procedure TFrmTreinoDetalhe.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmTreinoDetalhe := nil;
end;

procedure TFrmTreinoDetalhe.FormShow(Sender: TObject);
begin
    lblTitulo.Text := treino;
    CarregarExercicios;
end;

procedure TFrmTreinoDetalhe.imgFecharClick(Sender: TObject);
begin
    close;
end;

procedure TFrmTreinoDetalhe.lbExerciciosItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    if NOT Assigned(FrmExercicio) then
        Application.CreateForm(TFrmExercicio, FrmExercicio);

    FrmExercicio.id_exercicio := Item.Tag;
    FrmExercicio.show;
end;

end.
