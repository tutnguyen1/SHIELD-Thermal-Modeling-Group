% Prepare Matlab
clc; clear;

% System Inputs: % --------------------------------------------------------
Tevap = 7;                              % Evaporator Temp [C]
Tabs = 40;                              % Absorber Temp [C]
Tcond = 40;                             % Condenser Temp [C]
Tgen = 90;                              % Generator Temp [C]

zeta_w = 0.57;                          % LiBr Weak Concentration [100% -> 1]
zeta_s = 0.62;                          % LiBr Strong Concentration [100% -> 1]

Qload = 3.514;                         % Refrigeration load [kW]

% Efficiencies 
eta_HX = 1;                           % Solution Heat Exchanger Efficiency [100% -> 1]

v5 = 1/640;                            % Solution Specific Density [m^3/kg]

% Properties % ------------------------------------------------------------
Ph = XSteam('psat_T',Tcond) * 100;      % High-side System Pressure (Water, Sat.) [kPa] % Note: Mult by 100 to conv. Bar -> kPa
Pl = XSteam('psat_T',Tevap) * 100;      % Low-side System Pressure (Water, Sat.) [kPa] % Note: Mult. by 100 to conv. Bar -> kPa

wp = v5*(Ph-Pl);                        % Specific Pump Work (Incompressible Solution) [kJ/kg]

h1 = XSteam('hV_T',Tevap);              % Evaporator Outlet Enthalpy (Water, Sat. Vapor) [kJ/kg]
h2 = XSteam('hV_T',Tgen);               % Generator Refrigerant Outlet Enthalpy (Water, Sat. Vapor) [kJ/kg] {TN Not sure on this assumption, I think it is superheated}
h3 = XSteam('hL_T',Tcond);              % Condenser Outlet Enthalpy (Water, Sat. Liquid) [kJ/kg]
h4 = h3;                                % Refrigerant Valve Outlet Enthalpy (Isentropic) [kJ/kg]
h5 = LiBrH20_h(zeta_w,Tabs);            % Absorber Outlet Enthalpy (LiBr Lookup Table) [kJ/kg]
h6 = h5 + wp;                           % Pump Outlet Enthalpy (Isentropic) [kJ/kg]
h8 = LiBrH20_h(zeta_s,Tgen);            % Generator Absorbent Outlet Enthalpy (LiBr Empirical Fit) [kJ/kg]

% Mass Flow ---------------------------------------------------------------
lambda = zeta_w/(zeta_s-zeta_w);        % Circulation Ratio (definition) [kg/s]
mr = Qload/(h1-h4);                     % Refrigerant Mass Flow (Energy Balance of Condenser) [kg/s]
ms = mr * lambda;                       % Strong Solution Mass Flow Rate (Mass balance) [kg/s]
mw = mr * (1+lambda);                   % Weak Solution Mass Flow Rate (Mass balance) [kg/s]

cp_w = LiBrH20_Cp(Tabs,zeta_w,Pl);      % Weak Solution Specific Heat (LiBr Empirical Fit) [kJ/(kg-K)]
cp_s = LiBrH20_Cp(Tgen,zeta_w,Ph);      % Strong Solution Specific Heat (LiBr Empirical Fit) [kJ/(kg-K)]

% Solution Heat Exchanger % -----------------------------------------------
qhx_max = min(cp_s, cp_w)*(Tgen-Tabs);  % Solution HX max heat transfer [kJ/kg]
qhx = qhx_max * eta_HX;                 % Actual HX Heat Trans. Rate based on efficiency [kJ/kg]
h7 = h6 + qhx;                          % Solution HX Cold Outlet Enthalpy [kJ/kg]
h9 = h8 - qhx;                          % Solution HX Hot Outlet Enthalpy [kJ/kg]
h10 = h9;                               % Solution Valve Outlet Enthalpy (Isentropic) [kJ/kg]

% Heat Transfers ----------------------------------------------------------
Qgen = mr*h2 + ms*h8 - mw*h7;           % Generator Heat Input [kW]
Qcond = mr*(h2-h3);                     % Condenser Heat Rejection [kW]
Qabs = mr * h1 + ms *h10 - mw*h5;       % Absorber Heat Rejection [kW]
Wp = wp * mw;                           % Pump Work () [kW]

% Final Calculations ------------------------------------------------------
COP = Qload/(Qgen+Wp);
error = Qgen + Wp + Qload - Qabs - Qcond; %should be zero, or close to zero, if everything is correct. otherwise we are violating first law

% Print Results -----------------------------------------------------------
% fprintf('Refrigerant flow rate = %.4f kg/s\n', mr);
% fprintf('Strong solution flow = %.4f kg/s\n', ms);
% fprintf('Weak solution flow   = %.4f kg/s\n\n', mw);
% 
% fprintf('Low-side pressure  = %.3f Pa\n', Pl);
% fprintf('High-side pressure = %.3f Pa\n\n', Ph);

% fprintf('Cooling load Qe = %.3f kW\n', Qload);
fprintf('Generator heat Qg = %.3f kW\n', Qgen);
% fprintf('Condenser heat Qc = %.3f kW\n', Qcond);
fprintf('Absorber heat Qa = %.3f kW\n', Qabs);
% fprintf('Pump work = %.3f kW\n', Wp);
fprintf('COP = %.3f\n', COP);

fprintf('\nEnergy balance residual = %.6f kW\n',error);

% fprintf('\nEnthalpies:\n');
% fprintf('h1 = %.3f kJ/kg\n',h1);
% fprintf('h2 = %.3f kJ/kg\n',h2);
% fprintf('h3 = h4 = %.3f kJ/kg\n',h3);
% fprintf('h5 = %.3f kJ/kg\n',h5);
% fprintf('h6 = %.3f kJ/kg\n',h6);
% fprintf('h7 = %.3f kJ/kg\n',h7);
% fprintf('h8 = %.3f kJ/kg\n',h8);
% fprintf('h9 = h10 = %.3f kJ/kg\n',h9);
