#include "fecha.h"
#include <iostream>
using namespace std;

Fecha::Fecha()
{
    day = month = year = hour = minutes = seconds = 0;
}
bool Fecha::leer()
{
    char aux;
    cin >> day >> aux >> month >> aux >> year >> hour >> aux >> minutes >> aux >> seconds;
    return true;
}
void Fecha::escribir()
{
    cout << day << "/" << month << "/" << year << " ";
    if (hour < 10)
        cout << "0";
    cout << hour << ":";
    if (minutes < 10)
        cout << "0";
    cout << minutes << ":";
    if (seconds < 10)
        cout << "0";
    cout << seconds;
}
bool Fecha::es_igual(Fecha &otra)
{
    return ((otra.day == day) && (month == otra.month) && (otra.year == year) && (otra.minutes == minutes) && (otra.seconds == seconds) && (otra.hour == hour));
}
bool Fecha::es_menor(Fecha &otra)
{
    return (year < otra.year) ? true : (year > otra.year) ? false : (month < otra.month) ? true : (month > otra.month) ? false : (day < otra.day) ? true : (day > otra.day) ? false : (hour < otra.hour) ? true : (hour > otra.hour) ? false : (minutes < otra.minutes) ? true : (minutes > otra.minutes) ? false : (seconds < otra.seconds) ? true : false;
}