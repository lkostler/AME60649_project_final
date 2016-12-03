% AME60649 Final Project
%This script takes the setup generated by the moltemplate nanotube
%capillary example and selects the sheets/tube

clear all;
close all;

%% load data
load('AME60649_project_final/AME60649_project_final_test01_moltemplate_nanotube.mat');
%contains the variable data where each row corresponds to one atom and
%the columns are those for lammps type full
%atom-ID molecule-ID atom-type q x y z
%q is the charge


z_upper_sheet = 58.26;
z_lower_sheet = 32.0;

%% find atoms
ind_up = data(:,7) == z_upper_sheet;
ind_low = data(:,7) == z_lower_sheet;
ind_tube = data(:,7) < z_upper_sheet & data(:,7) > z_lower_sheet;
ind_water = data(:,7) < z_lower_sheet;
%% plot only tube and upper
ind = ind_up;
plot3(data(ind,5),data(ind,6),data(ind,7),'or');
hold on;
ind = ind_tube;
plot3(data(ind,5),data(ind,6),data(ind,7),'ok');
ind = ind_low;
plot3(data(ind,5),data(ind,6),data(ind,7),'or');
ind = ind_water;
plot3(data(ind,5),data(ind,6),data(ind,7),'b+');
xlabel('x');
ylabel('y');
zlabel('z');
axis equal


%% compare my algo
[X] = graphene_wall_coordinates(13, 14);
fig = figure;
ind = ind_up;
plot(data(ind,5),data(ind,6),'or');
hold on;
plot(X(1,:), X(2,:), '+g');
plot(X(3,:), X(4,:), '+g');
legend('original', 'me');






