clc; close;

%%%For some reason the plots have stopped coming up. Need to fix this first
%%%thing tomorrow morning.

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

%% Find error between holo and polhemus data for slow trials
% slow trials
for i=1:20

        holo_dynamic = ['ID_2_slow_', num2str(i), '_HoloData'];
        pol_dynamic = ['ID_2_slow_', num2str(i), '_POLGroundTruth'];
        
        if isfield(experiment_data,pol_dynamic) == 1
            Holo_data = experiment_data.(holo_dynamic);
            Pol_data = experiment_data.(pol_dynamic);

            x_holo = round(Holo_data.Milliseconds,2,'significant');
            holo_second = round(Holo_data.Timestamp, 'seconds');
            Polh_second = round(Pol_data.Timestamp, 'seconds');

            y_holo = Holo_data.Angle;
            if length(y_holo) > 1

            holo_data_final = cat(2,x_holo, y_holo);

            x_pol = round(Pol_data.Milliseconds,2,'significant');
            y_pol = Pol_data.Angle;

            pol_data_final = cat(2, x_pol, y_pol);

            [~, rowsA, rowsB] = intersect(holo_data_final(:, 1), pol_data_final(:, 1));
            comparing_angles = [holo_data_final(rowsA, 2) pol_data_final(rowsB, 2)];
    %         fprintf('length of C is %i',(length(C)))
    %         fprintf('length of holo data is %i',(length(holo_data_final)))
    %         fprintf('difference between the two is %i',(length(C) - length(holo_data_final)));
            if length(comparing_diff)>1
                
                comparing_diff = comparing_angles(:,1) - comparing_angles(:,2);
                rmse = sqrt(mean((comparing_angles(:,1)-comparing_angles(:,2)).^2));
                figure(i)
                bar(comparing_diff)
                title('Total rmse is',rmse)
                ylabel('Difference in angle data')
            else 
                fprintf('No comparing diff data')
            end
       
            else
                fprintf('Not enough Hololens data for trial %i; slow trial \n',i)
            end
    else
        fprintf('No polhemus data for trial %i\n; slow trial \n',i)
    end
end

for i=1:16  

    figure(i+20)
    
    % slow TRIAL 2
    holo_dynamic = ['ID_2_slow_trial2_', num2str(i), '_HoloData'];
    pol_dynamic = ['ID_2_slow_trial2_', num2str(i), '_POLGroundTruth'];

    if isfield(experiment_data,pol_dynamic) == 1
            Holo_data = experiment_data.(holo_dynamic);
            Pol_data = experiment_data.(pol_dynamic);

            x_holo = round(Holo_data.Milliseconds,2,'significant');
            holo_second = round(Holo_data.Timestamp, 'seconds');
            Polh_second = round(Pol_data.Timestamp, 'seconds');

            y_holo = Holo_data.Angle;
            if length(y_holo) > 1

            holo_data_final = cat(2,x_holo, y_holo);

            x_pol = round(Pol_data.Milliseconds,2,'significant');
            y_pol = Pol_data.Angle;

            pol_data_final = cat(2, x_pol, y_pol);

            [~, rowsA, rowsB] = intersect(holo_data_final(:, 1), pol_data_final(:, 1));
            comparing_angles = [holo_data_final(rowsA, 2) pol_data_final(rowsB, 2)];
    %         fprintf('length of C is %i',(length(C)))
    %         fprintf('length of holo data is %i',(length(holo_data_final)))
    %         fprintf('difference between the two is %i',(length(C) - length(holo_data_final)));
            comparing_diff = comparing_angles(:,1) - comparing_angles(:,2);
            rmse = sqrt(mean((comparing_angles(:,1)-comparing_angles(:,2)).^2));
            figure(i)
            bar(comparing_diff)
            title('Total rmse is',rmse)
            ylabel('Difference in angle data')
        else
            fprintf('Not enough Hololens data for trial %i, slow trial 2 \n',i)
        end
    else
        fprintf('No polhemus data for trial %i, slow trial 2 \n',i)
    end
end

for i=1:11 

    figure(i+36)
    % slow TRIAL 2
    holo_dynamic = ['ID_2_slow_trial2v2_', num2str(i), '_HoloData'];
    pol_dynamic = ['ID_2_slow_trial2v2_', num2str(i), '_POLGroundTruth'];
    
    if isfield(experiment_data,pol_dynamic) == 1
            Holo_data = experiment_data.(holo_dynamic);
            Pol_data = experiment_data.(pol_dynamic);

            x_holo = round(Holo_data.Milliseconds,2,'significant');
            holo_second = round(Holo_data.Timestamp, 'seconds');
            Polh_second = round(Pol_data.Timestamp, 'seconds');

            y_holo = Holo_data.Angle;
            if length(y_holo) > 1

            holo_data_final = cat(2,x_holo, y_holo);

            x_pol = round(Pol_data.Milliseconds,2,'significant');
            y_pol = Pol_data.Angle;

            pol_data_final = cat(2, x_pol, y_pol);

            [~, rowsA, rowsB] = intersect(holo_data_final(:, 1), pol_data_final(:, 1));
            comparing_angles = [holo_data_final(rowsA, 2) pol_data_final(rowsB, 2)];
    %         fprintf('length of C is %i',(length(C)))
    %         fprintf('length of holo data is %i',(length(holo_data_final)))
    %         fprintf('difference between the two is %i',(length(C) - length(holo_data_final)));
            comparing_diff = comparing_angles(:,1) - comparing_angles(:,2);
            rmse = sqrt(mean((comparing_angles(:,1)-comparing_angles(:,2)).^2));
            figure(i)
            bar(comparing_diff)
            title('Total rmse is',rmse)
            ylabel('Difference in angle data')

        else
            fprintf('Not enough Hololens data for trial %i, slow trial 2 \n',i)
        end
    else
        fprintf('No polhemus data for trial %i, slow trial 2 \n',i)
    end

end

%% Medium trials
% 
for i=1:20
    
    figure(i+47)
    holo_dynamic = ['ID_2_medium_', num2str(i), '_HoloData'];
    pol_dynamic = ['ID_2_medium_', num2str(i), '_POLGroundTruth'];

    % need to check if the field exists, if it does then do this otherwise
    % dont
    if isfield(experiment_data,pol_dynamic) == 1
            Holo_data = experiment_data.(holo_dynamic);
            Pol_data = experiment_data.(pol_dynamic);

            x_holo = round(Holo_data.Milliseconds,2,'significant');
            holo_second = round(Holo_data.Timestamp, 'seconds');
            Polh_second = round(Pol_data.Timestamp, 'seconds');

            y_holo = Holo_data.Angle;
            if length(y_holo) > 1

            holo_data_final = cat(2,x_holo, y_holo);

            x_pol = round(Pol_data.Milliseconds,2,'significant');
            y_pol = Pol_data.Angle;

            pol_data_final = cat(2, x_pol, y_pol);

            [~, rowsA, rowsB] = intersect(holo_data_final(:, 1), pol_data_final(:, 1));
            comparing_angles = [holo_data_final(rowsA, 2) pol_data_final(rowsB, 2)];
    %         fprintf('length of C is %i',(length(C)))
    %         fprintf('length of holo data is %i',(length(holo_data_final)))
    %         fprintf('difference between the two is %i',(length(C) - length(holo_data_final)));
            comparing_diff = comparing_angles(:,1) - comparing_angles(:,2);
            rmse = sqrt(mean((comparing_angles(:,1)-comparing_angles(:,2)).^2));
            figure(i)
            bar(comparing_diff)
            title('Total rmse is',rmse)
            ylabel('Difference in angle data')
        else
            fprintf('Not enough Hololens data for trial %i, medium trial \n',i)
        end
    else
        fprintf('No polhemus data for trial %i, medium trial \n',i)
    end

end

for i=1:3

    figure(i+67)
    % medium TRIAL 2
    holo_dynamic = ['ID_2_medium_trial2v1_', num2str(i), '_HoloData'];
    pol_dynamic = ['ID_2_medium_trial2v1_', num2str(i), '_POLGroundTruth'];
    
    if isfield(experiment_data,pol_dynamic) == 1
            Holo_data = experiment_data.(holo_dynamic);
            Pol_data = experiment_data.(pol_dynamic);

            x_holo = round(Holo_data.Milliseconds,2,'significant');
            holo_second = round(Holo_data.Timestamp, 'seconds');
            Polh_second = round(Pol_data.Timestamp, 'seconds');

            y_holo = Holo_data.Angle;
            if length(y_holo) > 1

            holo_data_final = cat(2,x_holo, y_holo);

            x_pol = round(Pol_data.Milliseconds,2,'significant');
            y_pol = Pol_data.Angle;

            pol_data_final = cat(2, x_pol, y_pol);

            [~, rowsA, rowsB] = intersect(holo_data_final(:, 1), pol_data_final(:, 1));
            comparing_angles = [holo_data_final(rowsA, 2) pol_data_final(rowsB, 2)];
    %         fprintf('length of C is %i',(length(C)))
    %         fprintf('length of holo data is %i',(length(holo_data_final)))
    %         fprintf('difference between the two is %i',(length(C) - length(holo_data_final)));
            comparing_diff = comparing_angles(:,1) - comparing_angles(:,2);
            rmse = sqrt(mean((comparing_angles(:,1)-comparing_angles(:,2)).^2));
            figure(i)
            bar(comparing_diff)
            title('Total rmse is',rmse)
            ylabel('Difference in angle data')

        else
            fprintf('Not enough Hololens data for trial %i, medium trial 2 \n',i)
        end
    else
        fprintf('No polhemus data for trial %i, medium trial 2 \n',i)
    end

end

for i=1:5

    figure(i+70)
    % medium TRIAL 2
    holo_dynamic = ['ID_2_medium_trial2v2_', num2str(i), '_HoloData'];
    pol_dynamic = ['ID_2_medium_trial2v2_', num2str(i), '_POLGroundTruth'];
    
    if isfield(experiment_data,pol_dynamic) == 1
            Holo_data = experiment_data.(holo_dynamic);
            Pol_data = experiment_data.(pol_dynamic);

            x_holo = round(Holo_data.Milliseconds,2,'significant');
            holo_second = round(Holo_data.Timestamp, 'seconds');
            Polh_second = round(Pol_data.Timestamp, 'seconds');

            y_holo = Holo_data.Angle;
            if length(y_holo) > 1

            holo_data_final = cat(2,x_holo, y_holo);

            x_pol = round(Pol_data.Milliseconds,2,'significant');
            y_pol = Pol_data.Angle;

            pol_data_final = cat(2, x_pol, y_pol);

            [~, rowsA, rowsB] = intersect(holo_data_final(:, 1), pol_data_final(:, 1));
            comparing_angles = [holo_data_final(rowsA, 2) pol_data_final(rowsB, 2)];
    %         fprintf('length of C is %i',(length(C)))
    %         fprintf('length of holo data is %i',(length(holo_data_final)))
    %         fprintf('difference between the two is %i',(length(C) - length(holo_data_final)));
            comparing_diff = comparing_angles(:,1) - comparing_angles(:,2);
            rmse = sqrt(mean((comparing_angles(:,1)-comparing_angles(:,2)).^2));
            figure(i)
            bar(comparing_diff)
            title('Total rmse is',rmse)
            ylabel('Difference in angle data')

        else
            fprintf('Not enough Hololens data for trial %i, medium trial 2 \n',i)
        end
    else
        fprintf('No polhemus data for trial %i, medium trial 2 \n',i)
    end

end

for i=1:15

    figure(i+75)
    % slow TRIAL 2
    holo_dynamic = ['ID_2_medium_trial2v3_', num2str(i), '_HoloData'];
    pol_dynamic = ['ID_2_medium_trial2v3_', num2str(i), '_POLGroundTruth'];
    
    if isfield(experiment_data,pol_dynamic) == 1
            Holo_data = experiment_data.(holo_dynamic);
            Pol_data = experiment_data.(pol_dynamic);

            x_holo = round(Holo_data.Milliseconds,2,'significant');
            holo_second = round(Holo_data.Timestamp, 'seconds');
            Polh_second = round(Pol_data.Timestamp, 'seconds');

            y_holo = Holo_data.Angle;
            if length(y_holo) > 1

            holo_data_final = cat(2,x_holo, y_holo);

            x_pol = round(Pol_data.Milliseconds,2,'significant');
            y_pol = Pol_data.Angle;

            pol_data_final = cat(2, x_pol, y_pol);

            [~, rowsA, rowsB] = intersect(holo_data_final(:, 1), pol_data_final(:, 1));
            comparing_angles = [holo_data_final(rowsA, 2) pol_data_final(rowsB, 2)];
    %         fprintf('length of C is %i',(length(C)))
    %         fprintf('length of holo data is %i',(length(holo_data_final)))
    %         fprintf('difference between the two is %i',(length(C) - length(holo_data_final)));
            comparing_diff = comparing_angles(:,1) - comparing_angles(:,2);
            rmse = sqrt(mean((comparing_angles(:,1)-comparing_angles(:,2)).^2));
            figure(i)
            bar(comparing_diff)
            title('Total rmse is',rmse)
            ylabel('Difference in angle data')

        else
            fprintf('Not enough Hololens data for trial %i, medium trial 2 \n',i)
        end
    else
        fprintf('No polhemus data for trial %i, medium trial 2 \n',i)
    end

end

%% Fast trials
% 
for i=1:24
    
    figure(i+90)
    holo_dynamic = ['ID_2_fast_', num2str(i), '_HoloData'];
    pol_dynamic = ['ID_2_fast_', num2str(i), '_POLGroundTruth'];

    % need to check if the field exists, if it does then do this otherwise
    % dont
   if isfield(experiment_data,pol_dynamic) == 1
            Holo_data = experiment_data.(holo_dynamic);
            Pol_data = experiment_data.(pol_dynamic);

            x_holo = round(Holo_data.Milliseconds,2,'significant');
            holo_second = round(Holo_data.Timestamp, 'seconds');
            Polh_second = round(Pol_data.Timestamp, 'seconds');

            y_holo = Holo_data.Angle;
            if length(y_holo) > 1

            holo_data_final = cat(2,x_holo, y_holo);

            x_pol = round(Pol_data.Milliseconds,2,'significant');
            y_pol = Pol_data.Angle;

            pol_data_final = cat(2, x_pol, y_pol);

            [~, rowsA, rowsB] = intersect(holo_data_final(:, 1), pol_data_final(:, 1));
            comparing_angles = [holo_data_final(rowsA, 2) pol_data_final(rowsB, 2)];
    %         fprintf('length of C is %i',(length(C)))
    %         fprintf('length of holo data is %i',(length(holo_data_final)))
    %         fprintf('difference between the two is %i',(length(C) - length(holo_data_final)));
            comparing_diff = comparing_angles(:,1) - comparing_angles(:,2);
            rmse = sqrt(mean((comparing_angles(:,1)-comparing_angles(:,2)).^2));
            figure(i)
            bar(comparing_diff)
            title('Total rmse is',rmse)
            ylabel('Difference in angle data')
        else
            fprintf('Not enough Hololens data for trial %i, fast trial \n',i)
        end
    else
        fprintf('No polhemus data for trial %i, fast trial \n',i)
    end

end

for i=1:14

    figure(i+114)
    % fast TRIAL 2
    holo_dynamic = ['ID_2_fast_trial2v1_', num2str(i), '_HoloData'];
    pol_dynamic = ['ID_2_fast_trial2v1_', num2str(i), '_POLGroundTruth'];
    
    if isfield(experiment_data,pol_dynamic) == 1
            Holo_data = experiment_data.(holo_dynamic);
            Pol_data = experiment_data.(pol_dynamic);

            x_holo = round(Holo_data.Milliseconds,2,'significant');
            holo_second = round(Holo_data.Timestamp, 'seconds');
            Polh_second = round(Pol_data.Timestamp, 'seconds');

            y_holo = Holo_data.Angle;
            if length(y_holo) > 1

            holo_data_final = cat(2,x_holo, y_holo);

            x_pol = round(Pol_data.Milliseconds,2,'significant');
            y_pol = Pol_data.Angle;

            pol_data_final = cat(2, x_pol, y_pol);

            [~, rowsA, rowsB] = intersect(holo_data_final(:, 1), pol_data_final(:, 1));
            comparing_angles = [holo_data_final(rowsA, 2) pol_data_final(rowsB, 2)];
    %         fprintf('length of C is %i',(length(C)))
    %         fprintf('length of holo data is %i',(length(holo_data_final)))
    %         fprintf('difference between the two is %i',(length(C) - length(holo_data_final)));
            comparing_diff = comparing_angles(:,1) - comparing_angles(:,2);
            rmse = sqrt(mean((comparing_angles(:,1)-comparing_angles(:,2)).^2));
            figure(i)
            bar(comparing_diff)
            title('Total rmse is',rmse)
            ylabel('Difference in angle data')

        else
            fprintf('Not enough Hololens data for trial %i, fast trial 2 \n',i)
        end
    else
        fprintf('No polhemus data for trial %i, fast trial 2 \n',i)
    end

end

for i=1:2

    figure(i+128)
    % fast TRIAL 2
    holo_dynamic = ['ID_2_fast_trial2v2_', num2str(i), '_HoloData'];
    pol_dynamic = ['ID_2_fast_trial2v2_', num2str(i), '_POLGroundTruth'];
    
    if isfield(experiment_data,pol_dynamic) == 1
            Holo_data = experiment_data.(holo_dynamic);
            Pol_data = experiment_data.(pol_dynamic);

            x_holo = round(Holo_data.Milliseconds,2,'significant');
            holo_second = round(Holo_data.Timestamp, 'seconds');
            Polh_second = round(Pol_data.Timestamp, 'seconds');

            y_holo = Holo_data.Angle;
            if length(y_holo) > 1

            holo_data_final = cat(2,x_holo, y_holo);

            x_pol = round(Pol_data.Milliseconds,2,'significant');
            y_pol = Pol_data.Angle;

            pol_data_final = cat(2, x_pol, y_pol);

            [~, rowsA, rowsB] = intersect(holo_data_final(:, 1), pol_data_final(:, 1));
            comparing_angles = [holo_data_final(rowsA, 2) pol_data_final(rowsB, 2)];
    %         fprintf('length of C is %i',(length(C)))
    %         fprintf('length of holo data is %i',(length(holo_data_final)))
    %         fprintf('difference between the two is %i',(length(C) - length(holo_data_final)));
            comparing_diff = comparing_angles(:,1) - comparing_angles(:,2);
            rmse = sqrt(mean((comparing_angles(:,1)-comparing_angles(:,2)).^2));
            figure(i)
            bar(comparing_diff)
            title('Total rmse is',rmse)
            ylabel('Difference in angle data')

        else
            fprintf('Not enough Hololens data for trial %i, fast trial 2 \n',i)
        end
    else
        fprintf('No polhemus data for trial %i, fast trial 2 \n',i)
    end

end

for i=1:10

    figure(i+130)
    % slow TRIAL 2
    holo_dynamic = ['ID_2_fast_trial2v3_', num2str(i), '_HoloData'];
    pol_dynamic = ['ID_2_fast_trial2v3_', num2str(i), '_POLGroundTruth'];
    
    if isfield(experiment_data,pol_dynamic) == 1
            Holo_data = experiment_data.(holo_dynamic);
            Pol_data = experiment_data.(pol_dynamic);

            x_holo = round(Holo_data.Milliseconds,2,'significant');
            holo_second = round(Holo_data.Timestamp, 'seconds');
            Polh_second = round(Pol_data.Timestamp, 'seconds');

            y_holo = Holo_data.Angle;
            if length(y_holo) > 1

            holo_data_final = cat(2,x_holo, y_holo);

            x_pol = round(Pol_data.Milliseconds,2,'significant');
            y_pol = Pol_data.Angle;

            pol_data_final = cat(2, x_pol, y_pol);

            [~, rowsA, rowsB] = intersect(holo_data_final(:, 1), pol_data_final(:, 1));
            comparing_angles = [holo_data_final(rowsA, 2) pol_data_final(rowsB, 2)];
    %         fprintf('length of C is %i',(length(C)))
    %         fprintf('length of holo data is %i',(length(holo_data_final)))
    %         fprintf('difference between the two is %i',(length(C) - length(holo_data_final)));
            comparing_diff = comparing_angles(:,1) - comparing_angles(:,2);
            rmse = sqrt(mean((comparing_angles(:,1)-comparing_angles(:,2)).^2));
            figure(i)
            bar(comparing_diff)
            title('Total rmse is',rmse)
            ylabel('Difference in angle data')

        else
            fprintf('Not enough Hololens data for trial %i, fast trial 2 \n',i)
        end
    else
        fprintf('No polhemus data for trial %i, fast trial 2 \n',i)
    end

end