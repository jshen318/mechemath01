%Short example demonstrating how to create a MATLAB animation
%In this case, a square moving along an elliptical path
%This version also store the animation in a vide.
function video_example()
    %define location and filename where video will be stored
    %written a bit weird to make it fit when viewed in assignment
    mypath1 = 'C:\Users\taylorott\Dropbox (Personal)\OrionTeachingMaterials\';
    mypath2 = 'AppliedMathForEngineers\Modules\Strandbeest\graphics\';
    fname='square_animation.avi';
    input_fname = [mypath1,mypath2,fname];

    %create a videowriter, which will write frames to the animation file
    writerObj = VideoWriter(input_fname);
    open(writerObj); %must call open before writing any frames

    %Define the coordinates of the square vertices (in its own frame)
    square_coords_x = [-3,3,3,-3,-3];
    square_coords_y = [-3,-3,3,3,-3];

    %initialize the current figure and save as object
    fig1 = figure(1);
    %set up the plotting axis
    hold on; axis equal; axis square
    axis([0,40,0,40])

    %initialize the plot of the square
    square_plot = plot(0,0,'k');

    %iterate through time
    for t=0:.03:10
        %compute the position of the square's center (travelling along ellipse)
        position_x = 9*cos(t)+20; position_y = 7*sin(t)+20;

        %compute positions of square vertices (in world frame)
        x_plot = square_coords_x+position_x;
        y_plot = square_coords_y+position_y;

        %update the coordinates of the square plot
        set(square_plot,'xdata',x_plot,'ydata',y_plot);

        %update the actual plotting window
        drawnow;

        %capture a frame (what is currently plotted)
        current_frame = getframe(fig1);
        
        %write the frame to the video
        writeVideo(writerObj,current_frame);
    end
    %must call close after all frames are written
    close(writerObj);
end