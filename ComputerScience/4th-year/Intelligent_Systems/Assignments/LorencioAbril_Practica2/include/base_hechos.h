#ifndef BASE_HECHOS_H
#define BASE_HECHOS_H

#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <string>
#include "Regla.h"

using namespace std;

class base_hechos
{
    public:
        base_hechos();
        virtual ~base_hechos();

        /** \Brief Inicializa la base de hechos a partir de un fichero de texto que la contiene
        * \param Ruta al fichero
        * \return True si el fichero tiene el formato correcto, false si no
        */
        bool inicializa_BH(string filename);

        /** \Brief Indica si un hecho está en la BH
        * \param el hecho a comprobar
        * \return true si el hecho está en la BH, false si no
        */
        bool contiene(string hecho);

        /** \Brief Devuelve el factor de certeza asociado a un hecho
        * \param el hecho cuyo fc queremos conocer
        * \return el fc del hecho
        */
        float get_fc(string hecho);

        /** \Brief Añade un hecho, junto con su fc asociado, a la BH
        * \param el hecho
        * \param el fc
        * \return true si se ha añadido correctamente, false si no
        */
        bool add_hecho(string hecho, float fc);

        /** \Brief Añade un objetivo a la BH
        * \param el objetivo a añadir
        * \return true si el objetivo se ha añadido correctamente, false si no
        */
        bool add_objetivo(string objetivo);

        /** \Brief Imprime los hechos de la BH, junto con sus FCs
        */
        void print_bh();

        /** \Brief Devuelve el conjunto de objetivos
        * \return Un conjunto hash de strings con los objetivos
        */
        unordered_set<string> get_objetivo();

    protected:

    private:
        unordered_map<string, float> hechos;
        unordered_set<string> objetivos;

};

#endif // BASE_HECHOS_H
