unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, WaitUnit, Buttons;

type
  TForm1 = class(TForm)
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  InitWt('подождите...  ',100,32);
  StartWt;
  Sleep(5000);
  StopWt;
end;

end.
