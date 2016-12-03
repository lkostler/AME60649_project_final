function write_system_file(Ltube, Lx, Ly, path)
%WRITE_SYSTEM_FILE Summary of this function goes here
%   Detailed explanation goes here
if nargin <4
    path = '/Users/Lukas/GD/lk/phd_courses/fall_2016/AME60649/project_final/my_moltemplate/';
end
fileID = fopen(strcat(path, 'system.lt'), 'w');

%% write file
fprintf(fileID, '#File created by Lukas Koestler on the basis of the moltemplate example. For further information visit: https://github.com/lkostler/AME60649_project_final.\n\n\n');
fprintf(fileID, '# This is a small version of a carbon-nanotube, water capillary system.  It was\n');
fprintf(fileID, '# inspired by this paper: Laurent Joly, J. Chem. Phys. 135(21):214705 (2011)\n\n');

fprintf(fileID, 'import "graphene_walls.lt"\n\n');

fprintf(fileID, 'import "nanotube.lt"\n\n');

fprintf(fileID, 'import "water_box.lt"\n\n');


fprintf(fileID, '# ------------ boundary conditions ------------\n\n');

fprintf(fileID, 'write_once("Data Boundary") {\n');
fprintf(fileID, ' %d %d  xlo xhi\n', -Lx/2, Lx/2);
fprintf(fileID, ' %d %d  ylo yhi\n', -Ly/2, Ly/2);
fprintf(fileID, ' %d %d  zlo zhi\n', -Ltube/2, 1.5*Ltube);
fprintf(fileID, '}\n\n');

fprintf(fileID, '# ---------------------------------------------\n\n');

fprintf(fileID, 'write_once("In Settings") {\n');
fprintf(fileID, '  # --- We must eventually specify the interactions between the atoms ---\n');
fprintf(fileID, '  # --- in different molecule types (graphene-water interactions).    ---\n');
fprintf(fileID, '  # (See Laurent Joly, J. Chem. Phys. 135(21):214705 (2011) for details\n\n');

fprintf(fileID, ' pair_coeff @atom:Graphene/C @atom:SPCE/O lj/cut/coul/long 0.114 3.28\n');
fprintf(fileID, ' pair_coeff @atom:Graphene/C @atom:SPCE/H lj/cut/coul/long 0.0   3.28\n');
fprintf(fileID, '}\n');

end

