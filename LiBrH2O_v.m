function [v] = LiBrH2O_X(T,X,warn)
%   LiBrH2O_X : Determines specific volume
%   Source: L
%
%   v = LiBrH2O_X(tR, tm)
%
% Inputs
%   T : Temperature [C]
%   X : LiBr/kg solution []
%   warn : Enable/Disable error messages using true (on) or false (off)
% 
% Outputs
%   v : Specific Volume [m^3/kg]

% Evaluate Concentration
v = 1 / 640; % temporary for now to get code to work

% % Generate Error Messages if Requested (when value out of bounds of eqn)
% if warn == true
%     if or(X > 0.65, X < 0.50) 
%         fprintf("ERROR - LiBrH2O_X OUT OF BOUNDS\n");
%     end
% end

end