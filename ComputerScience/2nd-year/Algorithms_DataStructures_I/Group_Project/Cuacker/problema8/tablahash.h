#ifndef _TABLA_HASH
#define _TABLA_HASH
#include "cuac.h"
#include <list>
#include <utility>

class TablaHash{
    private:
        int M;
        int nelem;
        list<pair<string, list<Cuac> > > *tabla;
        int hash_function(string nombre);
    public:
        TablaHash();
        ~TablaHash();
        Cuac* insertar(Cuac nuevo);
        void consultar(string nombre);
        int numelem(void){return nelem;};
};

#endif