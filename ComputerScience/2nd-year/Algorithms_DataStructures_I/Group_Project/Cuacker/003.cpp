#include <iostream>
using namespace std;
#include <string.h>
#include <iomanip>

class Fecha{
    private:
        int ano, mes, dia, hora, min, seg;
    public:
        Fecha(){
            ano=mes=dia=hora=min=seg=0;
        }
        bool leer(){
            char aux;
            cin >> dia >> aux >> mes >> aux >> ano >> hora >> aux >> min >> aux >> seg;
            return 1;
        }
        void escribir(){
            cout << dia << "/" << mes << "/" << ano << " " << setfill('0') << setw(2) << hora << ":" << setfill('0') << setw(2) << min << ":" << setfill('0') << setw(2) << seg;
        }
        //devuelve 1 si this<f
        bool es_menor(Fecha &f){
            return ano<f.ano ? true : 
            f.ano<ano ? false :
            mes<f.mes ? true :
            f.mes<mes ? false :
            dia<f.dia ? true :
            f.dia<dia ? false :
            hora<f.hora ? true :
            f.hora<hora ? false :
            min<f.min ? true :
            f.min<min ? false :
            seg<f.seg ? true :
            false;
        }
        //devuelve 1 si this=f
        bool es_igual(Fecha &f){
            if(ano==f.ano && mes==f.mes && dia==f.dia && hora==f.hora && min==f.min && seg==f.seg) return true;
            return false;
        }
};

int main(){
    int cases;
    Fecha factual, fanterior;
    cin >> cases;
    cin.ignore();
    factual.leer();
    cases--;
    while(cases--){
        fanterior=factual;
        factual.leer();
        if(factual.es_menor(fanterior)){
            factual.escribir();
            cout << " ES ANTERIOR A ";
            fanterior.escribir();
            cout << "\n";
        }
        else if(factual.es_igual(fanterior)){
            factual.escribir();
            cout << " ES IGUAL A ";
            fanterior.escribir();
            cout << "\n";
        }
        else{
            factual.escribir();
            cout << " ES POSTERIOR A ";
            fanterior.escribir();
            cout << "\n";
        }
    }
}