function delta = traj_wrapper1(t, traj_func, egg_params, perimeter, xy_range)
    [x, y, theta] = traj_func(t);
    [x_range, y_range] = compute_bounding_box(egg_params, x, y, theta);
    if xy_range == 1
        delta = perimeter - x_range(2);
    elseif xy_range == 2
        delta = y_range(1) - perimeter;
    else 
        disp("Pick 1 to output x_range, and 2 for y_range.")
    end
end