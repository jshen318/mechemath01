    %starter code for convergence experiments
%INPUTS:
%   fun: the function we are computing the root of
%   Note that fun(x) should output [f,dfdx], where dfdx is the derivative of f
%   (see test_func01 below for example)
%   x0: initial guess
%   dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
%   ftol: termination threshold (stop when abs(f(x_{i}))<ftol)
%   max_iter: maximum iteration limit
%   dxmax: threshold for checking for a divide by zero error: 
%   terminate when abs(x_{i+1}-x_i) > dxmax, where dxmax is a very large number
%   !!! NOTE !!! dxmax not used for Bisection method
%   solver: string representing which solver to use: "Newton", "Secant", or
%   "Bisection"
%OUTPUTS
%   
function guess_convergence(func, x0_ref, x1_ref, solver)
    num_iter = 50;
    dxtol = 1e-14;
    ftol = 1e-14;
    max_iter = 200;
    dxmax = 1e10;

    % create a list for the initial guesses that we would like to use in 
    % each trial
    guess0_list = linspace(x0_ref,x1_ref,num_iter);
    guess1_list = linspace(x0_ref,x1_ref,num_iter);
    [x0_list, x1_list] = meshgrid(guess0_list, guess1_list);
    
    x0_succ = [];
    x1_succ = [];
    
    x0_fail = [];
    x1_fail = [];

    % loop through each trial
    for n = 1:num_iter^2
        % pull out the left and right guess for the trial
        x0 = x0_list(n);
        x1 = x1_list(n);
        
        % Call your root finder using the recording function
        % you will need to change this, depending on the solver
        if solver == "Newton"
            [x_root,exit_flag] = newton_solver(func,x0,dxtol,ftol,max_iter,dxmax);
        elseif solver == "Secant"
            [~, exit_flag] = secant_solver(func,x0,x1,dxtol,ftol,max_iter,dxmax);
        elseif solver == "Bisection"
            [~, exit_flag] = bisection_solver(func,x0,x1,dxtol,ftol,max_iter);
        else
            disp("Input valid solver method: Newton, Secant, or Bisection")
        end
        
        if exit_flag == 1
            x0_succ(n) = x0;
            x1_succ(n) = x1;
        elseif exit_flag == 0
            x0_fail(n) = x0;
            x1_fail(n) = x1;
        end 
    end

    if solver == "Newton"
        figure(1)
        for i=1:length(x0_succ)
            y_succ = func(x0_succ(i));
        end
        for j=1:length(x0_fail)
            y_fail = func(x0_fail(i));
        end
        plot(x0, y_fail, 'r.')
        plot(x0, y_succ, 'g.')

    else
        figure(1)
        hold on
        plot(x0_fail, x1_fail, 'r.', 'MarkerFaceColor','r');
        plot(x0_succ, x1_succ, 'g.', 'MarkerFaceColor','g');
    end

end

