(************************
 * Fichero de prueba nº 2
 ************************)

program test2 ();
// Entero demasiado grande
const a := 123456789012;

begin    
    // Identificador demasiado largo
    _123456789012345678 := 1;

    // Secuencia de caracteres incorrectos
    write(#@$%& "hol");

    // Cadena de caracteres sin cerrar
    write("Hola\");

    // Comentario sin cerrar
    (* Esto no va a terminar nada bien
end.
