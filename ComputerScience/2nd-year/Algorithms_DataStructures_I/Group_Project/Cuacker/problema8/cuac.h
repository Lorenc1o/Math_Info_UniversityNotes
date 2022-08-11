#ifndef _CUAC
#define _CUAC

#include "fecha.h"
#include <iostream>
using namespace std;

class Cuac
{
  private:
    Fecha fecha;
    string usuario;
    string texto;

  public:
    bool leer_mcuac();
    bool leer_pcuac();
    void escribir();
    bool es_anterior(Cuac &otro);
    bool es_de_usuario(string nombre);
    Fecha get_fecha(){return fecha;}
    string get_nombre(){return usuario;}
};

#endif