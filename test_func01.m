% test function with two roots
% INPUTS: 
%   x: numeric input
% OUTPUTS: 
%   f_val: output value after computing the function
%   dfdx: slope of the function at the point x
function [fval,dfdx] = test_func01(x)
    fval = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) - 0.7 - exp(x/6);
    dfdx = 3*(x.^2)/100 - x/4 + 2 + 3*cos(x/2 + 6) - exp(x/6)/6;
end