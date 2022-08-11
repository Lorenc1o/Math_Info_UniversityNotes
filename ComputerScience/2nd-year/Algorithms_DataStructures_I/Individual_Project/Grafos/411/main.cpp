#include <stdlib.h>  // Funcion exit
#include <string.h>  // Funcion memset
#include <iostream>  // Variables cin y cout
#include <queue>     // Uso de colas
using namespace std;

#define MAX_NODOS 20000

//////////////////////////////////////////////////////////////
////////////        VARIABLES GLOBALES        ////////////////
//////////////////////////////////////////////////////////////

int nnodos;                   // Numero de nodos del grafo
int naristas;                 // Numero de aristas del grafo
int G[MAX_NODOS];              // Relación de equivalencia mediante punteros
bool visitado[MAX_NODOS];     // Marcas de nodos visitados

//////////////////////////////////////////////////////////////
////////////     FUNCIONES DEL PROGRAMA       ////////////////
//////////////////////////////////////////////////////////////

int buscarRaiz(int j){
    if(G[j]<=0) return j;
    G[j] = buscarRaiz(G[j]);
    return G[j];
}

void leeGrafo (void)
// Procedimiento para leer un grafo de la entrada
{
  cin >> nnodos >> naristas;
  if (nnodos<0 || nnodos>MAX_NODOS) {
    cerr << "Numero de nodos (" << nnodos << ") no valido\n";
    exit(0);
  }
  memset(G, 0, sizeof(G));
  int i1, i2;
  for (int i= 0; i<naristas; i++) {
    cin >> i1 >> i2;
    int r1=buscarRaiz(i1);
    int r2=buscarRaiz(i2);
    if(r1 < r2){
        G[r2] = r1;
    }
    else if(r1==r2){
        G[i2]=r1;
    }
    else{
        G[r1] = r2;
    }
    }    
}

void busquedaIslas(){
    int nislas=0;
    int isla=-1;
    for(int i=1; i<=nnodos; i++){
        if(G[i]==0) {
            nislas++;
            G[i] = isla;
            isla--;
        }
    }
    cout << nislas << endl;
    for(int i=1; i<=nnodos; i++){
        if(G[i]>=0){
            int j=buscarRaiz(G[i]);
            cout << -G[j] << endl;
        }
        else cout << -G[i] << endl;
    }

}

//////////////////////////////////////////////////////////////
////////////        PROGRAMA PRINCIPAL        ////////////////
//////////////////////////////////////////////////////////////

int main (void)
{
  int ncasos;
  cin >> ncasos;
  for (int i= 0; i<ncasos;) {
    cout << "Caso " << ++i << endl;
    leeGrafo();
    busquedaIslas();
  }
}