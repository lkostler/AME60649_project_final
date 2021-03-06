function [X, Y] = map_coordinates(X, Y, Lx, Ly, flag_plot)
%MAP_COORDINATES Summary of this function goes here
%   Detailed explanation goes here


if nargin < 5
    flag_plot = false;
    if nargout == 0
        flag_plot = true;
    end
end

if flag_plot
    
    fig = figure;
    subplot(1,2,1);
    plot(X,Y,'+');
    hold on;
    plot([-Lx/2 Lx/2 Lx/2 -Lx/2 -Lx/2], [-Ly/2 -Ly/2 Ly/2 Ly/2 -Ly/2], 'r');
    axis equal;
    legend('data', 'box');
end
%% map into box
X(X>Lx/2) = X(X>Lx/2) - Lx;
X(X<-Lx/2) = X(X<-Lx/2) + Lx;
Y(Y>Ly/2) = Y(Y>Ly/2) - Ly;
Y(Y<-Ly/2) = Y(Y<-Ly/2) + Ly;

if flag_plot

    subplot(1,2,2);
    plot(X,Y,'+');
    hold on;
    plot([-Lx/2 Lx/2 Lx/2 -Lx/2 -Lx/2], [-Ly/2 -Ly/2 Ly/2 Ly/2 -Ly/2], 'r');
    legend('data', 'box');
    title('mapped');
    axis equal;
    nice_plot(fig);
end
end

