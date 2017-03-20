unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, ImgList, StdCtrls, Menus, Buttons;

type
  TForm1 = class(TForm)
    ImageList: TImageList;
    PopupMenu1: TPopupMenu;
    AcionarAgora1: TMenuItem;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure AcionarAgora1Click(Sender: TObject);
    procedure EventoTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    procedure CriarTimer(qtd: Integer);
    procedure HabilitaDesabilitaTimer(habilita: boolean);

  public
    { Public declarations }
    Pt : TPoint;
    cont: Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.AcionarAgora1Click(Sender: TObject);
begin
  {Obtém o point no centro do Button1}
  Pt.x := Button1.Left + (Button1.Width div 2);
  Pt.y := Button1.Top + (Button1.Height div 2);
  {Converte Pt para as coordenadas da tela }
  Pt := ClientToScreen(Pt);
  Pt.x := Round(Pt.x * (65535 / Screen.Width));
  Pt.y := Round(Pt.y * (65535 / Screen.Height));

  Self.WindowState := wsMinimized;

  HabilitaDesabilitaTimer(True);
end;

procedure TForm1.Button1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Const
  SC_MOVE = $F012;
begin
  ReleaseCapture;
  (Sender as TWinControl).Perform(WM_SYSCOMMAND, SC_MOVE, 0);
end;

procedure TForm1.CriarTimer(qtd: Integer);
var
  FTimer: TTimer;
  i: Integer;
begin
  for i := 0 to qtd do
  begin
    FTimer          := TTimer.Create(Self);
    FTimer.Enabled  := False;
    FTimer.Interval := 1;
    FTimer.Name     := 'Timer' + IntToStr(i);
    FTimer.OnTimer  := EventoTimer;
  end;
end;

procedure TForm1.EventoTimer(Sender: TObject);
begin
  if GetAsyncKeyState(VK_Escape) <> 0 then
  begin
    HabilitaDesabilitaTimer(False);
    ShowMessage('Click Cancelado!');
  end
  else
  begin
    {Move o mouse}
    Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_MOVE, Pt.x, Pt.y, 0, 0);
    {Simula o pressionamento do botão esquerdo do mouse}
    Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTDOWN, Pt.x, Pt.y, 0, 0);
    { Simula soltando o botão esquerdo do mouse }
    Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTUP, Pt.x, Pt.y, 0, 0);
  end;

  Inc(Cont);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Self.Color                 := clFuchsia;
  Self.TransparentColor      := True;
  Self.TransparentColorValue := clFuchsia;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  qtd: String;
begin
  if (InputQuery('Click por milesegundos', 'Quantidade Click:', qtd)) then
    CriarTimer(StrToInt(qtd))
  else
    Application.Terminate;
end;

procedure TForm1.HabilitaDesabilitaTimer(habilita: boolean);
var
  i: Integer;
begin
  for i := 0 to Self.ComponentCount - 1 do
  begin
    if (Self.Components[i] is TTimer) then
    begin
      (Self.Components[i] as TTimer).Enabled := habilita;
    end;
  end;
end;

end.
