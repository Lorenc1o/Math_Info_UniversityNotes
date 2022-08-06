#include <iostream>
#include "base_conocimientos.h"
#include "base_hechos.h"
#include "Regla.h"
#include "SBR_FC.h"
#include <string>
#include <sstream>
#include <regex>
using namespace std;

string extract_name(string url){
    string url_expr = "(.*\\\\)*([a-zA-Z0-9_-]+)\\.txt";
    smatch match;
    if(regex_search(url, match,  regex(url_expr, regex_constants::extended))){
        const auto name_match = match[2].str();
        return name_match;
    }
    return "";
}

int main(int argc, char *argv[]){
    base_conocimientos BC;
    base_hechos BH;

    if(argc == 3 || argc == 4){
        string url_BC = argv[1];
        string url_BH = argv[2];
        BC.base_conocimientos::inicializa_BC(url_BC);
        BH.base_hechos::inicializa_BH(url_BH);

        if(argc == 4){ //debug mode
            BC.print_reglas();
            BH.print_bh();
        }

        unordered_set<string> objetivos = BH.get_objetivo();

        SBR_FC sbr;
        sbr.BC = BC;
        sbr.BH = BH;

        for(const auto& meta : objetivos){
            sbr.metas.push_back(meta);
        }

        string bc_name = extract_name(url_BC), bh_name = extract_name(url_BH);

        if(bc_name == "" || bh_name == ""){
            cout << "Llamada incorrecta, alguna de las urls proporcionadas no es correcta. Formato: SSII url_BC url_BH" << endl;
        }
        else{
            ostringstream filename;
            filename << bc_name << "_" << bh_name << ".txt";

            ofstream file(filename.str());

            file << "BC: " << url_BC << endl;
            file << "BH: " << url_BH << endl;

            sbr.encadenamiento_hacia_atras(file);

            file.close();
        }
    }else{
        cout << "Llamada incorrecta, formato: SSII url_BC url_BH" <<endl;
    }
}
