#include "tablahash.h"
#include <iostream>
using namespace std;

TablaHash::TablaHash()
{
    M = 25000;
    nelem = 0;
    tabla = new list<pair<string, list<Cuac> > >[M]();
}
TablaHash::~TablaHash()
{
    delete[] tabla;
    tabla = NULL;
}
int TablaHash::hash_function(string nombre)
{
    int k = 0;
    for (int i = 0; i < nombre.length(); i++)
    {
        k += ((i + 1) * nombre[i]);
    }
    if (k < 0)
        k *= (-1);
    return k % M;
}

Cuac* TablaHash::insertar(Cuac nuevo)
{
    string usuario = nuevo.get_nombre();
    int k = hash_function(usuario);
    list<pair<string, list<Cuac> > >::iterator it = tabla[k].begin();
    while ((it != tabla[k].end()) && (it->first.compare(usuario) < 0))
    {
        ++it;
    }
    if ((it == tabla[k].end()) || (it->first.compare(usuario) > 0))
    {
        tabla[k].insert(it, pair<string, list<Cuac> >(string(usuario), list<Cuac>()));
        it--;
    }
    list<Cuac>::iterator it2 = it->second.begin();
    while (it2 != it->second.end() && it2->es_anterior(nuevo))
    {
        ++it2;
    }
    it->second.insert(it2, nuevo);
    it2--;
    cout << ++nelem << " cuac" << endl;
    return &*it2;
}
void TablaHash::consultar(string usuario)
{
    int k = hash_function(usuario);
    int cont = 0;
    list<pair<string, list<Cuac> > >::iterator it = tabla[k].begin();
    while ((it != tabla[k].end()) && (it->first.compare(usuario) < 0))
    {
        ++it;
    }
    if ((it != tabla[k].end()) && (it->first.compare(usuario) == 0))
    {
        for (list<Cuac>::iterator it2 = it->second.begin(); it2 != it->second.end(); ++it2)
        {
            cout << ++cont << ". ";
            it2->Cuac::escribir();
        }
    }
    cout << "Total: " << cont << " cuac" << endl;
}