function [ y ] = Boltzmann(b,x)
%Boltzmann Equation
Vh=b(1);
k=b(2);
V=x;
y=1./(1+exp((Vh-V)./k));
end

