% sigmoid function
% INPUTS: 
%   x: numeric input
% OUTPUTS: 
%   f_val: output value after computing the function
%   dfdx: slope of the function at the point x
function [f_val,dfdx] = test_func03(x)
    a = 27.3; b = 2; c = 8.3; d = -3;
    H = exp((x-a)/b);
    dH = H/b;
    L = 1+H;
    dL = dH;
    f_val = c*H./L+d;
    dfdx = c*(L.*dH-H.*dL)./(L.^2);
end