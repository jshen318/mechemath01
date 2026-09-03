%Root finding function via Newton's method
%INPUTS:
%   fun: the function we are computing the root of
%   Note that fun(x) should output [f,dfdx], where dfdx is the derivative of f
%   (see test_func01 below for example)
%   x0: initial guess for Newton's method
%   dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
%   ftol: termination threshold (stop when abs(f(x_{i}))<ftol)
%   max_iter: maximum iteration limit
%   dxmax: threshold for checking for a divide by zero error: 
%   terminate when abs(x_{i+1}-x_i) > dxmax, where dxmax is a very large number
%OUTPUTS
%   x: estimate for root of fun
%   exit_flag: an integer indicating that the solver succeeded (1) or
%   failed (0)
function [x, exit_flag] = newton_solver(fun,x0,dxtol,ftol,max_iter,dxmax)
    iter = 0;                  % set iteration variable
    x = x0;

    iteration_flag = true;     % set flags True to start the while loop
    interval_flag = true;
    value_flag = true;
    max_flag = true;

    denomZero = false; % initialize denom zero checker

    % loop through newton's method until the root is found, or until
    % the iteration maximum is hit
    while interval_flag && value_flag && iteration_flag && max_flag && ~denomZero

        [fx, dfdx] = fun(x);            % compute Newton's method of 
        x_temp = x;                     % root-finding

        if abs(dfdx) < ftol
            denomZero = true;
            exit_flag = 0;
            return  % is "returning" the best practice for terminating in the middle of a while loop?
        end

        x = x_temp - fx/dfdx;

        % add one to the iteration
        iter = iter+1;

        % break while loop if...
        % iterations are too close together (guesses too far left/right)
        interval_flag = dxtol < abs(x - x_temp);
        
        % final value guess is 'close enough' to zero
        value_flag = ftol < abs(fun(x));

        % maximum iteration values reached
        iteration_flag = max_iter > iter;

        % iterations are too far apart
        max_flag = dxmax > abs(x - x_temp);
 

        % else: continue while loop to try and find roots
    end

    % success is based on whether the final value is 'close enough' to
    % zero. set exit_flag correspondingly
    exit_flag = ftol > abs(fun(x));

end
