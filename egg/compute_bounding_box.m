%Function that computes the bounding box of an oval
%INPUTS:
%theta: rotation of the oval. theta is a number from 0 to 2*pi.
%x0: horizontal offset of the oval
%y0: vertical offset of the oval
%egg_params: a struct describing the hyperparameters of the oval
%OUTPUTS:
%x_range: the x limits of the bounding box in the form [x_min,x_max]
%y_range: the y limits of the bounding box in the form [y_min,y_max]
function [x_range,y_range] = compute_bounding_box(x0,y0,theta,egg_params)
    %set the oval hyper-parameters
    egg_params = struct();
    egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;
    %specify the position and orientation of the egg
    x0 = 5; y0 = 5; theta = pi/6;
    %wrapper function that calls egg_wrapper1
    %but only takes s as an input (other inputs are fixed)
    %(single input)
    egg_wrapper2 = @(s) egg_wrapper1(s,x0,y0,theta,egg_params);
    s_root = secant_solver(egg_wrapper2,0,.01);
    
end