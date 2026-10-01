function [X] = LiBrH2O_X(tR,tm, warn)
%   LiBrH2O_X : Determines concentration of solution
%   Source: Lansing 1976, Computer modeling of a single-stage lithium bromide-water absorption refrigeration unit
%
%   X = LiBrH2O_X(tR, tm)
%
% Inputs
%   tR : Temperature, Refrigerant [C]
%   tm : Temperature, Saturated Solution [C]
%   warn : Enable/Disable error messages using true (on) or false (off)
% 
% Outputs
%   X : Concentration [LiBr/kg]

% Evaluate Concentration
X = (49.04 + 1.125*tm - tR) / ...
    (134.65 + 0.47*tm);

% Generate Error Messages if Requested (when value out of bounds of eqn)
if warn == true
    if or(X > 0.65, X < 0.50) 
        fprintf("ERROR - LiBrH2O_X OUT OF BOUNDS\n");
    end
end


end