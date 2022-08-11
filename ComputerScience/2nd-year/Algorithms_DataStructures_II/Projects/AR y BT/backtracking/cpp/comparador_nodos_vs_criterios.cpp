#include <iostream>
#include <vector>
#include <time.h>
#define infinity 10000
using namespace std;

void imprimir(const int &L, const int &S, const int &nodosteoricos, const int &C, const vector<pair<int, double>> v)
{
    cout << L << " & " << S << " & " << C << " & " << nodosteoricos << " & ";
    for (int i = 0; i < 4; i++)
    {
        cout << v[i].first << " & " << v[i].second << " & " << v[i].first / v[i].second;
        if (i < 3)
            cout << " & ";
    }
    cout << " \\\\ " << endl;
}

long long calcular_nodos_teoricos(const vector<int> &caudal)
{
    long long nodosteoricos = 0;
    long long aux = 1;
    for (const int &x : caudal)
        nodosteoricos += (x + 1) * aux, aux *= (x + 1);
    return nodosteoricos;
}

bool criterio_2(const int &caudalUsado, const int &C)
{
    return caudalUsado <= C;
}

bool criterio_3(const int &valorActual, const int &valor_max, const int &nivel, const vector<int> &caudal)
{
    int posible_mejora = 0;
    for (int i = nivel + 1; i < caudal.size(); i++)
        posible_mejora += caudal[i] * 2 + ((caudal[i] == 0) ? 0 : 1);
    return valorActual + posible_mejora > valor_max;
}
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
        // VARIABLE PARA GUARDAR LOS DATOS A IMPRIMIR
        vector<pair<int, double>> v(4, {0, 0});
        // LO RESOLVEMOS CON TODOS LOS CRITERIOS
        for (int j = 0; j < 4; j++)
        {
            cerr << "Queda(n) " << cases + 1 << " caso(s), probando criterio " << j + 1 << endl;
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
                if (nivel < S - 1 && (j < 1 || criterio_2(caudalUsado, C)) && (j != 2 || criterio_3(valorActual, valorMax, nivel, caudal)) && (j != 3 || criterio_4(valorActual, valorMax, nivel, caudal, posicion, jardinActual)))
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
            // GUARDAMOS LOS DATOS PARA CADA CRITERIO
            t = clock() - t;
            v[j] = {nodos, (double)t / CLOCKS_PER_SEC * 1000};
        }
        // IMPRIMIMOS TODOS LOS DATOS
        imprimir(L, S, calcular_nodos_teoricos(caudal), C, v);
    }
}