%Function that computes the bounding box of an oval
%INPUTS:
%   theta: rotation of the oval. theta is a number from 0 to 2*pi.
%   x0: horizontal offset of the oval
%   y0: vertical offset of the oval
%   egg_params: a struct describing the hyperparameters of the oval
%OUTPUTS:
%   x_range: the x limits of the bounding box in the form [x_min,x_max]
%   y_range: the y limits of the bounding box in the form [y_min,y_max]
function [x_range,y_range] = compute_bounding_box(egg_params, x0, y0, theta)

    % initialize variables
    num_iter = 60;
    xroot_list = zeros(1,2);
    yroot_list = zeros(1,2);

    % the egg has a period of 1, so only take guesses between 0 and 1
    % use meshgrid to take a variation of combinations instead of a line
    guess0_list = linspace(0,1,num_iter);
    guess1_list = linspace(0,1,num_iter);
    [x0_list, x1_list] = meshgrid(guess0_list, guess1_list);
    

    % wrapper function that calls egg_wrapper1 but only takes a single
    % input (s). make one each to solve for x and y respectively
    egg_wrapper_x = @(s) egg_wrapper1(s,x0,y0,theta,egg_params,1);
    egg_wrapper_y = @(s) egg_wrapper1(s,x0,y0,theta,egg_params,2);
    
    % loop through the mesh grid
    for n = 1:num_iter^2
        x_guess = x0_list(n);
        x1_guess = x1_list(n);

        % solve the roots at each set of guesses
        [xroot, xit_flag] = secant_solver(egg_wrapper_x, x_guess, x1_guess);
        [yroot, exyt_flag] = secant_solver(egg_wrapper_y, x_guess, x1_guess);

        % don't save NaNs, failed solutions, roots outside of [0, 1], or 
        % repeat solutions
        if ~isnan(xroot) && xit_flag && xroot>0 && xroot<1 
            if abs(xroot_list(1)-xroot)>0.1 && xroot_list(1)>0
                xroot_list(2) = xroot;
            else
                xroot_list(1) = xroot;
            end
        end
        if ~isnan(yroot) && exyt_flag && yroot>0 && yroot<1
            if abs(yroot_list(1)-yroot)>0.1 && yroot_list(1)>0
                yroot_list(2) = yroot;
            else
                yroot_list(1) = yroot;
            end
        end
    end
    
    % % statements for print testing
    % xroot_list
    % yroot_lists
    
    [vx, ~] = egg_func(xroot_list,x0,y0,theta,egg_params);
    x_range = [vx(1), vx(3)];

    [vy, ~] = egg_func(yroot_list,x0,y0,theta,egg_params);
    y_range = [vy(4), vy(2)];

    % figure()
    % hold on
    % title("Slope Plot for Testing")
    % [~, xfunc] = egg_func(guess0_list,x0,y0,theta,egg_params);
    % plot(guess0_list, xfunc)
    % yline(0)
    % legend('x slopes', 'y slopes')
end
