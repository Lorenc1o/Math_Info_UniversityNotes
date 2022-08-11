#include <iostream>
#include <stdlib.h>
#include <vector>
using namespace std;

int main(void)
{
    srand(time(NULL));
    int cases = 0;
    for (int L = 10; L <= 30; L += 10)
        for (int C = 2; C <= 2 * L; C *= 2)
            for (int S = 2; S <= L / 2; S += 3)
                cases++;
    cout << cases << endl;
    for (int L = 10; L <= 30; L += 10)
        for (int S = 2; S <= L / 2; S += 3)
            for (int C = 2; C <= 2 * L; C *= 2)
            {
                cout << L << endl
                     << S << endl;
                vector<int> posicion(S);
                for (int i = 0; i < S; i++)
                    posicion[i] = (rand() % L) + 1, cout << posicion[i] << ((i < S - 1) ? " " : "");
                cout << endl
                     << C << endl;
                for (int i = 0; i < S; i++)
                {
                    int minimo = min(posicion[i] - 1, L - posicion[i]);
                    cout << ((minimo) ? rand() % minimo : 0) << ((i < S - 1) ? " " : "");
                }
                cout << endl;
            }
}