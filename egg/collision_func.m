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
function [t_ground,t_wall] = collision_func(traj_fun, y_ground, x_wall)
    
    %set the oval hyper-parameters
    egg_params = struct();
    egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;

    % %specify the position and orientation of the egg
    % x0 = 5; y0 = 5; theta = pi/6;
    hold on; axis equal
    egg_plot = plot(0,0,'k');
    square_plot = plot(0,0);
    
    wallLine = xline(x_wall);
    set(egg_plot, 'xdata', wallLine);

    for t = 0:0.01:4
        [x, y, theta] = traj_fun(t);
        
        
        axis([0,x_wall,0,30])
        
        %plot the origin of the egg frame
        % plot(x,y,'ro','markerfacecolor','r');
        
        %compute the perimeter of the egg
        V_list = egg_func(linspace(0,1,100),x,y,theta,egg_params);
        
        
        % %compute the bounding box of the egg
        [x_range,y_range] = compute_bounding_box(egg_params, x, y, theta);

      
        % delta_y = y_range(1) - y_ground
        % delta_x = x_range(1) - x_wall

        xbox = [x_range(1), x_range(1), x_range(2), x_range(2), x_range(1)];
        ybox = [y_range(1), y_range(2), y_range(2), y_range(1), y_range(1)];

        % update the coordinates of the square plot
        set(square_plot,'xdata',xbox,'ydata',ybox);

        %plot the perimeter of the egg
        set(egg_plot, 'xdata', V_list(1,:),'ydata', V_list(2,:));
        
        %update the actual plotting window
        drawnow;
    end
end