function Natoms = write_nanotube_file(NR, NL, path)
%WRITE_GRAPHENE_WALL_FILE Summary of this function goes here
%   Detailed explanation goes here
if nargin < 3
    path = '/Users/Lukas/GD/lk/phd_courses/fall_2016/AME60649/project_final/my_moltemplate/';
end
fileID = fopen(strcat(path, 'nanotube.lt'), 'w');

%% calculate properties
d = 1.42; %carbon bond length
W=2*d*sqrt(3)/2; % width of hexagon

R= @(N) (W/4)./tan((2*pi)./(4*N));
Radius = R(NR);

%% write file
fprintf(fileID, '#File created by Lukas Koestler on the basis of the moltemplate example. For further information visit: https://github.com/lkostler/AME60649_project_final.\n\n\n');
fprintf(fileID, 'import "graphene.lt"\n\n');
fprintf(fileID, '# The "Graphene" unit cell defined in "graphene.lt" lies in the XY plane.\n');
fprintf(fileID, '# In the next line, we will create a new version of the graphene unit cell\n');
fprintf(fileID, '# which lies in the XZ plane, by rotating Graphene 90 degrees around the X axis:\n\n');

fprintf(fileID, 'GrapheneXZ = Graphene.rot(90,1,0,0)\n\n');


fprintf(fileID, '# ------------------ nanotube ---------------\n\n');

fprintf(fileID, '# Now use this to build a simple ("zigzag") nanotube where the long-axis of each\n');
fprintf(fileID, '# hexagon is aligned with the tube axis (along the Z direction).  If the \n');
fprintf(fileID, '# cicumference of a "zigzag" nanotube contains N hexagons, then the radius of \n');
fprintf(fileID, '# the tube, R=(W/4)/tan((2*pi)/(4*N)), where W=2*d*sqrt(3)/2, and d = the carbon\n');
fprintf(fileID, '# bond length.  If N=14 and d=1.42 Ansgroms then R=5.457193512764 Angstroms\n');
fprintf(fileID, '# In the Joly 2011 paper, the tube radii varied between 5.14 and 18.7 Angstroms.\n\n\n');


fprintf(fileID, 'nanotube = new GrapheneXZ.move(0, %d, 0)                         # %0.4f = R\n', Radius, Radius);
fprintf(fileID, '                  [%i].rot(%d,0,0,1)                             # %04f=360/%i\n', NR, 360/NR, 360/NR, NR);
fprintf(fileID, '                  [%i].rot(%d,0,0,1).move(0, 0, 2.13)            # %04f=180/%i\n', NL, 180/NR, 180/NR, NR);
fprintf(fileID, '                                                                           # 2.13= d*1.5\n');

Natoms = NR*NL*2;
end





