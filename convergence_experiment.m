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
function [abs_error_next, abs_error_current] = convergence_experiment(func, x0_ref, x1_ref, solver)
    num_iter = 1000;
    dxtol = 1e-14;
    ftol = 1e-14;
    max_iter = 200;
    dxmax = 1e10;

    % create an instance of the input_recorder
    my_recorder = input_recorder();
    
    % use input_recorder to generate a version of the test function
    % that records the input after every iteration
    % note: function handle "@" is necessary due to definition style
    f_record = my_recorder.generate_recorder_fun(func);

    % create a list for the initial guesses that we would like to use in 
    % each trial
    x0_list = linspace(x0_ref-3,x0_ref+3,num_iter);
    x1_list = linspace(x1_ref-3,x1_ref+3,num_iter);
    % list of estimate at current iteration (x_{n})
    x_current_list = [];
    
    % list of estimate at next iteration (x_{n+1})
    x_next_list = [];
    
    % list that tracks which iteration (n) in a trial 
    % each data point was collected from
    index_list = [];
    
    g0_list = zeros(0, length(x0_list));
    g1_list = zeros(0, length(x0_list));
    exit_flags = zeros(0, length(x0_list));
    x0_succ = [];
    x1_succ = [];
    
    x0_fail = [];
    x1_fail = [];

    % loop through each trial
    for n = 1:num_iter
        % pull out the left and right guess for the trial
        % x0 = x0_list(n);
        % x1 = x1_list(n);
        x0 = x0_ref - 3*rand();
        x1 = x1_ref + 3*rand();

        g0_list(n) = x0;
        g1_list(n) = x1;

        % reset input_list for the next test
        my_recorder.clear_input_list();
        
        % Call your root finder using the recording function
        % you will need to change this, depending on the solver
        if solver == "Newton"
            [x_root, exit_flag] = newton_solver(f_record,x0,dxtol,ftol,max_iter,dxmax);
            [dfdx,d2fdx2] = approximate_derivative(func, x_root);
            newt_k_pred = abs((1/2)*(d2fdx2/dfdx));
        elseif solver == "Secant"
            [x_root, exit_flag] = secant_solver(f_record,x0,x1,dxtol,ftol,max_iter,dxmax);
        elseif solver == "Bisection"
            [x_root, exit_flag, input_list] = bisection_solver(f_record,x0,x1,dxtol,ftol,max_iter);
        elseif solver == "Fzero"
            x_root = fzero(f_record, x0);
        else
            disp("Input valid solver method: Newton, Secant, or Bisection")
        end
        
        exit_flags(n) = exit_flag;

        %See what input values were used when f_record was called:
        if solver ~= 'Bisection'
         input_list = my_recorder.get_input_list();
        end
        %at this point, input_list will be populated with the values that
        %the solver called at each iteration.
        %In other words, it is now [x_1,x_2,...x_n-1,x_n]
    
        %append the collected data to the compilation
        x_current_list = [x_current_list,input_list(1:end-1)];
        x_next_list = [x_next_list,input_list(2:end)];
        index_list = [index_list,1:length(input_list)-1];
   
    end

    %At this point, x_current_list corresponds to many many
    %measurements of x_{n} across many trials
    %and x_next_list corresponds to many many measurements of
    %the corresponding value of x_{n+1} across many trials
    %this is the data the you want to clean and analaze
    
    %compute the absolute value of the error for current/next iteration
    % target_root = fzero(func,x0_ref); % true root calculated by 
    target_root = x_root;
    abs_error_current = abs(x_current_list-target_root);
    abs_error_next = abs(x_next_list-target_root);

    % % generate a loglog plot (before filtering)
    % loglog(abs_error_current,abs_error_next,...
    %     'ro','markerfacecolor','r','markersize',2);
    % 
    % xlabel('\epsilon_n (-)'); ylabel('\epsilon_{n+1} (-)');
    % title('Error Convergence Plot for Solver');

% ------------ cleaning data

    %data points to be used in the regression
    x_regression = []; % e_n
    y_regression = []; % e_{n+1}
    filter_list = [1e-15, 1e-2, 1e-14, 1e-2, 2];

    %iterate through the collected data
    for n=1:length(index_list)
        %if the error is not too big or too small
        %and it was enough iterations into the trial...
        if abs_error_current(n)>filter_list(1) && abs_error_current(n)<filter_list(2) && ...
            abs_error_next(n)>filter_list(3) && abs_error_next(n)<filter_list(4) && ...
            index_list(n)>filter_list(5)
            %then add it to the set of points for regression
            x_regression(end+1) = abs_error_current(n);
            y_regression(end+1) = abs_error_next(n);
        end
        % x_regression(end+1) = abs_error_current(n);
        % y_regression(end+1) = abs_error_next(n);
    end
    
    % disp(length(x_regression))
    % disp(length(y_regression))

    % generate a loglog plot (after filtering)
    figure(1)
    loglog(abs_error_current,abs_error_next,...
        'ro','markerfacecolor','r','markersize',2);

    xlabel('\epsilon_n (-)'); ylabel('\epsilon_{n+1} (-)');
    title('Error Convergence Plot for Solver');
    hold on
    loglog(x_regression, y_regression, 'bo','markerfacecolor','b','markersize',2);
    
    
    [p,k] = generate_error_fit(x_regression, y_regression)
    
    
    
    %generate x data on a logarithmic range
    fit_line_x = 10.^[-16:.01:1];
    %compute the corresponding y values
    fit_line_y = k*fit_line_x.^p;
    %plot on a loglog plot.
    loglog(fit_line_x,fit_line_y,'k-','linewidth',1)
    xlim([1e-17, 1e1]);
    ylim([1e-17, 1e1]);
    leg = legend("Raw Data", "Filtered Data", "Fit Line");
    set(leg,'location','northwest');
    title(sprintf('Error Convergence Plot for %s Root Solver', solver))
    

    for i = 1:length(exit_flags)
        if exit_flags(i) == 1
            x0_succ(i) = g0_list(i);
            x1_succ(i) = g1_list(i);
        elseif exit_flags(i) == 0
            x0_fail(i) = g0_list(i);
            x1_fail(i) = g1_list(i);
        end 
    end

    exit_flags
    figure(2)
    hold on
    plot(x0_fail, x1_fail, 'ro', 'MarkerFaceColor','r');
    plot(x0_succ, x1_succ, 'go', 'MarkerFaceColor','g');
    

end

%Definition of the test function and its derivative (as a single function):
%This definition uses the function keyword
%when passing this function as an argument to a solver,
%you'll need to use the handle operator
%ex. solver(func,x_guess)
function [fval,dfdx] = test_func01(x)
    fval = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
    dfdx = 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;
end

