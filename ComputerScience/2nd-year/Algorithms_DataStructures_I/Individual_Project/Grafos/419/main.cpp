#include <stdlib.h>  // Funcion exit
#include <string.h>  // Funcion memset
#include <iostream>  // Variables cin y cout
#include <list>      // Listas
#include <queue>     // colas
using namespace std;

#define MAX_NODOS 20000
#define MAX_DIST 10000

//////////////////////////////////////////////////////////////
////////////        VARIABLES GLOBALES        ////////////////
//////////////////////////////////////////////////////////////

int nplazas;                  // Numero de nodos del grafo
int ncalles;                  // Numero de aristas del grafo
int pcont;
int ccont;
list<pair<int,int>> *G;                // Array de listas
bool P[MAX_NODOS];            // Array de plazas controladas
bool C[MAX_NODOS][MAX_NODOS]; // Matriz de calles controladas
bool visitado[MAX_NODOS];     // Marcas de nodos visitados

//////////////////////////////////////////////////////////////
////////////     FUNCIONES DEL PROGRAMA       ////////////////
//////////////////////////////////////////////////////////////

void leeGrafo (void)
// Procedimiento para leer un grafo de la entrada
{
  cin >> nplazas >> ncalles;
  if (nplazas<0 || nplazas>MAX_NODOS) {
    cerr << "Numero de nodos (" << nplazas << ") no valido\n";
    exit(0);
  }
  G = new list<pair<int,int>>[nplazas]();
  memset(C, false, sizeof(C));
  memset(P, false, sizeof(P));
  pcont=0;
  ccont=0;
  for (int i= 0; i<nplazas; i++) {
    string s;
    cin >> s;
    if(s=="SI") {
        P[i]=true;
        pcont++;
    }
  }
  queue<bool> q;
  for (int i=0; i<ncalles; i++){
    string s;
    cin >> s;
    if(s=="SI") {
        q.push(true);
        ccont++;
    }
    else q.push(false);
  }
  for(int i=0; i<ncalles; i++){
    int x,y;
    cin >> x >> y;
    G[x].push_back({i,y});
    G[y].push_back({i,x});
    if(q.front()){
        C[x][y]=C[y][x]=true;
    }
    q.pop();
  }
}

int minDist(int na, int nb, int actual){
  int ret=MAX_DIST;
  for(pair<int,int> p: G[na]){
      if(p.second==nb){
          ret=p.first;
          if(P[nb]) ret+=ncalles/2;
          if(C[na][nb]) ret+=ncalles/2;
          break;
      }
  }
  return ret;
}

void Dijkstra()
{
  vector<bool> escogidos(nplazas,false);
  priority_queue<pair<int,int>,vector<pair<int,int> >, greater<pair<int,int> > > cola;
  vector<int> D(nplazas, MAX_DIST);
  queue<int> calles;
  D[0]=0;
  cola.push({0, 0});
  while(!cola.empty()){
    int v = cola.top().second;
    cola.pop();
    escogidos[v]=true;
    for(int i=0; i<nplazas; i++){
      int maybe=minDist(v, i, D[v]);
      if(maybe<D[i]) {
        D[i]=maybe;
        cola.push({D[i], i});
      }
    }
  }
  if (!escogidos[ncalles]){
      cout << "IMPOSIBLE" << endl;
    }
    else {
        cout << pcont << " " << ccont << endl;

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
  for (int i= 0; i<ncasos; i++) {
    leeGrafo();
    busquedaPP();
    delete[] G;
  }
}