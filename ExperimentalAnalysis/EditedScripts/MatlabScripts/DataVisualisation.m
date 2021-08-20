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

%%
figure(2)
subplot(1,3,1)
boxplot(Slow_tot(:,2))
ylabel('RMSE')
xlabel('slow')
subplot(1,3,2)
boxplot(Med_tot(:,2))
xlabel('medium')
subplot(1,3,3)
boxplot(Fast_tot(:,2))
xlabel('fast')

