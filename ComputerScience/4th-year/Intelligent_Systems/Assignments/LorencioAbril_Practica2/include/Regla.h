#ifndef REGLA_H
#define REGLA_H
#include <string>
#include <vector>

using namespace std;

#define MAX_SIZE 32

class Regla
{
    public:
        typedef struct{
            vector<string> literales;
            vector<string> ops;
            int num_literales;
        } fbf;
        string nombre;
        fbf lhs;
        string rhs;
        float fc;

        Regla(string n, fbf l, string r, float f);
        virtual ~Regla();

        /** \Brief imprime la regla por pantalla
        */
        void print_regla();

        /** \Brief devuelve la regla en forma de string
        */
        string to_string();

    protected:

    private:
};

#endif // REGLA_H
