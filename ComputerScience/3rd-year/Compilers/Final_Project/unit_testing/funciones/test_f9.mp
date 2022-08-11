program test_f9();

function y(const a:integer): integer
begin
    y := a+y;
    write("Puede haber sentencias detras de y := ...\n");
    y := 0;
    write("Tambien multiples asignaciones a y := ...\n")
end;

function b(const c,d:integer): integer
var y:integer;
begin
    y := c+d;
    b := y
end;

begin
    write(y(1),"\n")
end.

