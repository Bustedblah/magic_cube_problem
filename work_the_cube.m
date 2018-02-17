function work_the_cube(start_type)

%
% If start_type = 1, then start from the very beginning to populate the dataset
% If start_type = 0, then assume that we start from where we left off in the search ... 
%

addpath(strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data"));
addpath(strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/VariablePrecisionIntegers/VariablePrecisionIntegers"));

dataFile = strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data/base_triplets.binsev");
dataFile1 = strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data/center_search_data.binsev");
dataFile2 = strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data/center_ab_data.binsev");
dataFile3 = strrep(pwd, "/magic_cube_problem", "/magic_cube_problem/data/d1_d2_d3_cnt.binsev");                

fprintf('\nLoad the Crunched Triplet Array: ');
load("-v7",dataFile, "base_triplets");

%%%%%%%%%%%%%%%%%% Set Up the Space %%%%%%%%%%%%%%%%%%
write_counter = 0;
write_limit = 1;
central_num = vpi(0);
skip = 0;
t0 = clock();
max_iterations = 100000;  %size(center_triplets,1)-1 %vpi(10^10)

triplets = sortrows(base_triplets,2);
center_triplets = vpi(triplets(:,2));
end_of_list = center_triplets(size(center_triplets,1));
%%%%%%%%%%%%%%%%%% Define Start Type %%%%%%%%%%%%%%%%%%
if (start_type == 0)
    load("-v7",dataFile1, "center_search_data");
    load("-v7",dataFile2, "center_ab_data");
    load("-v7",dataFile3, "d1_d2_d3_cnt");
    d1 = d1_d2_d3_cnt(1);
    d2 = d1_d2_d3_cnt(2);
    d3 = d1_d2_d3_cnt(3);
    counter = d1_d2_d3_cnt(4);
elseif (start_type == 1)
    center_search_data = vpi([0,0,0,0]);
    center_ab_data = vpi([0,0,0,0]);
    d1 = vpi(center_triplets(size(center_triplets,1)-3));
    d2 = vpi(center_triplets(size(center_triplets,1)-2));
    d3 = vpi(center_triplets(size(center_triplets,1)-1));
    %d1 = 5
    %d2 = 13
    %d3 = 17
    second_to_last_in_list = d3;
    counter = 1;
else
    printf("**** INCORRECT START TYPE: CHOOSE 1 (start over), OR CHOOSE 0 (start where left off)****/n");
    break;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


while counter < max_iterations
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
    
    % central_num = vpi(1105);
    
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
            disp(size(q_final,1));
            disp(q_final);
            printf('Elapsed Time: ');
            elapsed_time = etime (clock (), t0);
            disp(elapsed_time);
            
            write_counter = write_counter + 1;
               
            a1 = q_final(1:size(q_final,1),1).*reshape(central_num./(q_final(1:size(q_final,1),2)),[size(q_final(1:size(q_final,1),1),1),size(q_final(1:size(q_final,1),1),2)]);
            b1 = vpi(central_num*ones(size(q_final,1),1)); 
            c1 = q_final(1:size(q_final,1),3).*reshape(central_num./(q_final(1:size(q_final,1),2)),[size(q_final(1:size(q_final,1),3),1),size(q_final(1:size(q_final,1),3),2)]);
            
            a1 = vpi(a1);
            b1 = vpi(b1);
            c1 = vpi(c1);
            q_final = vpi(q_final);
            central_num = vpi(central_num); 
            
            %%% Create the scaled triplet array aligned to the same centeral number
            q_final_scaled = horzcat(a1,b1,c1);
                              
            %%%%%%%%%%%%%%%%% CENTER WORK %%%%%%%%%%%%%%%%%
            
            %%% Determine the difference between the center number and the first number (same as the center and last number)
            delta1 = vpi(vpi(q_final_scaled(1:size(q_final_scaled,1),2)).^2-vpi(q_final_scaled(1:size(q_final_scaled,1),1)).^2)
            
            %delta1 = vpi(q_final_scaled(1:size(q_final_scaled,1),2)).^2-vpi(q_final_scaled(1:size(q_final_scaled,1),1)).^2;
            
            %%% Create vertical and horizontal arrays of the deltas
            delta_row = delta1*ones(1,size(delta1,1));
            delta_col = ones(size(delta1,1),1)*reshape(delta1,[1,size(delta1,1)]);
            
            %abs_a_minus_b = abs(delta_row-delta_col).*vpi(tril(ones(size(delta_col,1),size(delta_col,1)),-1));
            %abs_a_plus_b = abs(delta_row+delta_col).*vpi(tril(ones(size(delta_col,1),size(delta_col,1)),-1));
            
            %%% Create arrays for 'delta+delta' and 'delta-delta' 
            abs_a_minus_b = abs(delta_row-delta_col).*vpi(tril(ones(size(delta_col,1),size(delta_col,1)),-1));
            abs_a_plus_b = abs(delta_row+delta_col).*vpi(tril(ones(size(delta_col,1),size(delta_col,1)),-1));
            
            %%% Reshape the array into a column array
            [ind_m_i, ind_m_j, u_abs_a_minus_b] = find(reshape(abs_a_minus_b,[size(abs_a_minus_b,1)*size(abs_a_minus_b,1),1]));
            [ind_p_i, ind_p_j, u_abs_a_plus_b] = find(reshape(abs_a_plus_b,[size(abs_a_plus_b,1)*size(abs_a_plus_b,1),1]));
            
            if (central_num == 1105)
                u_abs_a_plus_b = vertcat(u_abs_a_plus_b,vpi(1197000));
            end;
            
            %%% Take the array and subtract all values by themselves to see if there are any matchs within the oringal delta list *** THERES'S A BETTER WAY!!!!
            ab_minus_match = abs(delta1*ones(1,size(u_abs_a_minus_b,1)).-ones(size(delta1,1),1)*reshape(u_abs_a_minus_b,[1,size(u_abs_a_minus_b,1)]));
            ab_plus_match = abs(delta1*ones(1,size(u_abs_a_plus_b,1)).-ones(size(delta1,1),1)*reshape(u_abs_a_plus_b,[1,size(u_abs_a_plus_b,1)]));
            
            %%% Look to see if any values were equivalent!!! (ie: where a zero would be)%%%
            [ind_m_row, ind_m_col, flag_m] = find((ab_minus_match==0));
            [ind_p_row, ind_p_col, flag_p] = find((ab_plus_match==0)); %.*ab_plus_match;
            
            ab_plus = vpi(0);
            ab_minus = vpi(0);
            ab_plus_out = vpi(0);
            ab_minus_out = vpi(0);
            match_found = 0;
                           
            if (isempty(flag_m) == 0)
                ab_minus = zeros(size(flag_m),1);
                for k = 1:size(flag_m)
                    %ab_minus(k) = ab_minus_match(ind_m_row,ind_m_col);
                    center_ab_data_temp = [central_num, num_rows, delta1(ind_m_row,1),-1];
                    center_ab_data = vertcat(center_ab_data,center_ab_data_temp);
                    save("-mat7-binary", dataFile2, "center_ab_data");
                end;
                match_found = 1;
                write_counter = write_limit;
                printf('We found a A+B Match for');
                disp(central_num);
                printf('!!!!!');
            end;    
            
            if (isempty(flag_p) == 0)    
                ab_plus = zeros(size(flag_p),1);
                for k = 1:size(flag_p)
                    %ab_plus(k) = ab_plus_match(ind_p_row,ind_p_col);
                    center_ab_data_temp = [central_num, num_rows, delta1(ind_p_row,1),1];
                    center_ab_data = vertcat(center_ab_data,center_ab_data_temp);
                    save("-mat7-binary", dataFile2, "center_ab_data");
                end;
                match_found = 1;
                write_counter = write_limit;
                printf('We found a A+B Match for');
                disp(central_num);
                printf('!!!!!');
            end;
            center_search_data_temp = horzcat(q_final_scaled,match_found.*ones(size(q_final_scaled,1),1));
            center_search_data = vertcat(center_search_data,center_search_data_temp);

            if write_counter >= write_limit;          
                save("-mat7-binary", dataFile1, "center_search_data");
                d1_d2_d3_cnt = [d1;d2;d3;counter];
                save("-mat7-binary", dataFile3, "d1_d2_d3_cnt");
                write_counter = 0;
            end;
            
            match_found = 0;
           % if and((isempty(flag_m) == 0),(isempty(flag_p) == 0))
           %     for list_cnt=1:max(size(ab_plus,1),ab_plus,1)
           %         if list_cnt>size(ab_plus,1)
           %             ab_plus_out=0;
           %         else
           %             ab_plus_out = ab_plus(list_cnt)
           %         end;
           %         if list>size(ab_minus,1)
           %             ab_minus=0;
           %         else
           %             ab_minus_out = ab_minus(list_cnt)
           %         end;
           %         center_ab_data_temp = central_num, num_rows, ab_plus_out, ab_minus_out
           %         center_ab_data = vertcat(center_ab_data,center_ab_data_temp);
           %     end;
           %     match_found = 0;
           %     save("-mat7-binary", dataFile2, "center_ab_data");
           % end;   
        end;    
    end;
    skip = 0; 
end;
   
printf('***************************** THE END? ****************************/n');