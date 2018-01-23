program login;


{$mode objfpc}{$H+}

Uses sysutils;


type
  data_user = 
  record
        id : integer;
        username : string[50];
        password : string[20];
  end;

var 

  MyFile: TextFile;
  username, password, s, hasilUsername, hasilPassword: string;
  
  resultLogin: data_user;
  loginSuccess : boolean;
  len: integer;
  separator: array[1 .. 3] of integer;
  i, x, lastId : integer;

begin

  if (not FileExists('data_user.csv')) then
    FileCreate ('data_user.csv');
    
  AssignFile(MyFile, 'data_user.csv');

  write('Login',#10);
  write('Username       : ');readln(username);
  write('Password       : ');readln(password);
 
  try
    reset(MyFile);
    i:= 1;
    x := 1;
    loginSuccess := false;
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
            hasilUsername := copy(s ,separator[1] + 1 ,separator[2]-3);
            hasilPassword := copy(s ,separator[2] + 1 ,len-1);

            if(not loginSuccess) then
            begin
                loginSuccess := ((username = hasilUsername) and (password = hasilPassword));
                resultLogin.id := lastId;
                resultLogin.username := hasilUsername;
                resultLogin.password := hasilPassword;
            end;
        end;

    if loginSuccess then
    begin
        writeln('Login success',#10);
        writeln(#10, 'Data Anda : ');
        writeln('ID Anda : ', resultLogin.id);
        writeln('Username Anda : ', resultLogin.username);
        writeln('Password Anda : ', resultLogin.password);


    end
    else
        Writeln('Gagal login');    
  finally
    CloseFile(MyFile)
  end
end.
