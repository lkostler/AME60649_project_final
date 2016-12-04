function write_systemIn_file(Ltube, R, Ntotal, timesteps, path)
%WRITE_SYSTEMIN_FILE Summary of this function goes here
%   Detailed explanation goes here

%% open file
if nargin <4
    path = '/Users/Lukas/GD/lk/phd_courses/fall_2016/AME60649/project_final/my_moltemplate/';
end

fileID = fopen(strcat(path, 'system.in'), 'w');

%% dumpfreq
NsingleAtomsDump = 1e6;
Ndumps = ceil(NsingleAtomsDump/Ntotal);
DumpFreq = ceil(timesteps/Ndumps);

%% write file
fprintf(fileID, '#File created by Lukas Koestler on the basis of the moltemplate example. For further information visit: https://github.com/lkostler/AME60649_project_final.\n\n\n');

fprintf(fileID, 'log log.prod\n\n');

fprintf(fileID, '# units are set to real\n');
fprintf(fileID, '# -----------------Load files  -----------------\n\n');

fprintf(fileID, 'include "system.in.init" #just reads and executes the file line by line\n');
fprintf(fileID, 'read_data "system.data"\n');
fprintf(fileID, 'include "system.in.settings"\n\n\n\n');



fprintf(fileID, '# ----------------- Setup/Groups ----------------\n\n');

fprintf(fileID, '#box is specified in system.data\n\n');

fprintf(fileID, 'region	 r1  block INF INF INF INF 5    %d 	#most of the tube (except the ends 5Angstrom)\n', Ltube-5);
fprintf(fileID, 'region  r2  block INF INF INF INF INF   5 	#part with the water\n');
fprintf(fileID, 'region	 r3  block INF INF INF INF %d  INF 		#upper part\n\n', Ltube-5);

fprintf(fileID, 'neigh_modify exclude group Cgraphene Cgraphene 										#excludes all the C-C connections from the neighbor list ==> force is not computed\n');
fprintf(fileID, 'neigh_modify every 1\n\n');

fprintf(fileID, 'group mobile subtract all Cgraphene 												# A group with all atoms except the Cgraphene ones (i.e. the water molecules)\n');
fprintf(fileID, 'group gf dynamic mobile region r1 every 10 											#creates a group called gf. This group is dynamic (the atoms in it change all the time). It includes all atoms in the region r1 (middle of the tube) and is updated every 10 timesteps\n\n');

fprintf(fileID, 'group gw1 dynamic mobile region r2 every 10 										# all water in the reservoir\n');
fprintf(fileID, 'group gw2 dynamic mobile region r3 every 10 										# all water in the outlet\n');
fprintf(fileID, 'group inTube dynamic mobile region r1 every 1										# water in tube\n\n\n\n\n');





fprintf(fileID, '# ----------------- Dumps ----------------\n');
fprintf(fileID, '# N atomes = %i\n', Ntotal);
fprintf(fileID, 'restart 20000 res.3 res.4 						#writes a restart file every 20000 timesteps. It switches between the two files periodically.\n');
fprintf(fileID, 'dump            2 all xyz %i product.xyz 		#ID=2, all atoms, xyz file, every 20000 timesteps, filename\n', DumpFreq);
fprintf(fileID, 'dump_modify 2 element C O H 					#ID=2 (so modify the dump above), writes the element types s.t. it is a propper .xyz file\n');
fprintf(fileID, 'thermo_style    custom step temp pe etotal press vol epair #ebond eangle edihed		#print thermodynamic data. style=custom, pe=total potential energy, etotal = pe+ke, epair = pairwise energy (evdwl + ecoul + elong)\n');
fprintf(fileID, 'thermo          10  																# time interval for printing out "thermo" data\n\n');

fprintf(fileID, 'timestep 1.0																		#1.0 femtoseconds\n\n\n');


fprintf(fileID, '# ----------------- NVT Equilibration ----------------\n');
fprintf(fileID, 'fix   fxnvt mobile nvt temp 300.0 300.0 100.0 tchain 1								#ID=fxnvt, group-ID=mobile=water, nvt=canonical, Tstart=300K, Tstop=300K, takes about Tdamp=100 steps to get from 300K to 300K,  tchain (just use 1)\n');
fprintf(fileID, 'fix fg1 mobile gravity 0.1 vector 0 0 1												#ID=fg1, group-ID=mobile=water, magnitude=0.1(force per mass) (this actually adds an acceleration) (Kcal/(grams*Angstrom))\n\n');

fprintf(fileID, 'run  10000																			#Xingfei had 50,000 here\n');
fprintf(fileID, 'unfix fxnvt																			#Delete the thermostate\n');



fprintf(fileID, '# ----------------- NVT Production ----------------\n');
fprintf(fileID, '#Use a Thermostat only for reservoir and outlet, not tube\n');
fprintf(fileID, 'fix fxLAN1 gw1 langevin 300.0 300.0 100 16100801									#ID=fxLAN1, water in reservoir, keeps temp at 300K, 100 damping, seed\n');
fprintf(fileID, 'fix fxLAN2 gw2 langevin 300.0 300.0 100 16100802									#ID=fxLAN1, water in outlet, keeps temp at 300K, 100 damping, seed\n');
fprintf(fileID, 'fix fg1 mobile gravity 0.1 vector 0 0 1												#why again? probably unnecessary\n');
fprintf(fileID, 'fix fxNVE mobile nve  																#(<--needed by fix langevin) to do the actual time integration\n');
fprintf(fileID, 'compute c1 mobile chunk/atom bin/1d z lower 1.0										#starts at the lower end of the box and separates the whole volume into chunks of length 1. Only for mobile=water. ID = c1\n');
fprintf(fileID, 'compute cCyl1 mobile chunk/atom bin/cylinder z lower 1 0 0 0 %d	100					# cylinder along z, starting at the lower end, deltaz = 1, x=y=0 of the cylinder axis, rmin = 0, rmax = R, nbin=100 --> \n', R);
fprintf(fileID, 'compute c2 mobile property/atom vx vy vz fx fy fz									#stores vx vy vz etc. in c2\n');
fprintf(fileID, 'compute cCyl2 mobile property/atom vx vy vz fx fy fz	\n');
fprintf(fileID, 'fix fd1 mobile ave/chunk 1 1000 1000 c1 c_c2[1] c_c2[2] c_c2[3] c_c2[4] c_c2[5] c_c2[6] file VF #writes the chunk avergaes (over 1000 timesteps every 1000 timesteps) to a file\n');
fprintf(fileID, 'fix fd2 mobile ave/chunk 1 1000 1000 cCyl1 c_cCyl2[1] c_cCyl2[2] c_cCyl2[3] c_cCyl2[4] c_cCyl2[5] c_cCyl2[6] file RadialVF #writes the chunk avergaes (over 1000 timesteps every 1000 timesteps) to a file\n\n');


fprintf(fileID, 'run %i\n\n\n', timesteps);


fprintf(fileID, '#  ----------------- Write data ----------------\n');
fprintf(fileID, 'write_data data.prod\n');




end

