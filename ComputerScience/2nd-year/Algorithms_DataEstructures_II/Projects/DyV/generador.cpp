#include <iostream>  // Variables cin y cout
using namespace std;

pair<string, string> generar_peor_caso(int n){
    string ret;
    for(int i=0; i<n; i++){
        ret+=rand()%26+97;
    }
    pair<string, string> par;
    par.first=par.second=ret;
    return par;
}

pair<string, string> generar_mejor_caso(int n){
    pair<string, string> par;
    for(int i=0; i<n; i++){
        char c=rand()%26+97;
        par.first+=c;
        if(c=='z') {
            c='a';
        }
        else c++;
        par.second+=c;
    }
    return par;
}

pair<string, string> generar_aleatorio(int n){
    pair<string, string> par;
    for(int i=0; i<n; i++){
        par.first+=rand()%26+97;
        par.second+=rand()%26+97;
    }
    return par;
}

main(){
    int n=1;
    int m;
    for(n=10; n<2000000; n*=10){

        for(m=n/5; m<n; m+=n/5){
            pair<string,string> par = generar_aleatorio(n);

            cout << n << endl;
            cout << m << endl;
            cout << par.first << endl;
            cout << par.second << endl;
        }
    //par = generar_mejor_caso(n);

    //par = generar_aleatorio(n);
    }
}


