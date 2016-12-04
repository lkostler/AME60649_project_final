function Nwater = write_water_box(Lx, Ly, Ltube, path)
%WRITE_WATER_BOX Summary of this function goes here
%   Detailed explanation goes here

%% file
if nargin <4
    path = '/Users/Lukas/GD/lk/phd_courses/fall_2016/AME60649/project_final/my_moltemplate/';
end

fileID = fopen(strcat(path, 'water_box.lt'), 'w');


%% density calculator
%R = Ltube/10
coeff = (Lx*Ly+pi*(Ltube/10)^2) / (Lx*Ly); %correction factor because the tube is not filled by water

% rho = coeff * 0.99699 * 1e6; %in g/m^3 at about 300K
rho = 0.8 * 0.99699 * 1e6; %use smaller rho because atoms too close
M = 18.01528; %in g/mol
NA = 6.022*1e23; %number/mol
sigma = nthroot(M/(rho*NA), 3); %distance between two molecules
sigma_Angstrom = sigma*1e10; %in Angstrom


nx = floor(Lx/sigma_Angstrom);
ny = floor(Ly/sigma_Angstrom);
nz = floor(Ltube/sigma_Angstrom);

Nwater = nx*ny*nz*3; %3 atoms per water

Lx_water = (nx-1)*sigma_Angstrom;
Ly_water = (ny-1)*sigma_Angstrom;
Lz_water = (nz-1)*sigma_Angstrom;

%% write file
fprintf(fileID, '#File created by Lukas Koestler on the basis of the moltemplate example. For further information visit: https://github.com/lkostler/AME60649_project_final.\n\n\n');

fprintf(fileID, 'import "spce.lt"\n\n');

fprintf(fileID, '# --------------- water ------------------\n\n');

fprintf(fileID, '# Create box of water. Use periodic bounday conditions in z direction\n\n');

fprintf(fileID, 'wat  =  new SPCE  [%i].move(    0,    0,  %d)\n', nz, -sigma_Angstrom);
fprintf(fileID, '                  [%i].move(    0,   %d,   0)\n', ny, sigma_Angstrom);
fprintf(fileID, '                  [%i].move(   %d,    0,   0)\n', nx, sigma_Angstrom);

fprintf(fileID, '\n# Optional: Center the water box at the origin. (Not really necessary.)\n\n');

fprintf(fileID, 'wat[*][*][*].move(%d, %d, %d)\n\n', -Lx_water/2, -Ly_water/2, -(Ltube-Lz_water)/2);

fprintf(fileID, '# --------------- Note: -----------------\n');
fprintf(fileID, '# The spacing between water molecules does not matter much as long as it is\n');
fprintf(fileID, '# reasonable. (I adjusted the spacing try to insure that the waters are spread \n');
fprintf(fileID, '# uniformly throughout the box.  We do not want bubles to form if there are \n');
fprintf(fileID, '# gaps near the XY periodic boundaries.)  We will have to equilibrate it later.\n');



end

