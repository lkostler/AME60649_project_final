%AME60649: Nanotube radii selection

clear all;
close all;

%% general
d = 1.42; %carbon bond length
L = 2*d; %length of hexagon
W=2*d*sqrt(3)/2; % width of hexagon
w = 1.5*d; %width of hexagon rows


%% dim
Nx = 13;
Ny = 14;

%% Walls
dy = -Ny*w/2;
dx = -(Nx*W + Ny*W/2)/2

%% Formulas: 



R= @(N) (W/4)./tan((2*pi)./(4*N));

NN = [10, 12, 14, 16, 20, 25, 50, 100, 200, 255];

NN
R(NN)