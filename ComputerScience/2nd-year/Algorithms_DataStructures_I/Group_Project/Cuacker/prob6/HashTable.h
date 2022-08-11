#ifndef _TABLA_HASH
#define _TABLA_HASH
using namespace std;
#include "cuac.h"
#include <list>

class TablaHash{
    private:
        int tam;
        list<Cuac>* lista;
        int n;  
    public:
        TablaHash();
        ~TablaHash();
        void insertar(Cuac nuevo);
        void consultar(string nombre);
        int numElem(){ return n; }
};

#endif