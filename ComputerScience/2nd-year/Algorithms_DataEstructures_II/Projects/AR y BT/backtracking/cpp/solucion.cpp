#include <iostream>
#include <vector>
#define infinity 10000
using namespace std;

bool criterio_4(const int &valorActual, const int &valor_max, const int &nivel, const vector<int> &caudal, const vector<int> &posicion, vector<int> jardinActual)
{
    int posible_mejora = 0;
    for (int i = nivel + 1; i < (int)caudal.size(); i++)
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
        cin >> L >> S;
        vector<int> posicion(S);
        vector<int> caudal(S);
        for (int i = 0; i < S; i++)
            cin >> posicion[i], posicion[i]--;
        cin >> C;
        for (int i = 0; i < S; i++)
            cin >> caudal[i];

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
            // fin Generar()
            if (nivel == S - 1 && caudalUsado <= C /*Solucion()*/ && valorActual > valorMax /*Comprobamos si esta solucion es mejor*/)
            {
                valorMax = valorActual;
                if (valorMax >= L)
                    break;
            }
            if (nivel < S - 1 && caudalUsado <= C && criterio_4(valorActual, valorMax, nivel, caudal, posicion, jardinActual))
                nivel++;
            // fin Criterio()
            else
                // MasHermanos()
                while (nivel >= 0 && !(solucion[nivel] < caudal[nivel]))
                {
                    // Retroceder()
                    for (int i = posicion[nivel] - solucion[nivel]; i < posicion[nivel] + solucion[nivel] + 1; i++)
                        if (--jardinActual[i] == 0)
                            valorActual--;
                    caudalUsado -= solucion[nivel];
                    solucion[nivel] = -1;
                    nivel--;
                }
        }
        cout << valorMax << endl;
    }
}