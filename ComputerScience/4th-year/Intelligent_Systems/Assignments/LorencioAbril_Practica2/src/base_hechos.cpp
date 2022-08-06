#include "base_hechos.h"
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <string>
#include <iostream>
#include <regex>
#include <fstream>

using namespace std;

unordered_map<string, float> hechos;
unordered_set<string> objetivos;

base_hechos::base_hechos()
{
}

base_hechos::~base_hechos()
{
    hechos.~unordered_map();
    objetivos.~unordered_set();
}

bool base_hechos::inicializa_BH(string filename){
    ifstream source;
    source.open(filename);
    string line;
    string hecho = "([a-zA-Z0-9]+), FC=(-?(0|1)(\\.[0-9]+)?)";

    smatch match;
    bool objetivos = false;
    while(getline(source,line)){
        if(!objetivos){
            if(regex_search(line, match,  regex(hecho, regex_constants::extended))){
                const auto hecho_match = match[1].str(); //Aquí tenemos la fbf con el hecho
                const auto fc_match = match[2].str(); //Aquí el fc
                string hech = hecho_match;
                float fc = stof(fc_match);
                base_hechos::add_hecho(hech, fc);
            } else if(regex_search(line, match,  regex("Objetivo", regex_constants::extended))) objetivos = true;
        } else if(regex_search(line, match,  regex("[a-zA-Z0-9]+", regex_constants::extended))){
            const auto obj_match = match[0].str();
            string obj = obj_match;
            base_hechos::add_objetivo(obj);
        }
    }
    if(base_hechos::hechos.empty() || base_hechos::objetivos.empty()) return false;
    return true;
}

bool base_hechos::contiene(string hecho){
    unordered_map<string, float>::const_iterator pos = hechos.find(hecho);
    if(pos == hechos.end()){
        return false;
    }
    return true;
}

float base_hechos::get_fc(string hecho){
    unordered_map<string, float>::const_iterator pos = hechos.find(hecho);
    if(pos == hechos.end()) return -2;
    else return pos->second;
}

bool base_hechos::add_hecho(string hecho, float fc){
    return hechos.insert( make_pair(hecho, fc) ).second;
}

bool base_hechos::add_objetivo(string objetivo){
    return objetivos.insert(objetivo).second;
}

void base_hechos::print_bh(){
    int n = base_hechos::hechos.size();
    cout<< "Hay " << n << " hechos: " <<endl;
    for (auto& it: base_hechos::hechos) {
        cout << it.first << ", FC=" << it.second << endl;
    }
    cout << "Objetivo: " << endl;
    for (auto& it: base_hechos::objetivos){
        cout << it << endl;
    }
}

unordered_set<string> base_hechos::get_objetivo(){
    return base_hechos::objetivos;
}
