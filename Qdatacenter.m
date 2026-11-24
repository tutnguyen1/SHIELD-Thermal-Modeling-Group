% function created based on ChatGPTs curve fit of data from 
% https://www.energy.ca.gov/sites/default/files/2026-04/Data_Center_Methodology_Memo_ada.pdf

function Qload = Qdatacenter(TimeData, CoefficientDataSource)

switch CoefficientDataSource
    case 'weekday'
        Coefficients = [0.8791; -0.0123; -0.0182; -0.0005; -0.0014];
    case 'weekend'
        Coefficients = [0.8601; -0.0020; -0.0109; -0.0001; -0.0006];
    case 'summer'
        Coefficients = [0.9098; -0.0128; -0.0260; -0.0033; -0.0023];
    case 'winter'
        Coefficients = [0.8488; -0.0088; -0.0140; 0.0002; -0.0013];
end

% Two-harmonic Fourier model:
%
% y = c0
%   + c1*cos(2*pi*x/24) + s1*sin(2*pi*x/24)
%   + c2*cos(4*pi*x/24) + s2*sin(4*pi*x/24)

% Evaluate fitted curve
XFit = [ ...
    ones(size(TimeData)), ...
    cos(2*pi*TimeData/24), ...
    sin(2*pi*TimeData/24), ...
    cos(4*pi*TimeData/24), ...
    sin(4*pi*TimeData/24)];

Qload = XFit * Coefficients;

end