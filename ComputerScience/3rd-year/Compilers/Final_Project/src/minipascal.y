%{
    #include <stdio.h>
    #include <string.h>
    #include "listaSimbolos.h"
    #include "listaCodigo.h"
    #include "semantic_analysis.h"
    #include "code_gen.h"


    extern int yylex();
    extern int yylineno;

    int errores_sintacticos = 0;
    int errores_semanticos = 0;
    extern int errores_lexicos;
    void yyerror(const char *msg);
    int ok();

    // Lista de símbolos
    Lista l;
    // puntero auxiliar
    PosicionLista aux, aux_fd;
    int in_function = 0;
    int param_count;
%}

%code requires {
    #include "listaCodigo.h"
}

/* Tipos de datos */
%union {
    char *str;
    ListaC codigo;
}

%type <codigo> expression statement read_list print_list print_item compound_statement optional_statements statements declarations constants function functions arguments expressions

/* Tokens de la gramática */

%token PROGRAM
%token FUNCTION
%token CONST
%token VAR 
%token INTTYPE 
%token BEGINN 
%token END 
%token IF 
%token THEN 
%token ELSE 
%token WHILE 
%token DO 
%token FOR 
%token TO 
%token WRITE 
%token READ 
%token <str> ID 
%token <str> INTCONST
%token <str> STRING 
%token LPAREN 
%token RPAREN 
%token SEMICOLON 
%token COLON 
%token COMMA 
%token POINT 
%token ASSIGNOP 
%token PLUSOP 
%token MINUSOP 
%token MULTOP 
%token DIVOP 

%start program

/* genera trazas de depuración */
%define parse.error verbose
%define parse.trace


/* Asociatividad y preferencia */
%expect 1
%left PLUSOP MINUSOP
%left MULTOP DIVOP


%%
program     : { l = creaLS(); } PROGRAM ID LPAREN RPAREN SEMICOLON functions declarations compound_statement POINT {
                if(ok()){
                    imprimirLS(l);
                    ListaC output = program_output($7, $8, $9);
                    imprimirCodigo(output);
                    liberaLC(output);
                }
                liberaLS(l);
           }
            ;
functions   : functions function SEMICOLON { if(ok()) $$ = functions_claus($1, $2);
                                            else{
                                                $$ = NULL;
                                                liberaLC($1);
                                                liberaLC($2);
                                            }  
                                        }
            | { if(ok()) $$ = functions_lambda(); else $$ = NULL;}
            ;
function    : FUNCTION ID {
                    parse_function_declaration($2);
                    in_function = 1;
                } LPAREN CONST { 
                    args_on();
                } identifiers {
                    aux_fd = args_off();
                } COLON type RPAREN COLON type declarations compound_statement {
                    end_function_declaration();
                    if(ok())
                        $$ = function_f(aux_fd, $14, $15);
                    else{
                        $$ = NULL;
                        liberaLC($14);
                        liberaLC($15);
                    }
                    in_function = 0;
                }
            ;
declarations : declarations VAR identifiers COLON type SEMICOLON { if(ok()) $$ = decl_id($1);
                                                                    else{
                                                                        $$ = NULL;
                                                                        liberaLC($1);
                                                                    }  
                                                                }
             | declarations CONST constants SEMICOLON { if(ok()) $$ = decl_const($1, $3);
                                                        else{
                                                            $$ = NULL;
                                                            liberaLC($1);
                                                            liberaLC($3);
                                                        }  
                                                    }
             | { if(ok()) $$ = decl_lambda(); else $$ = NULL;}
             ;
        
identifiers : ID { insert_identifier($1, VARIABLE); /* si es argumento lo detecta en el módulo*/ }
            | identifiers COMMA ID { insert_identifier($3, VARIABLE); }
            ;
type        : INTTYPE
            ;
constants   : ID ASSIGNOP expression { aux = insert_identifier($1, CONSTANTE); if(ok()) $$ = const_assign(aux, $3);
                                                                                else{
                                                                                    $$ = NULL;
                                                                                    liberaLC($3);
                                                                                }  
                                                                            }
            | constants COMMA ID ASSIGNOP expression { aux = insert_identifier($3, CONSTANTE); if(ok()) $$ = const_claus($1, aux, $5);
                                                                                                else{
                                                                                                    $$ = NULL;
                                                                                                    liberaLC($1);
                                                                                                    liberaLC($5);
                                                                                                } 
                                                                                            }
            ;
compound_statement : BEGINN optional_statements END { if(ok()) $$ = compstat_optstat($2);
                                                        else{
                                                            $$ = NULL;
                                                            liberaLC($2);
                                                        }  
                                                    }
                   ;
optional_statements : statements { 
                                    if(ok()) $$ = optstat_stats($1);
                                    else{
                                        $$ = NULL;
                                        liberaLC($1);
                                    } 
                                }
                    | { if(ok()) $$ = optstat_lambda(); else $$ = NULL; }
                    ;
statements  : statement { if(ok()) $$ = stats_stat($1);
                        else{
                            $$ = NULL;
                            liberaLC($1);
                        } 
                    }
            | statements SEMICOLON statement { if(ok()) $$ = stats_claus($1, $3);
                                                else{
                                                    $$ = NULL;
                                                    liberaLC($1);
                                                    liberaLC($3);
                                                } 
                                            }
            ;
statement   : ID ASSIGNOP expression{ 
                                        aux = check_identifier($1, VARIABLE); 
                                        if(aux != NULL && ok())
                                            $$ = stat_assign(aux, $3);
                                        else{
                                            $$ = NULL;
                                            liberaLC($3);
                                        }
                                    }
            | IF expression THEN statement { if(ok()) $$ = stat_if($2, $4);
                                            else{
                                                $$ = NULL;
                                                liberaLC($2);
                                                liberaLC($4);
                                            }  
                                        }
            | IF expression THEN statement ELSE statement { if(ok()) $$ = stat_if_else($2, $4, $6);
                                                            else{
                                                                $$ = NULL;
                                                                liberaLC($2);
                                                                liberaLC($4);
                                                                liberaLC($6);
                                                            }  
                                                        }
            | WHILE expression DO statement { if(ok()) $$ = stat_while($2, $4);
                                                else{
                                                    $$ = NULL;
                                                    liberaLC($2);
                                                    liberaLC($4);
                                                }  
                                            }
            | FOR ID ASSIGNOP expression TO expression DO statement { aux = check_identifier($2, VARIABLE); if(aux != NULL && ok()) $$ = stat_for(aux, $4, $6, $8);
                                                                                                            else{
                                                                                                                $$ = NULL;
                                                                                                                liberaLC($4);
                                                                                                                liberaLC($6);
                                                                                                                liberaLC($8);
                                                                                                            } 
                                                                                                            }
            | WRITE LPAREN print_list RPAREN { if(ok()) $$ = stat_write($3);
                                                else{
                                                    $$ = NULL;
                                                    liberaLC($3);
                                                } 
                                            }
            | READ LPAREN read_list RPAREN { if(ok()) $$ = stat_read($3);
                                            else{
                                                $$ = NULL;
                                                liberaLC($3);
                                            } 
                                        }
            | compound_statement { if(ok()) $$ = stat_comp($1);
                                    else{
                                        $$ = NULL;
                                        liberaLC($1);
                                    } 
                                }
            ;
print_list  : print_item { if(ok()) $$ = printl_printit($1); 
                            else{
                                $$ = NULL;
                                liberaLC($1);
                            }
                        }
            | print_list COMMA print_item { if(ok()) $$ = printl_claus($1, $3);
                                            else{
                                                $$ = NULL;
                                                liberaLC($1);
                                                liberaLC($3);
                                            } 
                                        }
            ;
print_item  : expression { if(ok()) $$ = printit_exp($1);
                            else{
                                $$ = NULL;
                                liberaLC($1);
                            } 
                        }
            | STRING {
                        int str_id = insert_string($1);
                        if(ok()) $$ = printit_str(str_id);
                        else $$ = NULL;
                    }
            ;
read_list   : ID { aux = check_identifier($1, VARIABLE); if(aux != NULL && ok()) $$ = readl_id(aux); else $$ = NULL; }
            | read_list COMMA ID { aux = check_identifier($3, VARIABLE); if(aux != NULL && ok()) $$ = readl_claus($1, aux);
                                                                        else{
                                                                            $$ = NULL;
                                                                            liberaLC($1);
                                                                        }
                                                                    }
            ;
expression  : expression PLUSOP expression { if(ok()) $$ = expr_op($1, $3, '+');
                                            else{
                                                $$ = NULL;
                                                liberaLC($1);
                                                liberaLC($3);
                                            } 
                                        }
            | expression MINUSOP expression { if(ok()) $$ = expr_op($1, $3, '-');
                                            else{
                                                $$ = NULL;
                                                liberaLC($1);
                                                liberaLC($3);
                                            } 
                                        }
            | expression MULTOP expression { if(ok()) $$ = expr_op($1, $3, '*');
                                            else{
                                                $$ = NULL;
                                                liberaLC($1);
                                                liberaLC($3);
                                            } 
                                        }
            | expression DIVOP expression { if(ok()) $$ = expr_op($1, $3, '/');
                                            else{
                                                $$ = NULL;
                                                liberaLC($1);
                                                liberaLC($3);
                                            }  
                                        }
            | MINUSOP expression { if(ok()) $$ = expr_neg($2);
                                    else{
                                        $$ = NULL;
                                        liberaLC($2);
                                    } 
                                }
            | LPAREN expression RPAREN { if(ok()) $$ = expr_paren($2);
                                        else{
                                            $$ = NULL;
                                            liberaLC($2);
                                        } 
                                    }
            | ID { aux = check_identifier($1, VARIABLE | CONSTANTE | ARGUMENTO); if(aux != NULL && ok()) $$ = expr_id(aux); else $$ = NULL; }
            | INTCONST { if(ok()) $$ = expr_num($1);
                            else{
                                $$ = NULL;
                            }
                        }
            | ID { parse_function_call($1); } LPAREN arguments RPAREN { end_function_call(); 
                                                                        if(ok()) aux = buscaLS(l, $1)->sig, $$ = expr_func(aux, $4);
                                                                        else{
                                                                            $$ = NULL;
                                                                            liberaLC($4);
                                                                        }
                                                                    }
            ;
arguments   : { param_count = 0; } expressions { if(ok()) $$ = args_exprs($2);
                                                    else{
                                                        $$ = NULL;
                                                        liberaLC($2);
                                                    }
                                                }
            | { if(ok()) $$ = args_lambda(); else $$ = NULL; }
            ; 
expressions : expression { add_param(); 
                            if(ok()) exprs_expr($1, param_count++);
                            else {
                                $$ = NULL;
                                liberaLC($1);
                            } 
                        }
            | expressions COMMA expression { add_param(); 
                                            if(ok()) exprs_claus($1, $3, param_count++);
                                            else{
                                                $$ = NULL;
                                                liberaLC($1);
                                                liberaLC($3);
                                            }    
                                         }
%%

void yyerror(const char *msg){
    printf("Error en linea %d: %s\n", yylineno, msg);
    errores_sintacticos++;
}

int ok() {
    return !(errores_lexicos + errores_sintacticos + errores_semanticos);
}
