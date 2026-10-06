%function if we want the temps to be fixed, but flow rates and pump work to
%change
function Mass_Flow_Rate_Time_Variant(Tevap, Tabs, Tcond, Tgen, eta_HX, warn)
dt = 60;                       % Time Step
time = 0:dt:24*3600;           % Total Time
N = length(time);

COP_hist   = zeros(1,N); %creating arrays for outputs to plot
Qevap_hist = zeros(1,N);
Qgen_hist  = zeros(1,N);
mr_hist    = zeros(1,N);
mw_hist    = zeros(1,N);
ms_hist    = zeros(1,N);
pump_hist  = zeros(1,N);


for i = 1:N

    t = time(i);

    Qgen = t^2;     % Whatever the Qgen profile is in kW

    [COP,m,~,~,~,Q,misc] = Solver__Qgen_Mass_Flow(Tevap, Tabs, Tcond, Tgen, Qgen, eta_HX, warn);

    Qgen_hist(i)  = Qgen;
    COP_hist(i)   = COP;
    Qevap_hist(i) = Q(4);
    mr_hist(i)    = m(1);
    mw_hist(i)    = m(2);
    ms_hist(i)    = m(3);
    pump_hist(i)  = misc(3);
    

end
subplot(2,3,1);
plot(time,Qgen_hist);
xlabel('time (s)');
ylabel('Qgen (kW)');
title('Qgen');

subplot(2,3,2);
plot(time,Qevap_hist);
xlabel('time (s)');
ylabel('Qevap (kW)');
title('Qevap');

subplot(2,3,3);
plot(time,mr_hist);
xlabel('time (s)');
ylabel('Ref. Mass Flow Rate (kg/s)');
title('Ref. Mass Flow Rate');

subplot(2,3,4);
plot(time,mw_hist);
xlabel('time (s)');
ylabel('Weak Sol. Mass Flow Rate (kg/s)');
title('Weak Sol. Mass Flow Rate');

subplot(2,3,5);
plot(time,ms_hist);
xlabel('time (s)');
ylabel('Strong Sol. Mass Flow Rate (kg/s)');
title('Strong Sol. Mass Flow Rate');

subplot(2,3,6);
plot(time,COP_hist);
xlabel('time (s)');
ylabel('COP');
title('COP');
ylim ([0,1]);
