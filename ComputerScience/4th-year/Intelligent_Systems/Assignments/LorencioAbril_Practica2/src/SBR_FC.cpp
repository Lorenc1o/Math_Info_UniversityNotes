#include "SBR_FC.h"
#include "base_conocimientos.h"
#include "base_hechos.h"
#include <iostream>

using namespace std;

SBR_FC::SBR_FC()
{
}

SBR_FC::~SBR_FC()
{
    //dtor
}

bool SBR_FC::contenida(string meta){
    return SBR_FC::BH.contiene(meta);
}

vector<string> extraer_antecedentes(vector<Regla> R){
    vector<string> ret;

    int n = R.size();
    for(int i=0; i<n; i++){
        Regla::fbf lhs = R.at(i).lhs;
        int m = lhs.num_literales;
        for(int j=0; j<m; j++){
            ret.push_back(lhs.literales[j]);
        }
    }
    return ret;
}

int str2int(string str){
    if(str == "o") return 1;
    if(str == "y") return 2;
    return 0;
}

float max(float a, float b){
    if(a>=b) return a;
    return b;
}

float min(float a, float b){
    if(a<=b) return a;
    return b;
}

float abs(float a){
    if(a>=0) return a;
    return -a;
}

float SBR_FC::calcular_fc(string meta, int profundidad, ofstream& ostr){

    //Formateo de la salida
    for(int i=0; i<profundidad; i++){
        ostr << "--";
    }

    ostr << "Procesando " << meta << endl;

    //caso base
    if(contenida(meta)){
        for(int i=0; i<profundidad+1; i++){
            ostr << "  ";
        }
        float fc = SBR_FC::BH.get_fc(meta);
        ostr << "Es un hecho con FC = " << fc << endl;
        return fc;
    }

    //Equiparar
    vector<Regla> conflicto = SBR_FC::BC.base_conocimientos::equiparar(meta);

    vector<float> FCs;
    int n = conflicto.size();

    //Si el conjunto conflicto es no vacío
    if(n>0){
        //recorremos las reglas
        for(int i=0; i<n; i++){
            Regla r = conflicto.at(i);
            Regla::fbf lhs = r.lhs;
            int m = lhs.num_literales;
            string op, lit1, lit2;
            //para cada regla, calculamos su fc
            float actual_fc = calcular_fc(lhs.literales.at(0), profundidad+1, ostr);
            for(int j=0; j<m-1; j++){
                op = lhs.ops.at(j);
                lit1 = lhs.literales.at(j);
                lit2 = lhs.literales.at(j+1);
                switch(str2int(op)){
                    case 1:
                        actual_fc = max(actual_fc, calcular_fc(lit2, profundidad+1, ostr)); //Caso 1.or
                        for(int i=0; i<profundidad+2; i++){
                            ostr << " ";
                        }
                        ostr << "Aplicando el caso 1 a " << lit1 << " o " << lit2 << endl;
                        break;
                    case 2:
                        actual_fc = min(actual_fc, calcular_fc(lit2, profundidad+1, ostr)); //Caso 1.and
                        for(int i=0; i<profundidad+2; i++){
                            ostr << " ";
                        }
                        ostr << "Aplicando el caso 1 a " << lit1 << " y " << lit2 << endl;
                        break;
                    default:
                        ostr << "Error, intentando procesar una operación incorrecta: " << lhs.ops.at(j) << endl; //esto no debe suceder
                        break;
                }
            }
            if(actual_fc < 0) {
                for(int i=0; i<profundidad+2; i++){
                        ostr << " ";
                    }
                ostr << "El FC es negativo, el caso 3 hace que este FC sea 0" << endl;
            }
            actual_fc = max(actual_fc, 0); //aplicación del Caso 3
            for(int i=0; i<profundidad+1; i++){
                ostr << " ";
            }
            ostr << "El FC calculado para la regla " << r.nombre << ", " << r.to_string() << ", es " << actual_fc*r.fc << endl;
            FCs.push_back(actual_fc*r.fc);
        }

        //Cuando tenemos el fc de todas las reglas que llevan a nuestra meta,
        //los combinamos
        int m = FCs.size();
        for(int i=0; i<m-1; i++){
            for(int i=0; i<profundidad+2; i++){
                ostr << " ";
            }
            ostr << "Aplicando el caso 2 a las reglas " << conflicto.at(i).nombre << " y " << conflicto.at(i+1).nombre << endl;
            if(FCs.at(i)>=0 && FCs.at(i+1)>=0) FCs.at(i+1) = FCs.at(i) + FCs.at(i+1)*(1-FCs.at(i)); //Caso 2.1
            else if(FCs.at(i)<=0 && FCs.at(i+1)<=0) FCs.at(i+1) = FCs.at(i) + FCs.at(i+1)*(1+FCs.at(i)); //Caso 2.2
            else FCs.at(i+1) = (FCs.at(i) + FCs.at(i+1)) / (1-min(abs(FCs.at(i)), abs(FCs.at(i+1)))); //Caso 2.3
        }

        //Añadimos la meta como un hecho, con el FC calculado
        SBR_FC::BH.add_hecho(meta, FCs.at(m-1));

        for(int i=0; i<profundidad+1; i++){
            ostr << " ";
        }
        ostr << "El FC calculado para " << meta << " es " << FCs.at(m-1) << endl;

        return FCs.at(m-1);
    }

    //Si el conjunto conflicto es vacío, entonces la meta actual no era un hecho
    //y no tiene antecedentes, por lo que no sabemos nada sobre ella, asumimos
    //que es un hecho con FC=0

    SBR_FC::BH.add_hecho(meta, 0);

    for(int i=0; i<profundidad+1; i++){
            ostr << " ";
        }
    ostr << "El objetivo " << meta << " no tiene antecedentes y no es un hecho, asumimos que tiene FC=0" << endl;

    return 0;
}

void SBR_FC::encadenamiento_hacia_atras(ofstream& ostr){
    int n = SBR_FC::metas.size(); //En principio dejamos la puerta abierta a que pueda haber varias metas
    for(int i=0; i<n; i++){
        ostr << "Comienza el encadenamiento hacia atrás" << endl;
        float fc = calcular_fc(SBR_FC::metas.at(i), 0, ostr);
        if(fc >= -1 && fc <= 1) ostr << "La meta " << SBR_FC::metas.at(i) << " es cierta con FC = " << fc << endl;
        else cout << "Se ha producido algún error" << endl;
    }
}
