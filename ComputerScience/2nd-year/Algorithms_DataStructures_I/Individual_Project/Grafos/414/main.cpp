#include <stdlib.h>  // Funcion exit
#include <iostream>  // Variables cin y cout
#include <queue>     // Para implementar el recorrido
#include <list>     // Para representar el grafo
#include <vector>   // Para representar el grafo
using namespace std;

#define MAX_NODOS 20000
#define MAX_DIST 1000000

//////////////////////////////////////////////////////////////
////////////        VARIABLES GLOBALES        ////////////////
//////////////////////////////////////////////////////////////

int N;                        // Número de casas
int S;                        // Lo que tarda en subir la marea
int B;                          // Lo que tarda en bajar
int nnodos;                     // Número nodos
int naristas;                   // Número aristas
pair<int,int> especial;         // (Casa, McDonalds)
list<vector<int>> *G;         // Array de listas de adyacencia
bool marea=false;

//////////////////////////////////////////////////////////////
////////////     FUNCIONES DEL PROGRAMA       ////////////////
//////////////////////////////////////////////////////////////

void leeGrafo (void)
// Procedimiento para leer un grafo de la entrada
{
  cin >> S >> B;
  cin >> nnodos >> naristas;
  if (nnodos<0 || nnodos>MAX_NODOS) {
    cerr << "Numero de nodos (" << nnodos << ") no valido\n";
    exit(0);
  }
  G = new list<vector<int>>[nnodos](); 

  cin >> especial.first >> especial.second;
  for(int i=0; i<naristas; i++){
    int u, v, p, s;

    cin >> u >> v >> p >> s;
    
    vector<int> vec(3,0), vecc(3,0);

    vec[0]=v; vec[1]=p; vec[2]=s;
    vecc[0]=u; vecc[1]=p; vecc[2]=s;

    G[u].push_back(vec);
    G[v].push_back(vecc);
  }
}

int minDist(int na, int nb, vector<int> D){
  for(vector<int> v : G[na]){
      if(v[0]==nb && D[na]+v[1]<D[nb] && (v[2]==1 || !marea))
          return v[1]+D[na];
      else if(v[0]==nb && D[na]+v[1]<D[nb] && (v[2]==0 && marea))
          return D[na]+v[1]+B-(D[na]%S);
      else if (v[0]==nb) return MAX_DIST;
  }
  return MAX_DIST;
}

int min(int a, int b){
    if(a<=b) return a;
    return b;
}

int Dijkstra(int inicio, vector<bool> &escogidos, int fin)
{
  priority_queue<pair<int,int>,vector<pair<int,int> >, greater<pair<int,int> > > cola;
  vector<int> D(nnodos, MAX_DIST);
  D[inicio]=0;
  marea=false;
  cola.push({0, inicio});
  while(!cola.empty() && !escogidos[fin]){
    int v = cola.top().second;
    cola.pop();
    escogidos[v]=true;
    if(D[v]%(S+B)>=S) marea=true;
    else marea=false; 
    for(vector<int> vec : G[v]){
        if(!escogidos[vec[0]]){
            int maybe=D[vec[0]];
            D[vec[0]]=min(minDist(v, vec[0], D), D[vec[0]]);
            if(maybe!=D[vec[0]])
                cola.push({D[vec[0]], vec[0]});
        }
    }
  }
  return D[fin];
}

void Dijk(){
  vector<bool> escogidos(nnodos,false);
  int dist=Dijkstra(especial.first, escogidos, especial.second);
  cout << dist << endl;
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