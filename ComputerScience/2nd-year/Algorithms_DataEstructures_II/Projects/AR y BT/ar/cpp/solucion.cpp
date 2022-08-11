#include <iostream>
#include <vector>
#include <set>
#include <algorithm>
#define infinity 1000000000
using namespace std;

int main()
{
    int cases, n, m;
    cin >> cases;
    while (cases--)
    {
        cin >> n >> m;
        // declaramos las estructuras de datos que necesitamos
        vector<vector<long long>> dist(n, vector<long long>(n, 0));
        vector<long long> adds(n, 0);
        vector<bool> sol(n, false);
        long long selected = 0;
        long long total_dist = 0;
        // leemos entrada
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++)
                cin >> dist[i][j], total_dist += dist[i][j], adds[i] += dist[i][j], adds[j] += dist[i][j];

        // algoritmo en sí
        // seleccionamos el primer nodo (primera llamada a Seleccionar())
        pair<int, long long> x = pair<int, long long>(0, infinity);
        for (int i = 0; i < n; i++)
            if (adds[i] < x.second)
                x.first = i, x.second = adds[i];
        while (selected < n - m)
        {
            // pair<unsigned long long, unsigned long long> x = seleccionar(dist, sol, adds, n);
            // insertar(dist, sol, total_dist, adds, selected, x, n);
            pair<int, long long> y = pair<int, long long>(0, infinity);
            // Insertar()
            sol[x.first] = true;
            total_dist -= x.second;
            for (int i = 0; i < n; i++)
                if (!sol[i])
                {
                    adds[i] -= (dist[x.first][i] + dist[i][x.first]);
                    /*
                    *   Aquí estamos guardando ya el mínimo de los nodos, para el Seleccionar()
                    */
                    if (adds[i] < y.second)
                        y.first = i, y.second = adds[i];
                }
            selected++;
            // Seleccionar() en sí
            x = y;
        }
        cout << total_dist << endl;
        for (int i = 0; i < n; i++)
            cout << !sol[i] << ((i < n - 1) ? " " : "");
        cout << endl;
    }
}
