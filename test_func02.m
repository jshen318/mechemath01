%Quadratic function with root at the minimum
function [f_val,dfdx] = test_func02(x)
    global input_list;
    input_list(:,end+1) = x;
    f_val = (x-37.879).^2;
    dfdx = 2*(x-37.879);
end