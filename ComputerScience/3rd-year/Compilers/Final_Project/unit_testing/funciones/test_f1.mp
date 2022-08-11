program test_f1();

function y(const a:integer): integer
var b:integer;
begin
    b := a+1;
    y := b*2
end;

var y_b:integer;
begin
    write(y(0))
end.

