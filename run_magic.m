function run_magic()

% Right now, the numbers get too big to even work pass something between 50-100 as the max
% Find match needs to be more robust 

max = 50;
trips = generate_triplets(1,max,1,max);
base_trips = isolated_base_trips(trips);
[dp,sp] = find_match(base_trips)


