#include <stdlib.h>  // Funcion exit
#include <string.h>  // Funcion memset
#include <iostream>  // Variables cin y cout
#include <sstream>  // Para poder leer líneas de enteros
#include <queue>     // Para implementar el recorrido
#include <list>     // Para representar el grafo
#include <vector>   // Para representar el grafo
using namespace std;

#define MAX_NODOS 20000
#define MAX_INSTANTE 10000

//////////////////////////////////////////////////////////////
////////////        VARIABLES GLOBALES        ////////////////
//////////////////////////////////////////////////////////////

int M;                        // Número de nodos del grafo, cotillas
int K;                        // Número de pares de cotillas, aristas
list<vector<int>> *G;         // Array de listas de adyacencia
queue<int> q;                 // cola para recorrer en profundidad y guardar los nodos en orden, por si no fuese conexo.

//////////////////////////////////////////////////////////////
////////////     FUNCIONES DEL PROGRAMA       ////////////////
//////////////////////////////////////////////////////////////

void leeGrafo (void)
// Procedimiento para leer un grafo de la entrada
{
  cin >> M;
  cin >> K;
  cin.ignore();
  if (M<0 || M>MAX_NODOS) {
    cerr << "Numero de nodos (" << M << ") no valido\n";
    exit(0);
  }
  G = new list<vector<int>>[M](); 
  
  for(int i=0; i<K; i++){
    int c1, c2, v;
    cin >> c1 >> c2 >> v;
    vector<int> vec(v+1);
    vec[0]=c2-1;
    vector<int> vecc(v+1);
    vecc[0]=c1-1;
    for(int j=1; j<=v; j++){
      int ins;
      cin >> ins;
      vec[j]=ins;
      vecc[j]=ins;
    } 
    G[c1-1].push_back(vec);
    G[c2-1].push_back(vecc);
  }
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

void Dijkstra()
{
  vector<bool> escogidos(M,false);
  priority_queue<pair<int,int>,vector<pair<int,int> >, greater<pair<int,int> > > cola;
  vector<int> D(M, MAX_INSTANTE);
  D[0]=0;
  cola.push({0, 0});
  while(!cola.empty()){
    int v = cola.top().second;
    cola.pop();
    escogidos[v]=true;
    for(int i=0; i<M; i++){
      int maybe=minDist(v, i, D[v]);
      if(maybe<D[i]) {
        D[i]=maybe;

        cola.push({D[i], i});
      }
    }
  }
  int max=0;
  for(int i=1; i<M;i++){
    if (!escogidos[i]){
      max=-1;
      break;
    }
    else {
      if (D[i] > max) max=D[i];
    }
  }
  cout << max << endl;
}

//////////////////////////////////////////////////////////////
////////////        PROGRAMA PRINCIPAL        ////////////////
//////////////////////////////////////////////////////////////

int main (void)
{
  int ncasos;
  cin >> ncasos;
  for (int i= 0; i<ncasos;i++) {
    leeGrafo();
    Dijkstra();
    delete[] G;
  }
}