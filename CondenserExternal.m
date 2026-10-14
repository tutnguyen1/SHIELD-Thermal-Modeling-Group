function Qcond_ext = CondenserExternal(Tcond)

% External condenser cooling-water loop
%
% Tcond = condenser temperature [C]
% Qcond_ext = heat rejected from condenser [kW]
% for now pressures are hardcoded in bars (3 bar in this case);
% external temperatures are hard coded, and are examples from chatgpt, so
% we want to verify

h_in = H2O_STEAM('h_pT', 3, 30);

h_limit = H2O_STEAM( 'h_pT', 3, Tcond);

Qmax = 100 * (h_limit - h_in); %kg/s *(delta H)

Qcond_ext = 0.80 * Qmax;

end