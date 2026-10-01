% Prepare Matlab
clc; clear;

% System Inputs: % --------------------------------------------------------
Tevap = 7;                              % Evaporator Temp [C]
Tabs = 40;                              % Absorber Temp [C]
Tcond = 40;                             % Condenser Temp [C]
Tgen = 90;                              % Generator Temp [C]
Qload = 3.514;                         % Refrigeration load [kW]
eta_HX = 1;                           % Solution Heat Exchanger Efficiency [100% -> 1]

[COP, m, P, h, T, Q, misc] = LiBr_Absorption_solver(Tevap, Tabs, Tcond, Tgen, Qload,eta_HX, 'false');

% Print Results -----------------------------------------------------------
fprintf('COP = %.3f\n\n', COP);

fprintf('Refrigerant flow rate = %.4f kg/s\n', m(1));
fprintf('Strong solution flow = %.4f kg/s\n', m(2));
fprintf('Weak solution flow   = %.4f kg/s\n\n', m(3));

fprintf('Low-side pressure  = %.3f Pa\n', P(1));
fprintf('High-side pressure = %.3f Pa\n\n', P(2));

fprintf('Cooling load Qe = %.3f kW\n', Q(4));
fprintf('Generator heat Qg = %.3f kW\n', Q(2));
fprintf('Condenser heat Qc = %.3f kW\n', Q(3));
fprintf('Absorber heat Qa = %.3f kW\n', Q(1));
fprintf('Pump work = %.3f kW\n', Q(5));
fprintf('\nEnergy balance residual = %.6f kW\n',Q(6));

fprintf('\nEnthalpies:\n');
fprintf('h1 = %.3f kJ/kg\n',h(1));
fprintf('h2 = %.3f kJ/kg\n',h(2));
fprintf('h3 = h4 = %.3f kJ/kg\n',h(3));
fprintf('h5 = %.3f kJ/kg\n',h(5));
fprintf('h6 = %.3f kJ/kg\n',h(6));
fprintf('h7 = %.3f kJ/kg\n',h(7));
fprintf('h8 = %.3f kJ/kg\n',h(8));
fprintf('h9 = h10 = %.3f kJ/kg\n',h(9));