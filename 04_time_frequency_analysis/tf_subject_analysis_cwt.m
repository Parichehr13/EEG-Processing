%% SOLUTION OF EXERCISE 9a - Suggestion: run one section at a time
%%(IMPORTANT:in one point, you need to use the topoplot function of EEGLAB toolbox. To this aim, before running this file,
% first launch EEGLAB from the Command Window. Then, close the EEGLAB GUI
% and clear the workspace (clear)
%% Exercise 9a Points 1 & 2 - Load the preprocessed data of a single subject (035 or 003) and apply baseline correction

clear
close all
clc

load sub-003_PreprocessStep2.mat  %sub-035_PreprocessStep2.mat %

[n,m,q]=size(X); %n=number of channels=60; m=number of samples per epoch=500; q=number of epochs(or trials)

baseidx=[1 101]; %indeces of the baseline period %from -200 ms to 0 ms (these are the first 200 ms = 101 samples in each epoch)

%efficient way to remove baseline
baseline=mean(X(:,baseidx(1):baseidx(2),:),2); % n x 1 x q
X_rmb=X-repmat(baseline,1,m,1); % n x m x q %baseline removed trial by trial

%less efficient way (but still correct) to remove baseline
% for i=1:n
%     for j=1:q
%         baseline=mean(X(i,idxbase(1):idxbase(2),j));
%         X_rmb(i,:,j)=X(i,:,j)-baseline;
%     end
% end

X=X_rmb; %baseline removed

%% Exercise 9a Point 3 - Separate the epochs based on the stimulus they correspond to

idx_standard=find(strcmp(stim_types,'standard'));     %find the indices of the epochs corresponding to the presentation of the standard stimulus
idx_target=find(strcmp(stim_types,'target'));         %find the indices of the epochs corresponding to the presentation of the target stimulus
idx_distractor=find(strcmp(stim_types,'distractor')); %find the indices of the epochs corresponding to the presentation of the distractor stimulus

X_standard=X(:,:,idx_standard);
X_target=X(:,:,idx_target);
X_distractor=X(:,:,idx_distractor);

%% Exercise 9a Point 4 - For standard condition, compute the TF power for each channel epoch by epoch and average across epochs 

flimits=[3.125 50]; %Hz, defines the frequency limits to use in cwt; since the 
%limits are at 4 octave distance and cwt uses 10 voices per octave, overall cwt 
%will be computed at 41 frequency values
%By default 10 voices per octave 50-->25-->12.5-->6.25-->3.125 (4 octave) =
%41 values in frequency (F=2.^[log2(50):-1/10:log2(3.125)]')
n_f=41; %overall number of frequencies at which cwt will be computed
%number of time points used for the cwt = m;
%number of channels = n;
q_stand=size(X_standard,3); %number of standard epochs

TF_Power_epoch_standard=zeros(n_f,m,q_stand); % initialization of a variable to be 
%used in the following for loops
TF_Power_mean_standard=zeros(n_f,m,n); % initialization of a variable to be used
%in the following for loops
%After computation, TF_Power_mean_standard will contains abs(cwt.^2) at each channel
%averaged across all q_stand epochs
for i=1:n %external for loop, iteration over channels
    i; %if you remove semicolon on this, you can see the progression of the computation
    for j=1:q_stand %internal for loop, iteration on epochs
        [C,F] = cwt(X_standard(i,:,j),'amor',srate,'frequencylimits',flimits);
        %C (n_f x m) contains the cwt coefficients of the i-th channel signal in
        %the j-th epoch. Each row corresponds to a frequency value, each
        %column corresponds to a time value
        TF_Power_epoch_standard(:,:,j)=abs(C).^2; %in the j-th page, it contains 
        %the TF power of the i-th channel signal in the j-th epoch
    end
    TF_Power_mean_standard(:,:,i)=mean(TF_Power_epoch_standard,3); %in the i-th page,
    %it contains the TF power of the i-th channel averaged across epochs
end

%TF_Power_mean_standard is a n_f x m x n, containing in the i-th page the 
%TF power of the i-th channel, averaged across all standard epochs. 
%In each page, each row refers to a frequency value, 
%each column refers to a time value

%% Exercise 9a Point 5 - For target and distractor condition, compute the TF power for each channel epoch by epoch and average across epochs 
%Repeat the same steps as in the previous section
q_targ=size(X_target,3); %number of target epochs

TF_Power_epoch_target=zeros(n_f,m,q_targ); 
TF_Power_mean_target=zeros(n_f,m,n);  
%After computation, TF_Power_mean_target will contains abs(cwt.^2) at each channel
%averaged across all q_targ epochs
for i=1:n
    i;
    for j=1:q_targ
        [C,F] = cwt(X_target(i,:,j),'amor',srate,'frequencylimits',flimits);
        TF_Power_epoch_target(:,:,j)=abs(C).^2; 
    end
    TF_Power_mean_target(:,:,i)=mean(TF_Power_epoch_target,3); 
end

%TF_Power_mean_target is a n_f x m x n, containing in the i-th page the 
%TF power of the i-th channel, averaged across all target epochs. 
%In each page, each row refers to a frequency value, 
%each column refers to a time value

q_distr=size(X_distractor,3); %number of distractor epochs

TF_Power_epoch_distractor=zeros(n_f,m,q_distr); 
TF_Power_mean_distractor=zeros(n_f,m,n); 
%After computation, TF_Power_mean_distractor will contains the coefficient abs(cwt.^2) at each channel
%averaged across all q_distr epochs
for i=1:n
    i;
    for j=1:q_distr
        [C,F] = cwt(X_distractor(i,:,j),'amor',srate,'frequencylimits',flimits);
        TF_Power_epoch_distractor(:,:,j)=abs(C).^2; 
    end
    TF_Power_mean_distractor(:,:,i)=mean(TF_Power_epoch_distractor,3); 
end

%TF_Power_mean_distractor is a n_f x m x n, containing in the i-th page the 
%TF power of the i-th channel, averaged across all distractor epochs. 
%In each page, each row refers to a frequency value, 
%each column refers to a time value

%% Exercise 9a Point 6 - For each frequency, normalize with respect to the mean in the baseline period

baseidx=[1 101]; %indices of the baseline period

baseline_standard=mean(TF_Power_mean_standard(:,baseidx(1):baseidx(2),:),2); %n_f x 1 x n
TF_Power_standard=TF_Power_mean_standard./baseline_standard; %n_f x m x n

baseline_target=mean(TF_Power_mean_target(:,baseidx(1):baseidx(2),:),2);     %n_f x 1 x n
TF_Power_target=TF_Power_mean_target./baseline_target;       %n_f x m x n

baseline_distractor=mean(TF_Power_mean_distractor(:,baseidx(1):baseidx(2),:),2);    %n_f x 1 x n 
TF_Power_distractor=TF_Power_mean_distractor./baseline_distractor;  %n_f x m x n

%% Exercise 9a Point 7 - Generate colormaps (3 x 3 subplots) representing the TF power (in dB) at three channels in the three conditions

times=([0:1:m-1]/srate)*1000; %in ms, from 0 to 1000 ms (200 ms is the time of stimulus presentation)
times=times-200; %in ms %so time starts from -200 ms and t = 0 ms correspond to stimulus presentation
frequencies=F;
clim=[-6 6]; %

figure
ch=12; %Fz
subplot(331)
TF_colormap(times,frequencies,TF_Power_standard(:,:,ch),clim,['standard ',ch_names{ch}])
subplot(334)
TF_colormap(times,frequencies,TF_Power_target(:,:,ch),clim,['target ',ch_names{ch}])
subplot(337)
TF_colormap(times,frequencies,TF_Power_distractor(:,:,ch),clim,['distractor ',ch_names{ch}])

ch=30; %Cz
subplot(332)
TF_colormap(times,frequencies,TF_Power_standard(:,:,ch),clim,['standard ',ch_names{ch}])
subplot(335)
TF_colormap(times,frequencies,TF_Power_target(:,:,ch),clim,['target ',ch_names{ch}])
subplot(338)
TF_colormap(times,frequencies,TF_Power_distractor(:,:,ch),clim,['distractor ',ch_names{ch}])

ch=47; %Pz
subplot(333)
TF_colormap(times,frequencies,TF_Power_standard(:,:,ch),clim,['standard ',ch_names{ch}])
subplot(336)
TF_colormap(times,frequencies,TF_Power_target(:,:,ch),clim,['target ',ch_names{ch}])
subplot(339)
TF_colormap(times,frequencies,TF_Power_distractor(:,:,ch),clim,['distractor ',ch_names{ch}])

%% Exercise 9a Point 8 - Generate topographical scalp maps (3 x 8 subplots) of the time evolution of alpha power (in dB)


alphalim=dsearchn(F,[8 14]'); %alphalim contains the indices of the values in F 
%closest to value 8 and to value 14. 
TF_Power_standard_alpha=squeeze(mean(TF_Power_standard(alphalim(2):alphalim(1),:,:),1));
%TF_Power_standard_alpha is a m x n matrix (m time points x n channels)
TF_Power_target_alpha=squeeze(mean(TF_Power_target(alphalim(2):alphalim(1),:,:),1));
%TF_Power_target_alpha is a m x n matrix (m time points x n channels)
TF_Power_distractor_alpha=squeeze(mean(TF_Power_distractor(alphalim(2):alphalim(1),:,:),1));
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
    ta_alpha_standard=mean(TF_Power_standard_alpha(start:stop,:),1);
    topoplot(10*log10(ta_alpha_standard),locs,'maplimits',clim);
    title(titles{i})  
end

for i=1:n_frames
    subplot(n_conditions,n_frames,i+8)
    start=frames(i)-0.05*srate;
    stop=frames(i)+0.05*srate;
    ta_alpha_target=mean(TF_Power_target_alpha(start:stop,:),1);
    topoplot(10*log10(ta_alpha_target),locs,'maplimits',clim);
    title(titles{i})  %title([num2str((frames(i)/srate-0.2)*1000),' ms']) %
end

for i=1:n_frames
    subplot(n_conditions,n_frames,i+16)
    start=frames(i)-0.05*srate;
    stop=frames(i)+0.05*srate;
    ta_alpha_distractor=mean(TF_Power_distractor_alpha(start:stop,:),1);
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
