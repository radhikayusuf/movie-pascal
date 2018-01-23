{$mode objfpc}{$H+}

Uses sysutils;

  type
    data_movie = 
    record
          id : integer;
          nama_film : string[50];
          studio : integer;
          durasi : integer;      
    end;

    array_data_movie = array of data_movie;


  function getMovieSize: integer;
    var 

      MyFile: TextFile;
      s: string;  
      panjang : integer;

    begin
    if (not FileExists('data_movie.csv')) then
      FileCreate ('data_movie.csv');
    
    AssignFile(MyFile, 'data_movie.csv');

    try
      reset(MyFile);        
    
       while not eof(MyFile) do    
          begin                         
             readln(MyFile, s);        
             inc(panjang);                       
          end;

      
    finally
      CloseFile(MyFile);    
      getMovieSize := panjang;

    end
    end;

  function getMovie: array_data_movie;
    var 
      MyFile: TextFile;
      s, a, b, c: string;  


      len: integer;
      separator: array[1 .. 3] of integer;
      hasil: array of data_movie;

      index, panjang, i, x, lastId, helper : integer;

    begin
    if (not FileExists('data_movie.csv')) then
      FileCreate ('data_movie.csv');
    
    AssignFile(MyFile, 'data_movie.csv');

    try
      reset(MyFile);
      i:= 1;
      x := 1;  
      lastId := 0;
      index:= 1;
          
      getMovieSize;
      setLength(hasil, getMovieSize);

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

              hasil[index].id := lastId;
              hasil[index].nama_film := a;
              hasil[index].studio := StrToInt(b);
              hasil[index].durasi := StrToInt(c);

             inc(index);                       
          end;
          
    finally
      CloseFile(MyFile);
    

      getMovie := hasil;

    end
    end;

  function saveMovie: boolean;
    var 

    MyFile: TextFile;
    nama_film, s: string;
    no_studio, durasi: integer;
  
    len: integer;
    separator: array[1 .. 3] of integer;
    i, x, lastId : integer;
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
            end;

        
        append(MyFile);
        inc(lastId);
        Writeln(MyFile, IntToStr(lastId) + ',' + nama_film + ',' +IntToStr(no_studio)+ ','+IntToStr(durasi));
        saveMovie:= true;
        
      finally
        CloseFile(MyFile)
      end
    end;

  function editMovie(paramId: integer; paramData: data_movie): boolean;
    var 
      MyFile: TextFile;
      s, a, b, c: string;  


      len: integer;
      separator: array[1 .. 3] of integer;
      hasil: array of data_movie;

      index, panjang, i, x, lastId, helper : integer;
      kembali: boolean = false;

    begin
      if (not FileExists('data_movie.csv')) then
        FileCreate ('data_movie.csv');
      
      AssignFile(MyFile, 'data_movie.csv');

      try
        reset(MyFile);
        i:= 1;
        x := 1;  
        lastId := 0;
        index:= 1;
            
        getMovieSize;
        setLength(hasil, getMovieSize);

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

                hasil[index].id := lastId;
                hasil[index].nama_film := a;
                hasil[index].studio := StrToInt(b);
                hasil[index].durasi := StrToInt(c);

               inc(index);                       
            end;



            Rewrite(MyFile);

            for i:= 1 to (index - 1) do
            begin
              if hasil[i].id = paramId then
                begin
                  hasil[i].nama_film := paramData.nama_film + '1';
                  hasil[i].studio := paramData.studio;
                  hasil[i].durasi := paramData.durasi;
                  kembali := true;
                end;      

                append(MyFile);                
                Writeln(MyFile, IntToStr(hasil[i].id) + ',' + hasil[i].nama_film + ',' +IntToStr(hasil[i].studio)+ ','+IntToStr(hasil[i].durasi));              
            end;

      finally
        CloseFile(MyFile);
      

        editMovie := kembali;

      end
    end;

var
  i :integer;

begin
  // writeln('1 ', getMovieSize);
  // getMovie;
  for i:= 1 to getMovieSize do
  begin
    writeln(editMovie(7, getMovie[4]));
  end;
end.