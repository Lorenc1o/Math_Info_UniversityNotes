#include <iostream>
using namespace std;
#include <string.h>
#include <iomanip>

const int MAX_TEXTOS= 30;

string arr[MAX_TEXTOS]={"Afirmativo.","Negativo.","Estoy de viaje en el extranjero.",
 "Muchas gracias a todos mis seguidores por vuestro apoyo.", "Enhorabuena, campeones!", 
 "Ver las novedades en mi pagina web.", "Estad atentos a la gran exclusiva del siglo.", 
 "La inteligencia me persigue pero yo soy mas rapido.", "Si no puedes convencerlos, confundelos.", 
 "La politica es el arte de crear problemas.", "Donde estan las llaves, matarile, rile, rile...", 
 "Si no te gustan mis principios, puedo cambiarlos por otros.", 
 "Un dia lei que fumar era malo y deje de fumar.",
 "Yo si se lo que es trabajar duro, de verdad, porque lo he visto por ahi.", 
 "Hay que trabajar ocho horas y dormir ocho horas, pero no las mismas.", "Mi vida no es tan glamurosa como mi pagina web aparenta.", 
 "Todo tiempo pasado fue anterior.", "El azucar no engorda... engorda el que se la toma.", 
 "Solo los genios somos modestos.", "Nadie sabe escribir tambien como yo.",
 "Si le molesta el mas alla, pongase mas aca.", "Me gustaria ser valiente. Mi dentista asegura que no lo soy.",
 "Si el dinero pudiera hablar, me diria adios.", "Hoy me ha pasado una cosa tan increible que es mentira.",
 "Si no tienes nada que hacer, por favor no lo hagas en clase.", "Que nadie se vanaglorie de su justa y digna raza, que pudo ser un melon y salio una calabaza.", "Me despido hasta la proxima. Buen viaje!", "Cualquiera se puede equivocar, inclusivo yo.", "Estoy en Egipto. Nunca habia visto las piramides tan solas.", "El que quiera saber mas, que se vaya a Salamanca."};

void escribirMensaje(int n){
    cout<<arr[n-1]<<endl;
}
string devolverMensaje(int n){
    return arr[n-1];
}

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

class cuac{
    private:
        Fecha fechaEnvio;
        string mensaje, usuario;
    public:
        void leer_mcuac(){
            cin >> usuario; 
            fechaEnvio.Fecha::leer();
            cin.ignore();
            getline(cin, mensaje);
        }
        void leer_pcuac(){
            int msg;
            cin >> usuario;
            fechaEnvio.Fecha::leer();
            cin >> msg;
            mensaje=devolverMensaje(msg);
        }
        void escribir(){
            cout << usuario << " ";
            fechaEnvio.Fecha::escribir();
            cout << "\n" << "   ";
            cout << mensaje << endl;
        }
        bool es_menor(cuac kuak){
            if(fechaEnvio.Fecha::es_menor(kuak.fechaEnvio)) return true;
            if(fechaEnvio.Fecha::es_igual(kuak.fechaEnvio)){
                if(mensaje<kuak.mensaje) return true;
                if(kuak.mensaje<mensaje) return false;
                if(usuario<kuak.usuario) return true;
                if(kuak.usuario<usuario) return false;
            }
            return false;
        }
        bool es_igual(cuac kuak){
            return fechaEnvio.Fecha::es_igual(kuak.fechaEnvio) && mensaje==kuak.mensaje && usuario==kuak.usuario;
        }
};

int main(){
    int i=1;
    string tipo;
    while(cin >> tipo){
        cuac kuak;
        if(tipo=="mcuac") kuak.leer_mcuac();
        else if(tipo=="pcuac") kuak.leer_pcuac();
        cout << i++ << " cuac" << endl;
        kuak.escribir();
    }
}