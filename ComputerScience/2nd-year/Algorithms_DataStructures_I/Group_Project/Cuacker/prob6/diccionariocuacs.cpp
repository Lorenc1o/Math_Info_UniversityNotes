#include "diccionariocuacs.h"
using namespace std;

DiccionarioCuacs::DiccionarioCuacs(){
    list<Cuac> lista;
    contador=0;
}
void DiccionarioCuacs::insertar(Cuac nuevo){
    list<Cuac>::iterator it=lista.begin();
    if(!lista.empty()){
        while(it->es_anterior(nuevo) && ++it!=lista.end()){}
    }
    lista.insert(it,nuevo);
    cout << ++contador << " cuac" << endl;
}
void DiccionarioCuacs::last(int N){
    if(contador<N) N=contador;
    list<Cuac>::iterator it = lista.begin();
    for(int i=0; i<N;){
        cout << ++i << ". ";
        it->Cuac::escribir();
        it++;
    }
    cout << "Total: " << N << " cuac" << endl;
}
void DiccionarioCuacs::date(Fecha f1, Fecha f2){
    int cont=0;
    if(!lista.empty()){
        list<Cuac>::iterator it=lista.begin();
        while((!it->get_fecha().es_menor(f2) && !it->get_fecha().es_igual(f2)) && (++it!=lista.end())){}
        while((it!=lista.end()) && (!it->get_fecha().es_menor(f1))){
            cout << ++cont << ". ";
            it->Cuac::escribir();
            ++it;
        }
    }
    cout << "Total: " << cont << " cuac" << endl;
}
void DiccionarioCuacs::follow(string nombre){
    int cont=0;
    for(list<Cuac>::iterator it=lista.begin(); it != lista.end(); ++it){
        if(it->Cuac::es_de_usuario(nombre)){
            cout << ++cont << ". ";
            it->Cuac::escribir();
        }
    }
    cout << "Total: " << cont << " cuac" << endl;
}