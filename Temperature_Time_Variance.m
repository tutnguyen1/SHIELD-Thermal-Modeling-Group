function Temperature_Time_Variance(Tevap, Tabs, Tcond, Tgen, mr, eta_HX, warn)
dt = 60;                       % Time Step
time = 0:dt:24*3600;           % Total Time
N = length(time);

COP_hist    = zeros(1,N); %creating arrays for outputs to plot
Qevap_hist  = zeros(1,N);
Qgen_hist   = zeros(1,N);
T_cond_hist = zeros(1,N);
T_evap_hist = zeros(1,N);
T_abs_hist  = zeros(1,N);
T_gen_hist  = zeros(1,N);

for i = 1:N

    t = time(i);
% Unknown temperatures:
% Temps(1) = Tevap [C]
% Temps(2) = Tabs  [C]
% Temps(3) = Tcond [C]
% Temps(4) = Tgen  [C]

% Initial guesses
Tguess = [ ...
    Tevap;      % Tevap
    Tabs;     % Tabs
    Tcond;     % Tcond
    Tgen];    % Tgen

[~, ~, ~, ~, ~, Q, ~] = Solver__Mr_In(Tevap, Tabs, Tcond, Tgen, mr, eta_HX, warn);

% fsolve options
options = optimoptions( ...
    'fsolve', ...
    'Display','iter', ...
    'FunctionTolerance',1e-6, ...
    'StepTolerance',1e-6);


% Solve
Temps = fsolve( ...
    @(Temps) temperatureResiduals(Temps,t,Q), ...
    Tguess, ...
    options);


% Extract converged temperatures
Tevap = Temps(1);
Tabs  = Temps(2);
Tcond = Temps(3);
Tgen  = Temps(4);

[COP, ~, ~, ~, ~, Q, ~] = Solver__Mr_In(Tevap, Tabs, Tcond, Tgen, mr, eta_HX, warn);

Qgen_hist(i)  = Q(2);
COP_hist(i)   = COP;
Qevap_hist(i) = Q(4);
T_cond_hist(i)    = Tcond;
T_evap_hist(i)    = Tevap;
T_abs_hist(i)    = Tabs;
T_gen_hist(i)  = Tgen;

end

end