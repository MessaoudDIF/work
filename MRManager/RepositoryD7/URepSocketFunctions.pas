unit URepSocketFunctions;

interface

uses Windows, Forms, URepSocketTypes, Classes, SysUtils, IdComponent, IniFiles;

procedure ThreadFlow(Dados: TClientData);

function GetMsgDisconection(DR: TDisconnectReason): String;

implementation

uses URepSocketConsts, IdTCPConnection, uEncryptFunctions, uParamFunctions;


function PegaMutex(Dados: TClientData) : Boolean;
var
  TempMutex : Cardinal;
begin

  TempMutex := CreateMutex(nil, True, PChar(Dados.NomeCliente + '_replication'));

  Result := not (GetLastError = ERROR_ALREADY_EXISTS);

  if Result then
    Dados.Mutex := TempMutex
  else
    begin
      ReleaseMutex(TempMutex);
      CloseHandle(TempMutex);
      Dados.Mutex := 0;
    end;
end;

function HeaderVsINI(Dados: TClientData): Boolean;
var
  ValidationIni: TIniFile;
  APassword, AVersion: String;

begin
  ValidationIni := TIniFile.Create(Dados.ClientConfigFile);
  try
    AVersion  := ValidationIni.ReadString(Dados.NomeCliente, 'version', '');
    APassword := ValidationIni.ReadString(Dados.NomeCliente, Dados.NomeLoja, '');
    Result    :=
      ((APassword <> '') and (Dados.Senha = APassword)) and
      ((AVersion <> '') and (Dados.Versao = AVersion));
  finally
    ValidationIni.Free;
  end;
end;

function ValidateAutenticationHeader(Dados: TClientData;AH : TAutenticationHeader): Byte;
var
  sDecInfo : String;
begin
  Result := 1;
  Dados.ClientInfo  := {StrPas(}AH.ClientInfo{)};
  sDecInfo          := DecodeServerInfo(Dados.ClientInfo, 'NetCon', CIPHER_TEXT_STEALING, FMT_XX);

  Dados.NomeCliente := ParseParam(sDecInfo, CI_NOMECLIENTE);
  Dados.NomeLoja    := ParseParam(sDecInfo, CI_NOMELOJA);
  Dados.Versao      := ParseParam(sDecInfo, CI_VERSAO);
  Dados.Senha       := ParseParam(sDecInfo, CI_SENHA);
  Dados.PacketSize  := StrToInt(ParseParam(sDecInfo, CI_PACKETSIZE));
  Dados.ClientType  := AH.ClientType;


  if HeaderVsINI(Dados) then
  begin
    Result := 0;

    if not PegaMutex(Dados) then
    begin
      Result := 2;
      Dados.Logger.Log(Format('Servidor ocupado com o job %S', [Dados.NomeCliente]));
    end;

    if Result = 0 Then
      Dados.Logger.Log('Autentica��o Aceita');
  end;

  if Assigned(Dados.OnAutenticationEvent) then
    Dados.OnAutenticationEvent(Dados, AH);

end;

procedure SetReceivingFileHeader(Dados: TClientData; FH: TFileHeader);
begin
  Dados.ReceivingStream.Clear;
  Dados.ReceivingStream.Seek(soFromBeginning, 0);
  Dados.ReceivingSize    := FH.FileSize;
  Dados.ReceivingName    := FH.FileName;
  Dados.ReceivingDestiny := FH.FileDestiny;
end;

procedure HandleData(Dados: TClientData);
var
  FS : TFileStream;
  SaveDir : String;
begin
  // Posiciona o Stream de mem�ria no come�o
  Dados.ReceivingStream.Seek(soFromBeginning, 0);

  // Obtem o diret�rio correto para salvar o arquivo e cria se n�o existir
  SaveDir := ExtractFilePath(Application.ExeName) + Dados.ReceivingDestiny;


  if not DirectoryExists(SaveDir) then
    ForceDirectories(SaveDir);

  try
    FS := TFileStream.Create(SaveDir + Dados.ReceivingName, fmCreate, fmShareExclusive);
    try
      // Cria o arquivo com os dados em mem�ria
      FS.CopyFrom(Dados.ReceivingStream, Dados.ReceivingStream.Size);
    finally
      FS.Free;
    end;
  finally
    // Limpa o stream de mem�ria pois os dados j� est�o salvos
    Dados.ReceivingStream.Clear;
  end;
end;

procedure SendPreHeader(HeaderType : THeaderType; Dados: TClientData);
var
  PreHeader : TPreHeader;
begin
  FillChar(PreHeader, SizeOf(TPreHeader), 0);
  PreHeader.HeaderType := HeaderType;
  Dados.PreHeaderStream.Clear;
  Dados.PreHeaderStream.WriteBuffer(PreHeader, SizeOf(TPreHeader));
  Dados.Conn.WriteStream(Dados.PreHeaderStream, True, False, SizeOf(TPreHeader){Dados.PreHeaderStream.Size});
  Dados.PreHeaderStream.Clear;
  Dados.HeaderState := chsSendingHeader;
end;

function LoadDataToSend(Dados: TClientData): Boolean;
var
  FE : TFileStream;
  NomeArquivo : String;
  FileHeader : TFileHeader;
  AppDir: String;
  DestDir: String;
begin
  Result := Dados.SendingList.Count > 0;
  if not Result then
    Exit;
  try
    Dados.Logger.Log('Preparando arquivo para envio');
    Dados.HeaderStream.Clear;
    Dados.SendingStream.Clear;
    Dados.SendingSize := 0;
    Dados.SendingName := '';

    AppDir := ExtractFilePath(Application.ExeName);

    DestDir     := Dados.SendingList[0].Cliente + '\' + Dados.SendingList[0].Loja + '\';

    if Dados.IsClient then
      case Dados.ClientType of
        ctpClient:
        begin
          NomeArquivo := Format(FMT_CLIENT_OUTPUT_DIR, [AppDir]) + CLIENT_FILENAME;
          DestDir := Dados.NomeCliente + '\' + Dados.NomeLoja + '\';
        end;

        ctpProcessor:
        begin
          NomeArquivo := Format(FMT_SERVER_OUTPUT_DIR, [AppDir, Dados.NomeCliente]) + SERVER_FILENAME;
          DestDir     := Dados.NomeCliente + '\global\';
        end;
      end
    else
      case Dados.ClientType of
        ctpClient:
        begin
          NomeArquivo     := Format(FMT_SERVER_OUTPUT_DIR, [AppDir, Dados.NomeCliente]) + SERVER_FILENAME;
          DestDir         := 'global\';
        end;

        ctpProcessor:
          NomeArquivo     := Format(FMT_SERVER_RECEIVING_DIR, [AppDir, Dados.SendingList[0].Cliente, Dados.SendingList[0].Loja]) + CLIENT_FILENAME;
      end;

    if FileExists(NomeArquivo) then
      begin
        FE := TFileStream.Create(NomeArquivo, fmOpenRead, fmShareExclusive);
        try
          FE.Seek(soFromBeginning, 0);
          Dados.SendingStream.CopyFrom(FE, FE.Size);
          Dados.SendingSize    := Dados.SendingStream.Size;
          Dados.SendingName    := ExtractFileName(NomeArquivo);
          Dados.SendingStream.Seek(soFromBeginning, 0);
        finally
          FE.Free;
        end;
      end
    else
      Result := False;

    if Result then
    begin
      FillChar(FileHeader, SizeOf(TFileHeader), 0);
      FileHeader.FileName    := Dados.SendingName;
      FileHeader.FileSize    := Dados.SendingSize;
      FileHeader.FileDestiny := DestDir;
      Dados.HeaderStream.WriteBuffer(FileHeader, SizeOf(TFileHeader));
      Dados.Logger.Log('Arquivo preparado');
    end;
  except
    Dados.Logger.Log('Erro em LoadDataToSend');
    Dados.SendingSize := 0;
    Dados.SendingName := '';
    Result := False;
  end;
end;

function NeedToSend(Dados: TClientData): Boolean;
begin
  Result := LoadDataToSend(Dados);
end;


procedure PrepareFileRequest(Dados: TClientData);
var
  FileRequest: TFileRequest;
begin
  FillChar(FileRequest, 0, SizeOf(TFileRequest));
  FileRequest.RequestType := rsLocalFiles;
  Dados.HeaderStream.Clear;
  Dados.HeaderStream.WriteBuffer(FileRequest, SizeOf(TFileRequest));
  Dados.HeaderStream.Seek(soFromBeginning, 0)
end;

procedure PrepareAutentication(Dados: TClientData);
var
  AutenticationHeader: TAutenticationHeader;
  sDecInfo: String;
begin
  FillChar(AutenticationHeader, 0, SizeOf(TAutenticationHeader));
  //FillChar(AutenticationHeader.ClientInfo, Length(AutenticationHeader.ClientInfo), 0);
  {StrPCopy(AutenticationHeader.ClientInfo,   Dados.ClientInfo);}

  sDecInfo          := DecodeServerInfo(Dados.ClientInfo, 'NetCon', CIPHER_TEXT_STEALING, FMT_XX);

  Dados.NomeCliente := ParseParam(sDecInfo, CI_NOMECLIENTE);
  Dados.NomeLoja    := ParseParam(sDecInfo, CI_NOMELOJA);


  AutenticationHeader.ClientInfo  := Dados.ClientInfo;
  AutenticationHeader.NomeCliente := Dados.NomeCliente;
  AutenticationHeader.NomeLoja    := Dados.NomeLoja;
  AutenticationHeader.Versao      := Dados.Versao;
  AutenticationHeader.PacketSize  := Dados.PacketSize;
  AutenticationHeader.Senha       := Dados.Senha;
  AutenticationHeader.ClientType  := Dados.ClientType;
  Dados.HeaderStream.Clear;
  Dados.HeaderStream.WriteBuffer(AutenticationHeader, SizeOf(TAutenticationHeader));
  Dados.HeaderStream.Seek(soFromBeginning, 0)
end;

procedure PrepareDisconnection(Dados: TClientData);
var
  DisconnectHeader: TDisconnectHeader;
begin
  FillChar(DisconnectHeader, 0, SizeOf(TDisconnectHeader));
  DisconnectHeader.DisconnectReason := Dados.DisconnectReason;
  Dados.HeaderStream.Clear;
  Dados.HeaderStream.WriteBuffer(DisconnectHeader, SizeOf(TDisconnectHeader));
  Dados.HeaderStream.Seek(soFromBeginning, 0)
end;

procedure DoDisconnect(Dados: TClientData; DR: TDisconnectReason);
begin
  Dados.DisconnectReason := DR;
  Dados.HeaderState      := chsSendingPreHeader;
  Dados.SendMode         := csmSendingDisconnect;

  Dados.ReceivingStream.Clear;
  Dados.SendingStream.Clear;
end;


procedure RecebePreHeader(Dados: TClientData);
begin
  Dados.Logger.Log('chsWaitingPreHeader');

  // Verifica qual o tipo de Header a receber
  Dados.ReceivingStream.Clear;
  Dados.Conn.ReadStream(Dados.ReceivingStream,
                                SizeOf(TPreHeader));
  Dados.ReceivingStream.Seek(soFromBeginning, 0);

  // Atualiza que tipo de Header que deve ser esperado
  Dados.ActualHeader := TPreHeader(Dados.ReceivingStream.Memory^).HeaderType;
  Dados.ReceivingStream.Clear;

  // Sinaliza que os pr�ximos dados a receber far�o parte do header
  Dados.HeaderState    := chsWaitingHeader;
  Dados.LastSokcetOper := GetTickCount;
end;

procedure RecebeHeader(Dados: TClientData);
begin
  Dados.Logger.Log('chsWaitingHeader');
  // S� pode receber Header se est� autenticado ou header de autentica��o
  if not (((Dados.ActualHeader in [hsAutenticate]) or (Dados.Autenticated = 0) or Dados.IsClient)) then
    DoDisconnect(Dados, drInvalidAutentication);

  // A grava��o � a partir do in�cio do Stream
  Dados.ReceivingStream.Clear;

  case Dados.ActualHeader of
    hsAutenticate:
    begin
      Dados.Logger.Log('Cliente tentando autenticar');
      Dados.Conn.ReadStream(Dados.ReceivingStream, SizeOf(TAutenticationHeader));
      Dados.ReceivingStream.Seek(soFromBeginning, 0);

      // Autentica Conex�o
      Dados.Autenticated :=
        ValidateAutenticationHeader(Dados, TAutenticationHeader(Dados.ReceivingStream.Memory^));


      case Dados.Autenticated of
        0: // Autenticado
        begin
          // Ok, pr�ximo est�gio.
          Dados.Logger.Log(Format('Autentica��o para %S - %S aceita', [Dados.NomeCliente, Dados.NomeLoja]));
          Dados.HeaderState := chsSendingPreHeader;
          Dados.SendMode    := csmRequestingFile;
        end;
        1: // Autenticacao inv�lida
        begin
          // Dispensa �ltimo header
          Dados.Logger.Log(Format('Autentica��o inv�lida: %S - %S, desconectando...', [Dados.NomeCliente, Dados.NomeLoja]));
          DoDisconnect(Dados, drInvalidAutentication);
        end;

        2:
        begin
          // Dispensa �ltimo header
          Dados.Logger.Log(Format('Job %S rodando - servidor ocupado, desconectando...', [Dados.NomeCliente]));
          DoDisconnect(Dados, drServerBusy);
        end

      end
    end;

    hsFileRequest:
    begin
      Dados.Logger.Log('Arquivo Solicitado');
      Dados.Conn.ReadStream(Dados.ReceivingStream, SizeOf(TFileRequest));
      Dados.ReceivingStream.Seek(soFromBeginning, 0);
      Dados.HeaderState := chsSendingPreHeader;
      Dados.SendMode    := csmSendingFile;
    end;

    hsFile:
    begin
      // Preenche informa��es de recep��o para o servidor saber o nome
      // e o tamanho esperado do arquivo
      Dados.Logger.Log('Preparando recep��o de arquivo...');
      Dados.Conn.ReadStream(Dados.ReceivingStream, SizeOf(TFileHeader));
      SetReceivingFileHeader(Dados, TFileHeader(Dados.ReceivingStream.Memory^));
      Dados.HeaderState := chsReceivingBody;
    end;

    hsDisconnect:
    begin
      Dados.Logger.Log('Pedido de desconex�o recebido, desconectando...');
      Dados.Conn.ReadStream(Dados.ReceivingStream, SizeOf(TDisconnectHeader));
      Dados.DisconnectReason := TDisconnectHeader(Dados.ReceivingStream.Memory^).DisconnectReason;
      Dados.Conn.DisconnectSocket;
    end;

    else
      DoDisconnect(Dados, drInvalidHeader);
  end;

  Dados.ReceivingStream.Clear;
  Dados.LastSokcetOper := GetTickCount;
end;

procedure RecebeBody(Dados: TClientData);
begin
  Dados.Logger.Log('chsReceivingBody');
  // L� o tamanho especificado (em bytes) do bufer da conex�o
  // Isto permite que as outras conex�es tambem recebam uma
  // fatia do tempo do processador

  if (Dados.ReceivingSize - Dados.ReceivingStream.Size) < Dados.PacketSize then
    Dados.Conn.ReadStream(Dados.ReceivingStream, Dados.ReceivingSize - Dados.ReceivingStream.Size)
  else
    Dados.Conn.ReadStream(Dados.ReceivingStream, Dados.PacketSize);

  Dados.Logger.Log(Format('Recebidos %S de %S Bytes', [FormatFloat(',000', Dados.ReceivingStream.Size), FormatFloat(',000', Dados.ReceivingSize)]));
  // Se completou a recep��o chama a rotina de tratamento
  // de arquivo e passa para o primeiro est�gio do envio
  if Dados.ReceivingStream.Size = Dados.ReceivingSize then
  begin
    Dados.Logger.Log('Recep��o Concluida');
    Dados.Logger.Log('Tratando Dados');
    HandleData(Dados);
    Dados.Logger.Log('Dados Tratados');
    if Dados.IsClient then
      begin
        Dados.HeaderState := chsWaitingPreHeader;
        Dados.SendMode    := csmNone;
      end
    else
      begin
        Dados.HeaderState := chsSendingPreHeader;
        Dados.SendMode    := csmSendingFile;
      end

  end;
  Dados.LastSokcetOper := GetTickCount;
end;

procedure EnviandoPreHeader(Dados: TClientData);
begin
  Dados.Logger.Log('chsSendingPreHeader');
  case Dados.SendMode of
    csmSendingFile:
    begin
      if NeedToSend(Dados) then
        SendPreHeader(hsFile, Dados)
      else
        begin
          if Dados.IsClient then
            begin
              Dados.HeaderState      := chsNone;
              Dados.DisconnectReason := drNoClientFiles;
            end
          else
            DoDisconnect(Dados, drNoServerFiles);
        end;
    end;

    csmRequestingFile:
    begin
      SendPreHeader(hsFileRequest, Dados);
    end;

    csmSendingAutentication:
    begin
      SendPreHeader(hsAutenticate, Dados);
    end;

    csmSendingDisconnect:
    begin
      SendPreHeader(hsDisconnect, Dados);
    end;

  end;
  Dados.LastSokcetOper := GetTickCount;
end;

procedure EnviandoHeader(Dados: TClientData);
begin
  Dados.Logger.Log('chsSendingHeader');
  //Dados.Conn.OpenWriteBuffer();
  case Dados.SendMode of
      csmSendingFile:
      begin
        Dados.Logger.Log('Enviando Arquivo');
        if Dados.SendingSize > 0 then
          begin
            Dados.Conn.WriteStream(Dados.HeaderStream, True, False, Dados.HeaderStream.Size);
            Dados.HeaderState := chsSendingBody;
          end
        else
          begin
            if Dados.IsClient then
              begin
                Dados.HeaderState      := chsNone;
                Dados.DisconnectReason := drNoClientFiles;
              end
            else
              DoDisconnect(Dados, drError)
          end;
      end;

      csmRequestingFile:
      begin
        Dados.Logger.Log('Requisitando Arquivo');
        PrepareFileRequest(Dados);
        Dados.Conn.WriteStream(Dados.HeaderStream, True, False, Dados.HeaderStream.Size);

        Dados.HeaderState := chsWaitingPreHeader;
      end;

      csmSendingAutentication:
      begin
        Dados.Logger.Log('Enviando Autentica��o');
        PrepareAutentication(Dados);
        Dados.Conn.WriteStream(Dados.HeaderStream, True, False, Dados.HeaderStream.Size);
        Dados.HeaderState := chsWaitingPreHeader;
      end;

     csmSendingDisconnect:
     begin
        Dados.Logger.Log('Solicitando Desconex�o');
        PrepareDisconnection(Dados);
        Dados.Conn.WriteStream(Dados.HeaderStream, True, False, Dados.HeaderStream.Size);
        Dados.HeaderState := chsNone;
     end;
  end;
  //Dados.Conn.CloseWriteBuffer;

  //Dados.Conn.FlushWriteBuffer();
  //Dados.Conn.CloseWriteBuffer;

  Dados.LastSokcetOper := GetTickCount;
end;


procedure EnviandoBody(Dados: TClientData);
begin
  // Envia uma parte do corpo, incrementando a posi��o enviada a cada
  // "passada" no fluxo da thread at� a conclus�o do envio
  Dados.Logger.Log('chsSendingBody');
  if (Dados.SendingStream.Size - Dados.SendingStream.Position) < Dados.PacketSize then
    Dados.Conn.WriteStream(Dados.SendingStream, False, False,
                     Dados.SendingStream.Size - Dados.SendingStream.Position)
  else
    Dados.Conn.WriteStream(Dados.SendingStream, False, False, Dados.PacketSize);

  Dados.Logger.Log(Format('Enviados %S de %S Bytes', [FormatFloat(',000', Dados.SendingStream.Position), FormatFloat(',000', Dados.SendingStream.Size)]));

  if Dados.SendingStream.Position >= Dados.SendingStream.Size then
  begin
    Dados.Logger.Log('Envio Concluido');
    Dados.SendingStream.Clear;

    Dados.SendingList.Delete(0);

    if Dados.SendingList.Count > 0 then
      begin
        Dados.HeaderState := chsSendingPreHeader;
        Dados.SendMode    := csmSendingFile;
      end
    else
      begin
        if Dados.IsClient then
          begin
            Dados.HeaderState := chsWaitingPreHeader;
            Dados.SendMode    := csmNone;
          end
        else
          begin
            DoDisconnect(Dados, drTransactionOK);
          end
      end;
    end;
  Dados.LastSokcetOper := GetTickCount;
end;

procedure CheckTimeout(Dados: TClientData);
begin
  // Verifica se o tempo de cada "passada" pelo fluxo da Thread excedeu
  // o tempo de limite especificado
  if Dados.HoraAtual - Dados.LastSokcetOper >= Dados.TimeOut then
  begin
    Dados.Logger.Log('TIMEOUT' + IntToStr(Dados.HoraAtual - Dados.LastSokcetOper));
    if Dados.IsClient Then
      begin
        Dados.HeaderState      := chsNone;
        Dados.DisconnectReason := drTimeOut;
        Dados.Conn.DisconnectSocket;
      end
    else
      DoDisconnect(Dados, drTimeOut);
  end;
end;

procedure ThreadFlow(Dados: TClientData);
begin
  try
    Dados.HoraAtual := GetTickCount;
    if Dados.Conn.Connected then
    begin
      case Dados.HeaderState of
        // Inativo
        chsNone: Dados.Conn.DisconnectSocket;

        //-----------------------------------//
        (*         R E C E P � � O           *)

        // Aguardando PREVIEW do cabe�alho
        chsWaitingPreHeader:
          if Dados.CanRead then
            RecebePreHeader(Dados);

        // Aguardando CABE�ALHO
        chsWaitingHeader:
          if Dados.CanRead then
            RecebeHeader(Dados);

        // Recebendo o CORPO dos dados
        chsReceivingBody:
          if Dados.CanRead then
            RecebeBody(Dados);
        //----------------------------------//


        //----------------------------------//
        (*           E N V I O              *)

        // Enviando PREVIEW do cabe�alho
        chsSendingPreHeader:
          EnviandoPreHeader(Dados);

        // Enviando CABE�ALHO
        chsSendingHeader:
          EnviandoHeader(Dados);

        // Recebendo o CORPO de dados
        chsSendingBody:
          EnviandoBody(Dados);
        //----------------------------------//
      end;


      // Verifica se a opera��o excedeu o tempo especificado
      // ( TIMEOUT )
      if Dados.Conn.Connected then
        CheckTimeout(Dados);

      // Permite que as outras Threads do servidor tambem trabalhem
      if not Dados.IsClient then
        Sleep(0);

    end;
  except
    on E: Exception do
    begin
      Dados.DisconnectReason := drError;
      Dados.Logger.Log('Erro em ThreadFlow - '+E.Message);
      Dados.Conn.DisconnectSocket;
    end;
  end;
end;

function GetMsgDisconection(DR: TDisconnectReason): String;
begin
  Result := '';
  case DR of
    drTransactionOK:;
    drInvalidAutentication: Result := 'Autentica��o ou Vers�o inv�lida';
    drNoServerFiles:        Result := 'Sem arquivo no servidor';
    drNoClientFiles:        Result := 'Sem arquivos para enviar';
    drTimeOut:              Result := 'Tempo Excedido';
    drError:                Result := 'Erro Interno';
    drServerBusy:           Result := 'Servidor Ocupado';
  end;
end;



end.


