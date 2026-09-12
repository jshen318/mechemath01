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
    num_iter = 100;
    dxtol = 1e-14;
    ftol = 1e-14;
    max_iter = 200;
    dxmax = 1e10;

    % create a list for the initial guesses that we would like to use in 
    % each trial
    guess0_list = linspace(x0_ref,x1_ref,num_iter);
    guess1_list = linspace(x0_ref,x1_ref,num_iter);

    %[x0_list, x1_list] = meshgrid(guess0_list, guess1_list);
   

    x0_succ = [];
    x1_succ = [];

    x0_fail = [];
    x1_fail = [];
    

    if solver == "Newton"
        for i = 1:num_iter
            x0 = guess0_list(i);
             [~,exit_flag] = newton_solver(func,x0,dxtol,ftol,max_iter,dxmax);

             if exit_flag == 1
                 x0_succ(end+1) = x0; % store successful guess
             else
                x0_fail(end+1) = x0; % store failed guess
             end
        end
        % plot newton's method
        figure(1);
        hold on;
        x = linspace(x0_ref, x1_ref, num_iter);
        plot(x, test_func03(x), 'k-')
        plot(x0_succ, func(x0_succ), 'g.', 'MarkerFaceColor', 'g');
        plot(x0_fail, func(x0_fail), 'r.', 'MarkerFaceColor', 'r');
        xlabel('');
        ylabel('');
        title('Newton Method Convergence');
        legend('function', 'successful', 'failed');
        

    elseif solver == "Secant" || solver == "Bisection"
        [x0_list, x1_list] = meshgrid(guess0_list, guess1_list);
        % loop through each trial
        for n = 1:num_iter^2
        % pull out the left and right guess for the trial
            x0 = x0_list(n);
            x1 = x1_list(n);
    
            if solver == "Secant"
                [~, exit_flag] = secant_solver(func,x0,x1,dxtol,ftol,max_iter,dxmax);
            elseif solver == "Bisection"
                [~, exit_flag] = bisection_solver(func,x0,x1,dxtol,ftol,max_iter);
            else
                disp("Input valid solver method")
            end
            
            % store successful/failed guesses
            if exit_flag == 1
                 x0_succ(end+1) = x0; 
                 x1_succ(end+1) = x1; 
            else
                x0_fail(end+1) = x0; 
                x1_fail(end+1) = x1;
            end
        end
        % plot 
        figure(1)
        hold on;
        plot(x0_fail, x1_fail, 'r.', 'MarkerSize', 2);
        plot(x0_succ, x1_succ, 'g.', 'MarkerSize', 2);

    end
end

