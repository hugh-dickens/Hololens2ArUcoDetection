clc; close all;

%% Input the ID of data you want to analyse here. The .mat file will then be auto-loaded.

chk = exist('Nodes','var');
if ~chk
     
    ID = 2;
    ID = num2str(ID);
    ID_folder = 'C:\MixedRealityDevelopment\CV4Holo\Hololens2ArUcoDetection\ExperimentalAnalysis\EditedScripts\Data_ID_';
    ID_folder =  [ID_folder ID '\'];
    mat_data = ['Data_' ID];

    load([ID_folder mat_data])
end

%% Plot holo and polhemus data for slow trials section
%slow trials
for i=1:20

        figure(i)
% %     slow if statements
   
        holo_dynamic = ['ID_2_slow_', num2str(i), '_HoloData'];
        pol_dynamic = ['ID_2_slow_', num2str(i), '_POLGroundTruth'];
        
        if isfield(experiment_data,pol_dynamic) == 1
        Holo_data = experiment_data.(holo_dynamic);
        Pol_data = experiment_data.(pol_dynamic);

        % % plot holo data with points and a spline overlaid
        x_holo = seconds(Holo_data.Timestamp);
        y_holo = Holo_data.Angle;
        if length(y_holo) > 1
        more_rowsToDelete =  x_holo > (x_holo(1)+1000);
        rowsToDelete = y_holo < 0 | y_holo > 180;
        y_holo(rowsToDelete) = [];
        x_holo(rowsToDelete) = [];
        y_holo(more_rowsToDelete) = [];
        x_holo(more_rowsToDelete) = [];
        steps_holo = (x_holo(length(x_holo)) - x_holo(1)) / sum(x_holo);
        xx_holo = x_holo(1):steps_holo:x_holo(length(x_holo));
        yy_holo = spline(x_holo,y_holo,xx_holo);
        
        subplot(2,1,1);
        plot(x_holo,y_holo,'o',xx_holo,yy_holo);
        hold on

        % % plot holo data with points and a spline overlaid
        x_pol = seconds(Pol_data.Timestamp);
        y_pol = Pol_data.Angle;
        rowsToDelete = y_pol < 0 | y_pol > 180;
        more_rowsToDelete = x_pol > (x_pol(1)+1000);
        y_pol(more_rowsToDelete) = [];
        x_pol(more_rowsToDelete) = [];
        y_pol(rowsToDelete) = [];
        x_pol(rowsToDelete) = [];
        % filter the polh data before plotting....
        order = 3;
        framelen = 101;

        sgf = sgolayfilt(y_pol,order,framelen);
        
        plot(x_pol, sgf);
% 
        xlabel('Time')
        ylabel('Angle')
        title('Slow trial')
        legend('Holo Data','Holo Spline','Polh Data')
        
        hold off
        % error bar part:
        
        Holo_data = experiment_data.(holo_dynamic);
        Pol_data = experiment_data.(pol_dynamic);

        holo_millisecond = round(Holo_data.Milliseconds,2,'significant');
        y_holo = Holo_data.Angle;
        
        holo_second = seconds(round(Holo_data.Timestamp, 'seconds'));
        Polh_second = seconds(round(Pol_data.Timestamp, 'seconds'));
        
        b1 = num2str(holo_second);
        b2 = num2str(holo_millisecond);
        % Concatenate the two strings element wise
        c1 = strcat(b1, b2);
        % turn spaces into 0s
        str = regexprep(cellstr(c1), ' ', '0');
        % Convert the result back to a numeric matrix
        x_holo = str2double(str);
        

        holo_data_final = cat(2,x_holo, y_holo);

        polh_millisecond = round(Pol_data.Milliseconds,2,'significant');
        polh_millisecond(polh_millisecond == 1000000) = 990000;
        y_pol = Pol_data.Angle;
        sgf = sgolayfilt(y_pol,order,framelen);
        
        a1 = num2str(Polh_second);
        a2 = num2str(polh_millisecond);
        % Concatenate the two strings element wise
        d1 = strcat(a1, a2);
        % turn spaces into 0s
        str1 = regexprep(cellstr(d1), ' ', '0');
        % Convert the result back to a numeric matrix
        x_pol = str2double(str1);

        pol_data_final = cat(2, x_pol, sgf);

        [~, rowsA, rowsB] = intersect(holo_data_final(:, 1), pol_data_final(:, 1));
        rowsA = sort(rowsA);
        rowsB = sort(rowsB);
        comparing_angles = [holo_data_final(rowsA, 2) pol_data_final(rowsB, 2)];

        comparing_diff = comparing_angles(:,1) - comparing_angles(:,2);        
        if length(comparing_diff)>1
            rmse = sqrt(mean((comparing_angles(:,1)-comparing_angles(:,2)).^2));
            subplot(2,1,2)
            bar(comparing_diff)
            title('Total rmse is',rmse)
            ylabel('Difference in angle data (holo - polh)')
        else 
            fprintf('No comparing diff data for trial %i; slow trial \n', i)
        end
        
        else
            fprintf('Not enough Hololens data for trial %i; slow trial \n',i)
        end
    else
        fprintf('No polhemus data for trial %i\n; slow trial \n',i)
    end
        
end