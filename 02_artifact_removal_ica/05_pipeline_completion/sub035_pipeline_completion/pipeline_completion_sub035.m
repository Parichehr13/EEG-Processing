%% SOLUTION OF EXERCISE 7 - This is the continuation of Exercise 1 - Suggestion: run one section at a time

%% Exercise 7 Point 1 - Load the .mat file obtained at the end of Exercise 1

clear
close all
clc

load sub-035_PreprocessStep1.mat %Xepoched_conc containes 195 concatenated epochs; each epoch is made up of 500 samples

%% Exercise 7 Point 2 - Save the data for their use in EEGLAB

%%comment the following instruction after the first usage
%save dataExercise7_1.mat X

%% Exercise 7 Point 3  - Perform ICA and obtain the demixing matrix (using the GUI of EEGLAB)
% Follow the instructions in the text of Exercise 7 (in eeglab, import dataExercise7.mat, compute and export the demixing
% matrix (here saved in matrixW_Exercise7.txt), plot the topographical maps of the first 25 ICs (1:25) and save them in a .fig file (here
% mapICs_Exercise7.fig)

%% Exercise 7 Point 4 - Load the demixing matrix, compute the ICs and plot them

load matrixW_Exercise7.txt 
W=matrixW_Exercise7;       

A=inv(W); % mixing matrix A obtained by inverting the demixing matrix W (n_good x n_good = 58 x 58)
Y=W*X;  % Y contains the estimated independent components (58 (n_good) x m_conc); 58 ICs

labels_IC=cell(1,size(Y,1)); % 1 x n
for i=1:size(Y,1)
    labels_IC{i}=['IC',num2str(i)];
end

[n_good,m_conc]=size(X); % 58 x 97500

t=[0:1:m_conc-1]/srate;

start=1;
stop=m_conc;

delta=20;

figure
for i = 1:n_good
    plot(t(start:stop), Y(i,start:stop)-delta*(i-1), 'k','linewidth',1);
    hold on
end
xlim([t(start) t(stop)])
ylim([-delta*n_good delta])
xlabel('time (s)')
ylabel('\muV')
title('estimated independent components of good chans','fontsize',10)
set(gca,'ytick',[-delta*(n_good-1):delta:0])
set(gca,'yticklabel',fliplr(labels_IC))
set(gca,'fontsize',11)
grid

%% Exercise 7 Point 5 - Compute the power spectral density of the ICs

window=5*srate; 
NFFT=2*window; 
[PSD_IC,f]=pwelch(Y',window,[],NFFT,srate);

% figure
% for i=1:n_good
%     subplot(6,10,i)
%     plot(f,PSD_IC(:,i),'k','linewidth',1)
%     xlim([0 50])
%     ylim([0 10])
%     title(labels_IC{i})
% end

%% Exercise 7 Point 6  - Analysis of the ICs (the first 30 ICs) and identification of the artifact components
%%you can also open  the figure of the topographical maps created using
%%EEGLAB (uncomment the following instruction)
%openfig('mapICs_Exercise7.fig');

%%I use the next istructions to better explore  ICs (IMPORTANT: since
%%the function plot_IC uses the topoplot function of EEGLAB toolbox, you need
%%first to launch EEGLAB (then you can close the EEGLAB GUI). 
% plot_IC([1,4,6,11],A,Y,PSD_IC,f,'Standard-10-20-Cap58_good.locs',srate,t(1),t(end))
% plot_IC([1:5],A,Y,PSD_IC,f,'Standard-10-20-Cap58_good.locs',srate,t(1),t(end))
% plot_IC([5:10],A,Y,PSD_IC,f,'Standard-10-20-Cap58_good.locs',srate,t(1),t(end))
% plot_IC([11:15],A,Y,PSD_IC,f,'Standard-10-20-Cap58_good.locs',srate,t(1),t(end))
% plot_IC([16:20],A,Y,PSD_IC,f,'Standard-10-20-Cap58_good.locs',srate,t(1),t(end))
% plot_IC([21:25],A,Y,PSD_IC,f,'Standard-10-20-Cap58_good.locs',srate,t(1),t(end))
% plot_IC([26:30],A,Y,PSD_IC,f,'Standard-10-20-Cap58_good.locs',srate,t(1),t(end))

index_IC_toberemoved=[1,4,6,11,14:25,28,29]; 

%IC1 blink artifact
%IC4 lateral eye movements
%IC6 blink or other ocular artifacts
%IC11 and IC14 seems to contain  EMG artifact  
%IC15  seems to contain other ocular artifacts localized in time
%(saccades?)
%IC16-IC24 artifact on single electrodes (electrode pop?) 
%IC25 EOG artifact and single electrode artifact
%IC28 and IC29 artifact on single electrodes
% also IC26 and IC27 could be eliminated

%% Exercise 7 Point 7  - Reconstruct good channels data cleaned from artifact ICs, and plot good channels before and after artifact removal
Snew=Y;
Snew(index_IC_toberemoved,:)=0;

Xnew=A*Snew; %good channels reconstructed without artifact ICs

ch_names_good=ch_names(index_good);

start=1;
stop=m_conc;

delta=100;

figure  
for i = 1:n_good
    plot(t(start:stop),X(i,start:stop)-delta*(i-1),'color',[0 0 0],'linewidth',1);
    hold on
end
xlim([t(start) t(stop)])
ylim([-delta*n_good delta])
xlabel('sec')
ylabel('\muV')
set(gca,'ytick',[-delta*(n_good-1):delta:0])
set(gca,'ytickLabel',fliplr(ch_names_good))
set(gca,'fontsize',11)
grid
title('epoched-concatenated EEG signals, good chans before ICA','fontsize',10)
 
figure  
for i = 1:n_good
    plot(t(start:stop),Xnew(i,start:stop)-delta*(i-1),'color',[0 0 0],'linewidth',1);
    hold on
end
xlim([t(start) t(stop)])
ylim([-delta*n_good delta])
xlabel('sec')
ylabel('\muV')
set(gca,'ytick',[-delta*(n_good-1):delta:0])
set(gca,'ytickLabel',fliplr(ch_names_good))
set(gca,'fontsize',11)
grid
title('epoched-concatenated EEG signals, good chans after ICA','fontsize',10)

%% Exercise 7 Point 8 - Add back bad channel(s) (all zeros) to the cleaned good channels and save the obtained dataset

n=length(index_good)+length(index_bad); % total number of acquired channels;
Xaux=zeros(n,m_conc); %n = 59; initialization of the variable
Xaux(index_good,:)=Xnew; % good chans data cleaned from artifact are placed at the original rows
%after this operation Xaux contain rows with all zeros at the original
%position of bad chans (here row 11, corresponding to F1)
X=Xaux;

delta=100;

% I check that the bad channel (row of all zeros) has been added back at
% the correct position, by plotting X 
figure  
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
title('epoched-concatenated EEG signals, cleaned good chans + all zeros bad chans','fontsize',10)

%%comment the save instruction after the first usage (this .mat file must
%%be imported in EEGLAB for spherical spline interpolation (SSI) of the
%%bad channel/s). 
%save dataExercise7_2 X

%% Exercise 7 Point 9 - Bad channel interpolation in EEGLAB
%%Follow the instructions reported in Exercise 7: In eeglab import dataExercise7_2.mat, the locs
%%file 'Standard-10-20-Cap59.locs' and indicate the sampling rate. Then,
%%select Tools-->Interpolate electrodes-->Select from data channels--> F1
%%and press ok. Then, in the command window, run the instruction
%%>> Xinterpolated=EEG.data and  
%%>> save dataExercise7_3.mat Xinterpolated

%% Exercise 7 Point 10 -  Re-referencing to Average Reference adding back the online reference electrode (CPz)

load dataExercise7_3.mat % This mat file has been created at point 9 

X=Xinterpolated; % n = 59 x m_conc = 97500 (at row 11 = F1 we now have the interpolated bad channel)

[n,m_conc]=size(X);

delta=100;

% First, I check that the bad channel has been replaced (compare with figure in
% Section 'Exercise 7 - Point 8')
figure  
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
title('epoched-concatenated EEG signals, cleaned good chans + interpolated bad chans','fontsize',10)

%re-referencing and recovering of online reference CPz
X_primed=[X; zeros(1,m_conc)]; %add a row of all zeros; X_primed has size n+1 = 60 x m_conc = 97500 
H=eye(n+1,n+1)-1/(n+1)*ones(n+1,n+1); %average reference operator

XAR_primed=H*X_primed; %60 channels, the last row contains CPz referred to AR

X=XAR_primed; %60 channels

ch_names=[ch_names 'CPz'];

[n,m_conc]=size(X); % now n = 60; m_conc = 97500

delta=100;

figure  
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
title('epoched-concatenated EEG signals, cleaned good chans + interpolated bad chans, AR','fontsize',10)

%% Exercise 7 Point 11 -  Convert the data from 2D to 3D and save

[n,m_conc]=size(X); % n = 60; m_conc = 97500

q=length(stim_types); % q = overall number of epochs

m_ep=m_conc/q; % number of samples per epoch; 
%we already know m_ep = 500 samples, since in Exercise 1 we extracted 1 second per epoch, and srate = 500

X=reshape(X,n,m_ep,q);

save sub-035_PreprocessStep2.mat X ch_names srate stim_types

