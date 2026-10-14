%this function just finds the difference of the Q between the inside of
%the loop and outside/external
function R = temperatureResiduals(Temps,t,Q)

Tevap = Temps(1);
Tabs  = Temps(2);
Tcond = Temps(3);
Tgen  = Temps(4);


% External heat-transfer rates
Qevap_ext = EvaporatorExternal(Tevap);

Qabs_ext = AbsorberExternal(Tabs);

Qcond_ext = CondenserExternal(Tcond);

Qgen_ext = Qsolar(t,18000,39600,500,0.75);


% Residual equations
R = [ ...
    Q(4) - Qevap_ext;
    Q(1) - Qabs_ext;
    Q(3) - Qcond_ext;
    Q(2)  - Qgen_ext];

fprintf('\nEVAP\n')
fprintf('Cycle    = %.2f kW\n',Q(4))
fprintf('External = %.2f kW\n',Qevap_ext)

fprintf('\nABS\n')
fprintf('Cycle    = %.2f kW\n',Q(1))
fprintf('External = %.2f kW\n',Qabs_ext)

fprintf('\nCOND\n')
fprintf('Cycle    = %.2f kW\n',Q(3))
fprintf('External = %.2f kW\n',Qcond_ext)

fprintf('\nGEN\n')
fprintf('Cycle    = %.2f kW\n',Q(2))
fprintf('External = %.2f kW\n',Qgen_ext)

end