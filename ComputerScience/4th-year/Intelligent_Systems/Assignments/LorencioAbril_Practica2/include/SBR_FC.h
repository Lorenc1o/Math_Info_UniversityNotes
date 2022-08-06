#ifndef SBR_FC_H
#define SBR_FC_H

#include "base_conocimientos.h"
#include "base_hechos.h"

using namespace std;

class SBR_FC
{
    public:
        SBR_FC();
        virtual ~SBR_FC();

        /** \Brief Resuelve los objetivos de la BH e imprime sus FC por pantalla
        * \param fichero en el que escribir
        */
        void encadenamiento_hacia_atras(ofstream& ostr);

        base_conocimientos BC;
        base_hechos BH;
        vector<string> metas;


    protected:

    private:
        /** \Brief comprueba si una meta dada es un hecho
        * \param la meta a verificar si es un hecho
        * \return true si la meta está en la BH, false si no
        */
        bool contenida(string meta);

        /** \Brief calcula el FC de una meta dada, de forma recursiva, a partir de la información de la BH y la BC
        * \param la meta cuyo FC queremos conocer
        * \param la profunidad de la recursividad, para propósitos de formateo de la salida
        * \param fichero en el que escribir
        * \return el FC calculado de meta
        */
        float calcular_fc(string meta, int profundidad, ofstream& ostr);


};

#endif // SBR_FC_H
