function [double_pair, single_pair] = find_match(data_array)

array = sortrows(data_array,2);
len = size(array,1);

% Code to be smarter about the multiplication will have to go here.
% This is a cludge to get the center values all the same

mfact = uint64(prod(array(:,2)));
mult_temp = unint64(mfact./array(:,2));
large_array = uint64(array.*(mult_temp*ones(1,3)));

% Following Code attempts to find the 5 trip configs and 4 trip configs
center = 3*(large_array(1,2))^2;

% compare_array = ones(size(large_array,1),size(large_array,1),size(large_array,1));

list = vertcat(large_array(:,1),large_array(:,3));

% Jeez ... there's surely a better way to do this.  Ugh.
two_parter = center^2-((list.*ones(size(list,1),size(list,1)))'.^2+list'.*ones(size(list,1),size(list,1)).^2);

% Would have been better to delete the center column in large_array
% list = horzcat(large_array(:,1),large_array(:,3));

double_pair = zeros(3,3);
single_pair = zeros(3,3);
trip_index = [0,0,0];
% antitrip_index = [0,0,0];

if(~isempty(intersect(list.^2,two_parter)))
    third_value_list = intersect(list.^2,two_parter);
    for q=1:size(third_value_list,1)
         if(trip_index==[0,0,0])
            [row,col] = find(list(k)^2==two_parter);
            
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
end
