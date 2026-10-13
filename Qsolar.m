% equation developed from Simulation and Performance Analysis of a Solar-Charged Desalination Salt Thermal Energy Storage System with Bypass Discharge
% by Andy Duong and Reza Lakeh

%t = current time (s)
%t_charge_start = when the charging window starts (s)
%t_charge_end = when charging window ends (s)
%Acollector = total effective area of colar collectors (m^2)
%collectorETA = efficiency of solar collectors (decimal form)

function out = Qsolar(t,t_charge_start,t_charge_end,Acollector,collectorETA)

%input is time, and output is solar irradiance (W/m^2)

Gmax = 1000;  % Peak irradiance (W/m^2)
tpeak = (t_charge_end + t_charge_start)/2; % peak time during charging window (s) for now assuming in the middle
sigma = (t_charge_end - t_charge_start)/6; % standard deviation (s) simple assumption for standard deviation

g = Gmax*exp(-(t-tpeak).^2 / (2*sigma^2)); %the actual equation

%outside of the 6 hour window, no solar irradiance
if t<t_charge_start || t>t_charge_end
    g = 0;
end
out = (Acollector * collectorETA * g)/1000; %output in kW
end