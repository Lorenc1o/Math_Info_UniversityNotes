#include <stdlib.h>  // Funcion exit
#include <string.h>  // Funcion memset
#include <iostream>  // Variables cin y cout
#include <sstream>  // Para poder leer líneas de enteros
#include <queue>     // Para implementar el recorrido
#include <list>     // Para representar el grafo
#include <vector>   // Para representar el grafo
using namespace std;

#define MAX_NODOS 1000
#define MAX_INSTANTE 10000

//////////////////////////////////////////////////////////////
////////////        VARIABLES GLOBALES        ////////////////
//////////////////////////////////////////////////////////////

int X;                        // Número de nodos del grafo, cotillas
int Y;                        // Número de pares de cotillas, aristas
int H[MAX_NODOS][MAX_NODOS];  // Matriz de alturas
bool visitado[MAX_NODOS]; // cola para recorrer en profundidad y guardar los nodos en orden, por si no fuese conexo.

//////////////////////////////////////////////////////////////
////////////     FUNCIONES DEL PROGRAMA       ////////////////
//////////////////////////////////////////////////////////////

void leeGrafo (void)
// Procedimiento para leer un grafo de la entrada
{
  cin >> X >> Y;
  for (int i=0; i<X; i++){
      for(int j=0; j<Y; j++){
        int h;
        cin >> h;
        H[i][j]=h;
      }
  }
  for()
}

int minDist(int na, int nb, int actual){
  int ret=MAX_INSTANTE;
  int centenas=actual/100;
  actual%=100;
  for(vector<int> x : G[na]){
    if(x[0]==nb){
      int size=x.size();
      for(int i=1; i<size; i++) {
        if(x[i] >= actual && x[i] < ret){
          ret=x[i];
        }
        else if(ret==MAX_INSTANTE && x[i] < actual ){
          ret=100+x[i];
        }
        else if(ret!=MAX_INSTANTE && ret%100 < actual && x[i]<ret%100){
          ret=100+x[i];
        }
      }
    }
  }
  if(ret!=MAX_INSTANTE) ret=100*centenas+ret;
  return ret;
}

void bpp(int v)
// Procedimiento recursivo de la busqueda primero en profundidad
//   v - primer nodo visitado en la bpp
{
  visitado[v]= true;
  cout << char(v+'A');
  for (int w= 0; w<nnodos; w++)
    if (!visitado[w] && G[v][w])
      bpp(w);
}

void busquedaPP (void)
// Procedimiento principal de la busqueda en profundidad
{
  memset(visitado, 0, sizeof(visitado));
  for (int v= 0; v<nnodos; v++)
    if (!visitado[v])
      bpp(v);
  cout << endl;
}

//////////////////////////////////////////////////////////////
////////////        PROGRAMA PRINCIPAL        ////////////////
//////////////////////////////////////////////////////////////

int main (void)
{
  int ncasos;
  cin >> ncasos;
  for (int i= 0; i<ncasos;i++) {
    cout << "Caso #" << i << ": "; 
    leeGrafo();
    Dijkstra();
    delete[] G;
  }
}