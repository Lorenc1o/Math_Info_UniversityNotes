#ifndef __CODE_GEN__
#define __CODE_GEN__

#include "listaCodigo.h"
#include "listaSimbolos.h"
extern int in_function;

// expressions -> ...
ListaC exprs_expr(ListaC arg, int param_count);
ListaC exprs_claus(ListaC arg1, ListaC arg2, int param_count);

// expression -> ...

ListaC expr_num(char* arg);
ListaC expr_id(PosicionLista p);
ListaC expr_op(ListaC arg1, ListaC arg2, char op);
ListaC expr_paren(ListaC arg);
ListaC expr_neg(ListaC arg);
ListaC expr_func(PosicionLista p, ListaC arg);

// statement -> ...

ListaC stat_assign(PosicionLista arg1, ListaC arg2);
ListaC stat_write(ListaC arg);
ListaC stat_read(ListaC arg);
ListaC stat_if(ListaC arg1, ListaC arg2);
ListaC stat_if_else(ListaC arg1, ListaC arg2, ListaC arg3);
ListaC stat_while(ListaC arg1, ListaC arg2);
ListaC stat_comp(ListaC arg);
ListaC stat_for(PosicionLista arg1, ListaC arg2, ListaC arg3, ListaC arg4);

// statements -> ...

ListaC stats_stat(ListaC arg);
ListaC stats_claus(ListaC arg1, ListaC arg2);

// optional_statements -> ...

ListaC optstat_lambda();
ListaC optstat_stats(ListaC arg);

// compound_statement -> ...

ListaC compstat_optstat(ListaC arg);

// print_* -> ...

ListaC printit_exp(ListaC arg);
ListaC printit_str(int arg);
ListaC printl_printit(ListaC arg);
ListaC printl_claus(ListaC arg1, ListaC arg2);

// read_list -> ...

ListaC readl_id(PosicionLista arg);
ListaC readl_claus(ListaC arg1, PosicionLista arg2);

// constants -> ...

ListaC const_assign(PosicionLista arg1, ListaC arg2);
ListaC const_claus(ListaC arg1, PosicionLista arg2, ListaC arg3);

// declarations -> ...

ListaC decl_id(ListaC arg);
ListaC decl_const(ListaC arg1, ListaC arg2);
ListaC decl_lambda();

// arguments -> ...

ListaC args_lambda();
ListaC args_exprs(ListaC arg);

// program -> ...

ListaC program_output(ListaC funcs, ListaC decl, ListaC comp_stat);

// function -> ...

ListaC function_f(PosicionLista p, ListaC decl, ListaC comp_stat);
ListaC functions_claus(ListaC arg1, ListaC arg2);
ListaC functions_lambda();

void imprimirCodigo(ListaC codigo);

#endif
