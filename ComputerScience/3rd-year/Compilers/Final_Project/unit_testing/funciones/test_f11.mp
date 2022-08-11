(************************
 * Fichero de prueba nº 3
 ************************)

program test1 ();

function siguiente(const a:integer) : integer
var c: integer;
begin
    if (a) then
      siguiente := siguiente(a-1) + 1
    else
      siguiente := 1
end;

var b: integer;

begin

    b := siguiente(5);
    while (b) do
    begin
      write("b == ",b,"\n");
      b := b-1
    end;
    for b := 1 to 10 do
    begin
      write("b == ",b,"\n")
    end

end.