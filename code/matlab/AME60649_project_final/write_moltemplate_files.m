% Generate all the different moltemplate files for my tests

clear all;
close all;

folderpath = '/Users/Lukas/GD/lk/phd_courses/fall_2016/AME60649/project_final/my_moltemplate/';
base_string = 'beta';

flag_moltemplate = true;
flag_check = true;
flag_plot3d = true;

timesteps = 1e5;

% NNR = [10, 12, 14, 16, 20, 25, 50, 100];
% NNR = [10, 12, 14, 16, 20];
NNR = [100];
%% parameters
d = 1.42; %carbon bond length
W=2*d*sqrt(3)/2; % width of hexagon
w = 1.5*d; %width of hexagon rows


%% Formulas: 
%L = 10R
R = @(NR) (W/4)./tan((2*pi)./(4*NR));
NL = @(NR) ceil(10*R(NR) / (1.5*d))+1;
L = @(NR) (NL(NR)-1)*1.5*d;
Ny = @(NR) ceil(  8*R(NR)/(W) + 1  ) + mod(ceil(  8*R(NR)/W + 1 ), 2); %Ny should always be even
Lx = @(NR) (Ny(NR)-1)*W;
Ly = @(NR) (Ny(NR))*w;
dy = 2*0.355;


% NNR = [10, 12, 14, 16, 20, 25, 50, 100];
% NNR = [10, 12, 14, 16, 20];


NNwater = nan(size(NNR));
NNwalls = nan(size(NNR));
NNtube = nan(size(NNR));

foldernames = cell(size(NNR));

%% write files
masterID = fopen(strcat(folderpath, 'masterFile.txt'), 'w');
fprintf(masterID, 'Experiments:\nID\tNR\tNL\tNy\tR\t\tL\t\tLx\t\tLy\n');

flag = true;
fprintf('Writing Moltemplate files     : ');
for i = 1:length(NNR)
    fprintf('.');
    NR = NNR(i);
    foldername = sprintf('%s%02i_NR_%04i_NL_%04i',base_string,  i, NR, NL(NR));
    foldernames{i} = foldername;
    
    %delte existing
    if exist(strcat(folderpath, foldername), 'dir')
        if flag
            warning('Folder %s already exists. Will be deleted', strcat(folderpath, foldername));
            flag = false;
        end
        rmdir(strcat(folderpath, foldername), 's');
    end
    
    %master file
    fprintf(masterID, '%02i\t%04i\t%04i\t%04i\t%d\t%d\t%d\t%d\n', i, NR, NL(NR), Ny(NR), R(NR), L(NR), Lx(NR), Ly(NR));
    
    %folder
    mkdir(strcat(folderpath, foldername));
    
    path_loc = strcat(folderpath, foldername, '/');
    
    %walls
    NNwalls(i) = write_graphene_wall_file(Ny(NR), R(NR), L(NR), path_loc);
    
    %tube
    NNtube(i) = write_nanotube_file(NR, NL(NR), path_loc);
    
    %water
    NNwater(i) = write_water_box(Lx(NR), Ly(NR), L(NR), path_loc);
    
    %system.lt
    write_system_file(L(NR), Lx(NR), Ly(NR), path_loc)
    
end


fprintf(masterID, '\n\n');
fprintf(masterID, 'ID:\tUnique Identification Number\n');
fprintf(masterID, 'NR:\tNumber of unit cells in the Radius of the nanotube\n');
fprintf(masterID, 'NL:\tNumber of unit cells in the Length of the nanotube\n');
fprintf(masterID, 'Ny:\tNumber of unit cells in the y-direction of the grephene sheet. Nx = Ny-1\n');
fprintf(masterID, 'R:\tRadius of the Nanotube\n');
fprintf(masterID, 'L:\tLength of the Nanotube. z is in [-1/2L, 1.5L] and the nanotube starts at z=0 and goes to z = L.\n');
fprintf(masterID, 'Lx:\tLength of the graphene sheets (and simulation box) in x-direction\n');
fprintf(masterID, 'Ly:\tLength of the graphene sheets (and simulation box) in y-direction\n');


% fprintf('Writing Moltemplate files     : ');
fprintf('\n');
fprintf('Execute Moltemplate in folders: ');
%% execute moltemplater
if flag_moltemplate
    for i = 1:length(NNR)
        fprintf('.');
        NR = NNR(i);
        
        foldername = sprintf('%s%02i_NR_%04i_NL_%04i',base_string,  i, NR, NL(NR));
        path_loc = strcat(folderpath, foldername);
        %the shell (system) command must be one big command
        command = ['cd ', path_loc, ';'];
        %use the full path of the moltemplate.sh script because the PATH
        %variable of matlab is different
        
        %the & command makes matlab not wait for the execution of the shell
        %command to finish
        command = strcat(command, ...
            '/Users/Lukas/GD/lk/phd_courses/fall_2016/AME60649/project_final/moltemplate/moltemplate/src/moltemplate.sh system.lt');
        [~, ~] = system(command);
        
        %overwrite the system.in file
        write_systemIn_file(L(NR), R(NR), NNwalls(i) + NNtube(i) + NNwater(i), timesteps, strcat(path_loc, '/'))
    end
end
fprintf('\n');


%% 

if flag_check
%     fprintf('Writing Moltemplate files     : ');
    fprintf('Checking Geometry             : ');
    for i = 1:length(NNR)
        fprintf('.');
        
        NR = NNR(i);
        
        foldername = sprintf('%s%02i_NR_%04i_NL_%04i',base_string,  i, NR, NL(NR));
        path_loc = strcat(folderpath, foldername);
        
        %load data
        data = importdata(strcat(path_loc, '/system.data'),' ', 24);
        data = data.data;
        indc = data(:,3)==1;
        X = data(indc,5);
        Y = data(indc,6);
        
        %plot
        [X,Y] = map_coordinates(X, Y, Lx(NR), Ly(NR), true);
        
        %% 3d plot
        if flag_plot3d
            figure
            plot3(X, Y, data(indc,7), '+');
            axis equal;
            hold on
            plotcube([Lx(NR), Ly(NR), 2*L(NR)], [-0.5*Lx(NR), -0.5*Ly(NR), -0.5*L(NR)], 0, [1 0 0])
        end
    end
end
fprintf('\n');

%% clean directory and create additonal files
for i = 1:length(NNR)
    NR = NNR(i);
    
    foldername = sprintf('%s%02i_NR_%04i_NL_%04i',base_string,  i, NR, NL(NR));
    path_loc = strcat(folderpath, foldername);
    
    
    %remove files
    command = ['cd ', path_loc, ';'];
    command = strcat(command, 'rm -r output_ttree');
    [~, ~] = system(command);
    
    command = ['cd ', path_loc, ';'];
    command = strcat(command, 'rm graphene_walls.lt');
    [~, ~] = system(command);
    
    command = ['cd ', path_loc, ';'];
    command = strcat(command, 'rm nanotube.lt');
    [~, ~] = system(command);
    
    command = ['cd ', path_loc, ';'];
    command = strcat(command, 'rm system.lt');
    [~, ~] = system(command);
    
    command = ['cd ', path_loc, ';'];
    command = strcat(command, 'rm water_box.lt');
    [~, ~] = system(command);
    
    
    %overwrite other lammps files
    write_systemInInit_file(strcat(path_loc, '/'));
    write_systemInSettings_file(strcat(path_loc, '/'));
    write_submit_file(foldername, strcat(path_loc, '/'));
end




%% master submit file
writesubmitMaster_file(folderpath, foldernames);
