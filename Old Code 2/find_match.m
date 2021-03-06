function [double_pair, single_pair] = find_match(data_array)

fprintf('\nStarting find match.  Press Enter: \n\n')
pause;
tic

addpath(strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/VariablePrecisionIntegers/VariablePrecisionIntegers"));

array = vpi(sortrows(data_array,2));
len = size(array,1);

% TODO: Code to be smarter about the multiplication will have to go here.

% This is a cludge to get the center values all the same

% Line below is old code. Stuff below has better factorization.
mfact = lcm(vpi(array(:,2)));

mult_temp = mfact./vpi(array(:,2));

% OLD CODE: Changed to allow for vpi
% large_array = array.*(mult_temp.*ones(1,3));
large_array = array;

for i=1:size(array,1)
    large_array(i,:) = vpi(array(i,:))*mult_temp(i);
end

toc
fprintf('\nLarge Array generated.  Press Enter: \n\n')
pause;
tic

% Following Code attempts to find the 5 trip configs and 4 trip configs
center = vpi(large_array(1,2));
total_sum = 3*(center)^2;

% compare_array = ones(size(large_array,1),size(large_array,1),size(large_array,1));
list = vertcat(large_array(:,1),large_array(:,3));

% Jeez ... there's surely a better way to do this. Ugh.

% NOTE: This is a better way to do this, but "binary operator '*' not implemented for 'uint64 matrix' by 'matrix' operations"
% two_parter = total_sum-list*ones(1,size(list,1)).^2+list'.*ones(size(list,1),size(list,1)).^2);
% The following is crappier inefficient code to do the above

rows_array = list;
cols_array = ones(size(list,1),1)*list(1);
for loop = 1:size(list,1)-1
    rows_array = horzcat(rows_array,list);
    cols_array = horzcat(cols_array,ones(size(list,1),1)*list(loop+1));
end

toc
fprintf('\nRows & cols array generated.  Press Enter to continue: \n\n')
pause;
tic

two_parter = total_sum*ones(size(list,1),size(list,1))-rows_array.^2-cols_array.^2;

toc
fprintf('\nTwo_parter_generated. Press Enter to continue: \n\n')
pause;
tic

% Would have been better to delete the center column in large_array
% list = horzcat(large_array(:,1),large_array(:,3));

double_pair = zeros(3,3);
single_pair = zeros(3,3);
trip_index = [0,0,0];
% antitrip_index = [0,0,0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: Wildly inefficient search
% TODO: IMPROVE THIS !!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

third_value_list = zeros(size(list,1),size(list,1));

for j=1:size(list)
    temp = list(j)^2;
    if (sum(sum(temp==two_parter))>0)
        third_value_list = third_value_list + (temp==two_parter);
    end
end

toc
fprintf('\Third value list complete. Press Enter to Continue: \n\n')
pause;
tic

if(~sum(sum(iszero(third_value_list)))==size(third_value_list,1)^2)
    % NOTE: Intersect doesn't work in vpi 
    % third_value_list = intersect(list.^2,two_parter);
    
    for q=1:size(list,1)
         if(trip_index==[0,0,0])
            [row,col] = find(list(q)^2==two_parter);
            
            if (size(row,1)>1)
                fprintf('\nThere is more than one trip for a given third value!!! Investigate & update code!!!!\n\n')
            end
            
            trip_index=[find(q=list),row,col];
            
        else
            trip_index = vertcat(trip_index,[find(q=list),row,col]);
        end     
    end
    % Check to see if they are doubles or single finds
   
    for p=1:size(trip_index,1)
        anti_1 = ((trip_index(p,1)^2-center^2)*-1+center^2)^.5;
        anti_2 = ((trip_index(p,2)^2-center^2)*-1+center^2)^.5;
        anti_3 = ((trip_index(p,3)^2-center^2)*-1+center^2)^.5;
        
        if(anti_1^2+anti_2^2+anti_3^2 == 3*center^2)
            if(double_pair==zeros(3,3))
                double_pair(1,1) = trip_index(p,1);
                double_pair(1,2) = trip_index(p,2);
                double_pair(1,3) = trip_index(p,3);
                double_pair(2,1) = 0;
                double_pair(2,2) = center;
                double_pair(2,3) = 0;
                double_pair(3,1) = anti_3;
                double_pair(3,2) = anti_2;
                double_pair(3,3) = anti_1; 
            else
                temp_pair = zeros(3,3);
                temp_pair(1,1) = trip_index(p,1);
                temp_pair(1,2) = trip_index(p,2);
                temp_pair(1,3) = trip_index(p,3);
                temp_pair(2,1) = 0;
                temp_pair(2,2) = center;
                temp_pair(2,3) = 0;
                temp_pair(3,1) = anti_3;
                temp_pair(3,2) = anti_2;
                temp_pair(3,3) = anti_1; 
                double_pair = vertcat(double_pair,temp_pair);
            end
        else
            if(single_pair==zeros(3,3))
                single_pair(1,1) = trip_index(p,1);
                single_pair(1,2) = trip_index(p,2);
                single_pair(1,3) = trip_index(p,3);
                single_pair(2,1) = 0;
                single_pair(2,2) = center;
                single_pair(2,3) = 0;
                single_pair(3,1) = anti_3;
                single_pair(3,2) = anti_2;
                single_pair(3,3) = anti_1; 
            else
                temp_pair = zeros(3,3);
                temp_pair(1,1) = trip_index(p,1);
                temp_pair(1,2) = trip_index(p,2);
                temp_pair(1,3) = trip_index(p,3);
                temp_pair(2,1) = 0;
                temp_pair(2,2) = center;
                temp_pair(2,3) = 0;
                temp_pair(3,1) = -1;
                temp_pair(3,2) = -1;
                temp_pair(3,3) = -1; 
                single_pair = vertcat(single_pair,temp_pair);
            end
        end
    end    
else
    fprintf('\nNo trips yet .... (sigh) ... \n\n')
end

toc
