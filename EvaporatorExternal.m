function Qevap_ext = EvaporatorExternal(Tevap)

% External load-side water loop
%
% Tevap = evaporator temperature [C]
% Qevap_ext = heat transferred into evaporator [kW]
% for now pressures are hardcoded in bars (3 bar in this case);
% external temperatures are hard coded, and are examples from chatgpt, so
% we want to verify

h_in = H2O_STEAM( 'h_pT', 3, 45);

h_limit = H2O_STEAM('h_pT', 3, Tevap);

Qmax = 25 * (h_in - h_limit); %kg/s * (delta h)

Qevap_ext = 0.80 * Qmax; %efficiency of heat exchanger

end