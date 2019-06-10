unit URunDOS;



interface

uses stdctrls, Windows, SysUtils, Forms, ShellApi;

procedure RunDosInList(Que:String;EnControl:TListBox; WaitForOutput : Boolean; Folder: String = '');


implementation


procedure RunDosInList(Que:String;EnControl:TListBox; WaitForOutput : Boolean; Folder: String = '');
  const
     CUANTOBUFFER = 10000;
  var
    Seguridades         : TSecurityAttributes;
    PaLeer,PaEscribir   : THandle;
    start               : TStartUpInfo;
    ProcessInfo         : TProcessInformation;
    Buffer              : Pchar;
    BytesRead           : DWord;
    CuandoSale          : DWord;
  begin
  if Folder<>'' then chdir(Folder);
    with Seguridades do
    begin
      nlength              := SizeOf(TSecurityAttributes);
      binherithandle       := true;
      lpsecuritydescriptor := nil;
    end;
    {Creamos el pipe...}
    if Createpipe (PaLeer, PaEscribir, @Seguridades, 0) then
    begin
      Buffer  := AllocMem(CUANTOBUFFER + 1);
      FillChar(Start,Sizeof(Start),#0);
      start.cb          := SizeOf(start);
      start.hStdError   := PaEscribir;
      start.hStdOutput  := PaEscribir;
      start.hStdInput   := PaLeer;
      start.dwFlags     := STARTF_USESTDHANDLES +
                           STARTF_USESHOWWINDOW;
      start.wShowWindow := SW_HIDE;

      if CreateProcess(nil,
         PChar(Que),
         @Seguridades,
         @Seguridades,
         true,
         NORMAL_PRIORITY_CLASS,
         nil,
         nil,
         start,
         ProcessInfo)
      then
        begin
          {Espera a que termine la ejecucion}
          repeat
            CuandoSale := WaitForSingleObject( ProcessInfo.hProcess,100);
            Application.ProcessMessages;
          until (CuandoSale <> WAIT_TIMEOUT);
          {Leemos la Pipe}
          repeat
            BytesRead := 0;
            {Llenamos un troncho de la pipe, igual a nuestro buffer}
            if WaitForOutput then ReadFile(PaLeer,Buffer[0],CUANTOBUFFER,BytesRead,nil);
            {La convertimos en una string terminada en cero}
            Buffer[BytesRead]:= #0;
            {Convertimos caracteres DOS a ANSI}
            OemToAnsi(Buffer,Buffer);
            EnControl.Items.Text := EnControl.Items.Text + String(Buffer);
          until (BytesRead < CUANTOBUFFER);
        end;
      FreeMem(Buffer);
      CloseHandle(ProcessInfo.hProcess);
      CloseHandle(ProcessInfo.hThread);
      CloseHandle(PaLeer);
      CloseHandle(PaEscribir);
    end;
  end;



end.
