#include <iostream>
#include <string.h>
#include <list>
#include "diccionariocuacs.h"
using namespace std;

DiccionarioCuacs dic;

int contador = 0;
Cuac actual;

void procesar_mcuac(){
    actual.leer_mcuac();
    dic.DiccionarioCuacs::insertar(actual);
}
void procesar_pcuac(){
    actual.leer_pcuac();
    dic.DiccionarioCuacs::insertar(actual);
}
void procesar_last(){
    int N;
    cin >> N;
    cout << "last" << " " << N << endl;
    dic.DiccionarioCuacs::last(N);
}
void procesar_follow(){
    string usuario;
    cin >> usuario;
    cout << "follow" << " " << usuario << endl;
    dic.DiccionarioCuacs::follow(usuario);
}
void procesar_date(){
    Fecha finicial, ffinal;
    finicial.leer();
    ffinal.leer();
    cout << "date" << " "; finicial.escribir(); cout << " "; ffinal.escribir(); cout << endl;
    dic.DiccionarioCuacs::date(finicial,ffinal);
}
void procesar_tag(){
    string etiqueta;
    cin >> etiqueta;
    cout << "tag" << " " << etiqueta << endl;
    cout << "1. ";
    actual.escribir();
    cout << "Total: 1 cuac" << endl;
}

void Interprete(string comando){
    if(comando=="mcuac") procesar_mcuac();
    else if(comando=="pcuac") procesar_pcuac();
    else if(comando=="last") procesar_last();
    else if(comando=="follow") procesar_follow();
    else if(comando=="date") procesar_date();
    else if(comando=="tag") procesar_tag();
}

int main()
{
    string comando;
    while (cin >> comando && comando != "exit")
        Interprete(comando);
}