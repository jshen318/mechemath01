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
function [t_ground,t_wall] = video_eggnimation(traj_fun, y_ground, x_wall)

    % save file to my files lol
    mypath1 = 'C:\Users\ssperou\OneDrive - Olin College of Engineering\Documents\GitHub\mechemath01\egg\';
    fname='eggnimation02.avi';
    input_fname = [mypath1,fname];

    %create a videowriter, which will write frames to the animation file
    writerObj = VideoWriter(input_fname);
    open(writerObj); %must call open before writing any frames
   

    %set the oval hyper-parameters
    egg_params = struct();
    egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;
    
    %find time egg hits wall/gorund
    [t_ground, t_wall] = collision_func(traj_fun, y_ground, x_wall);
    
    %whichever hits first is when the animation ends
    if t_ground > t_wall
        time = t_wall
    elseif t_wall > t_ground
        time = t_ground
    end


    %initialize the current figure and save as object
    fig1 = figure(1);
    hold on; axis equal
    egg_plot = plot(0,0,'k');
    square_plot = plot(0,0);
    impact_plot = plot(0,0,'ro','MarkerFaceColor','r','MarkerSize',8);

    
    wallLine = xline(x_wall);
    set(egg_plot, 'xdata', wallLine);
    
    xlabel('x position (cm)', 'Interpreter', 'Latex')
    ylabel('y position (cm)', 'Interpreter', 'Latex')
    title('Tumbling Egg Animation', 'Interpreter', 'Latex')
    set(gca,'TickLabelInterpreter','latex')
    fontsize(17, 'points')

    time_iter = linspace(0,time,100)

    % 
    for i =1:length(time_iter)
        t = time_iter(i);
       
        [x, y, theta] = traj_fun(t);


        axis([0,x_wall,0,30])
        
        %plot the origin of the egg frame
        % plot(x,y,'ro','markerfacecolor','r');
        
        %compute the perimeter of the egg
        V_list = egg_func(linspace(0,1,100),x,y,theta,egg_params);
        
        
        % %compute the bounding box of the egg
        [x_range,y_range] = compute_bounding_box(egg_params, x, y, theta);

      

        xbox = [x_range(1), x_range(1), x_range(2), x_range(2), x_range(1)];
        ybox = [y_range(1), y_range(2), y_range(2), y_range(1), y_range(1)];

        % update the coordinates of the square plot
        set(square_plot,'xdata',xbox,'ydata',ybox);
        % 
        % %plot the perimeter of the egg
        set(egg_plot, 'xdata', V_list(1,:),'ydata', V_list(2,:));
        
        %
        if i == length(time_iter)
            %V_list_fine = egg_func(linspace(0,1,1000), x, y, theta, egg_params);
            if t_wall < t_ground
                [~, idx] = max(V_list(1,:)); %rightmost point (touching wall)
            else
                [~, idx] = min(V_list(2,:)); %lowest point (touching ground)
            end
            impact_x = V_list(1,idx);
            impact_y = V_list(2,idx);
            set(impact_plot, 'xdata', impact_x, 'ydata', impact_y);
        end

        %update the actual plotting window
        drawnow;

        %capture a frame (what is currently plotted)
        current_frame = getframe(fig1);
        %write the frame to the video
        writeVideo(writerObj,current_frame);


    end
    close(writerObj);
end