% root finding function via bisection algorithm
%INPUTS:
%   fun: the function we are computing the root of
%   x_left: left guess
%   x_right: right guess
%   note that f(x_left) and f(x_right) should have different signs
%   dxtol: termination threshold (stop when interval x_right-x_left < dxtol)
%   ftol: termination threshold (stop when abs(f(x_guess))<ftol
%   max_iter: maximum iteration limit
%OUTPUTS
%   x: estimate for root of fun
%   exit_flag: an integer indicating that the solver succeeded (1) or
%   failed (0)
function [x_mid, exit_flag, guess_list] = bisection_solver(fun,x_left,x_right,dxtol,ftol,max_iter)
    iter = 0;                  % set iteration variable
    y_left = fun(x_left);       % solve for initial function values
    y_right = fun(x_right);
    
    iteration_flag = true;      % set flags True to start the while loop
    interval_flag = true;
    value_flag = true;

    % initialize a list for storing guesses
    guess_list = zeros(max_iter, 0);

    if y_left*y_right > 0    % check if guesses crosses zero
        x_mid = NaN;
        exit_flag = 0;
        % disp("No zero crossing between guesses; try a different initial guess?")
        return
    end

    % loop through the bisection method until the root is found, or until
    % the iteration maximum is hit
    while interval_flag && value_flag && iteration_flag
        x_mid = (x_right + x_left)/2;
        y_mid = fun(x_mid);
        % disp(x_mid);

        % check if the left and middle values are different signs
        if y_left*y_mid < 0
            guess_list(iter+1) = x_right;
            y_right = y_mid;
            x_right = x_mid;
        
        % check if the right and middle values are different signs
        elseif y_right*y_mid < 0
            guess_list(iter+1) = x_left;
            y_left = y_mid;
            x_left = x_mid;
        end

        % add one to the iteration
        iter = iter+1;

        % break while loop if...
        % iterations are too close together (guesses too far left/right)
        % final value guess is 'close enough' to zero
        % or maximum iteration values reached
        value_flag = ftol < abs(y_mid);
        interval_flag = dxtol < abs(x_right - x_left);
        iteration_flag = max_iter > iter;

        % else: continue while loop to try and find roots
        
    end
    
    % success is based on whether the final value is 'close enough' to
    % zero. set exit_flag correspondingly
    % exit_flag = ftol > abs(y_mid);
    if ftol > abs(y_mid)
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