function [v] = LiBrH2O_v(T,X)
Tk = T+273.15;
MW_LiBr = 0.08685;
MW_H2O  = 0.018015;
Tc = 647.096;        % K
rho_c = 17873;       % mol/m^3

% Convert mass fraction to mole fraction
x = (X/MW_LiBr) / ...
    (X/MW_LiBr + (1-X)/MW_H2O);

% Saturated liquid water density at T
rho_w_mass = XSteam('rhol_t',T);   % kg/m^3

% Convert water density to molar density
rho_w_molar = rho_w_mass/MW_H2O;

% Patek-Klomfar coefficients
a1 = 1.746;
a2 = 4.709;

S = a1*x + a2*x*(Tk/Tc)^6;

rho_molar = (1-x)*rho_w_molar + rho_c*S;

% Mixture molar mass
MW_mix = x*MW_LiBr + (1-x)*MW_H2O;

% Mass density
rho = rho_molar*MW_mix;

% Specific volume
[v] = 1/rho;
end