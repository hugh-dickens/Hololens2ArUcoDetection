clc; close all;
clear all;
%% Input the ID of data you want to analyse here. The .mat file will then be auto-loaded.

chk = exist('Nodes','var');
if ~chk
    
    ID = 17;
    ID = num2str(ID);
    ID_folder = 'C:\MixedRealityDevelopment\CV4Holo\Hololens2ArUcoDetection\ExperimentalAnalysis\EditedScripts\Data\Data_MATLAB\UnprocessedData';
    ID_folder =  [ID_folder '\'];
    mat_data = ['Data_' ID];


    load([ID_folder mat_data])
end

%% first recordings

pol_missing_data = [];
names = fieldnames( experiment_data );
subStrSlow = '_slow';
slow_filteredStruct = rmfield( experiment_data, names( find( cellfun( @isempty, strfind( names , subStrSlow ) ) ) ) );
subStrMedium = '_medium';
medium_filteredStruct = rmfield( experiment_data, names( find( cellfun( @isempty, strfind( names , subStrMedium ) ) ) ) );
subStrFast = '_fast';
fast_filteredStruct = rmfield( experiment_data, names( find( cellfun( @isempty, strfind( names , subStrFast ) ) ) ) );

% %% second recordings

pol_missing_data_v2 = [];
% names = fieldnames( experiment_data );
subStrSlow_v2 = '_slowv2';
slow_filteredStruct_v2 = rmfield( experiment_data, names( find( cellfun( @isempty, strfind( names , subStrSlow_v2 ) ) ) ) );
subStrMedium_v2 = '_mediumv2';
medium_filteredStruct_v2 = rmfield( experiment_data, names( find( cellfun( @isempty, strfind( names , subStrMedium_v2 ) ) ) ) );
subStrFast_v2 = '_fastv2';
fast_filteredStruct_v2 = rmfield( experiment_data, names( find( cellfun( @isempty, strfind( names , subStrFast_v2 ) ) ) ) );

% 
% %% third recordings
% 
pol_missing_data_v3 = [];
% names = fieldnames( experiment_data );
subStrSlow_v3 = '_slowv3';
slow_filteredStruct_v3 = rmfield( experiment_data, names( find( cellfun( @isempty, strfind( names , subStrSlow_v3 ) ) ) ) );
subStrMedium_v3 = '_mediumv3';
medium_filteredStruct_v3 = rmfield( experiment_data, names( find( cellfun( @isempty, strfind( names , subStrMedium_v3 ) ) ) ) );
subStrFast_v3 = '_fastv3';
fast_filteredStruct_v3 = rmfield( experiment_data, names( find( cellfun( @isempty, strfind( names , subStrFast_v3 ) ) ) ) );
% these need to be changed depending on participant

%% slow
namesslow = fieldnames( slow_filteredStruct );
subStrPol = '_POLGroundTruth';
Pol_filteredStruct_slow = rmfield( slow_filteredStruct, namesslow(find(cellfun(@isempty, strfind( namesslow, subStrPol)))));
Polh_Fields = fieldnames(Pol_filteredStruct_slow);
subStrHolo = '_HoloData';
Holo_filteredStruct_slow = rmfield( slow_filteredStruct, namesslow(find(cellfun(@isempty, strfind( namesslow, subStrHolo)))));
Holo_Fields = fieldnames(Holo_filteredStruct_slow);
lag_term_slow = 0.15;
calibration_term_slow = 2;
%% slow
vels_cell_slow_ID_17 = cell(0, 11);
integer = 0;
for trialnum = 1:length(Polh_Fields)
%     for trialnum = 11
       

    pol_dynamic = [string(Polh_Fields(trialnum - integer))]; 
    
    if trialnum < length(Holo_Fields)
        
    holo_dynamic = [string(Holo_Fields(trialnum))];
    newStr = erase(pol_dynamic,'_POLGroundTruth');
    newSubstr = erase(holo_dynamic, '_HoloData');
    
    if newStr ~= newSubstr
        integer = integer+1;
        
    elseif newStr == newSubstr

    if isfield(experiment_data,pol_dynamic) == 1
        Pol_data = experiment_data.(pol_dynamic);
        Holo_data = experiment_data.(holo_dynamic);

    

        x_pol = seconds(Pol_data.Timestamp);
        y_pol = Pol_data.Angle;
        pol_millis = Pol_data.Milliseconds;
        
        
        % % plot holo data with points and a spline overlaid
        x_holo = seconds(Holo_data.Timestamp) - lag_term_slow;
        seconds_diff = diff(seconds(Holo_data.Timestamp));
        holo_freq = 1/(sum(seconds_diff)/ length(seconds_diff));
     
        y_holo = Holo_data.Angle + calibration_term_slow;

        
        rowsToDelete = y_pol < 0 | y_pol > 180;
        more_rowsToDelete = x_pol > (x_pol(1)+100);
        y_pol(more_rowsToDelete) = [];
        x_pol(more_rowsToDelete) = [];
        y_pol(rowsToDelete) = [];
        x_pol(rowsToDelete) = []; 
        pol_millis(more_rowsToDelete) = [];
        pol_millis(rowsToDelete) = [];
        
        %%% added for presentation 
       
        order = 3;
        framelen = 93;

        sgf = sgolayfilt(y_pol,order,framelen);
        
        v = zeros(length(pol_millis),1) ;
        for i = 1:length(pol_millis)-1
            v(i) = abs((sgf(i+1)-sgf(i))/(pol_millis(i+1)-pol_millis(i)) * 1000000);
        end
        
        length_v_half = round(3*length(v)/9);
        length_v_end_part = round(length(v) * 0.8);
        
        max_v = max(v(length_v_half:length_v_end_part));
        if max_v > 100
            max_angle = find(v==max_v)+ 450;
            min_angle = max_angle - 250;
        elseif max_v > 40 & max_v <= 100
            max_angle = find(v==max_v)+ 400;
            min_angle = max_angle - 600;
        else
            max_angle = find(v==max_v)+ 250;
            min_angle = max_angle - 250;
        end

        start_ind = min_angle;
        end_ind = max_angle;

        pol_dataframe = [x_pol sgf];
        holo_data_comp = [x_holo y_holo];
        
        if end_ind < length(v)
            velocities = v(start_ind:end_ind);
            avg_vel = mean(velocities);
            pol_comp = pol_dataframe(start_ind:end_ind, :);
            pol_comp_non_spline = pol_dataframe(start_ind:end, :);
            
            
        elseif end_ind >= length(v)
            velocities = v(start_ind:end-500);
            avg_vel = mean(velocities);
            pol_comp = pol_dataframe(start_ind:end-500, :);
            pol_comp_non_spline = pol_dataframe(start_ind:end, :);
        else
            avg_vel = 0;
            pol_comp = [0 0];
            fprintf('No avg vel data trial %i\n', trialnum)
        end
        
%         x_holo = holo_filtered(:,1);
%         y_holo = holo_filtered(:,2);

        % create spline!!
        steps_holo = (x_holo(length(x_holo)) - x_holo(1)) / sum(x_holo);
        xx_holo = x_holo(1):steps_holo:x_holo(length(x_holo));
        

        % removing duplicate data from y_holo
        [~, indexA, ~] = unique(y_holo);
        A = sort(indexA);
        y_holo_spline_temp = y_holo(A);
        x_holo_spline_temp = x_holo(A);
        % removing duplicate data from x_holo_spline
        [~, indexA, ~] = unique(x_holo_spline_temp);
        A = sort(indexA);
        y_holo_spline = y_holo_spline_temp(A);
        x_holo_spline = x_holo_spline_temp(A);
        
        steps_holo_spline = (x_holo_spline(length(x_holo_spline)) - x_holo_spline(1)) / sum(x_holo_spline);
        xx_holo_spline_post = x_holo_spline(1):steps_holo_spline:x_holo_spline(length(x_holo_spline));
        if length(y_holo_spline) > 1
            
            yy_holo_spline_post = spline(x_holo_spline,y_holo_spline,xx_holo_spline_post);
        
        % cut the spline data so that it perfectly matches pol_comp    
        index_holo_spline_temp = xx_holo_spline_post(:)>( pol_comp(1,1));
        spline_filtered_temp_x = xx_holo_spline_post((index_holo_spline_temp));
        spline_filtered_temp_y = yy_holo_spline_post((index_holo_spline_temp));
        index_holo_spline = spline_filtered_temp_x(:)<( pol_comp(end,1));
        xx_holo_spline_post = spline_filtered_temp_x((index_holo_spline));
        yy_holo_spline_post = spline_filtered_temp_y((index_holo_spline));
        
        
           
        % cut holo data 'around' the polh determined catch phase
        index_holo = holo_data_comp(:,1)>( pol_comp_non_spline(1,1));
        holo_filtered_temp = holo_data_comp((index_holo),1:2);
        diff_holo = diff(holo_filtered_temp(:,2));
        max_diff = (max(diff_holo));
        idx_diff = find(max_diff == diff_holo);
        holo_filtered = holo_filtered_temp((1:idx_diff+1),1:2);
        
        % now need to make sure the timing is the same so cut polh data
        % around holo
        pol_index = pol_comp_non_spline(:,1) > holo_filtered(1,1);
        pol_filtered_temp = pol_comp_non_spline((pol_index),1:2);
        idx_pol_end = pol_filtered_temp(:,1) < holo_filtered(end,1);
        pol_comp_non_spline = pol_filtered_temp((idx_pol_end),1:2);
        
        % bin the data
        holo_comp_length = length(holo_filtered);
        pol_comp_length_non_spline = length(pol_comp_non_spline(:,1));
        bins_raw = floor(pol_comp_length_non_spline/holo_comp_length);
        i = 0;

        % bin the holo data
        holo_repeat_bins = [];
        bool = 0;
        for n = 1:holo_comp_length
            if bool == 0
                bool = 1;
                holo_repeat_bins(n:(n)*bins_raw) = holo_filtered(n,2);
            else
                holo_repeat_bins((n-1)*bins_raw + 1:(n)*bins_raw) = holo_filtered(n,2);
            end
            if n == holo_comp_length
                holo_repeat_bins(end:pol_comp_length_non_spline) = holo_filtered(n,2);
            end
        end
        
        % calculate the onset time during catch phase when holo misses tags
        holo_diffs = diff(y_holo_spline(:));
        time_diffs = diff(x_holo_spline(:));
        result = max( holo_diffs (holo_diffs >= 0) );
        onset_time = time_diffs(find(result == holo_diffs));
        
%         comparing_diff = abs(pol_binned_data(:) - holo_filtered(:,2));
        comparing_diff = abs(pol_comp_non_spline(:,2) - holo_repeat_bins(:));
        
        if length(comparing_diff) > 0 & onset_time < 1.4 
             
            rmse = sqrt((sum(comparing_diff).^2)/length(comparing_diff));

            vels_cell_slow_ID_17{end+1, 1}  = pol_dynamic;
            vels_cell_slow_ID_17{end, 2} = avg_vel;
            vels_cell_slow_ID_17{end, 3} = rmse;
            vels_cell_slow_ID_17{end, 5} = pol_comp_non_spline(:,1:2);
            vels_cell_slow_ID_17{end, 6} = holo_repeat_bins(:);
                   
            
            %spline rmse work: .....>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            spline_comp_length = length(yy_holo_spline_post);
            pol_comp_length_non_spline = length(pol_comp(:,1));
            bins = floor(spline_comp_length/pol_comp_length_non_spline);
            i = 0;
            spline_binned_data =[];

            for n = 1:pol_comp_length_non_spline
                i= i + 1;
                if i == 1
                    spline_binned_data(i) = mean(yy_holo_spline_post(1:(n)*bins));
                else
                    spline_binned_data(i) = mean(yy_holo_spline_post(bins*(n-1):(n)*bins));
                end
            end


            comparing_diff_spline = abs(pol_comp(:,2)-spline_binned_data(:) );

            rmse_spline = sqrt((sum(comparing_diff_spline).^2)/length(comparing_diff_spline));
            avg_vel_whole_trial = mean(v);
            
            vels_cell_slow_ID_17{end, 4} = rmse_spline;
            vels_cell_slow_ID_17{end, 7} = pol_comp(:,2);
            vels_cell_slow_ID_17{end, 8} = spline_binned_data(:);
            vels_cell_slow_ID_17{end, 9 } = onset_time;
            vels_cell_slow_ID_17{end, 10} = avg_vel_whole_trial;
            vels_cell_slow_ID_17{end, 11} = holo_freq;
            vels_cell_slow_ID_17{end, 12} = velocities;
            
            
%             figure(trialnum)
%             subplot(2,1,1)
% %             plot(holo_filtered(:,1), holo_filtered(:,2), 'x' )
%             plot( pol_comp_non_spline(:,1)- pol_comp_non_spline(1,1) ,holo_repeat_bins(:) )
%             hold on
%             plot(pol_comp_non_spline(:,1) - pol_comp_non_spline(1,1), pol_comp_non_spline(:,2))
%             title(['onset time: ' num2str(onset_time)], ['rmse with raw data: ' num2str(rmse)])
%             hold off 
% %             plot(x_holo_spline - x_pol(1), y_holo_spline, 'x')
% %             hold on
% %             plot(x_pol- x_pol(1), y_pol)
% %             hold off 
%             
%             subplot(2,1,2)
%             plot(xx_holo_spline_post-pol_comp(1,1), yy_holo_spline_post);
%             hold on
%             plot(pol_comp(:,1) - pol_comp(1,1), pol_comp(:,2))
%             title(['rmse with spline: ' num2str(rmse_spline)],['avg vel: ' num2str(avg_vel)])
%             hold off 
%             
        end
        end
        
    
            else
        fprintf('No polhemus data for trial %i\n; slow trial \n',i)
            end
    end
    
    end
end

%% just plot
close all;
figure(1)
avg_vel_tot_slow = vels_cell_slow_ID_17(:,2);
rmse_tot_slow_raw = vels_cell_slow_ID_17(:,3);
rmse_tot_slow_spline = vels_cell_slow_ID_17(:,4);

plot([avg_vel_tot_slow{:}], [rmse_tot_slow_raw{:}], 'o')
hold on
plot([avg_vel_tot_slow{:}], [rmse_tot_slow_spline{:}], 'X')
hold off
xlabel('Velocity (rad/s)')
ylabel('RMSE error')
legend('Raw data', 'Spline data')

%%
close all;
figure(2)
time_onset_slow = vels_cell_slow_ID_17(:,9);
rmse_tot_slow_raw = vels_cell_slow_ID_17(:,3);
rmse_tot_slow_spline = vels_cell_slow_ID_17(:,4);

plot([time_onset_slow{:}], [rmse_tot_slow_raw{:}], 'o')
hold on
plot([time_onset_slow{:}], [rmse_tot_slow_spline{:}], 'X')
hold off
xlabel('Time onset (s)')
ylabel('RMSE error')
legend('Raw data', 'Spline data')
% 
%% medium
namesMedium = fieldnames( medium_filteredStruct );
subStrPol = '_POLGroundTruth';
Pol_filteredStruct_medium = rmfield( medium_filteredStruct, namesMedium(find(cellfun(@isempty, strfind( namesMedium, subStrPol)))));
Polh_Fields = fieldnames(Pol_filteredStruct_medium);
subStrHolo = '_HoloData';
Holo_filteredStruct_medium = rmfield( medium_filteredStruct, namesMedium(find(cellfun(@isempty, strfind( namesMedium, subStrHolo)))));
Holo_Fields = fieldnames(Holo_filteredStruct_medium);
lag_term_medium = 0.15;
calibration_term_medium = 2;


%% edit ID number here !!
vels_cell_medium_ID_17 = cell(0, 11);
integer = 0;
for trialnum = 1:length(Polh_Fields)
%     for trialnum = 11
       

    pol_dynamic = [string(Polh_Fields(trialnum - integer))]; 
    
    if trialnum < length(Holo_Fields)
        
    holo_dynamic = [string(Holo_Fields(trialnum))];
    newStr = erase(pol_dynamic,'_POLGroundTruth');
    newSubstr = erase(holo_dynamic, '_HoloData');
    
    if newStr ~= newSubstr
        integer = integer+1;
        
    elseif newStr == newSubstr

    if isfield(experiment_data,pol_dynamic) == 1
        Pol_data = experiment_data.(pol_dynamic);
        Holo_data = experiment_data.(holo_dynamic);

    

        x_pol = seconds(Pol_data.Timestamp);
        y_pol = Pol_data.Angle;
        pol_millis = Pol_data.Milliseconds;
        
        
        % % plot holo data with points and a spline overlaid
        x_holo = seconds(Holo_data.Timestamp) - lag_term_medium;
        seconds_diff = diff(seconds(Holo_data.Timestamp));
        holo_freq = 1/(sum(seconds_diff)/ length(seconds_diff));
     
        y_holo = Holo_data.Angle + calibration_term_medium;

        
        rowsToDelete = y_pol < 0 | y_pol > 180;
        more_rowsToDelete = x_pol > (x_pol(1)+100);
        y_pol(more_rowsToDelete) = [];
        x_pol(more_rowsToDelete) = [];
        y_pol(rowsToDelete) = [];
        x_pol(rowsToDelete) = []; 
        pol_millis(more_rowsToDelete) = [];
        pol_millis(rowsToDelete) = [];
        
        %%% added for presentation 
       
        order = 3;
        framelen = 93;

        sgf = sgolayfilt(y_pol,order,framelen);
        
        v = zeros(length(pol_millis),1) ;
        for i = 1:length(pol_millis)-1
            v(i) = abs((sgf(i+1)-sgf(i))/(pol_millis(i+1)-pol_millis(i)) * 1000000);
        end
        
        length_v_half = round(3*length(v)/9);
        length_v_end_part = round(length(v) * 0.8);
        
        max_v = max(v(length_v_half:length_v_end_part));
        if max_v > 150
            max_angle = find(v==max_v)+ 100;
            min_angle = max_angle - 150;
        else
            max_v = max(v(length_v_half + 300 : length_v_end_part + 100));
            max_angle = find(v==max_v)+ 100;
            min_angle = max_angle - 150;
        end

        start_ind = min_angle;
        end_ind = max_angle;

        pol_dataframe = [x_pol sgf];
        holo_data_comp = [x_holo y_holo];
        
        if end_ind < length(v)
            velocities = v(start_ind:end_ind);
            avg_vel = mean(velocities);
            pol_comp = pol_dataframe(start_ind:end_ind, :);
            pol_comp_non_spline = pol_dataframe(start_ind:end, :);
            
            
        elseif end_ind >= length(v)
            velocities = v(start_ind:end-500);
            avg_vel = mean(velocities);
            pol_comp = pol_dataframe(start_ind:end-500, :);
            pol_comp_non_spline = pol_dataframe(start_ind:end, :);
        else
            avg_vel = 0;
            pol_comp = [0 0];
            fprintf('No avg vel data trial %i\n', trialnum)
        end
        
%         x_holo = holo_filtered(:,1);
%         y_holo = holo_filtered(:,2);

        % create spline!!
        steps_holo = (x_holo(length(x_holo)) - x_holo(1)) / sum(x_holo);
        xx_holo = x_holo(1):steps_holo:x_holo(length(x_holo));
        

        % removing duplicate data from y_holo
        [~, indexA, ~] = unique(y_holo);
        A = sort(indexA);
        y_holo_spline_temp = y_holo(A);
        x_holo_spline_temp = x_holo(A);
        % removing duplicate data from x_holo_spline
        [~, indexA, ~] = unique(x_holo_spline_temp);
        A = sort(indexA);
        y_holo_spline = y_holo_spline_temp(A);
        x_holo_spline = x_holo_spline_temp(A);
        
        steps_holo_spline = (x_holo_spline(length(x_holo_spline)) - x_holo_spline(1)) / sum(x_holo_spline);
        xx_holo_spline_post = x_holo_spline(1):steps_holo_spline:x_holo_spline(length(x_holo_spline));
        if length(y_holo_spline) > 1
            
            yy_holo_spline_post = spline(x_holo_spline,y_holo_spline,xx_holo_spline_post);
        
        % cut the spline data so that it perfectly matches pol_comp    
        index_holo_spline_temp = xx_holo_spline_post(:)>( pol_comp(1,1));
        spline_filtered_temp_x = xx_holo_spline_post((index_holo_spline_temp));
        spline_filtered_temp_y = yy_holo_spline_post((index_holo_spline_temp));
        index_holo_spline = spline_filtered_temp_x(:)<( pol_comp(end,1));
        xx_holo_spline_post = spline_filtered_temp_x((index_holo_spline));
        yy_holo_spline_post = spline_filtered_temp_y((index_holo_spline));
        
        
           
        % cut holo data 'around' the polh determined catch phase
        index_holo = holo_data_comp(:,1)>( pol_comp_non_spline(1,1));
        holo_filtered_temp = holo_data_comp((index_holo),1:2);
        diff_holo = diff(holo_filtered_temp(:,2));
        max_diff = (max(diff_holo));
        idx_diff = find(max_diff == diff_holo);
        holo_filtered = holo_filtered_temp((1:idx_diff+1),1:2);
        
        % now need to make sure the timing is the same so cut polh data
        % around holo
        pol_index = pol_comp_non_spline(:,1) > holo_filtered(1,1);
        pol_filtered_temp = pol_comp_non_spline((pol_index),1:2);
        idx_pol_end = pol_filtered_temp(:,1) < holo_filtered(end,1);
        pol_comp_non_spline = pol_filtered_temp((idx_pol_end),1:2);
        
        % bin the data
        holo_comp_length = length(holo_filtered);
        pol_comp_length_non_spline = length(pol_comp_non_spline(:,1));
        bins_raw = floor(pol_comp_length_non_spline/holo_comp_length);
        i = 0;

        % bin the holo data
        holo_repeat_bins = [];
        bool = 0;
        for n = 1:holo_comp_length
            if bool == 0
                bool = 1;
                holo_repeat_bins(n:(n)*bins_raw) = holo_filtered(n,2);
            else
                holo_repeat_bins((n-1)*bins_raw + 1:(n)*bins_raw) = holo_filtered(n,2);
            end
            if n == holo_comp_length
                holo_repeat_bins(end:pol_comp_length_non_spline) = holo_filtered(n,2);
            end
        end
        
        % calculate the onset time during catch phase when holo misses tags
        holo_diffs = diff(y_holo_spline(:));
        time_diffs = diff(x_holo_spline(:));
        result = max( holo_diffs (holo_diffs >= 0) );
        onset_time = time_diffs(find(result == holo_diffs));
        
%         comparing_diff = abs(pol_binned_data(:) - holo_filtered(:,2));
        comparing_diff = abs(pol_comp_non_spline(:,2) - holo_repeat_bins(:));
        
        if length(comparing_diff) > 0 & onset_time < 1.4 & avg_vel > 30
             
            rmse = sqrt((sum(comparing_diff).^2)/length(comparing_diff));

            vels_cell_medium_ID_17{end+1, 1}  = pol_dynamic;
            vels_cell_medium_ID_17{end, 2} = avg_vel;
            vels_cell_medium_ID_17{end, 3} = rmse;
            vels_cell_medium_ID_17{end, 5} = pol_comp_non_spline(:,1:2);
            vels_cell_medium_ID_17{end, 6} = holo_repeat_bins(:);
                   
            
            %spline rmse work: .....>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            spline_comp_length = length(yy_holo_spline_post);
            pol_comp_length_non_spline = length(pol_comp(:,1));
            bins = floor(spline_comp_length/pol_comp_length_non_spline);
            i = 0;
            spline_binned_data =[];

            for n = 1:pol_comp_length_non_spline
                i= i + 1;
                if i == 1
                    spline_binned_data(i) = mean(yy_holo_spline_post(1:(n)*bins));
                else
                    spline_binned_data(i) = mean(yy_holo_spline_post(bins*(n-1):(n)*bins));
                end
            end


            comparing_diff_spline = abs(pol_comp(:,2)-spline_binned_data(:) );

            rmse_spline = sqrt((sum(comparing_diff_spline).^2)/length(comparing_diff_spline));
            avg_vel_whole_trial = mean(v);
            
            vels_cell_medium_ID_17{end, 4} = rmse_spline;
            vels_cell_medium_ID_17{end, 7} = pol_comp(:,2);
            vels_cell_medium_ID_17{end, 8} = spline_binned_data(:);
            vels_cell_medium_ID_17{end, 9 } = onset_time;
            vels_cell_medium_ID_17{end, 10} = avg_vel_whole_trial;
            vels_cell_medium_ID_17{end, 11} = holo_freq;
            vels_cell_medium_ID_17{end, 12} = velocities;
            
            
%             figure(trialnum)
%             subplot(2,1,1)
% %             plot(holo_filtered(:,1), holo_filtered(:,2), 'x' )
%             plot( pol_comp_non_spline(:,1)- pol_comp_non_spline(1,1) ,holo_repeat_bins(:) )
%             hold on
%             plot(pol_comp_non_spline(:,1) - pol_comp_non_spline(1,1), pol_comp_non_spline(:,2))
%             title(['onset time: ' num2str(onset_time)], ['rmse with raw data: ' num2str(rmse)])
%             hold off 
% %             plot(x_holo_spline - x_pol(1), y_holo_spline, 'x')
% %             hold on
% %             plot(x_pol- x_pol(1), y_pol)
% %             hold off 
%             
%             subplot(2,1,2)
%             plot(xx_holo_spline_post-pol_comp(1,1), yy_holo_spline_post);
%             hold on
%             plot(pol_comp(:,1) - pol_comp(1,1), pol_comp(:,2))
%             title(['rmse with spline: ' num2str(rmse_spline)],['avg vel: ' num2str(avg_vel)])
%             hold off 
            
        end
        end
        
    
            else
        fprintf('No polhemus data for trial %i\n; medium trial \n',i)
            end
    end
    
    end
end

%% just plot
close all;
figure(1)
avg_vel_tot_medium = vels_cell_medium_ID_17(:,2);
rmse_tot_medium_raw = vels_cell_medium_ID_17(:,3);
rmse_tot_medium_spline = vels_cell_medium_ID_17(:,4);

plot([avg_vel_tot_medium{:}], [rmse_tot_medium_raw{:}], 'o')
hold on
plot([avg_vel_tot_medium{:}], [rmse_tot_medium_spline{:}], 'X')
hold off
xlabel('Velocity (rad/s)')
ylabel('RMSE error')
legend('Raw data', 'Spline data')

%%
close all;
figure(2)
time_onset_medium = vels_cell_medium_ID_17(:,9);
rmse_tot_medium_raw = vels_cell_medium_ID_17(:,3);
rmse_tot_medium_spline = vels_cell_medium_ID_17(:,4);

plot([time_onset_medium{:}], [rmse_tot_medium_raw{:}], 'o')
hold on
plot([time_onset_medium{:}], [rmse_tot_medium_spline{:}], 'X')
hold off
xlabel('Time onset (s)')
ylabel('RMSE error')
legend('Raw data', 'Spline data')

%% fast
namesFast = fieldnames( fast_filteredStruct );
subStrPol = '_POLGroundTruth';
Pol_filteredStruct = rmfield( fast_filteredStruct, namesFast(find(cellfun(@isempty, strfind( namesFast, subStrPol)))));
Polh_Fields = fieldnames(Pol_filteredStruct);
subStrHolo = '_HoloData';
Holo_filteredStruct_fast = rmfield( fast_filteredStruct, namesFast(find(cellfun(@isempty, strfind( namesFast, subStrHolo)))));
Holo_Fields = fieldnames(Holo_filteredStruct_fast);
lag_term_fast = 0.15;
calibration_term_fast = 2;
%% edit ID number here !! and everywhere
close all;
vels_cell_fast_ID_17 = cell(0, 12);
integer = 0;
for trialnum = 1:length(Polh_Fields)
%     for trialnum = 11
       

    pol_dynamic = [string(Polh_Fields(trialnum - integer))]; 
    
    if trialnum < length(Holo_Fields)
        
    holo_dynamic = [string(Holo_Fields(trialnum))];
    newStr = erase(pol_dynamic,'_POLGroundTruth');
    newSubstr = erase(holo_dynamic, '_HoloData');
    
    if newStr ~= newSubstr
        integer = integer+1;
        
    elseif newStr == newSubstr

    if isfield(experiment_data,pol_dynamic) == 1
        Pol_data = experiment_data.(pol_dynamic);
        Holo_data = experiment_data.(holo_dynamic);

    

        x_pol = seconds(Pol_data.Timestamp);
        y_pol = Pol_data.Angle;
        pol_millis = Pol_data.Milliseconds;
        
        
        % % plot holo data with points and a spline overlaid
        x_holo = seconds(Holo_data.Timestamp) - lag_term_fast;
        seconds_diff = diff(seconds(Holo_data.Timestamp));
        holo_freq = 1/(sum(seconds_diff)/ length(seconds_diff));
     
        y_holo = Holo_data.Angle + calibration_term_fast;

        
        rowsToDelete = y_pol < 0 | y_pol > 180;
        more_rowsToDelete = x_pol > (x_pol(1)+100);
        y_pol(more_rowsToDelete) = [];
        x_pol(more_rowsToDelete) = [];
        y_pol(rowsToDelete) = [];
        x_pol(rowsToDelete) = []; 
        pol_millis(more_rowsToDelete) = [];
        pol_millis(rowsToDelete) = [];
        
        %%% added for presentation 
       
        order = 3;
        framelen = 93;

        sgf = sgolayfilt(y_pol,order,framelen);
        
        v = zeros(length(pol_millis),1) ;
        for i = 1:length(pol_millis)-1
            v(i) = abs((sgf(i+1)-sgf(i))/(pol_millis(i+1)-pol_millis(i)) * 1000000);
        end
        
        length_v_half = round(3*length(v)/9);
        length_v_end_part = round(length(v) * 0.8);
        
        max_angle = find(v==max(v(length_v_half:end)))+ 50;
        min_angle = max_angle - 150;

        start_ind = min_angle;
        end_ind = max_angle;

        pol_dataframe = [x_pol sgf];
        holo_data_comp = [x_holo y_holo];
        
        if end_ind < length(v)
            velocities = v(start_ind:end_ind);
            avg_vel = mean(velocities);
            pol_comp = pol_dataframe(start_ind:end_ind, :);
            pol_comp_non_spline = pol_dataframe(start_ind:end, :);
            
            
        elseif end_ind >= length(v)
            velocities = v(start_ind:end-500);
            avg_vel = mean(velocities);
            pol_comp = pol_dataframe(start_ind:end-500, :);
            pol_comp_non_spline = pol_dataframe(start_ind:end, :);
        else
            avg_vel = 0;
            pol_comp = [0 0];
            fprintf('No avg vel data trial %i\n', trialnum)
        end
        
%         x_holo = holo_filtered(:,1);
%         y_holo = holo_filtered(:,2);

        % create spline!!
        steps_holo = (x_holo(length(x_holo)) - x_holo(1)) / sum(x_holo);
        xx_holo = x_holo(1):steps_holo:x_holo(length(x_holo));
        

        % removing duplicate data from y_holo
        [~, indexA, ~] = unique(y_holo);
        A = sort(indexA);
        y_holo_spline_temp = y_holo(A);
        x_holo_spline_temp = x_holo(A);
        % removing duplicate data from x_holo_spline
        [~, indexA, ~] = unique(x_holo_spline_temp);
        A = sort(indexA);
        y_holo_spline = y_holo_spline_temp(A);
        x_holo_spline = x_holo_spline_temp(A);
        
        steps_holo_spline = (x_holo_spline(length(x_holo_spline)) - x_holo_spline(1)) / sum(x_holo_spline);
        xx_holo_spline_post = x_holo_spline(1):steps_holo_spline:x_holo_spline(length(x_holo_spline));
        if length(y_holo_spline) > 1
            
            yy_holo_spline_post = spline(x_holo_spline,y_holo_spline,xx_holo_spline_post);
        
        % cut the spline data so that it perfectly matches pol_comp    
        index_holo_spline_temp = xx_holo_spline_post(:)>( pol_comp(1,1));
        spline_filtered_temp_x = xx_holo_spline_post((index_holo_spline_temp));
        spline_filtered_temp_y = yy_holo_spline_post((index_holo_spline_temp));
        index_holo_spline = spline_filtered_temp_x(:)<( pol_comp(end,1));
        xx_holo_spline_post = spline_filtered_temp_x((index_holo_spline));
        yy_holo_spline_post = spline_filtered_temp_y((index_holo_spline));
        
        
           
        % cut holo data 'around' the polh determined catch phase
        index_holo = holo_data_comp(:,1)>( pol_comp_non_spline(1,1));
        holo_filtered_temp = holo_data_comp((index_holo),1:2);
        diff_holo = diff(holo_filtered_temp(:,2));
        max_diff = (max(diff_holo));
        idx_diff = find(max_diff == diff_holo);
        holo_filtered = holo_filtered_temp((1:idx_diff+1),1:2);
        
        % now need to make sure the timing is the same so cut polh data
        % around holo
        pol_index = pol_comp_non_spline(:,1) > holo_filtered(1,1);
        pol_filtered_temp = pol_comp_non_spline((pol_index),1:2);
        idx_pol_end = pol_filtered_temp(:,1) < holo_filtered(end,1);
        pol_comp_non_spline = pol_filtered_temp((idx_pol_end),1:2);
        
        % bin the data
        holo_comp_length = length(holo_filtered);
        pol_comp_length_non_spline = length(pol_comp_non_spline(:,1));
        bins_raw = floor(pol_comp_length_non_spline/holo_comp_length);
        i = 0;

        % bin the holo data
        holo_repeat_bins = [];
        bool = 0;
        for n = 1:holo_comp_length
            if bool == 0
                bool = 1;
                holo_repeat_bins(n:(n)*bins_raw) = holo_filtered(n,2);
            else
                holo_repeat_bins((n-1)*bins_raw + 1:(n)*bins_raw) = holo_filtered(n,2);
            end
            if n == holo_comp_length
                holo_repeat_bins(end:pol_comp_length_non_spline) = holo_filtered(n,2);
            end
        end
        
        % calculate the onset time during catch phase when holo misses tags
        holo_diffs = diff(y_holo_spline(:));
        time_diffs = diff(x_holo_spline(:));
        result = max( holo_diffs (holo_diffs >= 0) );
        onset_time = time_diffs(find(result == holo_diffs));
        
%         comparing_diff = abs(pol_binned_data(:) - holo_filtered(:,2));
        comparing_diff = abs(pol_comp_non_spline(:,2) - holo_repeat_bins(:));
        
        if length(comparing_diff) > 0 & onset_time < 1.4
             
            rmse = sqrt((sum(comparing_diff).^2)/length(comparing_diff));

            vels_cell_fast_ID_17{end+1, 1}  = pol_dynamic;
            vels_cell_fast_ID_17{end, 2} = avg_vel;
            vels_cell_fast_ID_17{end, 3} = rmse;
            vels_cell_fast_ID_17{end, 5} = pol_comp_non_spline(:,1:2);
            vels_cell_fast_ID_17{end, 6} = holo_repeat_bins(:);
                   
            
            %spline rmse work: .....>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            spline_comp_length = length(yy_holo_spline_post);
            pol_comp_length_non_spline = length(pol_comp(:,1));
            bins = floor(spline_comp_length/pol_comp_length_non_spline);
            i = 0;
            spline_binned_data =[];

            for n = 1:pol_comp_length_non_spline
                i= i + 1;
                if i == 1
                    spline_binned_data(i) = mean(yy_holo_spline_post(1:(n)*bins));
                else
                    spline_binned_data(i) = mean(yy_holo_spline_post(bins*(n-1):(n)*bins));
                end
            end


            comparing_diff_spline = abs(pol_comp(:,2)-spline_binned_data(:) );

            rmse_spline = sqrt((sum(comparing_diff_spline).^2)/length(comparing_diff_spline));
            avg_vel_whole_trial = mean(v);
            
            vels_cell_fast_ID_17{end, 4} = rmse_spline;
            vels_cell_fast_ID_17{end, 7} = pol_comp(:,2);
            vels_cell_fast_ID_17{end, 8} = spline_binned_data(:);
            vels_cell_fast_ID_17{end, 9 } = onset_time;
            vels_cell_fast_ID_17{end, 10} = avg_vel_whole_trial;
            vels_cell_fast_ID_17{end, 11} = holo_freq;
            vels_cell_fast_ID_17{end, 12} = velocities;
            
            
%             figure(trialnum)
%             subplot(2,1,1)
% %             plot(holo_filtered(:,1), holo_filtered(:,2), 'x' )
%             plot( pol_comp_non_spline(:,1)- pol_comp_non_spline(1,1) ,holo_repeat_bins(:) )
%             hold on
%             plot(pol_comp_non_spline(:,1) - pol_comp_non_spline(1,1), pol_comp_non_spline(:,2))
%             title(['onset time: ' num2str(onset_time)], ['rmse with raw data: ' num2str(rmse)])
%             hold off 
% %             plot(x_holo_spline - x_pol(1), y_holo_spline, 'x')
% %             hold on
% %             plot(x_pol- x_pol(1), y_pol)
% %             hold off 
%             
%             subplot(2,1,2)
%             plot(xx_holo_spline_post-pol_comp(1,1), yy_holo_spline_post);
%             hold on
%             plot(pol_comp(:,1) - pol_comp(1,1), pol_comp(:,2))
%             title(['rmse with spline: ' num2str(rmse_spline)],['avg vel: ' num2str(avg_vel)])
%             hold off 
            
        end
        end
        
    
            else
        fprintf('No polhemus data for trial %i\n; fast trial \n',i)
            end
    end
    
    end
end


%% just plot
close all;
figure(1)
avg_vel_tot_fast = vels_cell_fast_ID_17(:,2);
rmse_tot_fast_raw = vels_cell_fast_ID_17(:,3);
rmse_tot_fast_spline = vels_cell_fast_ID_17(:,4);

plot([avg_vel_tot_fast{:}], [rmse_tot_fast_raw{:}], 'o')
hold on
plot([avg_vel_tot_fast{:}], [rmse_tot_fast_spline{:}], 'X')
hold off
xlabel('Velocity (rad/s)')
ylabel('RMSE error')
legend('Raw data', 'Spline data')

%%
close all;
figure(2)
time_onset_fast = vels_cell_fast_ID_17(:,9);
rmse_tot_fast_raw = vels_cell_fast_ID_17(:,3);
rmse_tot_fast_spline = vels_cell_fast_ID_17(:,4);

plot([time_onset_fast{:}], [rmse_tot_fast_raw{:}], 'o')
hold on
plot([time_onset_fast{:}], [rmse_tot_fast_spline{:}], 'X')
hold off
xlabel('Time onset (s)')
ylabel('RMSE error')
legend('Raw data', 'Spline data')

%% plot all
fname = 'C:\MixedRealityDevelopment\CV4Holo\Hololens2ArUcoDetection\ExperimentalAnalysis\EditedScripts\Data\Data_MATLAB\VelocityErrorData\Plots\IDPlots';
close all;
FigH = figure('Position', get(0, 'Screensize'));
x = [[avg_vel_tot_slow{:}] [avg_vel_tot_medium{:}] [avg_vel_tot_fast{:}]]';
y_raw = [[rmse_tot_slow_raw{:}] [rmse_tot_medium_raw{:}] [rmse_tot_fast_raw{:}]]';
y_spline = [[rmse_tot_slow_spline{:}] [rmse_tot_medium_spline{:}] [rmse_tot_fast_spline{:}]]';

bls_raw = regress(y_raw,[ones(length(x),1) x]);
bls_spline = regress(y_spline,[ones(length(x),1) x]);


leg_vel_raw = plot([avg_vel_tot_slow{:}], [rmse_tot_slow_raw{:}], 'ko','color', 'red');
hold on
plot([avg_vel_tot_medium{:}], [rmse_tot_medium_raw{:}], 'ko','color','red');
hold on
plot([avg_vel_tot_fast{:}], [rmse_tot_fast_raw{:}], 'ko','color','red');
hold on
leg_raw_LR = plot(x,bls_raw(1)+bls_raw(2)*x,'r');
hold on

leg_vel_spline = plot([avg_vel_tot_slow{:}], [rmse_tot_slow_spline{:}], 'X','color', 'b');
hold on
plot([avg_vel_tot_medium{:}], [rmse_tot_medium_spline{:}], 'X','color','b');
hold on
plot([avg_vel_tot_fast{:}], [rmse_tot_fast_spline{:}], 'X','color','b');
hold on
leg_spline_LR = plot(x,bls_spline(1)+bls_spline(2)*x,'b');

hold off
clear ylim xlim
ylim([0 1000])
xlim([0 200])
yticks([0:100:1000])
legend([leg_vel_raw, leg_raw_LR, leg_vel_spline, leg_spline_LR], {'Raw data','Raw linear model', 'Spline data','Spline linear model'},'FontSize', 20,'Location', 'northwest')
xlim=get(gca,'XLim');
ylim=get(gca,'YLim');
text(0.98*xlim(1)+0.02*xlim(2),0.28*ylim(1)+0.72*ylim(2),['y = ' num2str(bls_raw(1)) '+' num2str(bls_raw(2)) 'x'],'Color', 'r', 'FontSize', 20)
text(0.98*xlim(1)+0.02*xlim(2),0.38*ylim(1)+0.62*ylim(2),['y = ' num2str(bls_spline(1)) '+' num2str(bls_spline(2)) 'x'],'Color', 'b', 'FontSize', 20)
title(['Velocity against RMSE between hololens and polhemus angle readings for participant 17'],'FontSize', 18)
xlabel('Velocity (deg/s)','FontSize', 18)
ylabel('RMSE error', 'FontSize', 18)
hold on


mkdir 'C:\MixedRealityDevelopment\CV4Holo\Hololens2ArUcoDetection\ExperimentalAnalysis\EditedScripts\Data\Data_MATLAB\VelocityErrorData\Plots\IDPlots'  '\ID17'
filename = ['ID' num2str(ID) '\VelErrorID' num2str(ID)];
saveas(FigH, fullfile(fname, filename), 'png');

%%
% close all;
FigHRaw = figure('Position', get(0, 'Screensize'));

x_time_onset = [[time_onset_slow{:}] [time_onset_medium{:}] [time_onset_fast{:}]]';

bls_raw_onset = regress(y_raw,[ones(length(x_time_onset),1) x_time_onset]);
bls_spline_onset = regress(y_spline,[ones(length(x_time_onset),1) x_time_onset]);


leg_onset_raw = plot([time_onset_slow{:}], [rmse_tot_slow_raw{:}], 'o', 'color','r');
hold on
plot([time_onset_medium{:}], [rmse_tot_medium_raw{:}], 'o', 'color','r');
hold on
plot([time_onset_fast{:}], [rmse_tot_fast_raw{:}], 'o', 'color','r');
hold on
leg_raw_LR_onset = plot(x_time_onset,bls_raw_onset(1)+bls_raw_onset(2)*x_time_onset,'r');
hold on

leg_onset_spline = plot([time_onset_slow{:}], [rmse_tot_slow_spline{:}], 'x', 'color','b');
hold on
plot([time_onset_medium{:}], [rmse_tot_medium_spline{:}], 'x', 'color','b');
hold on
plot([time_onset_fast{:}], [rmse_tot_fast_spline{:}], 'x', 'color','b');
hold on
leg_spline_LR_onset = plot(x_time_onset,bls_spline_onset(1)+bls_spline_onset(2)*x_time_onset,'b');

hold off
hold off
clear ylim xlim
ylim([0 1000])
xlim([0 1.4])
yticks([0:100:1000])
legend([leg_onset_raw, leg_raw_LR_onset, leg_onset_spline, leg_spline_LR_onset], {'Raw data','Raw linear model', 'Spline data','Spline linear model'},'FontSize', 20,'Location', 'northwest')
xlim=get(gca,'XLim');
ylim=get(gca,'YLim');
text(0.98*xlim(1)+0.02*xlim(2),0.28*ylim(1)+0.72*ylim(2),['y = ' num2str(bls_raw_onset(1)) '+' num2str(bls_raw_onset(2)) 'x'],'Color', 'r', 'FontSize', 20)
text(0.98*xlim(1)+0.02*xlim(2),0.38*ylim(1)+0.62*ylim(2),['y = ' num2str(bls_spline_onset(1)) '+' num2str(bls_spline_onset(2)) 'x'],'Color', 'b', 'FontSize', 20)
title('RMSE error between Polhemus and Hololens angle recordings against time onset for participant 17', 'FontSize', 18)
xlabel('Time onset (s)', 'FontSize',18)
ylabel('RMSE error', 'FontSize', 18)
hold on

filename = ['ID' num2str(ID) '\TimeOnsetErrorID' num2str(ID)];
saveas(FigHRaw, fullfile(fname, filename), 'png');


%%
figure(3)
length_fast = length(vels_cell_fast_ID_17{1, 7});
length_medium = length(vels_cell_medium_ID_17{1, 7});

angle_pol_fast = reshape(cell2mat(vels_cell_fast_ID_17(:,7)), [length_fast,length(vels_cell_fast_ID_17)]);
angle_holo_fast = reshape(cell2mat(vels_cell_fast_ID_17(:,8)), [length_fast,length(vels_cell_fast_ID_17)]);
angular_velocity_fast = reshape(cell2mat(vels_cell_fast_ID_17(:,12)), [length_fast,length(vels_cell_fast_ID_17)]);

angle_pol_medium = reshape(cell2mat(vels_cell_medium_ID_17(:,7)), [length_medium,length(vels_cell_medium_ID_17)]);
angle_holo_medium = reshape(cell2mat(vels_cell_medium_ID_17(:,8)), [length_medium, length(vels_cell_medium_ID_17)]);
angular_velocity_medium = reshape(cell2mat(vels_cell_medium_ID_17(:,12)), [length_medium, length(vels_cell_medium_ID_17)]);

% angle_pol_slow = reshape(cell2mat(vels_cell_slow_ID_17(:,7)), [151,28]);
% angle_holo_slow = reshape(cell2mat(vels_cell_slow_ID_17(:,8)), [151,28]);
% angular_velocity = reshape(cell2mat(vels_cell_slow_ID_17(:,12)), [151,28]);
% surf(angle_pol_fast,angle_holo_fast,angular_velocity)
% plot3(angle_pol_fast,angle_holo_fast,angular_velocity_fast);
plot3(angle_pol_medium,angle_holo_medium,angular_velocity);
xlabel('Angle polhemus')
ylabel('Angle holo')
zlabel('Angular vel')

%%
slow_ID_17 = 'VelSlow_ID_17';
medium_ID_17 = 'VelMedium_ID_17';
fast_ID_17 = 'VelFast_ID_17';
VelErrorData17.(slow_ID_17) = cell2table(vels_cell_slow_ID_17);
VelErrorData17.(medium_ID_17) = cell2table(vels_cell_medium_ID_17) ;
VelErrorData17.(fast_ID_17) = cell2table(vels_cell_fast_ID_17);
foldersave = 'C:\MixedRealityDevelopment\CV4Holo\Hololens2ArUcoDetection\ExperimentalAnalysis\EditedScripts\Data\Data_MATLAB\VelocityErrorData';
filesave = 'VelErrorData17';
save(fullfile(foldersave, filesave), 'VelErrorData17')

