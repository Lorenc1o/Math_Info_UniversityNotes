#ifndef _FECHA
#define _FECHA

class Fecha
{
  private:
    int day, month, year, hour, minutes, seconds;

  public:
    Fecha();
    bool leer();
    void escribir();
    bool es_menor(Fecha &otra);
    bool es_igual(Fecha &otra);
};

#endif