#ifndef BASE_CONOCIMIENTOS_H
#define BASE_CONOCIMIENTOS_H

#include <vector>
#include "Regla.h"
#include "base_hechos.h"
#include <fstream>

using namespace std;

class base_conocimientos
{
    public:
        base_conocimientos();
        virtual ~base_conocimientos();

        /** \Brief Inicializa la base de conocimientos a partir de un fichero de texto que la contiene
        * \param Ruta al fichero
        * \return True si el fichero tiene el formato correcto, false si no
        */
        bool inicializa_BC(string filename);

        /** \Brief Añade una nueva regla
        * \param La regla a añadir
        */
        void add_regla(Regla r);

        /** \Brief Obtiene las reglas que tienen como consecuente la meta a verificar
        * \param Cadena que indica la meta a verificar
        * \return Vector con las reglas de la BC que tienen meta como consecuente
        */
        vector<Regla> equiparar(string meta);

        /** \Brief Imprime todas las reglas de la BC
        */
        void print_reglas();
    protected:

    private:
        int num_reglas=0;
        vector<Regla> reglas;
};

#endif // BASE_CONOCIMIENTOS_H
