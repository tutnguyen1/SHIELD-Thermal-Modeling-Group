%stuff for solar sizing
clc;
dt = 60;                       % Time Step
time = 0:dt:24*3600;           % Total Time
N = length(time);

Qgen_hist  = zeros(1,N);
Qevap_hist  = zeros(1,N);
Tevap = 12;
Tcond = 30;
Tabs = 30;
Tgen = 62;
Area = 12483; %(m^2)

for i = 1:N

    t = time(i);

    Qgen = Qsolar(t,28800,61200,Area,0.75);     % Using the values from the paper referenced in the Qsolar function, plus adding some baseline function that the waste heat represents

    [COP,m,~,~,~,Q,misc] = Solver__Qgen_In(Tevap, Tabs, Tcond, Tgen, Qgen, 0.7, 'false');

   
    Qevap_hist(i) = Q(4);
    Qgen_hist(i)  = Qgen;

end



plot(time,Qgen_hist, 'DisplayName', 'Solar Energy');
xlabel('time (s)');
ylabel('Qgen (kW)');
title('Qgen and Data Center Waste Heat');
hold on;
yline(2200, 'DisplayName','Waste Heat');
legend

energy_solar = (trapz(time, Qgen_hist))/1000;
data_waste = (2200 * (3600*24))/1000;
difference = abs(data_waste - energy_solar);
fprintf('Solar Energy = %1.3f MJ\n', energy_solar)
fprintf('Data center waste = %1.3f MJ\n', data_waste)
fprintf('Energy Deficit = %1.3f MJ\n', difference)

%% solar sizer auto

dt = 60;                       % Time Step
time = 0:dt:24*3600;           % Total Time
N = length(time);
difference = 7;
area = 1;
Qgen_hist  = zeros(1,N);
while difference > 0 
    for i = 1:N
        t = time(i);
        Qgen = Qsolar(t,28800,61200,area,0.75);     % Using the values from the paper referenced in the Qsolar function, plus adding some baseline function that the waste heat represents
        Qgen_hist(i)  = Qgen;
    end
    energy_solar = (trapz(time, Qgen_hist))/1000;
    data_waste = (2200 * (3600*24))/1000;
    difference = (data_waste - energy_solar);
    area = area+1;
end
area= area - 1;
energy_solar = (trapz(time, Qgen_hist))/1000;
data_waste = (2200 * (3600*24))/1000;
difference = (data_waste - energy_solar);
fprintf('best area = %1.1f m^2\n',area)
fprintf('Solar Energy = %1.3f MJ\n', energy_solar)
fprintf('Data center waste = %1.3f MJ\n', data_waste)
fprintf('Energy Deficit = %1.3f MJ\n', difference)