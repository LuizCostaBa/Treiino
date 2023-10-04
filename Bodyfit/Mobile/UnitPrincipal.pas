unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ListBox, uLoading,
  uSession, System.DateUtils;

type
  TFrmPrincipal = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    lblNome: TLabel;
    imgPerfil: TImage;
    Layout2: TLayout;
    rectDashTreino: TRectangle;
    Layout3: TLayout;
    Image2: TImage;
    Label3: TLabel;
    rectFundoTreino: TRectangle;
    rectBarraTreino: TRectangle;
    lblQtdTreino: TLabel;
    Rectangle3: TRectangle;
    Layout4: TLayout;
    Image3: TImage;
    Label5: TLabel;
    rectFundoPontos: TRectangle;
    rectBarraPontos: TRectangle;
    lblPontos: TLabel;
    Label7: TLabel;
    rectSugestao: TRectangle;
    lblSugestao: TLabel;
    imgSugestao: TImage;
    Label9: TLabel;
    lbTreinos: TListBox;
    imgRefresh: TImage;
    procedure FormShow(Sender: TObject);
    procedure lbTreinosItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure imgPerfilClick(Sender: TObject);
    procedure rectSugestaoClick(Sender: TObject);
    procedure imgRefreshClick(Sender: TObject);
  private
    procedure CarregarTreinos;
    procedure AddTreino(id_treino: integer; titulo, subtitulo: string);
    procedure SincronizarTreinos;
    procedure ThreadSincronizarTerminate(Sender: TObject);
    procedure MontarDashboard;
    procedure MontarBarraProgresso;
    procedure MontarTreinoSugerido;
    procedure ThreadDashboardTerminate(Sender: TObject);
    procedure DetalhesTreino(id_treino: integer; treino: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses Frame.Treino, UnitTreinoDetalhe, UnitPerfil, DataModule.Global;

procedure TFrmPrincipal.AddTreino(id_treino: integer;
                                  titulo, subtitulo: string);
var
    item: TListBoxItem;
    frame: TFrameTreino;
begin
    item := TListBoxItem.Create(lbTreinos);
    item.Selectable := false;
    item.Text := '';
    item.Height := 90;
    item.Tag := id_treino;
    item.tagstring := titulo;

    // Frame...
    frame := TFrameTreino.Create(item);
    frame.lblTitulo.Text := titulo;
    frame.lblSubtitulo.Text := subtitulo;

    item.AddObject(frame);

    lbTreinos.AddObject(item);
end;

procedure TFrmPrincipal.CarregarTreinos;
begin
    lbTreinos.Items.Clear;
    Dmglobal.ListarTreinos;

    with DmGlobal.qryConsTreino do
    begin
        while NOT EOF do
        begin
            AddTreino(fieldbyname('id_treino').asinteger,
                      fieldbyname('treino').asstring,
                      fieldbyname('descr_treino').asstring);

            Next;
        end;
    end;
end;

procedure TFrmPrincipal.MontarBarraProgresso;
var
    porc: double;
begin
    porc := lblQtdTreino.Text.ToInteger / DaysInMonth(now);
    rectBarraTreino.Width := rectFundoTreino.Width * porc;

    porc := lblPontos.Text.ToInteger / 1000;
    rectBarraPontos.Width := rectFundoPontos.Width * porc;
end;

procedure TFrmPrincipal.MontarTreinoSugerido;
begin
    if DmGlobal.qryConsEstatistica.recordcount = 0 then
    begin
        lblSugestao.Text := 'Nenhuma sugestão';
        imgSugestao.Visible := false;
        rectSugestao.Tag := 0;
    end
    else
    begin
        lblSugestao.Text := DmGlobal.qryConsEstatistica.fieldbyname('descr_treino').asstring;
        imgSugestao.Visible := true;
        rectSugestao.Tag := DmGlobal.qryConsEstatistica.fieldbyname('id_treino').asinteger;
    end;
end;

procedure TFrmPrincipal.DetalhesTreino(id_treino: integer; treino: string);
begin
    if NOT Assigned(FrmTreinoDetalhe) then
        Application.CreateForm(TFrmTreinoDetalhe, FrmTreinoDetalhe);

    FrmTreinoDetalhe.id_treino := id_treino;
    FrmTreinoDetalhe.treino := treino;
    FrmTreinoDetalhe.Show;
end;

procedure TFrmPrincipal.rectSugestaoClick(Sender: TObject);
begin
    if rectSugestao.Tag > 0 then
        DetalhesTreino(rectSugestao.Tag, lblSugestao.text);
end;

procedure TFrmPrincipal.ThreadDashboardTerminate(Sender: TObject);
begin
    TLoading.Hide;
    CarregarTreinos;
end;

procedure TFrmPrincipal.MontarDashboard;
var
    t: TThread;
begin
    TLoading.Show(FrmPrincipal, '');

    t := TThread.CreateAnonymousThread(procedure
    var
        qtd_treino, pontos: integer;
    begin
        qtd_treino := DmGlobal.TreinosMes(now);
        pontos := DmGlobal.Pontuacao();
        DmGlobal.TreinoSugerido(now);

        TThread.Synchronize(TThread.CurrentThread, procedure
        begin
            lblQtdTreino.Text := qtd_treino.ToString;
            lblPontos.Text := pontos.ToString;

            MontarBarraProgresso;
            MontarTreinoSugerido;
        end);
    end);

    t.OnTerminate := ThreadDashboardTerminate;
    t.Start;
end;

procedure TFrmPrincipal.ThreadSincronizarTerminate(Sender: TObject);
begin
    TLoading.Hide;

    MontarDashboard;
end;

procedure TFrmPrincipal.SincronizarTreinos;
var
    t: TThread;
begin
    TLoading.Show(FrmPrincipal, '');

    t := TThread.CreateAnonymousThread(procedure
    begin
        DmGlobal.ListarTreinoExercicioOnline(TSession.ID_USUARIO);

        with DmGlobal.TabTreino do
        begin
            if recordcount > 0 then
                DmGlobal.ExcluirTreinoExercicio;

            while NOT EOF do
            begin
                DmGlobal.InserirTreinoExercicio(FieldByName('id_treino').AsInteger,
                                                FieldByName('treino').AsString,
                                                FieldByName('descr_treino').AsString,
                                                FieldByName('dia_semana').AsInteger,
                                                FieldByName('id_exercicio').AsInteger,
                                                FieldByName('exercicio').AsString,
                                                FieldByName('descr_exercicio').AsString,
                                                FieldByName('duracao').AsString,
                                                FieldByName('url_video').AsString);

                Next;
            end;
        end;
    end);

    t.OnTerminate := ThreadSincronizarTerminate;
    t.Start;
end;
procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    lblNome.Text := TSession.NOME;
    SincronizarTreinos;
end;

procedure TFrmPrincipal.imgPerfilClick(Sender: TObject);
begin
    if NOT Assigned(FrmPerfil) then
        Application.CreateForm(TFrmPerfil, FrmPerfil);

    FrmPerfil.Show;
end;

procedure TFrmPrincipal.imgRefreshClick(Sender: TObject);
begin
    MontarDashboard;
end;

procedure TFrmPrincipal.lbTreinosItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    DetalhesTreino(Item.tag, Item.tagstring);
end;

end.
