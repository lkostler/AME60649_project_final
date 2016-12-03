%AME60649 Final Project
%Particle Models for friction

clear all;
close all;

%% 1D 1 particle in harmonic potential
aa = linspace(0,1,1e3 +2);
aa = aa(2:end-1);
beta = @(a) 2*pi/integral(@(z) 1./sqrt(1-a*sin(z)),0,2*pi);
bb = arrayfun(beta, aa);

fig = figure;
plot(aa, bb.^2);
xlabel('Roughness of U: $U_{max}/E_{kin, 0}$');
ylabel('$E_{kin, macro}/E_{kin, 0}$');
title('1-D: particle in harmonic potential');
nice_plot(fig);

%% 1d: many particles in harmonic potential
l = 1;
k = 1;
N = 1;
A = 1/2 * 1/2;
tspan = [0, 1000];
tt = linspace(tspan(1), tspan(2), 1e3);

dy = @(t,y) AME60649_project_final_01_1dParticles_dy(y, l, k, A);

y0 = ones(2*N,1);
y0(1:2:end) = l*(0:1:N-1);

sol = ode45(dy, tspan, y0);

Y = deval(sol,tt);

plot(tt, Y(1:2:end,:));