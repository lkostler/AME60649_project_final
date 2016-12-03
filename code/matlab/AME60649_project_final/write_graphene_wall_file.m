function write_graphene_wall_file(Ny, r, path)
%WRITE_GRAPHENE_WALL_FILE Summary of this function goes here
%   Detailed explanation goes here
if nargin < 3
    path = '/Users/Lukas/GD/lk/phd_courses/fall_2016/AME60649/project_final/my_moltemplate/';
end
fileID = fopen(strcat(path, 'graphene_walls.lt'), 'w');

%% generate coordinates and radius
[X] = graphene_wall_coordinates(Ny-1, Ny);
ind = [sqrt(X(1,:).^2 + X(2,:).^2) <= r;sqrt(X(3,:).^2 + X(4,:).^2) <= r];

%% move cordinates
Nx = Ny-1;
d = 1.42; %carbon bond length
L = 2*d; %length of hexagon
W=2*d*sqrt(3)/2; % width of hexagon
w = 1.5*d; %width of hexagon rows
move_y = -Ny*w/2;
move_x = -(Nx*W + Ny*W/2)/2;


%% write file
fprintf(fileID, 'import "graphene.lt"\n\n');
fprintf(fileID, 'File created by Lukas Koestler on the basis of the moltemplate example. For further information visit: https://github.com/lkostler/AME60649_project_final.\n\n"\n\n');
fprintf(fileID, '# Notes:\n');
fprintf(fileID, '#    Hexagonal lattice with:\n');
fprintf(fileID, '# d = length of each hexagonal side  = 1.42 Angstroms\n');
fprintf(fileID, '# L = length of each hexagon = 2*d   = 2.84 Angstroms\n');
fprintf(fileID, '# W =  width of each hexagon = 2*d*sqrt(3)/2 = 2.4595121467478 Angstroms\n');
fprintf(fileID, '# w =  width of hexagon rows = 1.5*d = 2.13 Angstroms\n\n');

fprintf(fileID, 'Wall {\n');
fprintf(fileID, '\tunitcells = new Graphene [%i].move(1.2297560733739, 2.13, 0)\n', Ny);
fprintf(fileID, '\t                         [%i].move(2.4595121467478,   0,  0)\n\n', Ny-1);

fprintf(fileID, 'unitcells[*][*].move(%d, %d, 0.000)\n\n', move_x, move_y);
fprintf(fileID, '# Now cut a hole in the graphene sheet roughly where the nanotube is located:\n');
for n = 1:size(ind, 2)
    ix_me = mod(n-1, Ny-1)+1;
    iy_me = floor((n-1)/(Ny-1))+1;
    
    if all(ind(:,n))
        %cut both
        fprintf(fileID, 'delete unitcells[%i][%i]\n', iy_me-1, ix_me-1);
    else
        if ind(1,n)==1
            %cut C1
            fprintf(fileID, 'delete unitcells[%i][%i]/C1\n', iy_me-1, ix_me-1);
        end
        if ind(2,n)==1
            %cut C2
            fprintf(fileID, 'delete unitcells[%i][%i]/C2\n', iy_me-1, ix_me-1);
        end
    end
end

end
