%% Stage 03A | Within-subject ERP analysis (WSA)
%% IMPORTANT: topographical plotting uses EEGLAB `topoplot`.
% Start EEGLAB from the MATLAB command window once, then you can close the EEGLAB GUI.
% Clear workspace before running this script.
%% Stage 03A | Load preprocessed data of a single subject (035 or 003) and apply baseline correction

clear
close all
clc

load sub-035_PreprocessStep2.mat %sub-003_PreprocessStep2.mat %

[n,m,q]=size(X); %n=number of channels=60; m=number of samples per epoch=500; q=number of epochs(or trials)

baseidx=[1 101]; %indices of the baseline period from -200 ms to 0 ms (these are the first 200 ms = 101 samples in each epoch)

%efficient way to remove baseline
baseline=mean(X(:,baseidx(1):baseidx(2),:),2); % n x 1 x q
X_rmb=X-baseline;  % X_rmb has size n x m x q %baseline removed trial by trial

%less efficient way (but still correct) to remove baseline
% for i=1:n % iterating over channels
%     for j=1:q % iterating over trials
%         baseline=mean(X(i,baseidx(1):baseidx(2),j));
%         X_rmb(i,:,j)=X(i,:,j)-baseline;
%     end
% end

X=X_rmb; %rewrite X; now X has the baseline removed

%% Stage 03A | Separate epochs by stimulus class

idx_standard=find(strcmp(stim_types,'standard'));     %find the indices of the epochs corresponding to the presentation of the standard stimulus
idx_target=find(strcmp(stim_types,'target'));         %find the indices of the epochs corresponding to the presentation of the target stimulus
idx_distractor=find(strcmp(stim_types,'distractor')); %find the indices of the epochs corresponding to the presentation of the distractor stimulus

X_standard=X(:,:,idx_standard);     % X_standard is a 3D matrix with size n x m x q_stand where q_stand is the number of the standard epochs
X_target=X(:,:,idx_target);         % X_target is a 3D matrix with size n x m x q_targ where q_targ is the number of the target epochs
X_distractor=X(:,:,idx_distractor); % X_distractor is a 3D matrix with size n x m x q_distr where q_distr is the number of the distractor epochs

%% Stage 03A | Compute within-subject averages at all electrodes

WSA_standard=mean(X_standard,3);     % n x m %average of the epochs corresponding to standard stimulus
WSA_target=mean(X_target,3);         % n x m %average of the epochs corresponding to target stimulus
WSA_distractor=mean(X_distractor,3); % n x m %average of the epochs corresponding to distractor stimulus

%% Stage 03A | Plot WSA waveforms for Fz, Cz, and Pz

time=([0:1:m-1]/srate)*1000; %in ms, from 0 to 1000 ms ( 200 ms is the time of stimulus presentation)
time=time-200; %in ms so time starts from -200 ms and t = 0 ms corresponds to stimulus presentation

ylimits=[-7 7];
location_legend='northeastoutside';

ch_F=12; %Fz
ch_C=30; %Cz
ch_P=47; %Pz

figure
subplot(311)
plot(time,WSA_standard(ch_F,:),time,WSA_target(ch_F,:),time,WSA_distractor(ch_F,:),'linewidth',2);
ylim(ylimits)
set(gca,'xtick',[-200:100:800])
xlabel('time (ms)')
ylabel('\muV')
l=legend('standard','target','distractor');
set(l,'fontsize',7,'location',location_legend)
title(ch_names{ch_F})
grid

subplot(312)
plot(time,WSA_standard(ch_C,:),time,WSA_target(ch_C,:),time,WSA_distractor(ch_C,:),'linewidth',2);
ylim(ylimits)
set(gca,'xtick',[-200:100:800])
xlabel('time (ms)')
ylabel('\muV')
l=legend('standard','target','distractor');
set(l,'fontsize',7,'location',location_legend)
title(ch_names{ch_C})
grid

subplot(313)
plot(time,WSA_standard(ch_P,:),time,WSA_target(ch_P,:),time,WSA_distractor(ch_P,:),'linewidth',2);
ylim(ylimits)
set(gca,'xtick',[-200:100:800])
xlabel('time (ms)')
ylabel('\muV')
l=legend('standard','target','distractor');
set(l,'fontsize',7,'location',location_legend)
title(ch_names{ch_P})
grid

%% Stage 03A | Plot topographical maps of WSA across time windows

frames=[0:0.1:0.7]*srate+0.2*srate; %frames contain the time samples corresponding to the time instants [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7] s
% where 0 s corresponds to the stimulus presentation (0.2 s from the  beginning of the epoch)
n_conditions=3; % number of conditions =3 (standard, target, distractor); this is the number of rows in the figure
n_frames=length(frames); % number of time instants; this is the number of columns in the figure
locs='Standard-10-20-Cap60.locs';
clim=[-7 +7]; %this are microvolts

titles = {'0 ms', '100 ms', '200 ms', '300 ms', ...
      '400 ms', '500 ms', '600 ms', '700 ms'};

figtopo=figure;
for i=1:n_frames
    subplot(n_conditions,n_frames,i)
    start=frames(i)-0.05*srate;
    stop=frames(i)+0.05*srate;
    ta_WSA_standard=mean(WSA_standard(:,start:stop),2);
    topoplot(ta_WSA_standard,locs,'maplimits',clim);
    title(titles{i})  %title([num2str((frames(i)/srate-0.2)*1000),' ms']) %
end

for i=1:n_frames
    subplot(n_conditions,n_frames,i+n_frames)
    start=frames(i)-0.05*srate;
    stop=frames(i)+0.05*srate;
    ta_WSA_target=mean(WSA_target(:,start:stop),2);
    topoplot(ta_WSA_target,locs,'maplimits',clim);
    title(titles{i})  %title([num2str((frames(i)/srate-0.2)*1000),' ms'])
end

for i=1:n_frames
    subplot(n_conditions,n_frames,i+2*n_frames)
    start=frames(i)-0.05*srate;
    stop=frames(i)+0.05*srate;
    ta_WSA_distractor=mean(WSA_distractor(:,start:stop),2);
    topoplot(ta_WSA_distractor,locs,'maplimits',clim);
    title(titles{i})  %title([num2str((frames(i)/srate-0.2)*1000),' ms'])
end
h=colorbar; %values are in microvolt
set(h,'Position',[0.93 0.17 0.01 0.1])

annotation(figtopo,'textbox',...
    [0.95 0.27 0.035 0.036],...
    'String',{'\muV'},...
    'LineStyle','none',...
    'FitBoxToText','off',...
    'FontSize',8);

annotation(figtopo,'textbox',...
    [0.02 0.8 0.09 0.047],...
    'String',{'standard'},...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FitBoxToText','off');

annotation(figtopo,'textbox',...
    [0.02 0.5 0.09 0.047],...
    'String',{'target'},...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FitBoxToText','off');

annotation(figtopo,'textbox',...
    [0.01 0.2 0.09 0.047],...
    'String',{'distractor'},...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FitBoxToText','off');
