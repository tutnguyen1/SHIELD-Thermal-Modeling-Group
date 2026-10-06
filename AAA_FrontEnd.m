% Implement loops in this code to calculate it for different scenarios 

% Prepare Matlab
clc; clear;

% System Inputs: % --------------------------------------------------------
Tevap = 7;                              % Evaporator Temp [C]
Tabs = 40;                              % Absorber Temp [C]
Tcond = 40;                             % Condenser Temp [C]
Tgen = 90;                              % Generator Temp [C]
Qload = 3.514;                          % Refrigeration load [kW]
eta_HX = .60;                           % Solution Heat Exchanger Efficiency [100% -> 1]

[COP, m, P, h, T, Q, misc] = LiBr_Absorption_solver(Tevap, Tabs, Tcond, Tgen, Qload,eta_HX, 'false');

% Print Results -----------------------------------------------------------
Print_Results(COP,m,P,Q,h);

fprintf("\n\n")

% Try with Qgen
Qsolar = Q(2);
[COP, m, P, h, T, Q, misc] = Solver__Qgen_IN(Tevap, Tabs, Tcond, Tgen, Qsolar,eta_HX, 'false');

% Print Results -----------------------------------------------------------
Print_Results(COP,m,P,Q,h);

% Results should be the same