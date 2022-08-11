#include <iostream>
using namespace std; 

int main(){
    char a='a',b='a',c='a';
    char A='A', B='A', C='A';
    bool f=false;
    /*while(!f){
        if(c=='z' && b=='z' && a=='z'){
            f=true;
        }
        else if(c=='z' && b=='z'){
            a++;
            b='a';
            c='a';
        }
        else if(c=='z'){
            b++;
            c='a';
        }
        cout << a << b << c << endl;
        c++;
    }*/
    while(!f){
        if(C=='Z' && B=='Z' && A=='Z'){
            f=true;
        }
        else if(C=='Z' && B=='Z'){
            a++;
            B='A';
            C='A';
        }
        else if(C=='Z'){
            B++;
            C='A';
        }
        cout << A << B << C << endl;
        C++;
    }
}