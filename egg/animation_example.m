%Short example demonstrating how to create a MATLAB animation
%In this case, a square moving along an elliptical path
function animation_example()
    %Define the coordinates of the square vertices (in its own frame)
    square_coords_x = [-3,3,3,-3,-3];
    square_coords_y = [-3,-3,3,3,-3];
    hold on; axis equal; axis square %set up the plotting axis
    axis([0,40,0,40])
    square_plot = plot(0,0,'k'); %initialize the plot of the square
    
    %iterate through time
    for t=0:.001:10
        %compute the position of the square's center (travelling along ellipse)
        position_x = 9*cos(t)+20; position_y = 7*sin(t)+20;

        %compute positions of square vertices (in world frame)
        x_plot = square_coords_x+position_x;
        y_plot = square_coords_y+position_y;

        %update the coordinates of the square plot
        set(square_plot,'xdata',x_plot,'ydata',y_plot);

        %update the actual plotting window
        drawnow;
    end
end