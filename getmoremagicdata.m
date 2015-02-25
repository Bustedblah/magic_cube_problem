function = getmoremagicdata()

% Clear all the mess from previous runs
clear all
close all
clc

pkg load all
fprintf('\nOKAY: lets go crunch some numbers\n\n');

load("-v7",magic_data_file,"magic_data")
    fprintf('\n     Successful Load from squaredTriplets.binsev');
load("-v7",runs_file,"runs")
    fprintf('\n     Successful Load from runs.binsev');

fprintf('\nJust as an FYI: Here are the previous completed runs:\n\n');
for i=1:size(runs,1)
    fprintf('Min: %d, Max: %d\n',runs(i,1),runs(i,2));
end
    
fprintf('\n\n');

a = input ("\n\nPick the value you want to start from:")
b = input ("\n\nPick the value you want to end at from:")

fprintf('OK - Standby, Crunching Numbers ...\n\n');

new_magic_data = generate_triplets(a,b);

% Write to file % 
pathArrayData = strcat(pwd, "/data/");
magic_data_file = strcat(pathArrayData,'/squaredTriplets.binsev')
runs_file = strcat(pathArrayData,'/runs.binsev')


old_magic_data = magic_data;

magic_data = vertcat(old_magic_data,new_magic_data);

fprintf('\n\nSaving Data to File: \n')
    save("-mat7-binary", magic_data_file, "magic_data")
    fprintf('\n     Successful Save!!! to squaredTriplets..binsev');
    
    temp_runs = runs;
    present_range = [a b];
    runs = vertcat(runs,present_range);
    
    save("-mat7-binary", runs_file, "runs")
    fprintf('\n     Successful Save!!! to runs.binsev\n\n'); 
    
fprintf('\n\nOK - Donezo!\n\n') 