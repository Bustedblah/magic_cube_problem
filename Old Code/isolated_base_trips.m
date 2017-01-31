function base_trips = isolated_base_trips(arrayToBeChecked,arrayAlreadyChecked)

% First check if any of the new array entries are in the already checked Array.

array = arrayToBeChecked;
% TODO: NEED TO ADD CODE TO THE FIRST PART (once the initial array is generated)

% Next, check if there are any repeated base pairs in the new array.


%x = sortrows(x,1);
%arr = ones(size(x,1),size(x,1),size(x,1));
%arr(:,:,1)=x(:,1)*ones(1,size(x,1)).*tril(ones(size(x,1),size(x,1)),-1);
%arr(:,:,2)=x(:,2)*ones(1,size(x,1)).*tril(ones(size(x,1),size(x,1)),-1);
%arr(:,:,3)=x(:,3)*ones(1,size(x,1)).*tril(ones(size(x,1),size(x,1)),-1);
%check = zeros(size(x,1),3);


x = data_array;
outarray = [1,1,1];
% There has to be a more elegant way to do this in terms of vector notation
% TODO: Figure the above out ...
for i=1:size(x,1)
    if isempty(intersect(intersect(factor(x(i,1)),factor(x(i,2))),factor(x(i,3))))
        % TODO: Preallocate memory for outarray ???
        outarray=vertcat(outarray,[x(i,1),x(i,2),x(i,3)]);
    end
end

base_trips = outarray;