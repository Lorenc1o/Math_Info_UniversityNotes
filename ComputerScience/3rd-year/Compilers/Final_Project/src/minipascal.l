%{
    #include "minipascal.tab.h"
    #include <math.h>
    int comment_start = 0; // guardo donde comienza el comentario
                           // para mostrar el error
    int errores_lexicos = 0;
%}
digito              [0-9]
letra               [a-zA-Z]
entero              {digito}+
idinit              [a-zA-Z_]       
panico              [^ \n\t\ra-zA-Z0-9_();:.,+/*-]

/* Opción para disponer de números de línea */
%option yylineno
/*%option debug*/

/* Condición de contexto */
%x comentario

%%
[ \n\t]+                                    ;
"//"(.*)[\n]                                ;
"(*"                                        {
                                                comment_start = yylineno;
                                                BEGIN(comentario);
                                            }
<comentario>"*)"                            BEGIN(INITIAL);
<comentario>(.|\n)                          ;
<comentario><<EOF>>                         {
                                                printf("Error en la linea %d, comentario sin cerrar\n", comment_start);
                                                errores_lexicos++;
                                                return 0;
                                            }
program                                     return PROGRAM;
function                                    return FUNCTION;
const                                       return CONST;
var                                         return VAR;
integer                                     return INTTYPE;
begin                                       return BEGINN;
end                                         return END;
if                                          return IF;
then                                        return THEN;
else                                        return ELSE;
while                                       return WHILE;
do                                          return DO;
for                                         return FOR;
to                                          return TO;
write                                       return WRITE;
read                                        return READ;
{idinit}({idinit}|{digito})*                {
                                                yylval.str = strdup(yytext);
                                                if(yyleng > 16){
                                                    printf("Error en linea %d, identificador %s demasiado largo\n", yylineno, yytext);
                                                    errores_lexicos++;
                                                }
                                                return ID;
                                            }
{entero}                                    {
                                                yylval.str = strdup(yytext);
                                                int first_nzero = 0;
                                                while(yytext[first_nzero] == '0') first_nzero++;
                                                if(yyleng - first_nzero > 12 || llabs(atoll(yytext)) > pow(2,31)){
                                                    printf("Error en linea %d, entero %s demasiado grande\n", yylineno, yytext);
                                                    errores_lexicos++;
                                                }
                                                return INTCONST;
                                            }
"("                                         return LPAREN;		
")"                                         return RPAREN;
";"                                         return SEMICOLON;
":"                                         return COLON;
","                                         return COMMA;
"."                                         return POINT;
":="                                        return ASSIGNOP;
"+"                                         return PLUSOP;
"-"                                         return MINUSOP;
"*"                                         return MULTOP;
"/"                                         return DIVOP;
\"(\\.|[^"\n])*\"                           {
                                                yylval.str = strdup(yytext);
                                                return STRING;
                                            }
\"(\\.|[^"\n])*                             {
                                                yylval.str = strdup(yytext);
                                                printf("Error en linea %d, cadena sin cerrar\n",yylineno);
                                                errores_lexicos++;
                                                return STRING;
                                            }
{panico}+                                   {
                                                printf("Error en linea %d, secuencia de caracteres incorrectos %s\n", yylineno, yytext);
                                                errores_lexicos++;
                                            }
%%
