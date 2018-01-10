function work_the_cube(counter)

% addpath('/data');
addpath(strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data"));
addpath(strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/VariablePrecisionIntegers/VariablePrecisionIntegers"));

dataFile = strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data/base_triplets.binsev");
dataFile1 = strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data/center_search_data.binsev");
dataFile2 = strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data/center_ab_data.binsev");
dataFile2 = strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data/d1_d2_d3.binsev");                

fprintf('\nLoad the Crunched Triplet Array: ');
load("-v7",dataFile, "base_triplets");
load("-v7",dataFile, "center_search_data");
load("-v7",dataFile, "center_ab_data");
load("-v7",dataFile, "d1_d2_d3");

center_search_data = vpi([0,0,0,0]);
center_ab_data = vpi([0,0,0,0]);

triplets = sortrows(base_triplets,2);
center_triplets = vpi(triplets(:,2));
end_of_list = center_triplets(size(center_triplets,1));

% Set Up the Space
d1 = vpi(center_triplets(size(center_triplets,1)-3));
d2 = vpi(center_triplets(size(center_triplets,1)-2));
d3 = vpi(center_triplets(size(center_triplets,1)-1));
second_to_last_in_list = d3;

% d1 = d1_d2_d3(1);
% d2 = d1_d2_d3(2);
% d3 = d1_d2_d3(3);

d = vpi(0);

write_counter = 0;
write_limit = 10;

%counter = 0;
central_num = vpi(0);
skip = 0;

while counter < 100000 %size(center_triplets,1)-1 %vpi(10^10)
    tic
    % Increment the center variable.
    counter = counter + 1;
    if (counter < size(center_triplets,1)-1)
        central_num = vpi(center_triplets(counter));
        if (vpi(center_triplets(counter)) == vpi(center_triplets(counter+1)))
            skip = 1;
        end;
    else
        if (vpi(d3+d2-d1) == central_num)
            skip = 1;
        end;
        central_num = vpi(d3+d2-d1);
        d1 = d2;
        d2 = d3;
        d3 = central_num;
    end;
    
    if(skip == 0)
        % Identify all of the factors (using the center sequence)
        row_selected = mod(central_num,center_triplets);
        z = row_selected == 0;
        num_rows = sum(z);
        q = sortrows(horzcat(z,z,z).*triplets,2);
        q_final = q((size(q)-num_rows+1):size(q),:);
            
        if size(q_final,1)>5
            printf('\nFound with >6 pairs: ');
            disp(central_num);
            printf('Number of pairs\n');
            disp(q_final);
            
            write_counter = write_counter + 1;
               
            a1 = q_final(1:size(q_final,1),1).*reshape(central_num./(q_final(1:size(q_final,1),2)),[size(q_final(1:size(q_final,1),1),1),size(q_final(1:size(q_final,1),1),2)]);
            b1 = vpi(central_num*ones(size(q_final,1),1)); 
            c1 = q_final(1:size(q_final,1),3).*reshape(central_num./(q_final(1:size(q_final,1),2)),[size(q_final(1:size(q_final,1),3),1),size(q_final(1:size(q_final,1),3),2)]);
            
            q_final_scaled = horzcat(a1,b1,c1);
                              
            %%%%%%%%%%%%%%%%% CENTER WORK %%%%%%%%%%%%%%%%%
            delta1 = vpi(q_final_scaled(1:size(q_final_scaled,1),2)).^2-vpi(q_final_scaled(1:size(q_final_scaled,1),1)).^2;
            
            delta_row = delta1*ones(1,size(delta1,1));
            delta_col = ones(size(delta1,1),1)*reshape(delta1,[1,size(delta1,1)]);
            
            abs_a_minus_b = abs(delta_row-delta_col).*vpi(tril(ones(size(delta_col,1),size(delta_col,1)),-1));
            abs_a_plus_b = abs(delta_row+delta_col).*vpi(tril(ones(size(delta_col,1),size(delta_col,1)),-1));

            [ind_m_i, ind_m_j, u_abs_a_minus_b] = find(reshape(abs_a_minus_b,[size(abs_a_minus_b,1)*size(abs_a_minus_b,1),1]));
            [ind_p_i, ind_p_j, u_abs_a_plus_b] = find(reshape(abs_a_plus_b,[size(abs_a_plus_b,1)*size(abs_a_plus_b,1),1]));
            
            ab_minus_match = abs(delta1*ones(1,size(u_abs_a_minus_b,1)).-ones(size(delta1,1),1)*reshape(u_abs_a_minus_b,[1,size(u_abs_a_minus_b,1)]));
            ab_plus_match = abs(delta1*ones(1,size(u_abs_a_plus_b,1)).-ones(size(delta1,1),1)*reshape(u_abs_a_plus_b,[1,size(u_abs_a_plus_b,1)]));
            
            %%% These have too many values ... WE WANT TO FIND THE ZERO's HERE!!!! %%%
            [ind_m_row, ind_m_col, flag_m] = find((ab_minus_match==0).*ab_minus_match);
            [ind_p_row, ind_p_col, flag_p] = find((ab_plus_match==0).*ab_plus_match);
            
            ab_plus = vpi(0);
            ab_minus = vpi(0);
            ab_plus_out = vpi(0);
            ab_minus_out = vpi(0);
            match_found = 0;
                           
            if (isempty(flag_m) == 0)
                ab_minus = diag(ab_minus_match(ind_m_row,ind_m_col))
                match_found = 1;
                write_counter = write_limit;
                printf('We found a A+B Match for');
                disp(central_num);
                printf('!!!!!');
            end;    
            
            if (isempty(flag_p) == 0)    
                ab_plus = diag(ab_plus_match(ind_p_row,ind_p_col))
                match_found = 1;
                write_counter = write_limit;
                printf('We found a A+B Match for');
                disp(central_num);
                printf('!!!!!');
            end; 
            
            if write_counter >= write_limit;          
                center_search_data_temp = horzcat(q_final_scaled,ones(size(q_final_scaled,1),1).*match_found);
                center_search_data = vertcat(center_search_data,center_search_data_temp);
                save("-mat7-binary", dataFile1, "center_search_data");
                d1_d2_d3 = [d1;d2;d3];
                save("-mat7-binary", dataFile1, "d1_d2_d3");
                write_counter = 0;
            end;
            
            if and((isempty(flag_m) == 0),(isempty(flag_p) == 0))
                for list_cnt=1:max(size(ab_plus,1),ab_plus,1)
                    if list_cnt>size(ab_plus,1)
                        ab_plus_out=0;
                    else
                        ab_plus_out = ab_plus(list_cnt)
                    end;
                    if list>size(ab_minus,1)
                        ab_minus=0;
                    else
                        ab_minus_out = ab_minus(list_cnt)
                    end;
                    center_ab_data_temp = central_num, num_rows, ab_plus_out, ab_minus_out
                    center_ab_data = vertcat(center_ab_data,center_ab_data_temp);
                end;
                match_found = 0;
                save("-mat7-binary", dataFile2, "center_ab_data");
            end;   
        end;    
    end;
    skip = 0; 
end;
   
printf('***************************** THE END? ****************************/n');