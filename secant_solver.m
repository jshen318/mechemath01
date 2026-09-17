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
%   x2: estimate for root of fun
%   exit_flag: an integer indicating whether or not the solver succeeded
function [x2, exit_flag] = secant_solver(fun, x0, x1,dxtol,ftol,max_iter,dxmax)   
    arguments
        fun (1,:) function_handle
        x0 (1,:) double
        x1 (1,:) double
        dxtol (1,:) double = 10e-14;
        ftol (1,:) double = 10e-14;
        max_iter (1,:) double = 200;
        dxmax (1,:) double = 10e5;
    end

    iter = 0;                  % set iteration variable
    y0 = fun(x0);              % solve for initial function values
    y1 = fun(x1);
    
    iteration_flag = true;     % set flags True to start the while loop
    interval_flag = true;
    value_flag = true;

    % loop through newton's method until the root is found, or until
    % the iteration maximum is hit
    while interval_flag && value_flag && iteration_flag

        if dxmax < abs(x1 - x0)         % check for zero in denom
            % disp("Zero denominator error, or oversized update step size.")
            exit_flag = 0;              % if true: mark failure and exit
            return                      % the program
        end
        
        x2 = x1 - y1*((x1-x0) / (y1-y0)); % otherwise, continue computing
        y2 = fun(x2);

        if mod(iter,2) == 0      % alternate assignment variable every loop
            x0 = x2;
            y0 = y2;
        else
            x1 = x2;
            y1 = y2;
        end
        
        % add one to the iteration
        iter = iter+1;
        
        % break while loop if...
        % iterations are too close together (tending to something not a root)
        % final value guess is 'close enough' to zero
        % maximum iteration values reached
        % iterations are too far apart
        interval_flag = dxtol < abs(x1 - x0);
        value_flag = ftol < abs(y1);
        iteration_flag = max_iter > iter;

        % else: continue while loop to try and find roots
        
    end

    % success is based on whether the final value is 'close enough' to
    % zero. set exit_flag correspondingly
    if ftol > abs(y1)
        exit_flag = 1;
        return
    elseif ~interval_flag
        % disp("Iterations tending towards a false root.")
        exit_flag = 0;
        return
    else ~iteration_flag;
        % disp("Maximum iterations reached.")
        exit_flag = 0;
        return
    end
end