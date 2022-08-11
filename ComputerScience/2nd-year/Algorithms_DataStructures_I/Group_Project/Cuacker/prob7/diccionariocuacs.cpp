#include "diccionariocuacs.h"
using namespace std;

void DiccionarioCuacs::insertar(Cuac nuevo){
    tabla.TablaHash::insertar(nuevo);
}
void DiccionarioCuacs::follow(string nombre){
    tabla.TablaHash::consultar(nombre);
}
int DiccionarioCuacs::numElem(){
    return tabla.TablaHash::numElem();
}