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
function [t_ground,t_wall] = collision_func(traj_fun, egg_params, y_ground, x_wall)
    %your code here
end