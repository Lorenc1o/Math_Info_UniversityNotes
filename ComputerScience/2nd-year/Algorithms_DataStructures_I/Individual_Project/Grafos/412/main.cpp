#include <stdlib.h>  // Funcion exit
#include <iostream>  // Variables cin y cout
#include <string.h>  // Funcion memset
#include <queue>     // Para implementar el recorrido
#include <list>     // Para representar el grafo
#include <vector>   // Para representar el grafo
using namespace std;

#define MAX_NODOS 10000
#define MAX_DIST 2000000

//////////////////////////////////////////////////////////////
////////////        VARIABLES GLOBALES        ////////////////
//////////////////////////////////////////////////////////////

int nnodos;                        // Número de nodos del grafo
int naristas;                        // Número de aristas
int nrutas;
list<pair<int,int>> *G;         // Grafo

//////////////////////////////////////////////////////////////
////////////     FUNCIONES DEL PROGRAMA       ////////////////
//////////////////////////////////////////////////////////////

void leeGrafo (void)
// Procedimiento para leer un grafo de la entrada
{
  if(nnodos==0 && naristas==0) return;
  if (nnodos<0 || nnodos>MAX_NODOS) {
    cerr << "Numero de nodos (" << nnodos << ") no valido\n";
    exit(0);
  }
  G = new list<pair<int,int>>[nnodos];
  for(int i=0; i<naristas; i++){
    int u, v, c;
    cin >> u >> v >> c; 
    G[u].push_back({v,c});
    G[v].push_back({u,c});
  }
}

int max(int a, int b){
    if(a>=b) return a;
    return b;
}

int min(int a, int b){
    if(a<=b) return a;
    return b;
}

int Dijkstra(int inicio, int fin)
{
  priority_queue<pair<int,int>,vector<pair<int,int> >, greater<pair<int,int> > > cola;
  vector<int> D(nnodos, MAX_DIST);
  vector<bool> escogidos(nnodos,false);
  D[inicio]=0;
  cola.push({0, inicio});
  while(!cola.empty()){
    int v = cola.top().second;
    cola.pop();
    escogidos[v]=true;
    for(pair<int,int> p : G[v]){
        if(!escogidos[p.first]){
            int pp=D[p.first];
            D[p.first]=min(D[p.first], max(D[v], p.second));
            if(pp!=D[p.first])
                cola.push({D[p.first], p.first});
        }
    }
  }
  return D[fin];
}

void Dijk(){
  int inicio, llegada;
  cin >> inicio >> llegada;
  if(inicio==llegada) cout << 0 << endl;
  else {
      int dist=Dijkstra(inicio, llegada);
      cout << dist << endl;
  }
}

//////////////////////////////////////////////////////////////
////////////        PROGRAMA PRINCIPAL        ////////////////
//////////////////////////////////////////////////////////////

int main (void)
{
  cin >> nnodos >> naristas;
  while(nnodos!=0 || naristas !=0) {
    leeGrafo();
    if(nnodos!=0 || naristas!=0){
        int nrutas;
        cin >> nrutas;
        for(int i=0; i<nrutas; i++){
            Dijk();
        }
        delete[] G;
        cin >> nnodos >> naristas;
        if(nnodos!=0) cout << endl;
    }
  }
}