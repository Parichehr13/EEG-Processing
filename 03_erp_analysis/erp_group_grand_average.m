%% SOLUTION OF EXERCISE 8b - Suggestion: run one section at a time
%%(IMPORTANT:in one point, you need to use the topoplot function of EEGLAB toolbox. To this aim, before running this file,
% first launch EEGLAB from the Command Window. Then, close the EEGLAB GUI
% and clear the workspace (clear)

%% Exercise 8b Points 1 & 2 - Load the file containing WSA of all subjects and compute the Grand Averages
 
clear
close all
clc

load WSA_allsubjects.mat

GA_standard=mean(WSA_standard_allsubj,3);     %n=60 chans x 500 samples
GA_target=mean(WSA_target_allsubj,3);         %n=60 chans x 500 samples 
GA_distractor=mean(WSA_distractor_allsubj,3); %n=60 chans x 500 samples 

%% Exercise 8b Point 3 - Plot the GA waveforms for channels Fz, Cz, Pz in the three conditions

ch_F=12; %Fz
ch_C=30; %Cz
ch_P=47; %Pz

[n,m]=size(GA_standard);

time=([0:1:m-1]/srate)*1000; %in ms, from 0 to 1000 ms (200 ms is stimulus presentation)
time=time-200; %in ms %so time starts from -200 ms and t = 0 ms correspond to stimulus presentation

ylimits=[-3 3];
location_legend='northeastoutside';

figure
subplot(311)
plot(time,GA_standard(ch_F,:),time,GA_target(ch_F,:),time,GA_distractor(ch_F,:),'linewidth',2);
ylim(ylimits)
set(gca,'xtick',[-200:100:800])
xlabel('time (ms)')
ylabel('\muV')
l=legend('standard','target','distractor');
set(l,'fontsize',7,'location',location_legend)
title(ch_names{ch_F})
grid

subplot(312)
plot(time,GA_standard(ch_C,:),time,GA_target(ch_C,:),time,GA_distractor(ch_C,:),'linewidth',2);
ylim(ylimits)
set(gca,'xtick',[-200:100:800])
xlabel('time (ms)')
ylabel('\muV')
l=legend('standard','target','distractor');
set(l,'fontsize',7,'location',location_legend)
title(ch_names{ch_C})
grid

subplot(313)
plot(time,GA_standard(ch_P,:),time,GA_target(ch_P,:),time,GA_distractor(ch_P,:),'linewidth',2);
ylim(ylimits)
set(gca,'xtick',[-200:100:800])
xlabel('time (ms)')
ylabel('\muV')
l=legend('standard','target','distractor');
set(l,'fontsize',7,'location',location_legend)
title(ch_names{ch_P})
grid

%% Exercise 8b Point 4 - Plot the topographical maps of GA at different times, for the three conditions

frames = [0.2:0.1:0.9]*srate;
n_condition=3; % number of conditions =3 (standard target distractor)
n_frames=length(frames);
locs='Standard-10-20-Cap60.locs';
clim=[-3 +3]; %this are microvolts

titles = {'0 ms', '100 ms', '200 ms', '300 ms', ...
      '400 ms', '500 ms', '600 ms', '700 ms'};

figtopo=figure;
for i=1:n_frames
    subplot(n_condition,n_frames, i);
    start = frames(i)-0.05*srate;
    stop = frames(i)+0.05*srate;
    ta_GA_standard = mean(GA_standard(:, start:stop), 2);
    topoplot(ta_GA_standard, locs,'maplimits',clim);
    title(titles{i})  %title([num2str((frames(i)/srate-0.2)*1000),' ms'])
end
for i=1:n_frames
    subplot(n_condition,n_frames, i+n_frames);
    start = frames(i)-0.05*srate;
    stop = frames(i)+0.05*srate;
    ta_GA_target = mean(GA_target(:, start:stop), 2);
    topoplot(ta_GA_target, locs,'maplimits',clim);
    title(titles{i})  %title([num2str((frames(i)/srate-0.2)*1000),' ms'])
end
for i=1:n_frames
    subplot(n_condition,n_frames, i+2*n_frames);
    start = frames(i)-0.05*srate;
    stop = frames(i)+0.05*srate;
    ta_GA_distractor = mean(GA_distractor(:, start:stop), 2);
    topoplot(ta_GA_distractor, locs,'maplimits',clim);
    title(titles{i})  %title([num2str((frames(i)/srate-0.2)*1000),' ms'])
end
h=colorbar;
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

