unit WaitUnit;

interface

uses
  Windows,  Classes,  Forms,  Graphics;

procedure InitWt(ATxt:string;ARct:integer;FntSize:integer);
procedure StartWt;
procedure StopWt;

implementation

type
  TThrd=class(TThread)
    procedure Execute;override;
  end;

var Txt:string;
    hFnt:dword;

var TStrt:integer;
    Thrd:TThrd;
var ScrBmp,Bmp:TBitMap;
    BmpW:integer;
    BmpW2:integer;
    BmpX,BmpY:integer;
    FSize:integer;
    DC:dword;
    LF:TLogFont;
    FntClr:TColor;

procedure InitWt(ATxt:string;ARct:integer;FntSize:integer);
var X,Y:integer;
    C:TColor;
    SR,SG,SB:integer;
    KC:integer;
begin
  Txt:=ATxt;
  BmpW:=ARct;
  FSize:=FntSize;
  BmpX:=(Screen.WorkAreaWidth-BmpW)div 2;
  BmpY:=(Screen.WorkAreaHeight-BmpW)div 2;
  BmpW2:=BmpW div 2;
  ScrBmp:=TBitMap.Create;
  ScrBmp.Width:=BmpW;
  ScrBmp.Height:=BmpW;
  Bmp:=TBitMap.Create;
  Bmp.Width:=BmpW;
  Bmp.Height:=BmpW;
  DC:=GetDC(0);
  StretchBlt(ScrBmp.Canvas.Handle,0,0,BmpW,BmpW,DC,BmpX,BmpY,BmpW,BmpW,SRCCOPY);
  SR:=0;SG:=0;SB:=0;
  KC:=0;
  for Y:=0 to BmpW-1 do begin
    for X:=0 to BmpW-1 do begin
      C:=ScrBmp.Canvas.Pixels[X,Y];
      SR:=SR+GetRValue(C);
      SG:=SG+GetGValue(C);
      SB:=SB+GetBValue(C);
      KC:=KC+1;
    end;
  end;
  SR:=SR div KC; SG:=SG div KC; SB:=SB div KC;
  //SR:=255-SR;  SG:=255-SG;  SB:=255-SB;
  SR:=255 XOR SR;  SG:=255 XOR SG;  SB:=255 XOR SB;
  FntClr:=RGB(SR,SG,SB);
  ScrBmp.Canvas.Font.Name:='Times New Roman';
  ScrBmp.Canvas.Font.Height:=FSize;
  LF.lfHeight:=FSize;
  LF.lfWidth:=0;
  LF.lfEscapement:=0;
  LF.lfOrientation:=0;

  LF.lfWeight:=FW_BOLD;
  LF.lfItalic:=0;
  LF.lfUnderline:=0;
  LF.lfStrikeOut:=0;
  LF.lfCharSet:=RUSSIAN_CHARSET;
  LF.lfOutPrecision:=OUT_DEFAULT_PRECIS;
  LF.lfClipPrecision:=CLIP_DEFAULT_PRECIS;
  LF.lfQuality:=DEFAULT_QUALITY;
  LF.lfPitchAndFamily:=DEFAULT_PITCH;
  LF.lfFaceName:='Times New Roman';

  TStrt:=GetTickCount;

  Thrd:=TThrd.Create(true);
end;

procedure StartWt;
begin
  Thrd.Resume;
end;

procedure StopWt;
begin
  Thrd.Terminate;
  Thrd.Free;

  ScrBmp.Free;
  Bmp.Free;
  ReleaseDC(0,DC);
end;

procedure Render(T:single);
var n:integer;
    L:integer;
    F,FF,Fi,CF,SF:single;
    X,Y,DX,DY:integer;
    Sz:TSize;
    C:char;
begin
  Bmp.Canvas.CopyRect(Rect(0,0,BmpW,BmpW),ScrBmp.Canvas,Rect(0,0,BmpW,BmpW));
  Fi:=T*Pi/180*60;

  L:=Length(Txt);

  for n:=1 to L do begin
    C:=Txt[n];
    Sz:=ScrBmp.Canvas.TextExtent(C);

    F:=2*Pi/L*n;
    FF:=Fi-F;
    CF:=-Cos(FF);SF:=Sin(FF);
    X:=Round((BmpW2+FSize/2)*CF)+BmpW2;
    Y:=Round((BmpW2+FSize/2)*SF)+BmpW2;

    LF.lfEscapement:=Round((FF+Pi/2)*180/Pi*10);

    DX:=Round(Sz.cx/2*Sin(FF));
    DY:=Round(Sz.cx/2*Cos(FF));

    hFnt:=CreateFontInDirect(LF);
    Bmp.Canvas.Font.Handle:=hFnt;
    Bmp.Canvas.Font.Color:=FntClr;//clLime;
    Bmp.Canvas.Brush.Style:=bsClear;

    Bmp.Canvas.TextOut(X+DX,Y+DY,C);

    Bmp.Canvas.Font.Handle:=0;
    DeleteObject(hFnt);

  end;
  StretchBlt(DC,BmpX,BmpY,BmpW,BmpW,Bmp.Canvas.Handle,0,0,BmpW,BmpW,SRCCOPY);
end;

procedure TThrd.Execute;
var T:integer;
begin
  while(not Terminated)do begin
    T:=GetTickCount;
    Render((T-TStrt)/1000);
  end;
  StretchBlt(DC,BmpX,BmpY,BmpW,BmpW,ScrBmp.Canvas.Handle,0,0,BmpW,BmpW,SRCCOPY);
end;

end.