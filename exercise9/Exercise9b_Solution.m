%% SOLUTION OF EXERCISE 9b - Suggestion: run one section at a time
%%(IMPORTANT:in one point, you need to use the topoplot function of EEGLAB toolbox. To this aim, before running this file,
% first launch EEGLAB from the Command Window. Then, close the EEGLAB GUI
% and clear the workspace (clear)
%% Exercise 9b Points 1 - Load the time-frequency power averaged across subjecs

clear
close all
clc

load TF_Power_GA

%% Exercise 9b Point 2 - Generate colormaps (3 x 3 subplot) representing the TF power (in dB) at three channels in the three conditions

m=size(TF_Power_standard_GA,2);
times=([0:1:m-1]/srate)*1000; %in ms, from 0 to 1000 ms (200 ms is the time of stimulus presentation)
times=times-200; %in ms %so time starts from -200 ms and t = 0 ms correspond to stimulus presentation
freqlims=[3.125 50]; 
%by default 10 voices per octave 50-->25-->12.5-->6.25-->3.125 (4 octave) =
%41 values in frequency (log2(3.125)=1.6439, 2^1.5439=2.9157) 
frequencies= F; %2.^[log2(50):-1/10:log2(3.125)]';
clim=[-3 3]; 

figure
ch=12; %Fz
subplot(331)
TF_colormap(times,frequencies,TF_Power_standard_GA(:,:,ch),clim,['standard ',ch_names{ch}])
subplot(334)
TF_colormap(times,frequencies,TF_Power_target_GA(:,:,ch),clim,['target ',ch_names{ch}])
subplot(337)
TF_colormap(times,frequencies,TF_Power_distractor_GA(:,:,ch),clim,['distractor ',ch_names{ch}])

ch=30; %Cz
subplot(332)
TF_colormap(times,frequencies,TF_Power_standard_GA(:,:,ch),clim,['standard ',ch_names{ch}])
subplot(335)
TF_colormap(times,frequencies,TF_Power_target_GA(:,:,ch),clim,['target ',ch_names{ch}])
subplot(338)
TF_colormap(times,frequencies,TF_Power_distractor_GA(:,:,ch),clim,['distractor ',ch_names{ch}])

ch=47; %Pz
subplot(333)
TF_colormap(times,frequencies,TF_Power_standard_GA(:,:,ch),clim,['standard ',ch_names{ch}])
subplot(336)
TF_colormap(times,frequencies,TF_Power_target_GA(:,:,ch),clim,['target ',ch_names{ch}])
subplot(339)
TF_colormap(times,frequencies,TF_Power_distractor_GA(:,:,ch),clim,['distractor ',ch_names{ch}])


%% Exercise 9b Point 3 - Generate topographical scalp maps (3 x 8 subplots) of the time evolution of alpha power (in dB)

alphalim=dsearchn(F,[8 14]'); %alphalim contains the indices of the values in F 
%closest to value 8 and to value 14. 
TF_Power_standard_alpha_GA=squeeze(mean(TF_Power_standard_GA(alphalim(2):alphalim(1),:,:),1));
%TF_Power_standard_alpha is a m x n matrix (m time points x n channels)
TF_Power_target_alpha_GA=squeeze(mean(TF_Power_target_GA(alphalim(2):alphalim(1),:,:),1));
%TF_Power_target_alpha is a m x n matrix (m time points x n channels)
TF_Power_distractor_alpha_GA=squeeze(mean(TF_Power_distractor_GA(alphalim(2):alphalim(1),:,:),1));
%TF_Power_distractor_alpha is a m x n matrix (m time points x n channels)

frames=[0:0.1:0.7]*srate+0.2*srate; %frames contain the time samples  %corresponding to the time instants [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7] s
%where 0 s corresponds to the stimulus presentation (0.2 s from the  beginning of the epoch)
n_conditions=3; % number of conditions =3 (standard, target, distractor); this is the number of rows in the figure
n_frames=length(frames); % number of time instants; this is the number of columns in the figure
locs='Standard-10-20-Cap60.locs';
titles = {'0 ms', '100 ms', '200 ms', '300 ms', ...
      '400 ms', '500 ms', '600 ms', '700 ms'};

figtopo=figure;
for i=1:n_frames
    subplot(n_conditions,n_frames,i)
    start=frames(i)-0.05*srate;
    stop=frames(i)+0.05*srate;
    ta_alpha_standard=mean(TF_Power_standard_alpha_GA(start:stop,:),1);
    topoplot(10*log10(ta_alpha_standard),locs,'maplimits',clim);
    title(titles{i})  %title([num2str((frames(i)/srate-0.2)*1000),' ms']) %
end

for i=1:n_frames
    subplot(n_conditions,n_frames,i+8)
    start=frames(i)-0.05*srate;
    stop=frames(i)+0.05*srate;
    ta_alpha_target=mean(TF_Power_target_alpha_GA(start:stop,:),1);
    topoplot(10*log10(ta_alpha_target),locs,'maplimits',clim);
    title(titles{i})  %title([num2str((frames(i)/srate-0.2)*1000),' ms']) %
end

for i=1:n_frames
    subplot(n_conditions,n_frames,i+16)
    start=frames(i)-0.05*srate;
    stop=frames(i)+0.05*srate;
    ta_alpha_distractor=mean(TF_Power_distractor_alpha_GA(start:stop,:),1);
    topoplot(10*log10(ta_alpha_distractor),locs,'maplimits',clim);
    title(titles{i})  %title([num2str((frames(i)/srate-0.2)*1000),' ms']) %
end
h=colorbar; %values are in microvolt
set(h,'Position',[0.93 0.17 0.01 0.1])
sgtitle('alpha power (dB)')

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