#include <stdlib.h>  // Funcion exit
#include <iostream>  // Variables cin y cout
#include <queue>     // Para implementar el recorrido
#include <list>     // Para representar el grafo
#include <vector>   // Para representar el grafo
using namespace std;

#define MAX_NODOS 20000
#define MAX_DIST 10000

//////////////////////////////////////////////////////////////
////////////        VARIABLES GLOBALES        ////////////////
//////////////////////////////////////////////////////////////

int nnodos;                        // Número de nodos del grafo, cotillas
int naristas;                        // Número de pares de cotillas, aristas
int inicio;
int paso;
int llegada;
list<pair<int,int>> *G;         // Array de listas de adyacencia

//////////////////////////////////////////////////////////////
////////////     FUNCIONES DEL PROGRAMA       ////////////////
//////////////////////////////////////////////////////////////

void leeGrafo (void)
// Procedimiento para leer un grafo de la entrada
{
  cin >> nnodos;
  cin >> naristas;
  cin >> inicio;
  cin >> llegada;
  cin >> paso;
  if (nnodos<0 || nnodos>MAX_NODOS) {
    cerr << "Numero de nodos (" << nnodos << ") no valido\n";
    exit(0);
  }
  G = new list<pair<int,int>>[nnodos](); 
  
  for(int i=0; i<naristas; i++){
    int u, v, c;
    cin >> u >> v >> c; 
    G[u-1].push_back({v-1,c});
    G[v-1].push_back({u-1,c});
  }
}

int minDist(int na, int nb){
  for(pair<int, int> p : G[na]){
      if(p.first==nb){
          return p.second;
      }
  }
  return MAX_DIST;
}

int Dijkstra(int inicio, vector<bool> &escogidos, int fin)
{
  priority_queue<pair<int,int>,vector<pair<int,int> >, greater<pair<int,int> > > cola;
  vector<int> D(nnodos, MAX_DIST);
  D[inicio]=0;
  cola.push({0, inicio});
  while(!cola.empty()){
    int v = cola.top().second;
    cola.pop();
    escogidos[v]=true;
    for(int i=0; i<nnodos; i++){
      if(!escogidos[i]){
        int maybe=minDist(v, i);
        if(maybe+D[v]<D[i]) {
            D[i]=D[v]+maybe;
            cola.push({D[i], i});
        }
      }
    }
  }
  /*for(int i=0; i<nnodos; i++){
      cout << "nodo " << i << " " << D[i] << endl;
  }*/
  return D[fin];
}

void Dijk(){
  vector<bool> escogidos(nnodos,false);
  int dist=Dijkstra(inicio-1, escogidos, paso-1);
  if(!escogidos[paso-1]) cout << "IMPOSIBLE" << endl;
  else {
      vector<bool> escogidos2(nnodos, false);
      dist+=Dijkstra(paso-1, escogidos2, llegada-1);
      if(!escogidos2[llegada-1]) cout << "IMPOSIBLE" << endl;
      else{
          cout << dist << endl;
      }
  }
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
    Dijk();
    delete[] G;
  }
}