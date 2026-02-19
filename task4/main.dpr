program WebApp;

uses
  Forms,
  // Здесь подключаем наши юниты
  SysUtils,
  Classes,
  IdHTTPWebBrokerBridge, // для работы с веб-сервером
  Web.WebReq,
  Web.WebBroker,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Phys,
  FireDAC.Phys.MSSQL,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.UI.Intf;

{$R *.res}

// Процедура инициализации приложения
procedure InitializeApp;
begin
  // Настройка подключения к БД
  FDManager.Setup;
  
  // Регистрация веб-модулей
  WebModuleClass := WebModuleClass;
  
  // Настройка веб-сервера
  WebRequestHandler := TIdHTTPWebBrokerBridge.Create(nil);
  try
    WebRequestHandler.WebRoot := ExtractFileDir(Application.ExeName);
    WebRequestHandler.DefaultPort := 8080;
    WebRequestHandler.Active := True;
  finally
    WebRequestHandler.Free;
  end;
end;

begin
  try
    Application.Initialize;
    InitializeApp;
    Application.Run;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end.
