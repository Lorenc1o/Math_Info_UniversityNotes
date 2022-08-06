#include "Regla.h"
#include <regex>
#include <iostream>
Regla::Regla(string n, fbf l, string r, float f) : nombre(n), lhs(l), rhs(r), fc(f)
{
    this->nombre = n;
    this->lhs = l;
    this->rhs = r;
    this->fc = f;
}

Regla::~Regla()
{
}

void Regla::print_regla(){
    string rule;
    ostringstream rule_stream;
    rule_stream << "Si " << Regla::lhs.literales.at(0) <<" ";
    int n = Regla::lhs.literales.size();
    for(int i=1; i<n; i++){
        rule_stream << Regla::lhs.ops.at(i-1) << " "<< Regla::lhs.literales.at(i) << " ";
    }
    rule_stream << "Entonces " << Regla::rhs << ", FC=" << Regla::fc;

    rule = rule_stream.str();
    cout << rule << endl;
}

string Regla::to_string(){
    string rule;
    ostringstream rule_stream;
    rule_stream << "Si " << Regla::lhs.literales.at(0) <<" ";
    int n = Regla::lhs.literales.size();
    for(int i=1; i<n; i++){
        rule_stream << Regla::lhs.ops.at(i-1) << " "<< Regla::lhs.literales.at(i) << " ";
    }
    rule_stream << "Entonces " << Regla::rhs;

    rule = rule_stream.str();
    return rule;
}
