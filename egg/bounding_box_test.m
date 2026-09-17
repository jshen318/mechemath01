% Testing compute_bounding_box with a plot
function bounding_box_test()
    %set the oval hyper-parameters
    egg_params = struct();
    egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;

    %specify the position and orientation of the egg
    x0 = 5; y0 = 5; theta = pi/6;
    
    %set up the axis
    hold on; axis equal; axis square
    axis([0,10,0,10])
    
    %plot the origin of the egg frame
    plot(x0,y0,'ro','markerfacecolor','r');
    
    %compute the perimeter of the egg
    V_list = egg_func(linspace(0,1,100),x0,y0,theta,egg_params);
    
    %plot the perimeter of the egg
    plot(V_list(1,:),V_list(2,:),'k');
    
    %compute the bounding box of the egg
    [x_range,y_range] = compute_bounding_box();

    x = [x_range(1), x_range(1), x_range(2), x_range(2), x_range(1)];
    y = [y_range(1), y_range(2), y_range(2), y_range(1), y_range(1)];

    %plot the bounding box of the egg]
    plot(x, y)

 end