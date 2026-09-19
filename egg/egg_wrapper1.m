function root_out = egg_wrapper1(s,x0,y0,theta,egg_params,xy_root)
    [~, G] = egg_func(s,x0,y0,theta,egg_params);
    root_out = G(xy_root);
end