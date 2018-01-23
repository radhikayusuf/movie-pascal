program main;

{$mode objfpc}{$H+}

uses crt,
  sysutils,
  cthreads,
  Classes;

type
  data_user = 
  record
        id : integer;
        username : string[50];
        password : string[20];
  end;

const
  pass = 'if6k';

var
  pimen : integer;
  mData: data_user;


{prosedur jika user benar memasukkan password akan masuk ke prosedur pilih film}
  procedure content; 
     begin    
     clrscr;
     WriteLn('Selamat Datang : ',mData.username,#10);
     WriteLn('--------------------------------------------------------------------------------');
     WriteLn('------------------------- SELAMAT DATANG DI HOME CINEMA! -----------------------');    
     WriteLn('--------------------------------------------------------------------------------');
     gotoxy(4,7);WriteLn('----------------');
     gotoxy(4,8);writeln('- 1.Pilih Film -');
     gotoxy(4,9);WriteLn('----------------');
     gotoxy(22,7);WriteLn('-----------------');
     gotoxy(22,8);WriteLn('- 2.Pilih Snack -');
     gotoxy(22,9);WriteLn('-----------------');
     gotoxy(41,7);WriteLn('----------------');
     gotoxy(41,8);WriteLn('-  3.History   -');
     gotoxy(41,9);WriteLn('----------------');
     gotoxy(59,7);WriteLn('----------------');
     gotoxy(59,8);WriteLn('-   4.Keluar   -');
     gotoxy(59,9);WriteLn('----------------');
     gotoxy(1,19);WriteLn('----------------------------');
     gotoxy(1,20);Write  ('- Masukan Pilihan Anda :');
     gotoxy(28,20);WriteLn('-');
     gotoxy(1,21);WriteLn('----------------------------');
     gotoxy(26,20);readln(pimen);
     gotoxy(1,23);
    
     case (pimen) of
        1 : writeln('var filmusr');
        2 : WriteLn('var snackusr');
        3 : WriteLn('var historyusr');
        4 : WriteLn('var exit');
     end;
  end;
{prosedur untuk daftar anggota}
  function daftar: boolean;

    var
      MyFile: TextFile;
      username, password, s, a: string;

      isUnique: boolean;
      len: integer;
      separator: array[1 .. 3] of integer;
      i, x, lastId : integer;

     begin
        clrscr;

        if (not FileExists('data_user.csv')) then
          FileCreate ('data_user.csv');  
        AssignFile(MyFile, 'data_user.csv');



        writeln('                 PENDAFTARAN HOME CINEMA');
        writeln('================================================================');
        writeln('Portal pendaftaran untuk menjadi anggota home cinema, memudahkan');
        writeln('pemesanan tiket bioskop.');
        writeln('================================================================',#10#10);
        Write('Username : ');readln(username);
        Write('Password : ');readln(password);

        try
          reset(MyFile);
          i:= 1;
          x := 1;
          isUnique := true;
          result := false;
          lastId := 0;

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
                  a := copy(s ,separator[1] + 1 ,separator[2]-3);

                  if(isUnique) then isUnique := (username <> a);                       
              end;

          if isUnique then
          begin
              append(MyFile);
              inc(lastId);
              Writeln(MyFile, IntToStr(lastId) + ',' + username + ',' +password);
              Writeln('Register berhasil, tekan <Enter> untuk kembali ke menu awal');                        
          end
          else
              Writeln('Username sudah dipakai');                    
        finally
          CloseFile(MyFile)          
        end;

        daftar := isUnique;

     end;

{prosedur untuk login anggota}
  function login: boolean;


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
        clrscr;
        writeln('                    MASUK HOME CINEMA');
        writeln('================================================================');
        writeln('Portal masuk/login home cinema, memudahkan');
        writeln('pemesanan tiket bioskop.');
        writeln('================================================================',#10#10);
        Write('Username : ');readln(username);
        Write('Password : ');readln(password);

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

              mData := resultLogin;
              login := loginSuccess;
          end
          else
              Writeln('Gagal login');                
              login := loginSuccess;
        finally
          CloseFile(MyFile)
        end

     end;

{prosedur menampikan tampilan awal}
  procedure main;

      var
        choose: integer;

       begin  
          writeln('                        HOME CINEMA');
          writeln('================================================================');
          writeln('1) Login');
          writeln('2) Register');
          writeln('================================================================',#10#10);
          Write('pilihan : ');readln(choose);        
          clrscr;
          case (choose) of
            1 : begin            
              if(login) then
              begin
                content;
              end
              else write('Gagal');
            end;
            2 : 
            begin            
              if(daftar) then
              begin
                main;
              end
              else write('Gagal');
            end;
         end;      

       end;


{program utama}
begin

clrscr;

main;

readln;
end.
