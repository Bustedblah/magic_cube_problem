function perm_array = generate_triplets(min_arr_size, max_arr_size)

tic
max_col = max_arr_size;
max_row = max_arr_size;
min_col = min_arr_size;
min_row = min_arr_size;

perm_array = [1, 1, 1];

col = uint32(min_col):1:uint32(max_col);
row = uint32(min_row):1:uint32(max_row);

col = col.^2;
row = row.^2;

arr_low = col'*ones(1,max_col);
arr_high = ones(max_col,1)*row;
array = zeros(max_row,max_col);
array((arr_low<arr_high))=1;

% I think i needed this before ... not sure why.  Hold on to this line in case below starts acting funny.
%array_out = (rem(array.*(double((((arr_high-arr_low)./2+arr_low).^.5))),1)==0).*array;

array_out = (rem(array.*(((((arr_high-arr_low)./2+arr_low).^.5))),1)==0).*array;


[a,b] = find(array_out==1);

adding_arr = [a,((b.^2-a.^2)./2+a.^2).^.5,b];
perm_array = vertcat(perm_array,adding_arr);
toc



% This is what we were using before, but there's a better way.
% arr_low = col'*ones(1,max_col);
% arr_high = ones(max_col,1)*row;
% a5rray = zeros(max_row,max_col);
% array((arr_low<arr_high))=1;
% array_out = (rem(array.*(double((((arr_high.^2-arr_low.^2)./2+arr_low.^2).^.5))),1)==0).*array;
% [a,b] = find(array_out==1);
% adding_arr = [a,((b.^2-a.^2)./2+a.^2).^.5,b];
% perm_array = vertcat(perm_array,adding_arr);

 
for i=1:size(perm_array,1)
    fprintf('| %d, %d, %d | \n\n',perm_array(i,1),perm_array(i,2),perm_array(i,3))
end
toc    

fprintf('REACHED THE END!!!:\n\n');
