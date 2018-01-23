{$mode objfpc}{$H+}
Uses sysutils;

var 

  MyFile: TextFile;
  username, password, s, a: string;

  isUnique : boolean;
  len: integer;
  separator: array[1 .. 3] of integer;
  i, x, lastId, helper : integer;


begin

  if (not FileExists('data_user.csv')) then
    FileCreate ('data_user.csv');
    
  AssignFile(MyFile, 'data_user.csv');

  write('Register',#10);
  write('Username       : ');readln(username);
  write('Password       : ');readln(password);
 
  try
    reset(MyFile);
    i:= 1;
    x := 1;
    isUnique := true;
    lastId := 1;

    while not eof(MyFile) do
        begin           
            readln(MyFile, s);
            len:= Length(s);            
            x:= 1;

            for i:= 1 to len do
            begin
                if (s[i] = ',') then
                begin
                    separator[x]:=i;
                    inc(x);
                end;
            end;


            lastId := StrToInt(copy(s, 1, separator[1] - 1));

            helper := separator[2] - (separator[1] + 1);
            a := copy(s ,separator[1] + 1 ,helper);

            Writeln(a);

            if(isUnique) then isUnique := (username <> a);                       
        end;

    if isUnique then
    begin
        append(MyFile);
        inc(lastId);
        Writeln(MyFile, IntToStr(lastId) + ',' + username + ',' +password);
    end
    else
        Writeln('Username sudah dipakai');    
  finally
    CloseFile(MyFile)
  end
end.
