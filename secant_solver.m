%Root finding function via secant method
%INPUTS:
%   fun: the function we are computing the root of
%   x0: first guess for secant method
%   x1: second guess for secant method
%   dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
%   ftol: termination threshold (stop when abs(f(x_{i}))<ftol
%   max_iter: maximum iteration limit
%   dxmax: threshold for checking for a divide by zero error: 
%   terminate when abs(x_{i+1}-x_i) > dxmax, where dxmax is a very large number
%OUTPUTS
%   x: estimate for root of fun
%   exit_flag: an integer indicating whether or not the solver succeeded
function [x2, exit_flag] = secant_solver(fun, x0, x1,dxtol,ftol,max_iter,dxmax)
    iter = 0;                  % set iteration variable

    iteration_flag = true;     % set flags True to start the while loop
    interval_flag = true;
    value_flag = true;
    max_flag = true;

    % loop through newton's method until the root is found, or until
    % the iteration maximum is hit
    while interval_flag && value_flag && iteration_flag && max_flag
        y0 = fun(x0);
        y1 = fun(x1);

        x2 = x1 - y1*((x1-x0) / (y1-y0));
        
        if mod(iter,2) == 0
            x0 = x2;
        else
            x1 = x2;
        end

        % add one to the iteration
        iter = iter+1;


        % break while loop if...
        % iterations are too close together (guesses too far left/right)
        interval_flag = dxtol < abs(x1 - x0);

        % final value guess is 'close enough' to zero
        value_flag = ftol < abs(fun(x1));

        % maximum iteration values reached
        iteration_flag = max_iter > iter;

        % iterations are too far apart
        max_flag = dxmax > abs(x1 - x0);
 
        
        % else: continue while loop to try and find roots
    end

    % success is based on whether the final value is 'close enough' to
    % zero. set exit_flag correspondingly
    exit_flag = ftol > abs(fun(x2));

end