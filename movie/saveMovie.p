{$mode objfpc}{$H+}

Uses sysutils;


var 

  MyFile: TextFile;
  nama_film, s, a, b, c, d: string;
  no_studio, durasi: integer;

  isUnique : boolean;
  len: integer;
  separator: array[1 .. 3] of integer;
  i, x, lastId, helper : integer;


begin

  if (not FileExists('data_movie.csv')) then
    FileCreate ('data_movie.csv');
    
  AssignFile(MyFile, 'data_movie.csv');

  write('Pendaftaran Film',#10);
  write('Nama Film           : ');readln(nama_film);
  write('Durasi Film (menit) : ');readln(durasi);
  write('No Studio           : ');readln(no_studio);

  
  try
    reset(MyFile);
    i:= 1;
    x := 1;  
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

            helper := separator[2] - (separator[1] + 1);
            a := copy(s ,separator[1] + 1 , helper);

            helper := separator[3] - (separator[2] + 1);
            b := copy(s ,separator[2] + 1 , helper);

            c := copy(s ,separator[3] + 1 , len - 1);
        end;

    
    append(MyFile);
    inc(lastId);
    Writeln(MyFile, IntToStr(lastId) + ',' + nama_film + ',' +IntToStr(no_studio)+ ','+IntToStr(durasi));
    
  finally
    CloseFile(MyFile)
  end
end.