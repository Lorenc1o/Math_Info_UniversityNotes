#include <stdlib.h>  // Funcion exit
#include <string.h>  // Funcion memset
#include <iostream>  // Variables cin y cout
#include <sstream>  // Para poder leer líneas de enteros
#include <queue>     // Para implementar el recorrido
#include <list>     // Para representar el grafo
using namespace std;

#define MAX_NODOS 20000

//////////////////////////////////////////////////////////////
////////////        VARIABLES GLOBALES        ////////////////
//////////////////////////////////////////////////////////////

int nnodos;                   // Numero de nodos del grafo
list<int> *G;                 // Array listas de adyacencia. Dado G[x][y]={Mayor int cuanto más a la derecha está.}
bool visitado[MAX_NODOS];     // Marcas de nodos visitados
queue<int> q;                 // cola para recorrer en profundidad y guardar los nodos en orden, por si no fuese conexo.

//////////////////////////////////////////////////////////////
////////////     FUNCIONES DEL PROGRAMA       ////////////////
//////////////////////////////////////////////////////////////



void busquedaPP (void)
// Hago búsqueda en profundidad solo en el primer elemento, para saber si conecta con el último
{
  memset(visitado, 0, sizeof(visitado));
  bpp(0);
  if (visitado[nnodos-1]) {
    cout << q.size() << endl;
    while(!q.empty()){
      int x=q.front();
      q.pop();
      cout << x << endl;
    }
  }
  else{
    cout << "INFINITO" << endl;
    while(!q.empty()) q.pop();
  } 
}

void leeGrafo (void)
// Procedimiento para leer un grafo de la entrada
{
  cin >> nnodos;
  cin.ignore();
  if (nnodos<0 || nnodos>MAX_NODOS) {
    cerr << "Numero de nodos (" << nnodos << ") no valido\n";
    exit(0);
  }
  delete[] G;
  G = new list<int>[nnodos];
  int c;
  for (int i=0; i<nnodos; i++){
      string linea;
      getline(cin, linea);
      istringstream iss (linea);
      while(iss >> c){
        G[i].push_back(c);
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
  for (int i= 0; i<ncasos;) {
    cout << "Caso " << ++i << endl;
    leeGrafo();
    busquedaPP();
  }
}