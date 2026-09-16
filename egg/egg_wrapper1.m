function x_out = egg_wrapper1(s)
    %set the oval hyper-parameters
    egg_params = struct();
    egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;

    %specify the position and orientation of the egg
    x0 = 5; y0 = 5; theta = pi/6;
    [~, G] = egg_func(s,x0,y0,theta,egg_params);
    x_out = G(1);
end