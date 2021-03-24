program Project1;
type
  celular=record
    codigo:integer;
    nombre:string[8];
    descripcion:string[8];
    marca:string[8];
    precio:integer;
    stockMin:integer;
    stockDisp:integer;
  end;
  arch_celu=file of celular;
procedure leerCelu(var cel:celular);
begin
  writeln('----------INGRESANDO UN NUEVO CELULAR----------');
  with cel do begin
    write('ingrese el codigo del celular(-1 para terminar la lectura): ');readln(codigo);
    if (codigo<>-1) then begin
      write('ingrese el nombre del celular: ');readln(nombre);
      write('ingrese la descripcion del delular: ');readln(descripcion);
      write('ingrese la marca del dispositivo: ');readln(marca);
      write('ingrese el precio del celular: ');readln(precio);
      write('ingrese el stock minimo del celular: ');readln(stockMin);
      write('ingrese el stock disponible del celular: ');readln(stockDisp);
    end;
  end;
end;
procedure regATxt(var txt:text;cel:celular);
begin
  with cel do begin
    Write(txt,codigo);Write(txt,' ');
    Write(txt,nombre);Write(txt,' ');
    Write(txt,sLineBreak);
    Write(txt,descripcion);Write(txt,' ');
    Write(txt,marca);Write(txt,' ');
    Write(txt,sLineBreak);
    Write(txt,precio);Write(txt,' ');
    Write(txt,stockMin);Write(txt,' ');
    Write(txt,sLineBreak);
    Write(txt,stockDisp);Write(txt,' ');
    Write(txt,' ');
  end;
end;
procedure cargarTxt(var txt:text);
var
  cel:celular;
begin
  Rewrite(txt);
  leerCelu(cel);
  while (cel.codigo<>-1) do begin
    regATxt(txt,cel);
    leerCelu(cel);
  end;
  Close(txt);
end;
procedure cargarRegistro(var txt:text;var cel:celular);
var
  aux:string;
begin
  Readln(txt,cel.codigo,cel.nombre);
  Readln(txt,cel.descripcion,cel.marca);
  Readln(txt,cel.precio,cel.stockMin);
  Readln(txt,cel.stockDisp);
end;

procedure cargarArchivo(var arch_cel:arch_celu;var txt:text);
var
  cel:celular;
begin
  Reset(txt);
  Rewrite(arch_cel);
  while (not EOF(txt)) do begin
    cargarRegistro(txt,cel);
    Write(arch_cel,cel);
  end;
  Close(txt);
  Close(arch_cel);
end;
procedure listarStockMin(var arch_cel:arch_celu);
var
  cel:celular;
begin
  Reset(arch_cel);
  while (not EOF(arch_cel)) do begin
    Read(arch_cel,cel);
    if (cel.stockMin>cel.stockDisp) then
      writeln('codigo: ',cel.codigo,', nombre: ',cel.nombre,', descripcion: ',cel.descripcion,', marca: ',cel.marca,', precio: ',cel.precio,', stock minimo: ',cel.stockMin,', stock disponible: ',cel.stockDisp);
  end;
  Close(arch_cel);
end;
procedure listarEspecificados(var arch_cel:arch_celu;cad:string);
var
  cel:celular;
begin
  Reset(arch_cel);
  while(not EOF(arch_cel)) do begin
    Read(arch_cel,cel);
    if (cel.descripcion = cad) then
      writeln('codigo: ',cel.codigo,', nombre: ',cel.nombre,', descripcion: ',cel.descripcion,', marca: ',cel.marca,', precio: ',cel.precio,', stock minimo: ',cel.stockMin,', stock disponible: ',cel.stockDisp);
  end;
end;
procedure agregarMasCelulares(var arch_cel:arch_celu);
var
  cel:celular;
  SiNo:string;
begin
  Reset(arch_cel);
  write('desea agregar otro celular al archivo?(si/no): ');readln(SiNo);
  while (SiNo = 'si') do begin
    leerCelu(cel);
    Write(arch_cel,cel);
    write('desea agregar otro celular al archivo?(si/no): ');readln(SiNo);
  end;
  Close(arch_cel);
end;
procedure modificarStock(var arch_cel:arch_celu;nom:string);
var
  cel:celular;
  encontre:boolean;
begin
  encontre:=true;
  Reset(arch_cel);
  while (not EOF(arch_cel) and  encontre) do begin
    Read(arch_cel,cel);
    if (cel.descripcion = nom) then begin
      encontre:= false;
      seek(arch_cel,FilePos(arch_cel)-1);
      write('ingrese el nuevo stock del celular: ');readln(cel.stockDisp);
      Write(arch_cel,cel);
    end;
  end;
  Close(arch_cel);
end;
procedure deRegABinario(var arch_cel:arch_celu;var txt:text);
var
  cel:celular;
begin
  Rewrite(txt);
  Reset(arch_cel);
  while (not EOF(arch_cel)) do begin
    Read(arch_cel,cel);
    if (cel.stockDisp = 0) then
      regATxt(txt,cel);
  end;
  Close(txt);
  Close(arch_cel);
end;

var
  txt,txtSinStock:text;
  arch_cel:arch_celu;
  cad,nom:string;
begin
  assign(txtSinStock,'sinStock.txt');
  assign(arch_cel,'celulares');
  assign(txt,'celulares.txt');
  cargarTxt(txt);
  cargarArchivo(arch_cel,txt);
  agregarMasCelulares(arch_cel);
  write('ingrese la descripcion del celular a modificar su stock: ');readln(nom);
  write('SOLO SIRVE SI PONES UNA DESCRIPCION DE 8 ESPACIOS');
  modificarStock(arch_cel,nom);
  writeln('----------LISTANDO CELULARES CON STOCK DISPONIBLE MENOR A STOCK MINIMO----------');
  listarStockMin(arch_cel);
  writeln('---------------------');
  write('ingrese una cadena: ');readln(cad);
  writeln('----------LISTANDO CELULARES QUE CONTENGAN DICHA CADENA DE CARACTERES----------');
  listarEspecificados(arch_cel,cad);
  deRegABinario(arch_cel,txtSinStock);
  readln();
end.
