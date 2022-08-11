#include "code_gen.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "assert.h"
#define NREG 10
#define REGV 1
#define REGA 2
// SYSCALLS
#define READSYSCALL "5"
#define WRITESYSCALLSTR "4"
#define WRITESYSCALLVAR "1"

/*
 * Utilidades para etiquetas
 */

int tag_count = 1;

char* new_tag() {
    char aux[16];
    sprintf(aux, "$l%d", tag_count++);
    return strdup(aux);
}

/*
 * Variable Operacion global para las functiones
 */

Operacion oper;

void set_oper(char* res, char* op, char* arg1, char* arg2) {
    oper.res = res;
    oper.op = op;
    oper.arg1 = arg1;
    oper.arg2 = arg2;
}

/*
 * Manejador de registros libres
 */
char registros[NREG] = {0};

char* obtener_reg() {
    for (int i = 0; i < NREG; i++)
        if (registros[i] == 0) {
            registros[i] = 1;
            char aux[16];
            sprintf(aux, "$t%d", i);
            return strdup(aux);
        }
    printf("Error: registros agotados\n");
    exit(1);
}

void liberarReg(char* reg) {
    if (reg[0] == '$' && reg[1] == 't') {
        int aux = reg[2] - '0';
        assert(aux >= 0);
        assert(aux < 10);
        registros[aux] = 0;
    }
}

/*
 * Otras utilidades
 */
char* concatena(char* arg1, char* arg2) {
    char* aux = (char*)malloc(strlen(arg1) + strlen(arg2) + 1);
    sprintf(aux, "%s%s", arg1, arg2);
    return aux;
}

char* get_str_tag(int count) {
    char buffer[32];
    sprintf(buffer, "$str%d", count);
    return strdup(buffer);
}

char* get_argument(int count) {
    char buffer[10];
    sprintf(buffer, "$a%d", count);
    return strdup(buffer);
}

ListaC save_syscall_regs(ListaC arg, int save) {
    if (save & REGV) {
        set_oper("$s1", "move", "$v0", NULL);
        insertaLC(arg, inicioLC(arg), oper);
        set_oper("$v0", "move", "$s1", NULL);
        insertaLC(arg, finalLC(arg), oper);
    }
    if (save & REGA) {
        set_oper("$s0", "move", "$a0", NULL);
        insertaLC(arg, inicioLC(arg), oper);
        set_oper("$a0", "move", "$s0", NULL);
        insertaLC(arg, finalLC(arg), oper);
    }
    return arg;
}

void mark(char* reg, char reg_aux[NREG]) {
    if (reg != NULL && reg[1] == 't') reg_aux[reg[2] - '0'] = 1;
}

char* get_sp_offset(int offset) {
    char buffer[32];
    sprintf(buffer, "%d($sp)", offset);
    return strdup(buffer);
}

char* int_to_reg(int ind) {
    assert(ind < NREG);
    assert(ind >= 0);
    char buffer[5];
    sprintf(buffer, "$t%d", ind);
    return strdup(buffer);
}

char* my_itoa(int a) {
    char buffer[20];
    sprintf(buffer, "%d", a);
    return strdup(buffer);
}

ListaC envolve(ListaC arg, char* name) {
    char reg_aux[NREG] = {0};
    PosicionListaC p = inicioLC(arg);
    int offset, i;
    while (p != finalLC(arg)) {
        Operacion o = recuperaLC(arg, p);
        mark(o.res, reg_aux);
        /*mark(o.arg1, reg_aux);*/
        /*mark(o.arg2, reg_aux);*/
        p = siguienteLC(arg, p);
    }
    // beginning
    set_oper("$v0", "move", "$zero", NULL);
    insertaLC(arg, inicioLC(arg), oper);
    set_oper("$ra", "sw", "0($sp)", NULL);
    insertaLC(arg, inicioLC(arg), oper);
    for (offset = 4, i = NREG - 1; i >= 0; i--)
        if (reg_aux[i] != 0) {
            set_oper(int_to_reg(i), "sw", get_sp_offset(offset), NULL);
            insertaLC(arg, inicioLC(arg), oper);
            offset += 4;
        }
    set_oper("$sp", "addiu", "$sp", my_itoa(-offset));
    insertaLC(arg, inicioLC(arg), oper);
    set_oper(name, "tag", NULL, NULL);
    insertaLC(arg, inicioLC(arg), oper);
    // end
    set_oper("$ra", "lw", "0($sp)", NULL);
    insertaLC(arg, finalLC(arg), oper);
    for (offset = 4, i = NREG - 1; i >= 0; i--)
        if (reg_aux[i] != 0) {
            set_oper(int_to_reg(i), "lw", get_sp_offset(offset), NULL);
            insertaLC(arg, finalLC(arg), oper);
            offset += 4;
            reg_aux[i] = 0;
        }
    set_oper("$sp", "addiu", "$sp", my_itoa(offset));
    insertaLC(arg, finalLC(arg), oper);
    set_oper("$ra", "jr", NULL, NULL);
    insertaLC(arg, finalLC(arg), oper);
    return arg;
}

// expressions -> ...

ListaC exprs_expr(ListaC arg, int param_count) {
    set_oper(get_argument(param_count), "move", recuperaResLC(arg), NULL);
    liberarReg(recuperaResLC(arg));
    insertaLC(arg, finalLC(arg), oper);
    return arg;
}

ListaC exprs_claus(ListaC arg1, ListaC arg2, int param_count) {
    concatenaLC(arg1, exprs_expr(arg2, param_count));
    liberaLC(arg2);
    return arg1;
}

// expression -> ...
ListaC expr_id(PosicionLista arg) {
    ListaC ret = creaLC();
    switch (arg->dato.tipo) {
        case FUNCION:
            guardaResLC(ret, "$v0");
            break;
        case ARGUMENTO:
            guardaResLC(ret, get_argument(arg->dato.valor));
            break;
        default:
            set_oper(obtener_reg(), "lw", concatena("_", arg->dato.nombre),
                     NULL);
            insertaLC(ret, finalLC(ret), oper);
            guardaResLC(ret, oper.res);
    }
    return ret;
}

ListaC expr_num(char* arg) {
    ListaC ret = creaLC();
    set_oper(obtener_reg(), "li", arg, NULL);
    insertaLC(ret, finalLC(ret), oper);
    guardaResLC(ret, oper.res);
    return ret;
}

ListaC expr_op(ListaC arg1, ListaC arg2, char op) {
    concatenaLC(arg1, arg2);
    char* operation;
    switch (op) {
        case '+':
            operation = "add";
            break;
        case '-':
            operation = "sub";
            break;
        case '*':
            operation = "mul";
            break;
        case '/':
            operation = "div";
            break;
    }
    set_oper(obtener_reg(), operation, recuperaResLC(arg1),
             recuperaResLC(arg2));
    insertaLC(arg1, finalLC(arg1), oper);
    liberaLC(arg2);
    guardaResLC(arg1, oper.res);
    liberarReg(oper.arg1);
    liberarReg(oper.arg2);
    return arg1;
}

ListaC expr_paren(ListaC arg) { return arg; }

ListaC expr_neg(ListaC arg) {
    set_oper(obtener_reg(), "neg", recuperaResLC(arg), NULL);
    insertaLC(arg, finalLC(arg), oper);
    liberarReg(oper.arg1);
    return arg;
}

ListaC expr_func(PosicionLista p, ListaC arg) {
    set_oper(concatena("_", p->dato.nombre), "jal", NULL, NULL);
    insertaLC(arg, finalLC(arg), oper);
    char* res = obtener_reg();
    set_oper(res, "move", "$v0", NULL);
    insertaLC(arg, finalLC(arg), oper);
    guardaResLC(arg, res);
    return arg;
}

/*
 * statement -> ...
 */

ListaC stat_assign(PosicionLista arg1, ListaC arg2) {
    if (arg1->dato.tipo == FUNCION)
        set_oper("$v0", "move", recuperaResLC(arg2), NULL);
    else
        set_oper(recuperaResLC(arg2), "sw", concatena("_", arg1->dato.nombre),
                 NULL);
    insertaLC(arg2, finalLC(arg2), oper);
    liberarReg(recuperaResLC(arg2));
    return arg2;
}

ListaC stat_write(ListaC arg) { return arg; }
ListaC stat_read(ListaC arg) { return arg; }

ListaC stat_if(ListaC arg1, ListaC arg2) {
    char* tag = new_tag();
    set_oper(recuperaResLC(arg1), "beqz", tag, NULL);
    insertaLC(arg1, finalLC(arg1), oper);
    liberarReg(recuperaResLC(arg1));
    concatenaLC(arg1, arg2);
    liberaLC(arg2);
    set_oper(tag, "tag", NULL, NULL);
    insertaLC(arg1, finalLC(arg1), oper);
    return arg1;
}

ListaC stat_if_else(ListaC arg1, ListaC arg2, ListaC arg3) {
    char *tag_if = new_tag(), *tag_else = new_tag();
    set_oper(recuperaResLC(arg1), "beqz", tag_else, NULL);
    insertaLC(arg1, finalLC(arg1), oper);
    liberarReg(recuperaResLC(arg1));
    concatenaLC(arg1, arg2);
    liberaLC(arg2);
    set_oper(tag_if, "b", NULL, NULL);
    insertaLC(arg1, finalLC(arg1), oper);
    set_oper(tag_else, "tag", NULL, NULL);
    insertaLC(arg1, finalLC(arg1), oper);
    concatenaLC(arg1, arg3);
    liberaLC(arg3);
    set_oper(tag_if, "tag", NULL, NULL);
    insertaLC(arg1, finalLC(arg1), oper);
    return arg1;
}

ListaC stat_while(ListaC arg1, ListaC arg2) {
    char *tag_start = new_tag(), *tag_end = new_tag();
    // start tag
    set_oper(tag_start, "tag", NULL, NULL);
    insertaLC(arg1, inicioLC(arg1), oper);
    // conditional jump to end
    set_oper(recuperaResLC(arg1), "beqz", tag_end, NULL);
    insertaLC(arg1, finalLC(arg1), oper);
    // concatenate body of loop
    concatenaLC(arg1, arg2);
    liberaLC(arg2);
    // jump to beginning
    set_oper(tag_start, "b", NULL, NULL);
    insertaLC(arg1, finalLC(arg1), oper);
    // end tag
    set_oper(tag_end, "tag", NULL, NULL);
    insertaLC(arg1, finalLC(arg1), oper);
    liberarReg(recuperaResLC(arg1));
    return arg1;
}

ListaC stat_comp(ListaC arg) { return arg; }

ListaC stat_for(PosicionLista arg1, ListaC arg2, ListaC arg3, ListaC arg4) {
    ListaC ret, advance_iteration, aux; // ret contains response
    char *tag_start = new_tag(), *tag_end = new_tag();
    ret = stat_assign(arg1, arg2); // id := expr1
    // concatenate iteration advance to body of iteration
    advance_iteration =
        stat_assign(arg1, expr_op(expr_id(arg1), expr_num("1"), '+'));
    concatenaLC(arg4, advance_iteration);
    liberaLC(advance_iteration);
    // beginning tag
    set_oper(tag_start, "tag", NULL, NULL);
    insertaLC(ret, finalLC(ret), oper);
    // comparison and jump
    concatenaLC(ret, arg3); // value of expr2
    aux = expr_id(arg1); // get value of variable
    concatenaLC(ret, aux); 
    set_oper(recuperaResLC(aux), "bgt", recuperaResLC(arg3), tag_end); // compare these values
    insertaLC(ret, finalLC(ret), oper);
    // liberate registers and lists
    liberarReg(recuperaResLC(aux));
    liberarReg(recuperaResLC(arg3));
    liberaLC(arg3);
    liberaLC(aux);
    // body of loop
    concatenaLC(ret, arg4);
    liberaLC(arg4);
    // jump to beginning
    set_oper(tag_start, "b", NULL, NULL);
    insertaLC(ret, finalLC(ret), oper);
    // end tag
    set_oper(tag_end, "tag", NULL, NULL);
    insertaLC(ret, finalLC(ret), oper);
    return ret;
}

/*
 * statements -> ...
 */

ListaC stats_stat(ListaC arg) { return arg; }

ListaC stats_claus(ListaC arg1, ListaC arg2) {
    concatenaLC(arg1, arg2);
    liberaLC(arg2);
    return arg1;
}

/*
 * optional_statements -> ...
 */

ListaC optstat_lambda() { return creaLC(); }

ListaC optstat_stats(ListaC arg) { return arg; }

/*
 * compound_statement -> ...
 */

ListaC compstat_optstat(ListaC arg) { return arg; }

/*
 * print_* -> ...
 */

ListaC printit_exp(ListaC arg) {
    set_oper("$v0", "li", WRITESYSCALLVAR, NULL);
    insertaLC(arg, finalLC(arg), oper);
    set_oper("$a0", "move", recuperaResLC(arg), NULL);
    insertaLC(arg, finalLC(arg), oper);
    set_oper(NULL, "syscall", NULL, NULL);
    insertaLC(arg, finalLC(arg), oper);
    liberarReg(recuperaResLC(arg));
    int save = in_function ? (REGV | REGA) : 0;
    return save_syscall_regs(arg, save);
}

ListaC printit_str(int arg) {
    ListaC res = creaLC();
    set_oper("$v0", "li", WRITESYSCALLSTR, NULL);
    insertaLC(res, finalLC(res), oper);
    set_oper("$a0", "la", get_str_tag(arg), NULL);
    insertaLC(res, finalLC(res), oper);
    set_oper(NULL, "syscall", NULL, NULL);
    insertaLC(res, finalLC(res), oper);
    int save = in_function ? (REGV | REGA) : 0;
    return save_syscall_regs(res, save);
}

ListaC printl_printit(ListaC arg) { return arg; }

ListaC printl_claus(ListaC arg1, ListaC arg2) {
    concatenaLC(arg1, arg2);
    liberaLC(arg2);
    return arg1;
}

/*
 * read_list->...
 */

ListaC readl_id(PosicionLista arg) {
    ListaC res = creaLC();
    set_oper("$v0", "li", READSYSCALL, NULL);
    insertaLC(res, finalLC(res), oper);
    set_oper(NULL, "syscall", NULL, NULL);
    insertaLC(res, finalLC(res), oper);
    if (arg->dato.tipo == FUNCION) {
        return res;
    }
    set_oper("$v0", "sw", concatena("_", arg->dato.nombre), NULL);
    insertaLC(res, finalLC(res), oper);
    return (in_function ? save_syscall_regs(res, REGV) : res);
}

ListaC readl_claus(ListaC arg1, PosicionLista arg2) {
    ListaC aux = readl_id(arg2);
    concatenaLC(arg1, aux);
    liberaLC(aux);
    return arg1;
}

/*
 * constants -> ...
 */
ListaC const_assign(PosicionLista arg1, ListaC arg2) {
    return stat_assign(arg1, arg2);
}

ListaC const_claus(ListaC arg1, PosicionLista arg2, ListaC arg3) {
    ListaC aux = const_assign(arg2, arg3);
    concatenaLC(arg1, aux);
    liberaLC(aux);
    return arg1;
}

/*
 * declarations -> ...
 */

ListaC decl_id(ListaC arg) { return arg; }

ListaC decl_const(ListaC arg1, ListaC arg2) {
    concatenaLC(arg1, arg2);
    liberaLC(arg2);
    return arg1;
}

ListaC decl_lambda() { return creaLC(); }

// arguments -> ...

ListaC args_lambda() { return creaLC(); }
ListaC args_exprs(ListaC arg) { return arg; }

/*
 * program ->...
 */

ListaC program_output(ListaC funcs, ListaC decl, ListaC comp_stat) {
    // etiqueta main
    set_oper("main", "tag", NULL, NULL);
    insertaLC(decl, inicioLC(decl), oper);
    // al final desapilo $ra y salto a él
    set_oper("$v0", "li", "10", NULL);
    insertaLC(comp_stat, finalLC(comp_stat), oper);
    set_oper(NULL, "syscall", NULL, NULL);
    insertaLC(comp_stat, finalLC(comp_stat), oper);
    // concateno todo
    concatenaLC(funcs, decl);
    liberaLC(decl);
    concatenaLC(funcs, comp_stat);
    liberaLC(comp_stat);
    return funcs;
}

/*
 * function -> ...
 */

ListaC function_f(PosicionLista p, ListaC decl, ListaC comp_stat) {
    concatenaLC(decl, comp_stat);
    liberaLC(comp_stat);
    return envolve(decl, concatena("_", p->dato.nombre));
}

ListaC functions_claus(ListaC arg1, ListaC arg2) {
    concatenaLC(arg1, arg2);
    liberaLC(arg2);
    return arg1;
}

ListaC functions_lambda() { return creaLC(); }

/*
 * Generate code
 */
void imprimirCodigo(ListaC codigo) {
    PosicionListaC p = inicioLC(codigo);
    printf("\n###################\n");
    printf("# Seccion de codigo\n");
    printf("\t.text\n");
    printf("\t.globl main\n");
    while (p != finalLC(codigo)) {
        oper = recuperaLC(codigo, p);
        if (strcmp(oper.op, "tag") == 0) {
            printf("%s:\n", oper.res);
        } else {
            printf("\t%s ", oper.op);
            if (oper.res) printf("%s", oper.res);
            if (oper.arg1) printf(",%s", oper.arg1);
            if (oper.arg2) printf(",%s", oper.arg2);
            printf("\n");
        }
        p = siguienteLC(codigo, p);
    }
}
