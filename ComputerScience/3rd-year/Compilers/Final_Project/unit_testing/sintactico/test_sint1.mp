program prueba ();
var a,b,c: integer;

begin
    write("Inicio del programa\n");
    a := 0; b := 0; c := 5+2-2;
    if (a) then write("a","\n")
    else if (b) then write("No a y b\n")
         else while (c) do
              begin
                write("c = ",c,"\n");
                c := c-2+1
              end;
    write("Final","\n")
end.