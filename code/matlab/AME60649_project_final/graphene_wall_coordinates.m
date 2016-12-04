function [X] = graphene_wall_coordinates(Nx, Ny)
%GRAPHENE_WALL_COORDINATES Summary of this function goes here
%   Detailed explanation goes here
% X = [ [C1_X;C1_Y;C2_X;C2_Y], [...], ..., ]; each column contains the four
% coordinates of the two C atoms of one unit cell

%% lengths
d = 1.42; %carbon bond length
L = 2*d; %length of hexagon
W=2*d*sqrt(3)/2; % width of hexagon
w = 1.5*d; %width of hexagon rows

dx_x = W;
dy_x = 0;
dx_y = W/2;
dy_y = w;

unitdx = 0.61487803668695;
unitdy = 0.355;

%% init
N = Nx*Ny;

X = nan(4, N);

for j = 1:Ny
    for i = 1:Nx
        X(:, (j-1)*Nx+i) = [...
            (i-1)*dx_x+(j-1)*dx_y;...
            (i-1)*dy_x+(j-1)*dy_y;....
            (i-1)*dx_x+(j-1)*dx_y;...
            (i-1)*dy_x+(j-1)*dy_y] + ...
            [-unitdx;-unitdy;unitdx;unitdy];
    end
end

%% Walls
move_y = -Ny*w/2 + w/2;
% move_x = -(Nx*W + Ny*W/2)/2;
move_x = -(3/4*Ny-1)*W; 

X(1,:) = X(1,:) + move_x;
X(2,:) = X(2,:) + move_y;
X(3,:) = X(3,:) + move_x;
X(4,:) = X(4,:) + move_y;
end

