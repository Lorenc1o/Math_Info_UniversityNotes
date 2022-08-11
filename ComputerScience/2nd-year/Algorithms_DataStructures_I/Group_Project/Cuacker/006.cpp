#include <iostream>
using namespace std;
#include <list>
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

class Cuac{
    private:
        Fecha fechaEnvio;
        string mensaje, usuario;
        int msg;
    public:
        Cuac(){
            msg=0;
        }
        void leer_mcuac(){
            cin >> usuario; 
            fechaEnvio.Fecha::leer();
            cin.ignore();
            getline(cin, mensaje);
        }
        void leer_pcuac(){
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
        bool es_anterior(Cuac kuak){
            if(fechaEnvio.Fecha::es_menor(kuak.fechaEnvio)) return true;
            if(fechaEnvio.Fecha::es_igual(kuak.fechaEnvio)){
                if(mensaje<kuak.mensaje) return true;
                if(kuak.mensaje<mensaje) return false;
                if(usuario<kuak.usuario) return true;
                if(kuak.usuario<usuario) return false;
            }
            return false;
        }
        bool es_igual(Cuac kuak){
            return fechaEnvio.Fecha::es_igual(kuak.fechaEnvio) && mensaje==kuak.mensaje && usuario==kuak.usuario;
        }
        Fecha get_fecha(){return fechaEnvio;}
        string get_usuario(){return usuario;}
};

class DiccionarioCuacs{
    private:
        list<Cuac> lista;
        int contador;
    public:
        DiccionarioCuacs();
        void insertar(Cuac nuevo);
        void last(int N);
        void follow(string nombre);
        void date (Fecha f1, Fecha f2);
        int numElem(){
            return contador;
        }
};
DiccionarioCuacs::DiccionarioCuacs(){
    list<Cuac> lista;
    contador=0;
}
void DiccionarioCuacs::insertar(Cuac nuevo){
    list<Cuac>::iterator it = lista.begin();
    while(nuevo.es_anterior(*it)&& it!=lista.end()) it++;
    lista.insert(it,nuevo);
    contador++;
    cout << contador << " cuac" << endl;
}
void DiccionarioCuacs::last(int N){
    if(contador<N) N=contador;
    list<Cuac>::iterator it = lista.begin();
    for(int i=0; i<N;){
        cout << ++i << " ";
        it->Cuac::escribir();
        cout << endl;
        ++it;
    }
    cout << "Total: " << N << " cuac" << endl;
}
void DiccionarioCuacs::date(Fecha f1, Fecha f2){
    int cont=0;
    for(list<Cuac>::iterator it=lista.begin(); it != lista.end(); ++it){
        Fecha date=it->Cuac::get_fecha();
        if(!f1.Fecha::es_menor(date) && (date.Fecha::es_menor(f2))||date.Fecha::es_igual(f2)){
            it->Cuac::escribir();
            cont++;
        }
    }
    cout << "Total: " << cont << " cuac" << endl;
}
void DiccionarioCuacs::follow(string nombre){
    int cont=0;
    for(list<Cuac>::iterator it=lista.begin(); it != lista.end(); ++it){
        string usuario=it->Cuac::get_usuario();
        if(usuario==nombre){
            it->Cuac::escribir();
            cont++;
        }
    }
    cout << "Total: " << cont << " cuac" << endl;
}

DiccionarioCuacs dic;


// int contador = 0;
Cuac actual;

void procesar_mcuac(){
    actual.leer_mcuac();
    dic.DiccionarioCuacs::insertar(actual);
}
void procesar_pcuac(){
    actual.leer_pcuac();
    dic.DiccionarioCuacs::insertar(actual);
}
void procesar_last(){
    int N;
    cin >> N;
    dic.DiccionarioCuacs::last(N);
}
void procesar_follow(){
    string usuario;
    cin >> usuario;
    cout << "follow" << usuario << endl;
    dic.DiccionarioCuacs::follow(usuario);
}
void procesar_date(){
    Fecha finicial, ffinal;
    finicial.leer();
    ffinal.leer();
    cout << "date" << " ";
    finicial.escribir();
    dic.DiccionarioCuacs::date(finicial, ffinal);
}
void procesar_tag(){
    string etiqueta;
    cin >> etiqueta;
    cout << "tag" << " " << etiqueta << endl;
    cout << "1. ";
    actual.escribir();
    cout << "Total: 1 cuac" << endl;
}

void Interprete(string comando){
    if(comando=="mcuac") procesar_mcuac();
    else if(comando=="pcuac") procesar_pcuac();
    else if(comando=="last") procesar_last();
    else if(comando=="follow") procesar_follow();
    else if(comando=="date") procesar_date();
    else if(comando=="tag") procesar_tag();
}


int main(){
    string comando;
    while (cin >> comando && comando != "exit")
        Interprete(comando);
}