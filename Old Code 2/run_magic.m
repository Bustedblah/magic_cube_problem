function run_magic()

addpath("/VariablePrecisionIntegers");

% Right now, the numbers get too big to even work pass something between 50-100 as the max
% Find match needs to be more robust 

max = 100;
tic
trips = generate_triplets(1,max,1,max);
toc
base_trips = isolated_base_trips(trips);
toc
[dp,sp] = find_match(base_trips)
toc

% 