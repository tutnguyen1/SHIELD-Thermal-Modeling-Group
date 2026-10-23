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

%% Vary 1 temperature input (Tgen)
Tgen = 50:1:106;
Qg_Log = zeros(1,length(Tgen));
COP_Log = zeros(1,length(Tgen));
m_Log = zeros(3,length(Tgen));
X_Log = zeros(1,length(Tgen));

for i = 1:length(Tgen)
    [COP, m, P, h, T, Q, misc] = LiBr_Absorption_solver(Tevap, Tabs, Tcond, Tgen(i), Qload,eta_HX, 'false');

    fprintf('mr [kg/s] = %.3f \n', m(1));
    Qg_Log(i) = Q(2);
    COP_Log(i) = COP;
    m_Log(1:3,i) = m';
    X_Log(1:2,i) = misc(1,3:4)';
end 

plotting.Tyler1(1,Tgen,COP_Log);
plotting.Tyler2(2,Tgen, Qg_Log);
plotting.Tyler3(3,Tgen, m_Log);
plotting.Tyler4(4,Tgen, X_Log);

%%

%trying the time dependent mass flow rates
Mass_Flow_Rate_Time_Variant(Tevap, Tabs, Tcond, Tgen, eta_HX, 'false'); % Qgen is independently called in the function whenever we get the function
Temps = [7; 40; 40; 90];
[COP, m, P, h, T, Q, misc] = Solver__Mr_In(7, 40, 40, 90, 1.4, 0.8, 'false');
R = temperatureResiduals(Temps,28800,Q);
disp(R);


%%
%try the time dependent temperature
Temperature_Time_Variance(Tevap, Tabs, Tcond, Tgen, m(1), eta_HX, 'false');