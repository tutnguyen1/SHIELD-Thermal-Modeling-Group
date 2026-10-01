function cp = LiBrH2O_Cp(T, x, p)
%EMPIRICALCP Evaluate the empirical heat-capacity fit.
%
%   cp = empiricalCp(T, x, p)
%
% Inputs
%   T : Temperature in degrees Celsius
%   x : LiBr composition as a decimal mass fraction (e.g., 0.5 = 50%)
%   p : Pressure in kPa
%
% Output
%   cp : Evaluated empirical fit.
%
% The aqueous-lithium-bromide coefficients from Table 2 are embedded below
% and are always used. The original fit uses T (K), x (LiBr mass fraction
% expressed in percent), and p (kPa). This function converts T and x to
% those fitting units internally.
%
% The equation implemented is
%
% cp = -2*T*(C0 + C1*x + C2*x^2 + C3*x^3 + C4*x^1.1)
%      -6*T^2*(D0 + D1*x + D2*x^2 + D4*x^1.1)
%      -12*T^3*(E0 + E1*x)
%      -2*(F0 + F1*x)*T/(T - T0)^3
%      -2*p*T*(V6 + V7*x)
%      +(L0 + L1*x + L2*x^2 + L3*x^3 + L4*x^1.1)/T
%      -(M0 + M1*x + M2*x^2 + M3*x^3 + M4*x^1.1).
%
% The powers and divisions are element-wise, so T, x, and p may be
% scalars, vectors, or compatible arrays.

% written by Chat GPT based on figures provide from Specific Heat
% Measurements on Aqueous Lithium Bromide, July 2005, Z. Yuan and K.E.
% Herold, HVAC&R Research 

% Table 2 coefficients for aqueous lithium bromide.
C0 =  2.648364473e-2;
C1 = -2.311041091e-3;
C2 =  7.559736620e-6;
C3 = -3.763934193e-8;
C4 =  1.176240649e-3;

D0 = -8.526516950e-6;
D1 =  1.320154794e-6;
D2 =  2.791995438e-11;
D4 = -8.511514931e-7; % D3 is not present in the fit

E0 = -3.840447174e-11;
E1 =  2.625469387e-11;

F0 = -5.159906276e+1;
F1 =  1.114573398;
T0 = 220; % K

V6 =  3.057997846e-9;
V7 = -5.129589007e-11;

L0 = -2.183429482e+3;
L1 = -1.266985094e+2;
L2 = -2.364551372;
L3 =  1.389414858e-2;
L4 =  1.583405426e+2;

M0 = -2.267095847e+1;
M1 =  2.983764494e-1;
M2 = -1.259393234e-2;
M3 =  6.849632068e-5;
M4 =  2.767986853e-1;

% Convert user inputs to the units used by the fitting coefficients.
T_K = T + 273.15;
x_percent = 100.*x;

% Polynomial groups in x.
C = C0 + C1.*x_percent + C2.*x_percent.^2 + ...
    C3.*x_percent.^3 + C4.*x_percent.^1.1;
D = D0 + D1.*x_percent + D2.*x_percent.^2 + D4.*x_percent.^1.1;
E = E0 + E1.*x_percent;
L = L0 + L1.*x_percent + L2.*x_percent.^2 + ...
    L3.*x_percent.^3 + L4.*x_percent.^1.1;
M = M0 + M1.*x_percent + M2.*x_percent.^2 + ...
    M3.*x_percent.^3 + M4.*x_percent.^1.1;

cp = -2.*T_K.*C ...
    -6.*T_K.^2.*D ...
    -12.*T_K.^3.*E ...
    -2.*(F0 + F1.*x_percent).*T_K./(T_K - T0).^3 ...
    -2.*p.*T_K.*(V6 + V7.*x_percent) ...
    +L./T_K ...
    -M;
end
