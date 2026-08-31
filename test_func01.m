function [fval,dfdx] = test_func01(x)
% Definition of the test function and its derivative (as a single file):
    % When passing this as an arg to a solver, you'll have to use the 
    % @ sign (handle operator) e.g. solver(@test_func01,x_guess)
    fval = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) - 0.7 - exp(x/6);
    dfdx = 3*(x.^2)/100 - x/4 + 2 + 3*cos(x/2 + 6) - exp(x/6)/6;
end