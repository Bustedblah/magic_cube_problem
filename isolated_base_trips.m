function base_trips = isolated_base_trips(arrayToBeChecked)

% First check if any of the new array entries are in the already checked Array.

array = arrayToBeChecked;

% TODO: NEED TO ADD CODE TO THE FIRST PART (once the initial array is generated)
% Next, check if there are any repeated base pairs in the new array.

x = array;
outarray = [1,1,1];
% There has to be a more elegant way to do this in terms of vector notation
% TODO: Figure the above out ...
for i=1:size(x,1)
    if isempty(intersect(intersect(factor(x(i,1)),factor(x(i,2))),factor(x(i,3))))
        % TODO: Preallocate memory for outarray ???
        outarray=vertcat(outarray,[x(i,1),x(i,2),x(i,3)]);
    end
end

outarray(1,:)= [];

base_trips = outarray;
