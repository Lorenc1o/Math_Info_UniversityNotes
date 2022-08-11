#include <iostream>
#include <vector>
#include <time.h>
#define infinity 10000
using namespace std;

bool criterio_4(const int &valorActual, const int &valor_max, const int &nivel, const vector<int> &caudal, const vector<int> &posicion, vector<int> jardinActual)
{
    int posible_mejora = 0;
    for (int i = nivel + 1; i < caudal.size(); i++)
        for (int j = posicion[i] - caudal[i]; j <= posicion[i] + caudal[i]; j++)
            if (jardinActual[j]++ == 0)
                posible_mejora++;

    return valorActual + posible_mejora > valor_max;
}

int main()
{
    int cases, L, S, C;
    cin >> cases;
    while (cases--)
    {
        // LECTURA DE DATOS DEL PROBLEMA
        cin >> L >> S;
        vector<int> posicion(S);
        vector<int> caudal(S);
        for (int i = 0; i < S; i++)
            cin >> posicion[i], posicion[i]--;
        cin >> C;
        for (int i = 0; i < S; i++)
            cin >> caudal[i];

        cerr << "Queda(n) " << cases + 1 << " caso(s)" << endl;
        // variables para llevar los datos que queremos obtener
        clock_t t = clock();
        long long nodos = 0;
        // BACKTRACKING
        vector<int> solucion(S, -1);
        vector<int> jardinActual(L, 0);
        int valorActual = 0, nivel = 0, valorMax = -infinity, caudalUsado = 0;
        while (nivel >= 0)
        {
            // Generar()
            if (++solucion[nivel] == 1 && jardinActual[posicion[nivel]]++ == 0)
                valorActual++;
            if (solucion[nivel] > 0)
            {
                if (jardinActual[posicion[nivel] + solucion[nivel]]++ == 0)
                    valorActual++;
                if (jardinActual[posicion[nivel] - solucion[nivel]]++ == 0)
                    valorActual++;
                caudalUsado++;
            }
            nodos++;
            // fin Generar()
            if (nivel == S - 1 && caudalUsado <= C /*Solucion()*/ && valorActual > valorMax /*Comprobamos si esta solucion es mejor*/)
            {
                valorMax = valorActual;
                if (valorMax >= L)
                    break;
            }
            // Criterio()
            if (nivel < S - 1 && caudalUsado <= C && criterio_4(valorActual, valorMax, nivel, caudal, posicion, jardinActual))
                nivel++;
            // fin Criterio()
            else

                while (nivel >= 0 && !(solucion[nivel] < caudal[nivel]) /*MasHermanos()*/)
                {
                    // Retroceder()
                    for (int i = posicion[nivel] - solucion[nivel]; i < posicion[nivel] + solucion[nivel] + 1; i++)
                        if (--jardinActual[i] == 0)
                            valorActual--;
                    caudalUsado -= solucion[nivel];
                    solucion[nivel] = -1;
                    nivel--;
                    // fin Retroceder()
                }
        }
        t = clock() - t;
        // IMPRIMIMOS
        double tiempo = (double)t / CLOCKS_PER_SEC * 1000;
        long long nodosteoricos = 0;
        long long aux = 1;
        for (const int &x : caudal)
            nodosteoricos += (x + 1) * aux, aux *= (x + 1);
        cout << L << " & " << S << " & " << C << " & " << nodosteoricos << " & ";
        for (int i = 0; i < S; i++)
            cout << caudal[i] << ((i < S - 1) ? ", " : "");
        cout << " & " << nodos << " & " << tiempo << " & " << nodos / tiempo << " \\\\ " << endl;
    }
}