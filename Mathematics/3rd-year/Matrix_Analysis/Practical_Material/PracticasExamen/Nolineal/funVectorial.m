%prueba derivada
clear all

clc

f=@(x) [sin(x),cos(x)];

f(pi/4)
global paso=0.001;

derivaprox3(f,pi/4)
