#include <iostream>
#include <string.h>
#include <list>
#include "diccionariocuacs.h"
using namespace std;

DiccionarioCuacs dic;

Cuac actual;

void procesar_mcuac()
{
    actual.leer_mcuac();
    dic.DiccionarioCuacs::insertar(actual);
}
void procesar_pcuac()
{
    actual.leer_pcuac();
    dic.DiccionarioCuacs::insertar(actual);
}
void procesar_follow()
{
    string usuario;
    cin >> usuario;
    cout << "follow" << " " << usuario << endl;
    dic.DiccionarioCuacs::follow(usuario);
}
void procesar_last()
{
    int n;
    cin >> n;
    cout << "last " << n << endl;
    dic.DiccionarioCuacs::last(n); 
}
void procesar_tag()
{
    string etiqueta;
    cin >> etiqueta;
    cout << "tag"
         << " " << etiqueta << endl;
    cout << "1. ";
    actual.escribir();
    cout << "Total: 1 cuac" << endl;
}
void procesar_date(){
    Fecha fecha1, fecha2;
    fecha1.leer();
    fecha2.leer();
    cout << "date ";
    fecha1.escribir();
    cout << " ";
    fecha2.escribir();
    cout << endl;
    dic.DiccionarioCuacs::date(fecha1, fecha2);
}

void Interprete(string comando)
{
    if (comando == "mcuac")
        procesar_mcuac();
    else if (comando == "pcuac")
        procesar_pcuac();
    else if (comando == "follow")
        procesar_follow();
    else if (comando == "tag")
        procesar_tag();
    else if (comando == "last")
        procesar_last();
    else if (comando == "date")
        procesar_date();
}

int main()
{
    string comando;
    while (cin >> comando && comando != "exit")
        Interprete(comando);
}