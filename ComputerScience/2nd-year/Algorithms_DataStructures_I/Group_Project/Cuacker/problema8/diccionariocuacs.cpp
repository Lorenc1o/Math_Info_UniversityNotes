#include "diccionariocuacs.h"
using namespace std;

void DiccionarioCuacs::insertar(Cuac nuevo){
    Cuac* ref=tabla.TablaHash::insertar(nuevo);
    arbol.Arbol::insertar(ref, arbol.get_raiz());
}
void DiccionarioCuacs::follow(string nombre){
    tabla.TablaHash::consultar(nombre);
}
void DiccionarioCuacs::last(int n){
    int cont=0;
    arbol.Arbol::last(n,cont, arbol.get_raiz());
    cout << "Total: " << cont << " cuac" << endl;
}
void DiccionarioCuacs::date(Fecha fecha1, Fecha fecha2){
    int cont=0;
    arbol.Arbol::date(fecha1, fecha2, cont, arbol.get_raiz());
    cout << "Total: " << cont << " cuac" << endl;
}