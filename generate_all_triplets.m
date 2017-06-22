function adding_arr = generate_all_triplets(min_row_size, max_row_size, min_col_size, max_col_size)
% Note: The row size must be the same as the col size, and the row values must be greater than the col values.

% addpath('/data');
addpath(strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data"));
addpath(strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/VariablePrecisionIntegers/VariablePrecisionIntegers"));

%tic
max_col = max_col_size;
max_row = max_row_size;
min_col = min_col_size;
min_row = min_row_size;

perm_array = [1, 1, 1];

col = uint64(min_col):1:uint64(max_col);
row = uint64(min_row):1:uint64(max_row);

col = (col.^2);
row = (row.^2);

arr_low = col'*ones(1,max_col-min_col+1); 
arr_high = ones(max_row-min_row+1,1)*row; 

array = zeros(max_row-min_row+1,max_col-min_col+1);

array((arr_low<arr_high))=1;

array_out = (rem(array.*(((((arr_high-arr_low)./2+arr_low).^.5))),1)==0).*array;

[a,b] = find(array_out==1);

adding_arr = [(min_col+a-1),(((min_row+b-1).^2-(min_col+a-1).^2)./2+(min_col+a-1).^2).^.5,min_row+b-1];

%fprintf('\nTime To Complete Triplet Generation: ')
%toc

%fprintf('\n\nREACHED THE END!!!:\n\n');
