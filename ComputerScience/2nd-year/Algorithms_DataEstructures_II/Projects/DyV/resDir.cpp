#include <iostream>
#include <utility>
#include <vector>
using namespace std;

int n, m;
string strA, strB;

pair<int, int> resolucionDirecta(int a, int b)
{
    int index = a, contador = 0;
    for (; index < a+m; index++)
    {
        if (strA[index] == strB[index])
            contador++;
    }
    int maximo = contador, maximoIndice = a;
    for (; index < b; index++)
    {
        contador -= (strA[index - m] == strB[index - m]);
        contador += (strA[index] == strB[index]);
        if (maximo < contador)
        {
            maximo = contador;
            maximoIndice = index - m + 1;
        }
    }
    return {maximoIndice, maximo};
}

main(){
    unsigned t0, t1;
    while(cin>>n){
        cin >> m >> strA >> strB;
        cout << "n: " << n << ", m: " << m << endl;
        t0=clock();
        pair<int,int> respuesta = resolucionDirecta(0, n-1);
        t1=clock();
        cout << "Tiempo de ejecución: " << (double(t1-t0)/CLOCKS_PER_SEC) << endl;
        cout << respuesta.first << " " << respuesta.second << endl;
    }
    
}

