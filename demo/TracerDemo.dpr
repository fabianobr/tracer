program TracerDemo;

uses
  Forms,
  uMain in 'uMain.pas' {Form1};

{$R *.RES}

begin
  TObject.create;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  application.Run;
end.
