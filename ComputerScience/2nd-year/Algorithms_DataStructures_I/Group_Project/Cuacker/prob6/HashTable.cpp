#include "HashTable.h"
using namespace std;

TablaHash::TablaHash(){
    M = 5000;
    lista[M];
    for(int i=0; i<M, i++){
        lista[i] = new list<Cuac>;
    }
    n=0;
}
~TablaHash(){
    for(int i=0; i<M; i++0){
        lista[i].delete();
    }
}