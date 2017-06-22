function perm_array = generate_triplets(min_row_size, max_row_size, min_col_size, max_col_size)

% addpath('/data');
addpath(strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data"));
addpath(strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/VariablePrecisionIntegers/VariablePrecisionIntegers"));

tic
max_col = max_col_size;
max_row = max_row_size;
min_col = min_col_size;
min_row = min_row_size;

perm_array = [1, 1, 1];

col = uint32(min_col):1:uint32(max_col);
row = uint32(min_row):1:uint32(max_row);

%col = vpi(min_col):1:vpi(max_col);
%row = vpi(min_row):1:vpi(max_row);

%col = vpi(col.^2);
%row = vpi(row.^2);

col = (col.^2);
row = (row.^2);

arr_low = col'*ones(1,max_col);
%arr_low = col'*ones(1,max_col-min_col+1); % EXPERIMENT IS

%arr_low = cross(col',ones(1,max_col));

arr_high = ones(max_row,1)*row; 
% arr_high = ones(max_row-min_row+1,1)*row; % EXPERIMENT IS

array = zeros(max_row,max_col);
array = zeros(max_row-min_row+1,max_col-min_col+1); % EXPERIMENT IS

array((arr_low<arr_high))=1;

% I think i needed this before ... not sure why.  Hold on to this line in case below starts acting funny.
% array_out = (rem(array.*(double((((arr_high-arr_low)./2+arr_low).^.5))),1)==0).*array;

array_out = (rem(array.*(((((arr_high-arr_low)./2+arr_low).^.5))),1)==0).*array;

[a,b] = find(array_out==1);

adding_arr = [a,((b.^2-a.^2)./2+a.^2).^.5,b];
perm_array = vertcat(perm_array,adding_arr);
triplet_array = perm_array;

dataFile = strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data/triplet_array.binsev");

save("-mat7-binary", dataFile, "triplet_array");

% This is what we were using before, but there's a better way.
% arr_low = col'*ones(1,max_col);
% arr_high = ones(max_col,1)*row;
% array = zeros(max_row,max_col);
% array((arr_low<arr_high))=1;
% array_out = (rem(array.*(double((((arr_high.^2-arr_low.^2)./2+arr_low.^2).^.5))),1)==0).*array;
% [a,b] = find(array_out==1);
% adding_arr = [a,((b.^2-a.^2)./2+a.^2).^.5,b];
% perm_array = vertcat(perm_array,adding_arr);

% Uncomment this for display 
% for i=1:size(perm_array,1)
%    fprintf('| %d, %d, %d | \n\n',perm_array(i,1),perm_array(i,2),perm_array(i,3))
% end

fprintf('\nTime To Complete Triplet Generation: ')
toc

fprintf('\n\nREACHED THE END!!!:\n\n');
