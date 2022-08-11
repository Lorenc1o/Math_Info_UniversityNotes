#include <stdlib.h>  // Funcion exit
#include <iostream>  // Variables cin y cout
#include <string.h>  // Funcion memset
#include <queue>     // Para implementar el recorrido topológico
#include <list>     // Para representar el grafo
#include <vector>   // Para representar el grafo
using namespace std;

#define MAX_NODOS 1000
#define MAX_DIST 1000

//////////////////////////////////////////////////////////////
////////////        VARIABLES GLOBALES        ////////////////
//////////////////////////////////////////////////////////////

int nnodos;                        // Número de nodos del grafo
int naristas;                        // Número de aristas
int nrutas;
list<pair<int,int>> *G;         // Grafo
int *grado;
int *tiempo;
list<int> *dep;

//////////////////////////////////////////////////////////////
////////////     FUNCIONES DEL PROGRAMA       ////////////////
//////////////////////////////////////////////////////////////

void leeGrafo (void)
// Procedimiento para leer un grafo de la entrada
{
  cin >> nnodos;
  if (nnodos<0 || nnodos>MAX_NODOS) {
    cerr << "Numero de nodos (" << nnodos << ") no valido\n";
    exit(0);
  }
  G = new list<pair<int,int>>[nnodos];
  grado = new int[nnodos];
  tiempo = new int[nnodos];
  dep = new list<int>[nnodos];
  for(int i=0; i<nnodos; i++){
      grado[i]=0;
  }
  for(int i=0; i<nnodos; i++){
    int pre, ti;
    cin >> ti >> pre;
    tiempo[i]=ti;
    while(pre!=0){
        G[pre-1].push_back({i, ti});
        dep[i].push_back(pre-1);
        grado[i]++;
        cin >> pre;
    }
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

void Topological(){
    vector<bool> escogidos(nnodos,false);
    vector<int> toposort;
    vector<int> dist(nnodos, 0);
    queue<int> c;
    for(int i=0; i<nnodos; i++)
        if(grado[i]==0) {
            c.push(i);
            dist[i]=tiempo[i];
        }
    
    for(int i=0; i<nnodos; i++){
        if(c.empty()) break;
        int cero=c.front();
        c.pop();
        toposort.push_back(cero);
        escogidos[cero]=true;
        for (pair<int,int> p:G[cero]){
            grado[p.first]--;
            dist[p.first]=max(dist[p.first], dist[cero]+p.second);
            if(grado[p.first]==0)
                c.push(p.first);
        } 
    }

    bool b=false;
    for(int i=0; i<nnodos;i++){
        if(!escogidos[i]) b=true;
    }
    if(b) cout << "IMPOSIBLE" << endl;
    else {
        int dista=0;
        for(int i=0; i<nnodos; i++){
            if(dist[i]>dista) dista=dist[i];
        }
        cout << dista << endl;
    }
}

bool posible(){
    for(int i=0; i<nnodos; i++)
        if(grado[i]==0) return true;
    return false;
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
    if(!posible()) cout << "IMPOSIBLE" << endl;
    else Topological();
    delete[] G;
  }
}