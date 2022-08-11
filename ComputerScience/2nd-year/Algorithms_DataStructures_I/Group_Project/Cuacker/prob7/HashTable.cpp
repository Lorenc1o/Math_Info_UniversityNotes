#include "HashTable.h"
using namespace std;

TablaHash::TablaHash(){
    M = 10000;
    tabla = new list<Cuac>[M]();
    n = 0;
}
TablaHash::~TablaHash(){
    delete[] tabla;
    tabla=NULL;
}

int TablaHash::HashFunction(string Usuario){
    int k=0;
    for(int i=0; i<Usuario.length(); i++){
        k+=(i+1)*Usuario[i];
    }
    if (k<0) k*=-1; 
    return k%M;
}

void TablaHash::insertar(Cuac nuevo){
    int k = TablaHash::HashFunction(nuevo.get_usuario());
    list<Cuac>::iterator it=tabla[k].begin();
    if(!tabla[k].empty()){
        while(it->es_anterior(nuevo) && ++it!=tabla[k].end()){}
    } 
    tabla[k].insert(it, nuevo);
    cout << ++n << " cuac" << endl;
}

void TablaHash::consultar(string nombre){
    int cont=0;
    int k = TablaHash::HashFunction(nombre);
    for(list<Cuac>::iterator it=tabla[k].begin(); it!=tabla[k].end(); ++it){
        if(it->Cuac::get_usuario()==nombre) {
            cout << ++cont << ". ";
            it->Cuac::escribir();
        }
    }
    cout << "Total: " << cont << " cuac" << endl;
}

