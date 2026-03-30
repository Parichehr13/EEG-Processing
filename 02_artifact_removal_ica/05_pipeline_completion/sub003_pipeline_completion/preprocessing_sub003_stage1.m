%% SOLUTION OF EXERCISE 1 - Suggestion: run one section at a time

%% Exercise 1 Point 1 - Load the data; transform from single to double precision

clear
close all
clc

load(['sub-003_ses-01_task-Rest_eeg.mat'])  %it contains X(=data), srate, stim_samples, stim_types

X=double(X); %double precision

[n_or,m_or]=size(X); % n_or= original number of channels=59; m_or=original number of samples before resampling

%% Exercise 1 Point 2 - Possible Resampling (here, resampling is not applied)

p=1;
q=1; %resample at P/Q time the original sampling rate
srate_or=srate; %original sampling rate
srate=srate_or*p/q; %new sampling rate

Xresampled=resample(X',p,q)'; %59 x number of samples
X=Xresampled; %at each step, X is overwritten 

[n,m]=size(Xresampled); % n=number of channels=59; m=number of samples after resampling; here m = m_or (no resampling)

% the stim_samples must be recomputed considering the new sampling
% frequency
stim_samples_or=stim_samples; %original time samples of the stimuli
stim_samples=floor(stim_samples_or*p/q); %time samples of the stimuli recomputed considering the new Fs

%% Exercise 1 Point 3 - Linear Detrending

Xdetrended=detrend(X')'; 
X=Xdetrended;

%% Exercise 1 Point 4 - Plot the signals over the entire duration 

[n, m]=size(X); % n=number of channels=59; m=number of samples after resampling; here m = m_or

t=[0:1:m-1]/srate;

start=1;
stop=m;   % full trace

%use the following trick to visualize all signals in the same plot

delta=100;

figure % entire duration
for i = 1:n
    plot(t(start:stop), X(i,start:stop)-delta*(i-1),'color',[0 0 0],'linewidth',1);
    hold on
end
xlim([t(start) t(stop)])
ylim([-delta*n delta])
xlabel('sec')
ylabel('\muV')
title('detrended EEG signals')
set(gca,'ytick',[-delta*(n-1):delta:0])
set(gca,'ytickLabel',fliplr(ch_names))
set(gca,'fontsize',11)
grid

%% Exercise 1 Point 5 - Compute the power spectrum density of all signals and plot the PSD of electrodes n.10,11,53

window=srate*10; % window of 10 seconds (usually I use window of 5 sec and then zero padding to 10 sec)
NFFT=window;  % not use zero padding here as it introduces artifacts in the power spectra

start=1;
stop=m; %entire duration

[PSD_unfiltered,f]=pwelch(X(:,start:stop)',window,[],NFFT,srate); 
% f from 0 to 125 with 0.1 Hz step, number of frequencies n_fr = 1251 
% PSD_unfiltered: n_fr x n (each column is the power spectrum density of one channel)

% %in the following figures (commented), all  power spectra are plotted. In almost all channels the power spectra
% %appear flat since at low frequencies they assume much larger values than
% %at other frequencies. In case, you may limit the y-axis to improve visualization
% figure
% for i = 1:20
%     subplot(4,5,i)
%     plot(f(1:end), PSD_unfiltered(1:end,i),'k','linewidth',1);
%     title(ch_names{i})
%     xlim([0 80])
%     ylim([0 50])
%     xlabel('Hz')
%     ylabel('{\muV}^2/Hz')
% end
% sgtitle('PSD unfitered signals')
% 
% figure
% for i = 21:40
%     subplot(4,5,i-20)
%     plot(f(1:end), PSD_unfiltered(1:end,i),'k','linewidth',1);
%     title(ch_names{i})
%     xlim([0 80])
%     ylim([0 50])
%     xlabel('Hz')
%     ylabel('{\muV}^2/Hz')
% end
% sgtitle('PSD unfitered signals')
% 
% figure
% for i = 41:59
%     subplot(4,5,i-40)
%     plot(f(1:end), PSD_unfiltered(1:end,i),'k','linewidth',1);
%     title(ch_names{i})
%     xlim([0 80])
%     ylim([0 50])
%     xlabel('Hz')
%     ylabel('{\muV}^2/Hz')
% end
% sgtitle('PSD unfitered signals')

%Focus on F4 = 14
figure
plot(f(1:end), PSD_unfiltered(1:end,14),'k','linewidth',1);
xlim([0 80])
ylim([0 50])
xlabel('Hz')
ylabel('{\muV}^2/Hz')
title(['PSD of unfiltered ' ch_names{14}])

%Focus on T8 = 34
figure
plot(f(1:end), PSD_unfiltered(1:end,34),'k','linewidth',1);
xlim([0 80])
ylim([0 50])
xlabel('Hz')
ylabel('{\muV}^2/Hz')
title(['PSD of unfiltered ' ch_names{34}])

%Focus on Oz = 58
figure
plot(f(1:end), PSD_unfiltered(1:end,58),'k','linewidth',1);
xlim([0 80])
ylim([0 50])
xlabel('Hz')
ylabel('{\muV}^2/Hz')
title(['PSD of unfiltered ' ch_names{58}])

%% Exercise 1 Point 6 - Filtering with FIR filter (Kaiser window) COMMENTED 
% %I have commented this part but left here as an example of FIR filter application

% %LOW-PASS FIR FILTER
% Fedges=[60 80];
% Mags=[1 0];
% Devs=[0.05 0.01];
% [N,Wn,beta,ftype] = kaiserord(Fedges,Mags,Devs,srate);%the order ot the FIR filter N = 56
% b=fir1(N,Wn,ftype,kaiser(N+1,beta));
% figure
% freqz(b,1,srate*10,srate)
% 
% XFIR_lp=filter(b,1,X,[],2); % the filtered signals are delayed by N/2 samples
% 
% [n, m] = size(XFIR_lp); % n=number of channels=59; m=number of samples after resampling; here m = m_or
%  
% %  This figure shows that the FIR-filtered signals are delayed by N/2 samples 
% %  compared to the unfiltered signals: to appreciate this, zoom over a peak 
% figure
% plot(t,X(1,:),'k')
% hold on
% plot(t,XFIR_lp(1,:),'r')
%  
% %  IMPORTANT: time delay compensation of FIR filtered signal
% %  so to obtain a zero-phase filter in bandpass
% XFIR_lp(:,1:N/2)=[]; %elimination of the first N/2 values, the FIR-filtered signals will have m-N/2 time samples
% 
% figure
% plot(t(1:m-N/2),X(1,1:m-N/2),'k')
% hold on
% plot(t(1:m-N/2), XFIR_lp(1,:),'r')  
 
%% Exercise 1 Point 6 - Filtering (low-pass, high-pass, notch) with IIR filters (elliptic) 

%I have separated low-pass and high-pass as it seems there is less risk of
%instabilty of the filter
%LOW-PASS FILTERING
Wp = [60]/(srate/2); 
Ws = [80]/(srate/2); 
Rp = 0.1;
Rs = 40;
[N,Wp] = ellipord(Wp,Ws,Rp,Rs);
[b,a] = ellip(N,Rp,Rs,Wp);
%%uncomment following rows to visualize the frequency response of the filter
figure
freqz(b,a,srate*10,srate)
title('Frequency response Low Pass Filter')
X_IIR_lp=filtfilt(b,a,X')'; %with filtfilt is a zero-phase filter;
X=X_IIR_lp;

%HIGH-PASS FILTERING
Wp = [0.5]/(srate/2);    
Ws = [0.01]/(srate/2); 
Rp = 0.1;
Rs = 40;
[N,Wp] = ellipord(Wp,Ws,Rp,Rs);
[b,a] = ellip(N,Rp,Rs,Wp,'high');
%%uncomment following rows to visualize the frequency response of the filter
figure
freqz(b,a,srate*10,srate)
title('Frequency response High Pass Filter')
X_IIR_hp=filtfilt(b,a,X')'; %with filtfilt is a zero-phase filter;
X=X_IIR_hp;

%STOP-BAND FILTERING (NOTCH)
Wo = 60/(srate/2);  BW = Wo/45;
[b,a] = iirnotch(Wo,BW);  
%%uncomment following rows to visualize the frequency response of the filter
figure
freqz(b,a,srate*10,srate)
title('Frequency response Notch Filter')
X_IIR_sp=filtfilt(b,a,X')'; %with filtfilt is a zero-phase filter;
X=X_IIR_sp;

%% Exercise 1 Point 7 - Plot the filtered signals over the entire duration

[n, m] = size(X); % n=number of channels=59; m=number of samples after resampling

t=[0:1:m-1]/srate;

start=1;
stop=m;   % full trace

%use this trick to visualize all signals in the same plot

delta=100;

figure % entire duration
for i = 1:n
    plot(t(start:stop), X(i,start:stop)-delta*(i-1),'color',[0 0 0],'linewidth',1);
    hold on
end
xlim([t(start) t(stop)])
ylim([-delta*n delta])
xlabel('sec')
ylabel('\muV')
set(gca,'ytick',[-delta*(n-1):delta:0])
set(gca,'ytickLabel',fliplr(ch_names))
set(gca,'fontsize',11)
grid
title('Filtered EEG signals')

%% Exercise 1 Point 8 - Compute the power spectrum density of all filtered signals and compare the PSD before vs after filtering (electr. 10,11,53)

window=srate*10; 
NFFT=window;  

start=1;
stop=m; %entire duration

[PSD_filtered,f]=pwelch(X(:,start:stop)',window,[],NFFT,srate); 
% f from 0 to 250 with 0.1 Hz step, number of frequencies n_fr = 2501 
% PSD_filtered n_fr x n (each column is the power spectrum density of one channel)

% %figures (commented) with PSD of all signals before and after filtering
% %(y-axis limited between 0 100)
% figure
% for i = 1:20
%     subplot(4,5,i)
%     hold on
%     plot(f(1:end), PSD_unfiltered(1:end,i),'k','linewidth',1);
%     plot(f(1:end), PSD_filtered(1:end,i),'m','linewidth',1);
%     title(ch_names{i})
%     xlim([0 80])
%     ylim([0 50])
%     xlabel('Hz')
%     ylabel('{\muV}^2/Hz')
% end
% sgtitle('PSD unfitered & filtered signals')
% 
% figure
% for i = 21:40
%     subplot(4,5,i-20)
%     hold on
%     plot(f(1:end), PSD_unfiltered(1:end,i),'k','linewidth',1);
%     plot(f(1:end), PSD_filtered(1:end,i),'m','linewidth',1);
%     title(ch_names{i})
%     xlim([0 80])
%     ylim([0 50])
%     xlabel('Hz')
%     ylabel('{\muV}^2/Hz')
% end
% sgtitle('PSD unfitered & filtered signals')
% 
% figure
% for i = 41:59
%     subplot(4,5,i-40)
%     hold on
%     plot(f(1:end), PSD_unfiltered(1:end,i),'k','linewidth',1);
%     plot(f(1:end), PSD_filtered(1:end,i),'m','linewidth',1);
%     title(ch_names{i})
%     xlim([0 80])
%     ylim([0 50])
%     xlabel('Hz')
%     ylabel('{\muV}^2/Hz')
% end
% sgtitle('PSD unfitered & filtered signals')

%Focus on F4 = 14
figure
plot(f(1:end), PSD_unfiltered(1:end,14),'k','linewidth',1);
hold on
plot(f(1:end), PSD_filtered(1:end,14),'m','linewidth',1);
xlim([0 80])
ylim([0 50])
xlabel('Hz')
ylabel('{\muV}^2/Hz')
title(['PSD of unfiltered & filtered ' ch_names{14}])
legend('unfiltered','filtered')

%Focus on T8 = 34
figure
plot(f(1:end), PSD_unfiltered(1:end,34),'k','linewidth',1);
hold on
plot(f(1:end), PSD_filtered(1:end,34),'m','linewidth',1);
xlim([0 80])
ylim([0 50])
xlabel('Hz')
ylabel('{\muV}^2/Hz')
title(['PSD of unfiltered & filtered ' ch_names{34}])
legend('unfiltered','filtered')

%Focus on Oz = 58
figure
plot(f(1:end), PSD_unfiltered(1:end,58),'k','linewidth',1);
hold on
plot(f(1:end), PSD_filtered(1:end,58),'m','linewidth',1);
xlim([0 80])
ylim([0 50])
xlabel('Hz')
ylabel('{\muV}^2/Hz')
title(['PSD of unfiltered & filtered ' ch_names{53}])
legend('unfiltered','filtered')

%% Exercise 1 Point 9 - Plot the markers of the events over the n filtered signals 

%close all previous figures
close all

[n, m] = size(X); %can be commented 

t=[0:1:m-1]/srate;

start=1;
stop=m;   % full trace

delta=100;

figure 
for i = 1:n
    plot(t(start:stop), X(i,start:stop)-delta*(i-1),'color',[0 0 0],'linewidth',1);
    hold on
end
xlim([t(start) t(stop)])
ylim([-delta*n delta])
xlabel('sec')
ylabel('\muV')
title('filtered EEG signals')
set(gca,'ytick',[-delta*(n-1):delta:0])
set(gca,'ytickLabel',fliplr(ch_names))
set(gca,'fontsize',11)
grid

for i=1:length(stim_samples)
    if strcmp(stim_types{i},'target')
        color=[0 0.9 0]; %green
    elseif strcmp(stim_types{i},'standard')
        color=[1 0 1]; % violet
    elseif strcmp(stim_types{i},'distractor')
        color=[0 0.5 1]; % light blue
    end
    plot([(stim_samples(i)-1)/srate (stim_samples(i)-1)/srate], [-delta*n delta], 'color',color,'linewidth',0.5)   
end

% %During the first part of recording no stimulus was applied
% %In the second part, two block of stimuli were applied separated by 
% %about 1 minutes. 
% %We can limit x-axis (uncomment followin instruction)
%xlim([300 650])
        
%% Exercise 1 Point 10 - Extract epochs [-0.2 0.8]s around each stimulus presentation--> 3-D matrix

epoch_lim=[-0.2 0.8]; %in seconds
% n = 59 is the number of channels in the epochs 
m_ep=(epoch_lim(2)-epoch_lim(1))*srate; %number of samples in the epochs =500; 
r=length(stim_samples); %number of epochs

Xepoched=zeros(n,m_ep,r); %initialization of the 3-D matrix 
for i=1:r
    lim1=stim_samples(i)+epoch_lim(1)*srate;
    lim2=stim_samples(i)+epoch_lim(2)*srate-1; 
    Xepoched(:,:,i)=X(:,lim1:lim2);
end

X=Xepoched; % 3D matrix with size n x m_ep x r

%% Exercise 1 Point 11 - Concatenation of extracted epochs 3-D matrix --> 2-D matrix

[n,m_ep,r]=size(X);
Xconcat=reshape(X,n,m_ep*r);
X=Xconcat;

% I also plot the epoch-concatenated data
[n,m_conc]=size(X); %n=numb of chans=n_ep=59; m_conc = numb of samples in the epoch_concatenated data

t=[0:1:m_conc-1]/srate;

start=1;
stop=m_conc;

delta=100;

figure % entire duration of the epoch_concatenated data 
for i = 1:n
    plot(t(start:stop),X(i,start:stop)-delta*(i-1),'color',[0 0 0],'linewidth',1);
    hold on
end
xlim([t(start) t(stop)])
ylim([-delta*n delta])
xlabel('sec')
ylabel('\muV')
set(gca,'ytick',[-delta*(n-1):delta:0])
set(gca,'ytickLabel',fliplr(ch_names))
set(gca,'fontsize',11)
grid
title('epoched EEG signals (concatenated)')

%% Exercise 1 Point 12 - Identification and plot of bad channels 

[n,m_conc]=size(X); %can be commented

load nearby_channels

correlation=zeros(n,1);
for c=1:n
    index_ch=nearby_ch{c};
    aux=abs(corr(X(c,:)',X(index_ch,:)'));
    correlation(c)=mean(aux);
end
M_Corr=mean(correlation); %average behavior 
S_Corr=std(correlation);  %standard deviation
th=M_Corr-3*S_Corr; %threshold
index_bad=find(correlation<th) %indeces of bad channels (here only one channel results bad)
ch_names_bad=ch_names(index_bad)

index_good=setdiff([1:n],index_bad);
ch_names_good=ch_names(index_good);

% %the following commented rows compute the average correlation of each channel with all
% %other channels rather than with only nearby channels
% Corrmatrix=corr(Xepoched_conc'); %59 x 59
% abs_Corrmatrix=abs(Corrmatrix);
% MeanCorr=(sum(abs_Corrmatrix,2)-1)/(n-1); %I exclude autocorrelation
% %MeanCorr is a n x 1 vector, each element is the average correlation of
% %each channel with all other channels
% M_MeanCorr=mean(MeanCorr); %average behavior 
% S_MeanCorr=std(MeanCorr);  %standard deviation
% th=M_MeanCorr-3*S_MeanCorr; %threshold
% index_bad=find(MeanCorr<th) %indeces of bad channels (here only one channel results bad)
% ch_names_bad=ch_names(index_bad)

%the following figure highlights in red the identified bad channels
t=[0:1:m_conc-1]/srate;

start=1;
stop=m_conc;   % full trace

delta=100;

figure 
for i = 1:n
    if ismember(i,index_bad)
        colore=[1 0 0];
    else
        colore=[0 0 0];
    end
    plot(t(start:stop), X(i,start:stop)-delta*(i-1),'color',colore,'linewidth',1);
    hold on
end
xlim([t(start) t(stop)])
ylim([-delta*n delta])
xlabel('sec')
ylabel('\muV')
title('filtered,epoch-concatenated EEG signals')
set(gca,'ytick',[-delta*(n-1):delta:0])
set(gca,'ytickLabel',fliplr(ch_names))
set(gca,'fontsize',11)
grid

%% Exercise 1 Point 13 - Removal of bad channels

Xgood=X(index_good,:);
X=Xgood; % n_good x m_conc where n_good = total number of recorded channels (=59) minus the number of identified bad channels. Here only
% one channel is identified as bad, thus n_good = 58

%% Exercise 1 Point 14 - Saving at the end of these pre-processing steps

save sub-003_PreprocessStep1 X ch_names srate stim_types index_bad index_good


