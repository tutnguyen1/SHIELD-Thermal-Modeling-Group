function [COP, m, P, h, T, Q, misc] = Solver__Qgen_In(Tevap, Tabs, Tcond, Tgen, Qgen, eta_HX, warn)
%   LiBr_Absorption_solver : Main code that evaluates properties of
%   absorption refrigeration cycle
%
%   [COP, m, P, h, T, Q, misc] = Solver__Qgen_IN(Tevap, Tabs, Tcond, Tgen, Qgen, eta_HX, warn);
%
% Inputs
%   Tevap : Temp, Evaporator [C]
%   Tabs : Temp, Absorber [C]
%   Tcond : Temp, Condenser [C]
%   Tgen : Temp, Generator [C]
%   Qgen : Heat, Generator Input [kW]
%   eta_HX : Effectiveness, Soln Heat Exchanger [100% -> 1]
%   warn : Enable/Disable Warning messages for out of range values [true/false]
%
% Outputs
%   COP : Coefficient of Performance of System [-]
%   m : Mass Flow Rates [kg/s] {1x3 array. see below for calling array values}
%       m(1) mr : Refrigerant
%       m(2) mw : Weak Solution
%       m(3) ms : Strong Solution
%   P : Pressure [kPa] {1x2 array. see below for calling array values}
%       P(1) Pl : Low Side
%       P(2) Ph : High Side
%   h : Specific Enthalpies [kJ/kg] {1x10 array}
%       h(1) :      Evap      OUT | IN      Abs
%       h(2) :      Gen       OUT | IN      Cond
%       h(3) :      Cond      OUT | IN      RefValv
%       h(4) :      RefValv   OUT | IN      Evap
%       h(5) :      Abs       OUT | IN      Pump
%       h(6) :      Pump      OUT | IN      SolHX_LO
%       h(7) :      SolHX_LO  OUT | IN      Gen
%       h(8) :      Gen       OUT | IN      SolHX_HI
%       h(9) :      SolHX_HI  OUT | IN      SolValn
%       h(10) :     SolValv   OUT | IN      ABS     
%   T : Temperature [C] {1x10 array}
%       T(1) :      Evap      OUT | IN      Abs
%       T(2) :      Gen       OUT | IN      Cond
%       T(3) :      Cond      OUT | IN      RefValv
%       T(4) :      RefValv   OUT | IN      Evap
%       T(5) :      Abs       OUT | IN      Pump
%       T(6) :      Pump      OUT | IN      SolHX_LO
%       T(7) :      SolHX_LO  OUT | IN      Gen
%       T(8) :      Gen       OUT | IN      SolHX_HI
%       T(9) :      SolHX_HI  OUT | IN      SolValn
%       T(10) :     SolValv   OUT | IN      ABS     
%   Q : Work/Heat Transfers [kJ] {1x6 array}
%       Q(1) : OUT OF   Absorber
%       Q(2) : INTO     Generator
%       Q(3) : OUT OF   Condenser
%       Q(4) : INTO     Evaporator
%       Q(5) : INTO     Pump
%       Q(6) : 1ST LAW ERROR CHECKING
%   X : Concentrations [LiBr/kg soln] {1x2 array}
%       X(1) :      Evap      OUT | IN      Abs
%       X(2) :      Gen       OUT | IN      Cond
%       X(3) :      Cond      OUT | IN      RefValv
%       X(4) :      RefValv   OUT | IN      Evap
%       X(5) :      Abs       OUT | IN      Pump
%       X(6) :      Pump      OUT | IN      SolHX_LO
%       X(7) :      SolHX_LO  OUT | IN      Gen
%       X(8) :      Gen       OUT | IN      SolHX_HI
%       X(9) :      SolHX_HI  OUT | IN      SolValn
%       X(10) :     SolValv   OUT | IN      ABS     
%   misc : Miscellaneous Properties [see below] {1x5 array, add extra properties here as needed}
%       misc(1) : i.e. pump specific work [kJ/kg]
%       misc(2) : circulation ratio [-]
%       misc(3) : ???
%       misc(4) : ???
%       misc(5) : ???

%% Properties %%
Xw = LiBrH2O_X(Tevap, Tabs, warn);      % Concentration, Weak Solution [LiBr/kg soln]
Xs = LiBrH2O_X(Tcond, Tgen, warn);      % Concentration, Strong Solution [LiBr/kg soln]
lambda = Xw/(Xs-Xw);                    % Circulation Ratio (definition) [kg/s]

Ph = H2O_STEAM('psat_T',Tcond) * 100;   % High-side System Pressure (Water, Sat.) [kPa] % Note: Mult by 100 to conv. Bar -> kPa
Pl = H2O_STEAM('psat_T',Tevap) * 100;   % Low-side System Pressure (Water, Sat.) [kPa] % Note: Mult. by 100 to conv. Bar -> kPa

v5 = LiBrH2O_v(Tabs,Xw);                % Specific Volume at Pump [m^3/kg]
wp = v5*(Ph-Pl);                        % Specific Pump Work (Incompressible Solution) [kJ/kg]

cp_w = LiBrH2O_Cp(Tabs,Xw,Pl);          % Weak Solution Specific Heat (LiBr Empirical Fit) [kJ/(kg-K)]
cp_s = LiBrH2O_Cp(Tgen,Xs,Ph);          % Strong Solution Specific Heat (LiBr Empirical Fit) [kJ/(kg-K)]

h1 = H2O_STEAM('hV_T',Tevap);           % Evaporator Outlet Enthalpy (Water, Sat. Vapor) [kJ/kg]
h2 = H2O_STEAM('h_pT',Ph/100,Tgen);     % Generator Refrigerant Outlet Enthalpy (Superheated Vapor) [kJ/kg]
h3 = H2O_STEAM('hL_T',Tcond);           % Condenser Outlet Enthalpy (Water, Sat. Liquid) [kJ/kg]
h4 = h3;                                % Refrigerant Valve Outlet Enthalpy (Isentropic) [kJ/kg]
h5 = LiBrH2O_h(Xw,Tabs);                % Absorber Outlet Enthalpy (LiBr Lookup Table) [kJ/kg]
h6 = h5 + wp;                           % Pump Outlet Enthalpy (Isentropic) [kJ/kg]
h8 = LiBrH2O_h(Xs,Tgen);                % Generator Absorbent Outlet Enthalpy (LiBr Empirical Fit) [kJ/kg]

% Solution Heat Exchanger % -----------------------------------------------
qhx_max = min(cp_s, cp_w)*(Tgen-Tabs);  % Solution HX max heat transfer [kJ/kg]
qhx = qhx_max * eta_HX;                 % Actual HX Heat Trans. Rate based on efficiency [kJ/kg]
h7 = h6 + qhx;                          % Solution HX Cold Outlet Enthalpy [kJ/kg]
h9 = h8 - qhx;                          % Solution HX Hot Outlet Enthalpy [kJ/kg]
h10 = h9;                               % Solution Valve Outlet Enthalpy (Isentropic) [kJ/kg]

% Mass Flow ---------------------------------------------------------------
mr = Qgen / ...
     (h2+lambda*h8-(1+lambda)*h7);      % Refrigerant Mass Flow (Energy Balance of Generator) [kg/s]
ms = mr * lambda;                       % Strong Solution Mass Flow Rate (Mass balance) [kg/s]
mw = mr * (1+lambda);                   % Weak Solution Mass Flow Rate (Mass balance) [kg/s]

% Heat Transfers ----------------------------------------------------------
Qevap = mr*(h1-h4);                     % Evaporator Heat Load [kW]
Qcond = mr*(h2-h3);                     % Condenser Heat Rejection [kW]
Qabs = mr*h1 + ms*h10 - mw*h5;          % Absorber Heat Rejection [kW]
Wp = wp * mw;                           % Pump Work () [kW]

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Need to implement below based intermediate temperatures on mass flow and enthalpy change
T7 = -1; T9 = -1; T10 = T9;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% Final Calculations ------------------------------------------------------
COP = Qevap/(Qgen+Wp);                      % COP of System
error = Qgen + Wp + Qevap - Qabs - Qcond;   %should be zero, or close to zero, if everything is correct. otherwise we are violating first law

%% Organizing
% Take values from above code and organize it for function output
COP = COP;
m = [mr mw ms];
P = [Pl Ph];
h = [h1 h2 h3 h4 h5 h6 h7 h8 h9 h10];
T = [Tevap, Tgen, Tcond, Tcond, Tabs, Tabs, T7 Tgen T9 T10];
Q = [Qabs, Qgen, Qcond, Qevap, Wp, error];
misc = [wp, lambda, -1, -1, -1];


end
