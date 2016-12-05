function write_submit_file(name, path)
%WRITE_SUBMIT_FILE Summary of this function goes here
%   Detailed explanation goes here

fileID = fopen(strcat(path, 'submit.sh'), 'w');

fprintf(fileID, '#!/bin/csh\n');
fprintf(fileID, '#$ -N %s\n', name);
fprintf(fileID, '#$ -pe smp 2\n');
fprintf(fileID, '#$ -q long\n\n');

fprintf(fileID, 'module load  lammps\n');
fprintf(fileID, 'mpiexec -n $NSLOTS lmp_mpi  < system.in\n');

end

