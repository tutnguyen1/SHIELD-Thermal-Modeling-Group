function [out,Topt] = COP_Finder(Tgen_range, Tevap_range, Tabs_range, Tcond_range, Cooling, Hxeta)
eta_HX = Hxeta;
Qload = Cooling;
Tgen = Tgen_range;
Tabs = Tabs_range;
Tcond = Tcond_range;
Tevap = Tevap_range;
total_length = length(Tgen) * length(Tabs) * length(Tcond) * length(Tevap);
COP_Log = 1:total_length;
pos = 1;
max_COP = 0;
for i = 1:length(Tgen)
    for p = 1:length(Tevap)
        for j = 1:length(Tcond)
            for k = 1:length(Tabs)
                Xw = LiBrH2O_X(Tevap(p), Tabs(k), 'false');    
                Xs = LiBrH2O_X(Tcond(j), Tgen(i), 'false');
                if (Xw >= Xs)
                    continue
                end
                if (Xw<0.4 || Xs>0.7)
                    continue
                end
                [COP, m, P, h, T, Q, misc] = LiBr_Absorption_solver(Tevap(p), Tabs(k), Tcond(j), Tgen(i), Qload,eta_HX, 'false');
                pos = pos+1;
                COP_Log(pos) = COP;
                if max_COP<= COP
                    max_COP = COP;
                    Tg_opt = Tgen(i);
                    Tevap_opt = Tevap(p);
                    Ta_opt = Tabs(k);
                    Tc_opt = Tcond(j);
                end 
            end
        end
    end
end
out = max_COP;
Topt = [Tg_opt, Tevap_opt, Ta_opt, Tc_opt];
end