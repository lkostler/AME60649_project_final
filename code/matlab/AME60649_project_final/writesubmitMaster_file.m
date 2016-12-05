function writesubmitMaster_file(path, foldernames)
%WRITESUBMITMASTER_FILE Summary of this function goes here
%   Detailed explanation goes here

fileID = fopen(strcat(path, 'submitMaster.sh'), 'w');

fprintf(fileID, '#!/bin/csh\n');
for i = 1:length(foldernames)
    fprintf(fileID, 'cd %s \n', foldernames{i});
    fprintf(fileID, 'qsub submit.sh \n');
    fprintf(fileID, 'cd .. \n\n');
    
end

