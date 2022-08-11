#include <iostream>
#include <vector>
#include <set>
#include <algorithm>
#include <time.h>
#define infinity 10000000000000
using namespace std;

int main()
{
    cout << "<table><tr><th>n</th><th>m</th><th>time</th></tr>";
    int cases, n, m;
    cin >> cases;
    while (cases--)
    {
        cin >> n >> m;
        cerr << "Tratando el caso " << cases + 1 << endl;
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
        clock_t t = clock();
        pair<int, long long> x = pair<int, long long>(0, infinity);
        for (int i = 0; i < n; i++)
            if (adds[i] < x.second)
                x.first = i, x.second = adds[i];
        while (selected < n - m)
        {
            // pair<unsigned long long, unsigned long long> x = seleccionar(dist, sol, adds, n);
            // insertar(dist, sol, total_dist, adds, selected, x, n);
            pair<int, long long> y = pair<int, long long>(0, infinity);
            sol[x.first] = true;
            total_dist -= x.second;
            for (int i = 0; i < n; i++)
                if (!sol[i])
                {
                    adds[i] -= (dist[x.first][i] + dist[i][x.first]);
                    if (adds[i] < y.second)
                        y.first = i, y.second = adds[i];
                }
            selected++;
            x = y;
        }
        t = clock() - t;
        cout << "<tr><th>" << n << "</th><th>" << m << "</th><th>" << (double)t / CLOCKS_PER_SEC * 1000 << "</th></tr>";
    }
    cout << "</table>";
}
