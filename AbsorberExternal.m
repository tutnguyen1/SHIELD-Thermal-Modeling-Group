function Qabs_ext = AbsorberExternal(Tabs)

% External absorber cooling-water loop
%
% Tabs = absorber temperature [C]
% Qabs_ext = heat rejected from absorber [kW]
% for now pressures are hardcoded in bars (3 bar in this case);
% external temperatures are hard coded, and are examples from chatgpt, so
% we want to verify

h_in = H2O_STEAM( 'h_pT', 3, 30);

h_limit = H2O_STEAM( 'h_pT', 3, Tabs);

Qmax = 133 * (h_limit - h_in); %kg/s * (delta h)

Qabs_ext = 0.8 * Qmax;

end