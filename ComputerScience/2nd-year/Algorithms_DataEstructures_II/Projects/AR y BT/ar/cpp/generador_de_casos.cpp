#include <iostream>
#include <stdlib.h>
#include <time.h>
const int nbegin = 10;
const int nend = 10000;
const int nstep = 5;
const int mpern = 7;

using namespace std;

const int maxDist = 100000;

int main(void)
{
    srand(time(0));
    int cases = 0;
    for (int n = nbegin; n <= nend; n *= 10)
        for (int m = n / mpern; m <= n; m += n / mpern)
            cases++;
    cout << cases << endl;
    int cont = 0;
    for (int n = nbegin; n <= nend; n *= 10)
        for (int m = n / mpern; m <= n; m += n / mpern)
        {
            cont++;
            cout << n << " " << m << endl;
            for (int i = 0; i < n; i++)
            {
                for (int j = 0; j < n; j++)
                    cout << ((i == j) ? 0 : rand()) << ((j < n - 1) ? " " : "");
                cout << endl;
            }
            cerr << "Tratando el caso " << cont << ", te tamaño " << n << endl;
        }
}