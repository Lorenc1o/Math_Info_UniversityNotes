#ifndef _TABLA_HASH
#define _TABLA_HASH

#include <list>
#include "cuac.h"
using namespace std;

class TablaHash{
    private:
        int M;
        list<Cuac> *tabla;
        int n;  
        int HashFunction(string Usuario);
    public:
        TablaHash();
        ~TablaHash();
        void insertar(Cuac nuevo);
        void consultar(string nombre);
        int numElem(){ return n; };
};

#endif