clc; close all;
clear all;
%% Input the ID of data you want to analyse here. The .mat file will then be auto-loaded.
IDs = [1,4,5,6,7,8,9,10,11,12,13];
chk = exist('Nodes','var');
if ~chk
    for ID = IDs
%     ID = 11;
    ID = num2str(ID);
    ID_folder = 'C:\MixedRealityDevelopment\CV4Holo\Hololens2ArUcoDetection\ExperimentalAnalysis\EditedScripts\Data_MATLAB\VelocityErrorData\';
    mat_data = ['VelErrorData' ID];
    load([ID_folder mat_data])
    end
end
% mergeVelErrors = cell2struct([struct2cell(VelErrorData11), fieldname(VelErrorData11));
mergeVelErrors = cell2struct([struct2cell(VelErrorData1);struct2cell(VelErrorData4);...
    struct2cell(VelErrorData5);struct2cell(VelErrorData6);...
    struct2cell(VelErrorData7);struct2cell(VelErrorData8);...
    struct2cell(VelErrorData9);struct2cell(VelErrorData10);...
    struct2cell(VelErrorData11);...
    struct2cell(VelErrorData12);struct2cell(VelErrorData13)],...
[fieldnames(VelErrorData1);fieldnames(VelErrorData4);...
    fieldnames(VelErrorData5);fieldnames(VelErrorData6);...
    fieldnames(VelErrorData7);fieldnames(VelErrorData8);fieldnames(VelErrorData9);...
    fieldnames(VelErrorData10);...
    fieldnames(VelErrorData11);fieldnames(VelErrorData12);fieldnames(VelErrorData13)]);
figure(1)
x = [];
y = [];
fields = fieldnames(mergeVelErrors);
mergeSlow_vel = [];
mergeMed_vel = [];
mergeFast_vel = [];
mergeSlow_RMSE = [];
mergeMed_RMSE = [];
mergeFast_RMSE = [];
% fields = fieldnames(VelErrorData11);
counter = 0;
for i = 1:numel(fields)

temp = table2cell(mergeVelErrors.(fields{i}));
% temp = table2cell(VelErrorData11.(fields{i}));

vel = temp(:,2);
rmse = temp(:,3);

if counter == 0
    mergeSlow_vel = [mergeSlow_vel; vel];
    mergeSlow_RMSE = [mergeSlow_RMSE; rmse];
    counter = 1;
    
elseif counter == 1
    mergeMed_vel = [mergeMed_vel; vel];
    mergeMed_RMSE = [mergeMed_RMSE; rmse];
    counter = 2;
elseif counter == 2
    mergeFast_vel = [mergeFast_vel; vel];
    mergeFast_RMSE = [mergeFast_RMSE; rmse];
    counter = 0;
end
    
    

vel = vel(all(cell2mat(vel) ~= 0,2),:);
rmse = rmse(all(cell2mat(rmse) ~= 0,2),:);
x = [x; vel];
y = [y; rmse];

plot([vel{:}], [rmse{:}], 'o')
xlabel('Velocity (rad/s)')
ylabel('RMSE error')

hold on

% 




end

x = cell2mat(x);
y = cell2mat(y);
mdl = fitlm(x,y)

plot(mdl)

% legend('Slow 10', 'Medium 10', 'Fast 10', 'Slow 11', 'Medium 11', 'Fast 11','Slow 12', 'Medium 12', 'Fast 12')

title('Velocity against error between hololens and polhemus recordings for all participants')
xlabel('Velocity (rad/s)')
ylabel('RMSE error')

hold off

Slow_tot= cell2mat([mergeSlow_vel mergeSlow_RMSE]);
Med_tot= cell2mat([mergeMed_vel mergeMed_RMSE]);
Fast_tot= cell2mat([mergeFast_vel mergeFast_RMSE]);
% A = Slow_tot(mergeSlow_RsMSE~=0);

%% new sec

merge_all_vels = [Slow_tot; Med_tot; Fast_tot];

vel_bel_20 = merge_all_vels((merge_all_vels(:,1) < 20),:);
vel_bel_20 = vel_bel_20((vel_bel_20(:,1) > 0),:);

vel_20_40 = merge_all_vels((merge_all_vels(:,1) > 20),:);
vel_20_40 = vel_20_40((vel_20_40(:,1) < 40 ),:);

vel_40_60 = merge_all_vels((merge_all_vels(:,1) > 40),:);
vel_40_60 = vel_40_60((vel_40_60(:,1) < 60 ),:);

vel_60_80 = merge_all_vels((merge_all_vels(:,1) > 60),:);
vel_60_80 = vel_60_80((vel_60_80(:,1) < 80 ),:);

vel_80_100 = merge_all_vels((merge_all_vels(:,1) > 80),:);
vel_80_100 = vel_80_100((vel_80_100(:,1) < 100 ),:);

vel_100_120 = merge_all_vels((merge_all_vels(:,1) > 100),:);
vel_100_120 = vel_100_120((vel_100_120(:,1) < 120 ),:);

vel_120_140 = merge_all_vels((merge_all_vels(:,1) > 120),:);
vel_120_140 = vel_120_140((vel_120_140(:,1) < 140 ),:);

vel_140_160 = merge_all_vels((merge_all_vels(:,1) > 140),:);
vel_140_160 = vel_140_160((vel_140_160(:,1) < 160 ),:);

vel_above_160 = merge_all_vels((merge_all_vels(:,1) > 160),:);

%%
figure(1)

subplot(3,3,1)
boxplot(vel_bel_20(:,2))
ylim([0 150])
yticks([0:30:150])
hold on
ylabel('RMSE')
xlabel('Below 20rad/s')

subplot(3,3,2)
boxplot(vel_20_40(:,2))
ylim([0 150])
yticks([0:30:150])
hold on
ylabel('RMSE')
xlabel('20-40 rad/s')

subplot(3,3,3)
boxplot(vel_40_60(:,2))
ylim([0 150])
yticks([0:30:150])
hold on
ylabel('RMSE')
xlabel('40-60 rad/s')

subplot(3,3,4)
boxplot(vel_60_80(:,2))
ylim([0 150])
yticks([0:30:150])
hold on
ylabel('RMSE')
xlabel('60-80 rad/s')

subplot(3,3,5)
boxplot(vel_80_100(:,2))
ylim([0 150])
yticks([0:30:150])
hold on
ylabel('RMSE')
xlabel('80-100 rad/s')

subplot(3,3,6)
boxplot(vel_100_120(:,2))
ylim([0 150])
yticks([0:30:150])
hold on
ylabel('RMSE')
xlabel('100-120 rad/s')

subplot(3,3,7)
boxplot(vel_120_140(:,2))
ylim([0 150])
yticks([0:30:150])
hold on
ylabel('RMSE')
xlabel('120-140 rad/s')

subplot(3,3,8)
boxplot(vel_140_160(:,2))
ylim([0 150])
yticks([0:30:150])
hold on
ylabel('RMSE')
xlabel('140-160 rad/s')

subplot(3,3,9)
boxplot(vel_above_160(:,2))
ylim([0 150])
yticks([0:30:150])
hold on
ylabel('RMSE')
xlabel('Above 160 rad/s')

%% new section
figure(2)
subplot(1,3,1)
boxplot(Slow_tot(:,2))
ylim([0 150])
yticks([0:10:150])

hold on
ylabel('RMSE')
xlabel('slow')

subplot(1,3,2)
boxplot(Med_tot(:,2))
ylim([0 150])
yticks([0:10:150])

hold on
xlabel('medium')

subplot(1,3,3)
boxplot(Fast_tot(:,2))
ylim([0 150])
yticks([0:10:150])

hold on
xlabel('fast')
 

