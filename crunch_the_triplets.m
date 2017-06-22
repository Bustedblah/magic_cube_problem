function crunch_the_triplets(step_size,matrix_cube_size)

% addpath('/data');
addpath(strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data"));
addpath(strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/VariablePrecisionIntegers/VariablePrecisionIntegers"));

% step_size = 1000;
% matrix_cube_size = 1000;

perm_array = [1, 1, 1];
adding_array = [1, 1, 1];
low_row = 1;
high_col = 1;

tic
for outter_step=1:step_size
    for inner_step=1:outter_step
        %tic
        low_row = low_row;
        high_col = high_col;
        adding_array = generate_all_triplets(low_row+matrix_cube_size*(outter_step-1),low_row+matrix_cube_size*(outter_step),high_col+matrix_cube_size*(inner_step-1),high_col+matrix_cube_size*(inner_step));
        perm_array = vertcat(perm_array,adding_array);
        %fprintf('\nTime To Complete Triplet Generation Run#: ');
        %toc
    end;    
end;
toc 

triplet_array = perm_array;

%fprintf(perm_array);
%fprintf('\n\nREACHED THE END OF GENERATING TRIPLETS!!!:\n\n');

dataFile = strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data/triplet_array.binsev");
save("-mat7-binary", dataFile, "triplet_array");

base_triplets = isolated_base_trips(triplet_array);

dataFile = strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data/base_triplets.binsev");
save("-mat7-binary", dataFile, "base_triplets");


