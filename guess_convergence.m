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
%   none
function guess_convergence(func, x0_ref, x1_ref, solver)
    if solver == "Newton" || solver == "Fzero"
        num_iter = 500;
    else
        num_iter = 60;
    end
    dxtol = 1e-14;
    ftol = 1e-14;
    max_iter = 200;
    dxmax = 1e10;

    % create a list for the initial guesses that we would like to use in 
    % each trial
    guess0_list = linspace(x0_ref,x1_ref,num_iter);
    guess1_list = linspace(x0_ref,x1_ref,num_iter);

    % initialize variables
    x0_succ = [];
    x1_succ = [];
    x0_fail = [];
    x1_fail = [];
    root = NaN;

    % for the Newton method solver:
    if solver == "Newton"
        % run the solver for each iteration
        for i = 1:num_iter
            x0 = guess0_list(i);  % pull guesses from the list
            [x_root,exit_flag] = newton_solver(func,x0,dxtol,ftol,max_iter,dxmax);
                
            % store x_root on one successful solver run
            if ~isnan(x_root) && isnan(root)
                root = x_root
            end
            
            % store successful and failed guesses in separate lists based
            % on the success flag that the solver outputs
            if exit_flag == 1
                 x0_succ(end+1) = x0; 
            else
                x0_fail(end+1) = x0;
            end
        end
        
        % plot the function as a color-coded map of successful and failed
        % guesses 
        figure(1);
        hold on;
        plot(x0_succ, func(x0_succ), 'b.', 'MarkerFaceColor', 'b', 'Displayname',"Successful Guesses");
        plot(x0_fail, func(x0_fail), 'r.', 'MarkerFaceColor', 'r', 'Displayname',"Failed Guesses");
        plot(root, 0, 'ko', 'MarkerFaceColor', 'cyan', 'MarkerSize', 7, 'Displayname',"Function Root")
        title(sprintf('%s Method Sigmoid Guess Successes', solver));
        legend('Location','northwest')
        yline(0, 'LineStyle','--','HandleVisibility','off');
        xlabel("x")
        ylabel("f(x)")

    % for the Fzero solver:
    elseif solver == 'Fzero'
        % run the solver for each iteration
        for i = 1:num_iter
            x0 = guess0_list(i);        % pull guesses
            x_root = fzero(func,x0);    % run solver
            
            % when Fzero fails, it outputs NaN, so use isnan to determine
            % whether the function failed or succeeded. 
            if isnan(x_root)
                x0_fail(end+1) = x0; 
            else
                x0_succ(end+1) = x0; 
            end
        end
    
        % plot the function as a color-coded map of successes & failures
        figure(1);
        hold on;
        plot(x0_succ, func(x0_succ), 'b.', 'MarkerFaceColor', 'b', 'Displayname',"Successful Guesses");
        plot(x0_fail, func(x0_fail), 'r.', 'MarkerFaceColor', 'r', 'Displayname',"Failed Guesses");
        plot(x_root, 0, 'ko', 'MarkerFaceColor', 'cyan', 'MarkerSize', 7, 'Displayname',"Function Root")
        title(sprintf('%s Method Sigmoid Guess Successes', solver));
        legend('Location','northwest')
        yline(0, 'LineStyle','--','HandleVisibility','off');
        xlabel("x")
        ylabel("f(x)")

    % for the Secant and Bisection methods:
    else
        % set up a meshgrid of guesses
        [x0_list, x1_list] = meshgrid(guess0_list, guess1_list);

        % run the solver for each iteration
        % since we're using a 2D grid of guesses, the number of iterations
        % is the regular iteration size squared
        for n = 1:num_iter^2
            % pull each pair of guesses from the mesh
            x0 = x0_list(n);
            x1 = x1_list(n);
    
            % run the solver based on the solver selected on input
            if solver == "Secant"
                [x_root, exit_flag] = secant_solver(func,x0,x1,dxtol,ftol,max_iter,dxmax);
            elseif solver == "Bisection"
                [x_root, exit_flag] = bisection_solver(func,x0,x1,dxtol,ftol,max_iter);
            else
                disp("Input valid solver method: choose Newton, Bisection, Secant, or Fzero")
                return
            end

            % store x_root when the solver runs successfully
            if ~isnan(x_root) && isnan(root) && exit_flag
                root = x_root;
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
        yline(root, 'LineStyle','-','HandleVisibility','off', 'Color', [.7 .7 .7]);
        xline(root, 'LineStyle','-','HandleVisibility','off', 'Color', [.7 .7 .7]);
        plot(x0_fail, x1_fail, 'r.', 'MarkerSize', 4, 'Displayname',"Successful Guesses");
        plot(x0_succ, x1_succ, 'b.', 'MarkerSize', 4, 'Displayname', "Failed Guesses");  
        plot(root, root, 'ko', 'MarkerFaceColor', 'cyan', 'MarkerSize', 7, 'Displayname',"Solved root value")
        title(sprintf('%s Method Sigmoid Guess Successes', solver));
        legend('Location','southoutside')

        if solver == "Secant"
            xlabel("x_0")
            ylabel("x_1")
        elseif solver == "Bisection"
            xlabel("x_L")
            ylabel("x_R")
        else
            disp("How'd you even get this error message")
        end
    end

end

