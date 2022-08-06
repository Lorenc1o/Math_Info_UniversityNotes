#include "base_conocimientos.h"
#include <regex>
#include <iostream>

using namespace std;

base_conocimientos::base_conocimientos()
{
}

base_conocimientos::~base_conocimientos()
{
}

bool base_conocimientos::inicializa_BC(string filename){
    ifstream source;
    source.open(filename);
    string line;
    string regla = "(R[1-9][0-9]*): Si ([a-zA-Z0-9]+(( (o|y)) [a-zA-Z0-9]+)*) Entonces ([a-zA-Z0-9]+), FC=(-?(0|1)(\\.[0-9]+)?)";

    smatch match;

    while(getline(source,line)){
        if(regex_search(line, match,  regex(regla, regex_constants::extended))){
            const auto nom_match = match[1].str(); //Aquí tenemos el hombre de la regla: Ri
            const auto lhs_match = match[2].str(); //Aquí tenemos la fbf con la lhs
            const auto rhs_match = match[6].str(); //Aquí tenemos la rhs
            const auto fc_match = match[7].str(); //Aquí el fc
            string rhs = rhs_match, lhs=lhs_match, nombre = nom_match;
            float fc = stof(fc_match);

            Regla::fbf left;
            int n_literales=0;

            while(regex_search(lhs, match, regex("([a-zA-Z0-9]+)(( (o|y)) (.+))*", regex_constants::extended))){
                        const auto literal = match[1].str();
                        const auto op = match[4].str();
                        left.literales.push_back(literal);
                        left.ops.push_back(op);
                        n_literales++;
                        lhs = match[5].str();
                    }
            left.num_literales = n_literales;
            Regla r(nombre,left, rhs,fc);
            base_conocimientos::add_regla(r);
        }
    }
    if(base_conocimientos::reglas.empty()) return false;
    return true;
}

void base_conocimientos::add_regla(Regla r){
    base_conocimientos::reglas.push_back(r);
    base_conocimientos::num_reglas++;
}

//función equiparar
vector<Regla> base_conocimientos::equiparar(string meta){
    vector<Regla> conflicto;
    for(int i=0; i<base_conocimientos::num_reglas; i++){
        Regla r = base_conocimientos::reglas.at(i);
        //si meta es un consecuente de la regla, la añade al conjunto conflicto
        if(r.rhs == meta){
            conflicto.push_back(r);
        }
    }

    return conflicto;
}

//Para debugging
void base_conocimientos::print_reglas(){
    int n = base_conocimientos::reglas.size();
    for(int i=0; i<n; i++){
        reglas.at(i).print_regla();
    }
}
