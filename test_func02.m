% quadratic function with root at the minimum
% INPUTS: 
%   x: numeric input
% OUTPUTS: 
%   f_val: output value after computing the function
%   dfdx: slope of the function at the point x
function [f_val,dfdx] = test_func02(x)
    global input_list;
    input_list(:,end+1) = x;
    f_val = (x-37.879).^2;
    dfdx = 2*(x-37.879);
end