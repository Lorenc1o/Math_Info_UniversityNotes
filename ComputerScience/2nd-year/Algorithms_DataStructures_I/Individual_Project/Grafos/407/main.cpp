#include <stdlib.h>  // Funcion exit
#include <string.h>  // Funcion memset
#include <iostream>  // Variables cin y cout
#include <sstream>  // Para poder leer líneas de enteros
#include <queue>     // Para implementar el recorrido
#include <list>     // Para representar el grafo
#include <vector>   // Para representar el grafo
using namespace std;

#define MAX_NODOS 200
#define inf 20000

//////////////////////////////////////////////////////////////
////////////        VARIABLES GLOBALES        ////////////////
//////////////////////////////////////////////////////////////

int M;                        // Número de nodos del grafo, cotillas
int K;                        // Número de pares de cotillas, aristas
string *C;                    // Array para guardar a qué número corresponde cada ciudad
int D[MAX_NODOS][MAX_NODOS];  // Matriz de caminos mínimos
//////////////////////////////////////////////////////////////
////////////     FUNCIONES DEL PROGRAMA       ////////////////
//////////////////////////////////////////////////////////////

void leeGrafo (void)
// Procedimiento para leer un grafo de la entrada
{
  cin >> M;
  cin.ignore();
  if (M<0 || M>MAX_NODOS) {
    cerr << "Numero de nodos (" << M << ") no valido\n";
    exit(0);
  }

  C = new string[M];
  
  for(int i=0; i<M; i++){
    string city;
    getline(cin, city);
    C[i]=city;
  }

  for(int i=0; i<M; i++){
      for(int j=0; j<M; j++){
          D[i][j]=inf;
      }
  }

  int c1, c2, L;
  while(true){
      cin >> c1 >> c2 >> L;
      if(c1==0 && c2==0 && L==0) break;
      else {
          D[c1][c2]=D[c2][c1]=L;
      }
  }
}

int min(int a, int b){
    if(a<=b) return a;
    return b;
}

void Floyd()
{
  for(int k=0; k<M; k++){
      for(int i=0; i<M; i++){
          for(int j=0; j<M; j++){
              D[i][j]=min(D[i][j], D[i][k]+D[k][j]);
          }
      }
  }
  /*for(int i=0; i<M; i++){
          for(int j=0; j<M; j++){
              cout << D[i][j] << "   ";
          }
          cout << endl;
      }*/
  int capital=0;
  int excentricidad=inf;
  for(int i=0; i<M; i++){
      int mayor=0;
      for(int j=0; j<M; j++){
          if(i!=j && D[i][j]>mayor) mayor=D[i][j];
      }
      if(mayor < excentricidad || (mayor==excentricidad && C[i]<C[capital])){
          capital=i;
          excentricidad=mayor;
      }
  }
  cout << C[capital] << endl;
  cout << excentricidad << endl;
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
    Floyd();
    delete[] C;
  }
}