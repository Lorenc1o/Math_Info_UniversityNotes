#include <iostream>
#include <stdlib.h>
#include <time.h>
#include <vector>
const int nbegin = 10;
const int nend = 10000;
const int nstep = 5;
const int mpern = 7;
const int max_dist = 100000;
using namespace std;

int main(void)
{
    srand(time(0));
    short type;
    cin >> type;
    int cases = 0;
    for (int n = nbegin; n <= nend; n *= 10)
        for (int m = n / mpern; m <= n; m += n / mpern)
            cases++;
    cout << cases << endl;
    int cont = 0;
    for (int n = nbegin; n <= nend; n *= 10)
    {
        vector<vector<int>> v(n, vector<int>(n));
        for (int m = n / mpern; m <= n; m += n / mpern)
        {
            cont++;
            cout << n << " " << m << endl;
            switch (type)
            {
            case 1:
                for (int i = 0; i < n; i++)
                    for (int j = 0; j < n; j++)
                        v[i][j] = ((i == j) ? 0 : rand()) % max_dist;
                break;
            case 2:
                for (int i = 0; i < n; i++)
                    for (int j = 0; j < n; j++)
                        v[i][j] = ((i == j) ? 0 : i + 1);
                break;
                break;
            case 3:
                for (int i = 0; i < n; i++)
                    for (int j = 0; j < n; j++)
                        v[i][j] = ((i == j) ? 0 : n - i);
                break;
            }

            for (int i = 0; i < n; i++)
            {
                for (int j = 0; j < n; j++)
                    cout << v[i][j] << ((j < n - 1) ? " " : "");
                cout << endl;
            }
            cerr << "Tratando el caso " << cont << ", de tamaño " << n << endl;
        }
    }
}