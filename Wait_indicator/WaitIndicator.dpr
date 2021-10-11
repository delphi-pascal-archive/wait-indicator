program WaitIndicator;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  WaitUnit in 'WaitUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
