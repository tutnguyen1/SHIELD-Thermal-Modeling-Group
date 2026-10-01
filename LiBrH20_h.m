function h = LiBrH20_h(x,t)
% Function LiBrH20_Enthalpy calcultates the Enthalpy for the corresponding 
% concentration and temperature of Lithium Bromide - Water solution,
% within the range as per as curve-fitting equation.
%
% INPUTS:
%           x = Lithium Bromide - Solution concentration [100% -> 1]
%           t = Lithium Bromide - Solution temperature [C]
% OUTPUT:
%           h = Enthalpy of Lithium Bromide - Water solution in kJ/kg

% Implemented by ASHISH MESHRAM
% meetashish85@gmail.com http://www.facebook.com/ashishmeet

% Checking Input Arguments
if nargin<2||isempty(t),error('Input Argument:Temperature missing');end
if nargin<1||isempty(x),error('Input Argument:Concentration missing');end

x = x * 100; % Convert % to whole numbers

if (x>40 && x<70) %---Checks concentration range
    if (t>15 && t<165) %---Checks temperature range
        %---Constants
        A0 = -2024.33; A1 = 163.309; A2 = -4.88161; A3 = 6.302948*10^(-2); A4 = -2.913705*10^(-4);
        B0 = 18.2829; B1 = -1.1691757; B2 = 3.248041*10^(-2); B3 = -4.034184*10^(-4); B4 = 1.8520569*10^(-6);
        C0 = -3.7008214*10^(-2); C1 = 2.8877666*10^(-3); C2 = -8.1313015*10^(-5); C3 = 9.9116628*10^(-7); C4 = -4.4441201*10^(-9);
        %---Creating polynomial coefficiens
        P0 = A0 + t*B0 + t*t*C0;
        P1 = A1 + t*B1 + t*t*C1;
        P2 = A2 + t*B2 + t*t*C2;
        P3 = A3 + t*B3 + t*t*C3;
        P4 = A4 + t*B4 + t*t*C4;
        %---Calculation for Enthalpy
        P = [P4 P3 P2 P1 P0];
        h = polyval(P,x);
    else
        disp('Error: Temperature out of range: t>15 && t<165');
    end
else
    disp('Error: Lithium Bromide Concentration out of range: x>40 && x<70');
end


