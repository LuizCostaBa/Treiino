unit UnitTreinoCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox;

type
  TFrmTreinoCad = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgFechar: TImage;
    Layout1: TLayout;
    lblProgresso: TLabel;
    rectFundoBarra: TRectangle;
    rectBarra: TRectangle;
    rectBtnLogin: TRectangle;
    btnConcluir: TSpeedButton;
    lbExercicios: TListBox;
    procedure FormShow(Sender: TObject);
    procedure imgFecharClick(Sender: TObject);
    procedure lbExerciciosItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure btnConcluirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    Fid_treino: integer;
    procedure AddExercicio(id_exercicio: integer; titulo, subtitulo: string;
      ind_concluido: boolean);
    procedure CarregarExercicios;
    procedure CalcularProgresso;
    { Private declarations }
  public
    property id_treino: integer read Fid_treino write Fid_treino;
  end;

var
  FrmTreinoCad: TFrmTreinoCad;

implementation

{$R *.fmx}

uses Frame.FichaExercicio, UnitExercicio, DataModule.Global, UnitTreinoDetalhe;

procedure TFrmTreinoCad.AddExercicio(id_exercicio: integer;
                                     titulo, subtitulo: string;
                                     ind_concluido: boolean);
var
    item: TListBoxItem;
    frame: TFrameFichaExercicio;
begin
    item := TListBoxItem.Create(lbExercicios);
    item.Selectable := false;
    item.Text := '';
    item.Width := Trunc(lbExercicios.Width * 0.85);
    item.Tag := id_exercicio;

    // Frame...
    frame := TFrameFichaExercicio.Create(item);
    frame.lblTitulo.Text := titulo;
    frame.lblSubtitulo.Text := subtitulo;

    item.AddObject(frame);

    lbExercicios.AddObject(item);
end;

function StringToBoolean(str: string): Boolean;
begin
    if str = 'S' then
        Result := true
    else
        Result := false;
end;

procedure TFrmTreinoCad.CarregarExercicios;
begin
    lbExercicios.Items.Clear;
    DmGlobal.ListarExerciciosAtividade;

    with DmGlobal.qryConsExercicio do
    begin
        while NOT EOF do
        begin
            AddExercicio(fieldbyname('id_exercicio').AsInteger,
                         fieldbyname('exercicio').AsString,
                         fieldbyname('duracao').AsString,
                         StringToBoolean(fieldbyname('ind_concluido').AsString));

            Next;
        end;
    end;

    CalcularProgresso;
end;


procedure TFrmTreinoCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.cafree;
    FrmTreinoCad := nil;
end;

procedure TFrmTreinoCad.FormShow(Sender: TObject);
begin
    rectBarra.Width := 0;
    CarregarExercicios;
end;

procedure TFrmTreinoCad.imgFecharClick(Sender: TObject);
begin
    close;
end;

procedure TFrmTreinoCad.btnConcluirClick(Sender: TObject);
begin
    DmGlobal.FinalizarTreino(id_treino);

    FrmTreinoDetalhe.Close;
    Close;
end;

procedure TFrmTreinoCad.CalcularProgresso;
var
    frame: TFrameFichaExercicio;
    i, qtd_concluido: integer;
begin
    qtd_concluido := 0;

    for i := 0 to lbExercicios.Items.Count - 1 do
    begin
        frame := lbExercicios.ItemByIndex(i).Components[0] as TFrameFichaExercicio;

        if frame.chkConcluido.isChecked then
            inc(qtd_concluido);
    end;

    lblProgresso.text := qtd_concluido.ToString + ' de ' + lbExercicios.Items.Count.ToString + ' concluídos';

    // Barras...
    rectBarra.Width := (qtd_concluido / lbExercicios.Items.Count) * rectFundoBarra.Width;

    //TAnimator.AnimateFloat(rectBarra, 'Width', (qtd_concluido / lbExercicios.Items.Count) * rectFundoBarra.Width, 0.5,
    //                      TAnimationType.&Out, TInterpolationType.Circular);
end;

procedure TFrmTreinoCad.lbExerciciosItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
     if NOT Assigned(FrmExercicio) then
        Application.CreateForm(TFrmExercicio, FrmExercicio);

    FrmExercicio.id_exercicio := Item.Tag;
    FrmExercicio.show;
end;

end.
