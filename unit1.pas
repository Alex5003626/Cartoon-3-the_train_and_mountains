unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

const
  delta = 50;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  i,Sangle, Mangle, Wangle, FlDeltaX, Mdelta, TDeltaX, HDeltaX: integer;


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);   //при создании//
begin
  i:= 1;
  FlDeltaX:= 0;
  HDeltaX := -200;
  Wangle:= 0;
  Sangle:= 500;
  Mangle:= 0;
  Mdelta:= 0;
  TDeltaX:= 0;
  clientWidth:= 1000;
  ClientHeight:= 650;
end;

procedure rotate(var x : integer; var y : integer; angle : double);      // поворот //
var
  xbuf : double;
  rangle : double;
begin
   rangle := angle * pi / 180;
   xbuf := x * cos(rangle) + y * sin(rangle);
   y := Trunc(-x * sin(rangle) + y * cos(rangle));
   x := Trunc(xbuf);
end;


procedure CanvasBackground(Canvas: TCanvas);                          // небо //

begin

  Canvas.Clear;
  Canvas.Clear;

  if i < 30 then
    Canvas.Brush.Color:= RGBToColor(135, 206, 235);
    Canvas.FillRect(0, 0, 1500, 500);

  if (i > 29) and (i < 50) then
    Canvas.Brush.Color:= RGBToColor(141, 209, 254);
    Canvas.FillRect(0, 0, 1500, 500);

  if (i > 49) and (i < 65) then
    Canvas.Brush.Color:= RGBToColor(99, 192, 254);
    Canvas.FillRect(0, 0, 1500, 500);

  if (i > 64) and (i < 80) then
    Canvas.Brush.Color:= RGBToColor(19, 140, 251);
    Canvas.FillRect(0, 0, 1500, 500);

  if (i > 79) and (i < 100) then
      Canvas.Brush.Color:= RGBToColor(20, 112, 222);
      Canvas.FillRect(0, 0, 1500, 500);

  if (i > 99) and (i < 120) then
      Canvas.Brush.Color:= RGBToColor(16, 88, 175);
      Canvas.FillRect(0, 0, 1500, 500);

  if (i > 119) then
        Canvas.Brush.Color:= RGBToColor(14, 75, 150);
        Canvas.FillRect(0, 0, 1500, 500);

end;

procedure DrawMount(Canvas: TCanvas);                       // горы //
var
  j, DeltaX: integer;

begin
  DeltaX:= 0;


  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Width:= 1;
  Canvas.Pen.Color:= clBlack;


  for j:= 0 to 4 do
  begin
    Canvas.Brush.Color := clBlack;
    Canvas.Polygon([Point(0 + DeltaX + Mdelta - 200, 450 ),  Point(200 + DeltaX  + Mdelta - 200, 150), Point(400  + DeltaX + Mdelta - 200, 450)]);     // горы //
    Canvas.Brush.Color := clWhite;
    if i > 49 then
      Canvas.Brush.Color := RGBToColor(227, 227, 227);
    Canvas.Polygon([point(138  + DeltaX + Mdelta - 200, 247), point(190  + DeltaX + Mdelta - 200, 230), point(230  + DeltaX + Mdelta - 200, 250), point(265  + DeltaX + Mdelta - 200, 250), point(200  + DeltaX + Mdelta - 200, 150)]);   // снег //
    DeltaX:= DeltaX + 250;
  end;

end;

procedure Sun(Canvas: TCanvas);          // солнце //
var
  x, y: integer;
begin
  x:= 200;
  y:= 200;
  rotate(x, y, Sangle);

  Canvas.Pen.Width:= 1;
  Canvas.Pen.Color:= clBlack;
  Canvas.Brush.Color:= clYellow;
  if i > 64 then
    Canvas.Brush.Color := RGBToColor(255, 204, 0);
  Canvas.Ellipse(100+ x - 100, 300+ y - 100,100 + x,300 + y);
  if (Sangle > 250) then
  Sangle:= Sangle - 1;
end;

procedure Moon(Canvas: TCanvas);                    // луна //
var
  x, y: integer;
begin
  x:= 150;
  y:= 150;

  rotate(x, y, Mangle);

  Canvas.Pen.Width:= 1;
  Canvas.Pen.Color:= clBlack;
  Canvas.Brush.Color:= clWhite;
  Canvas.Ellipse(1000+ x - 100, 300+ y - 100,1000 + x,300 + y);

  if (Mangle > - 200) then
     Mangle:= Mangle - 1;

end;
                                                                    // пол  //
procedure Floor(Canvas: TCanvas);
var
  j: integer;
begin
  Canvas.Brush.Color:= RGBToColor(236, 220, 213);
  if (i > 64) and (i < 80) then
    Canvas.Brush.Color:= RGBToColor(230, 209, 200);

  if (i > 99) and (i < 120) then
      Canvas.Brush.Color:= RGBToColor(225, 206, 187);

  Canvas.Rectangle(0, 450, 1500, 700);

  Canvas.Pen.Color:= RGBToColor(102, 51, 0);
  Canvas.Pen.Width:= 5;

  for j:= 0 to 45 do
  begin
    Canvas.Line(j * delta - 1400 + FlDeltaX, 500, (j * delta) - 1410 + FlDeltaX, 550);   // шпалы //
  end;


  Canvas.Pen.Color:= RGBToColor(96, 96, 96);
  Canvas.Pen.Width:= 8;

  Canvas.Line(-1500 + FlDeltaX, 500, 1000 + FlDeltaX, 500);                        // рельсы //
  Canvas.Line(-1500 + FlDeltaX, 550, 1000 + FlDeltaX, 550);

end;

procedure Train(Canvas: TCanvas);                                      // поезд //
var
  n, DeltaTrain, x, y: integer;
begin
  DeltaTrain:= 0;

  x:= 20;
  y:= 20;
  rotate(x, y, Wangle);

  for n:= 1 to 3 do
  begin
    Canvas.Pen.Color:= clBlack;
    Canvas.Pen.Width:= 2;
    Canvas.Brush.Color:= clGray;
    Canvas.Rectangle(-400 - DeltaTrain + TDeltaX, 300, 0 - DeltaTrain + TDeltaX , 515);     //вагон//

    Canvas.Brush.Color:= clBlack;
    Canvas.Ellipse(-350 - DeltaTrain + TDeltaX, 500, -300 - DeltaTrain + TDeltaX, 550);    //колеса//
    Canvas.Ellipse(-100 - DeltaTrain + TDeltaX, 500, -50 - DeltaTrain + TDeltaX, 550);

    Canvas.Pen.Width:= 3;
    Canvas.Pen.Color:= clRed;
    Canvas.Line(-365 + 40 + TDeltaX - DeltaTrain, 0 + 525,-365 + x + 40 + TDeltaX - DeltaTrain, y + 525);                  // колеса катятся //
    Canvas.Line(-365 + 40 + 250 + TDeltaX - DeltaTrain, 0 + 525,-365 + x + 40 + 250 + TDeltaX - DeltaTrain, y + 525);

    Canvas.Pen.Color:= clBlack;
    Canvas.Brush.Color:= RGBToColor(245, 227, 1);
    Canvas.Rectangle(-350 - DeltaTrain + TDeltaX, 320, -250 - DeltaTrain + TDeltaX , 425);  //окна//
    Canvas.Rectangle(-150 - DeltaTrain + TDeltaX, 320, -50 - DeltaTrain + TDeltaX , 425);

    DeltaTrain:= DeltaTrain + 450;
  end;



  Canvas.Pen.Width:= 3;
  Canvas.Pen.Color:= clRed;
  Canvas.Line(-365 + 40 + TDeltaX, 0 + 525,-365 + x + 40 + TDeltaX, y + 525);
  Canvas.Line(-365 + 40 + 250 + TDeltaX, 0 + 525,-365 + x + 40 + 250 + TDeltaX, y + 525);


  Wangle:= Wangle - 15;
  TDeltaX:= TDeltaX + 20;
end;

                                                                           // звездюльки //
procedure Stars(Canvas: TCanvas);
var
  k, x1, y1: integer;
begin
  Canvas.Brush.Color:= clWhite;
  Canvas.Pen.Color:= clWhite;
  for k:= 0 to 30 do
  begin
    x1:= Random(1000);
    y1:= Random(300);
    Canvas.Ellipse(x1, y1, x1+2, y1+2 );
  end;
end;

procedure House(Canvas: TCanvas);            // дом //
var
  x, y: integer;
begin
  x:=32;
  y:= 32;

  rotate(x, y, Wangle + 20);

  Canvas.Pen.Color:= clBlack;
  Canvas.Pen.Width:= 1;
  Canvas.Brush.Color:= clGray;
  Canvas.Rectangle(-100 + HDeltaX, 100, 100 + HDeltaX, 500);

  Canvas.Pen.Width:= 2;
  Canvas.Brush.Color:= clWhite;
  Canvas.Ellipse(100 + HDeltaX, 200, 200 + HDeltaX, 300);

  Canvas.Pen.Color:= clBlack;
  Canvas.Pen.Width:= 3;
  Canvas.Line(150 + HDeltaX, 250, 150 + x + HDeltaX, 250 + y);

  if i < 120 then
    HDeltaX:= HDeltaX + 15;

end;

procedure TForm1.Button1Click(Sender: TObject);     //button//
begin

  Timer1.Enabled:=True;
end;

procedure TForm1.Button1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Timer1.Enabled:=False;
end;

procedure TForm1.Timer1Timer(Sender: TObject);          //при работе таймера//
begin
  CanvasBackground(Canvas);
  if (i > 100) then
    Stars(Canvas);
  Sun(Canvas);
  Moon(Canvas);
  DrawMount(Canvas);
  Floor(Canvas);
  if (i > 30) then
    Train(Canvas);


  i:= i + 1;
  if i < 120 then
    FlDeltaX:= FlDeltaX + 15;

  if Mdelta < 115 then
     Mdelta:= Mdelta + 1;

  if (i > 105) then
    House(Canvas);
end;

end.

