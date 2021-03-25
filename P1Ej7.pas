program Project1;
type
  novela = record
    cod:integer;
    nombre:string[10];
    precio:integer;
    genero:string[10];
  end;
  arch_nove = file of novela;

procedure binATxt(var txt:text;nov:novela);
begin
  Write(txt,nov.cod);
  Write(txt,nov.precio);
  Write(txt,nov.genero);
  Write(txt,sLineBreak);
  Write(txt,nov.nombre);
end;
procedure leer(var nov:novela);
begin
  writeln('----------INGRESANDO UNA NOVELA----------');
  with nov do begin
    write('ingrese el codigo de la novela(ingresar -1 para terminar la lectura: ');readln(cod);
    if (cod <> -1) then begin
      write('ingrese el nombre de la novela: ');readln(nombre);
      write('ingrese el precio de la novela: ');readln(precio);
      write('ingrese el genero de la novela: ');readln(genero);
    end;
  end;
end;
procedure cargarTxt(var txt:text);
var
  nov:novela;
begin
  Rewrite(txt);
  leer(nov);
  while (nov.cod <> -1) do begin
    binATxt(txt,nov);
    leer(nov);
  end;
  Close(txt);
end;
procedure txtABin(var txt:text;var nov:novela);

begin
  with nov do begin
    Readln(txt,cod,precio,genero);
    Readln(txt,nombre);
  end;
end;

procedure cargarArchivo(var txt:text;var arch_nov:arch_nove);
var
  nov:novela;
begin
  Rewrite(arch_nov);
  Reset(txt);
  while (not EOF(txt)) do begin
    txtABin(txt,nov);
    Write(arch_nov,nov);
  end;
  Close(txt);
  Close(arch_nov);
end;
procedure imprimirTxt(var txt:text);
var
  aux:string;
begin
  Reset(txt);
//  while (not EOF(txt)) do begin
    Read(txt,aux);
    writeln(aux);
 // end;
  Close(txt);
end;
var
  txt:text;
  arch_nov:arch_nove;
begin
  assign(txt,'novelas.txt');
  assign(arch_nov,'archivoNovelas');
  cargarTxt(txt);
  writeln('----------LISTANDO EL ARCHIVO DE TEXTO----------');
  imprimirTxt(txt);
  cargarArchivo(txt,arch_nov);
  readln();
end.

    //NO FUNCIONA, PREGUNTAR COMO FUNCIONAN LOS TXT 
