function work_the_cube()

% addpath('/data');
addpath(strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data"));
addpath(strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/VariablePrecisionIntegers/VariablePrecisionIntegers"));

dataFile = strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data/base_triplets.binsev");

fprintf('\nLoad the Crunched Triplet Array: ');
load("-v7",dataFile, "base_triplets");

base_triplets;

