%Function that computes the collision time for a thrown egg
%INPUTS:
%   traj_fun: a function that describes the [x,y,theta] trajectory
%   of the egg (takes time t as input)
%   egg_params: a struct describing the hyperparameters of the oval
%   y_ground: height of the ground
%   x_wall: position of the wall
%OUTPUTS:
%   t_ground: time that the egg would hit the ground
%   t_wall: time that the egg would hit the wall
function [t_ground,t_wall] = collision_func(traj_func, y_ground, x_wall)
    
    %set the oval hyper-parameters
    egg_params = struct();
    egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;
    
    t_ground = NaN;
    t_wall = NaN;

    iter = 25;
    guess0_list = linspace(0,0.5,iter);
    guess1_list = linspace(0,0.5,iter);
    [x0_list, x1_list] = meshgrid(guess0_list, guess1_list);

    
    
    for t = 1:iter^2
        x_guess = x0_list(t);
        x1_guess = x1_list(t);

        traj_wrapper_x = @(t) traj_wrapper1(t,traj_func,egg_params,x_wall,1);
        traj_wrapper_y = @(t) traj_wrapper1(t,traj_func,egg_params,y_ground,2);

        if isnan(t_wall)
            [x_root, xit_flag] = secant_solver(traj_wrapper_x, x_guess, x1_guess);
            x_root
            if xit_flag == 1 && x_root > 0
                t_wall = x_root;
            end
        end

        if isnan(t_ground)
            [y_root, exyt_flag] = secant_solver(traj_wrapper_y, x_guess, x1_guess);
            y_root
            if exyt_flag == 1 && y_root > 0
                t_ground = y_root;
            end
        end

    end
    % t_ground = y_root
    % t_wall = x_root
end