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
void procesar_follow(){
    string usuario;
    cin >> usuario;
    cout << "follow" << " " << usuario << endl;
    dic.DiccionarioCuacs::follow(usuario);
}

void Interprete(string comando){
    if(comando=="mcuac") procesar_mcuac();
    else if(comando=="pcuac") procesar_pcuac();
    else if(comando=="follow") procesar_follow();
}

int main()
{
    string comando;
    while (cin >> comando && comando != "exit")
        Interprete(comando);
}