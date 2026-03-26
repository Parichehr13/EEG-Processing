
%% Exercise 3 Point 1 - Load the file and plot the 19 EEG signals in time (before artifact correction)

clear
close all
clc

load EYES_OPEN.mat

[n,m] = size(X); % n channels, m time samples

t=[0:1:m-1]/srate; % time axis in seconds


% plot the first 30 seconds of the tracing 
start=1;
stop=30*srate; %m;
delta=100;

figure
for i = 1:n
    plot(t(start:stop), X(i,start:stop)-delta*(i-1), 'k','linewidth',1);
    hold on
end
xlim([t(start) t(stop)])
ylim([-delta*n delta])
xlabel('time (s)')
ylabel('\muV')
title('EEG signals (before artifact correction)')
set(gca,'ytick',[-delta*(n-1):delta:0])
set(gca,'ytickLabel',fliplr(ch_names))
set(gca,'fontsize',11)
grid

%% Exercise 3 Point 2 - Compute and plot the power spectral density of the 19 EEG signals (before artifact correction)

window=srate*5;  %I use sections of 5 seconds (number of points per section = 5*srate=5*128)
NFFT=2*window; %number of points used for estimation of PSD = 10*srate-->zero-padding to increase
% frequency resolution up to 0.1 Hz  (freq res = srate/NFFT = srate/(10*srate)=0.1)
[PSD,f]=pwelch(X',window,[],NFFT,srate); %each column of PSD contains the power spectral
% density of the corresponding column of X', that is the i-th column of PSD
% contains the PSD of the i-th EEG channel

figure
for i = 1:n
    subplot(4,5,i)
    plot(f, PSD(:,i),'color',[0 0 0],'linewidth',1);
    title(ch_names{i})
    xlim([0.5 50])
    xlabel('Hz');
    ylabel('{\muV}^2/Hz')  
end
sgtitle('PSD of EEG signals (before artifact correction)')

%% Exercise 3 Point 3 - Save the EEG data X for their use in EEGLAB

%%comment the following instruction after the first usage
%save dataExercise3.mat X

%% Exercise 3 Point 4  - Perform ICA and obtain the demixing matrix (using the GUI of EEGLAB)
% Follow the instructions in the text of Exercise 3: in eeglab, import dataExercise3.mat, compute and export the demixing
% matrix (here saved in matrixW_Exercise3.txt), plot the topographical maps and save them in a .fig file (here
% mapICs_Exercise3.fig)

%% Exercise 3 Point 5 - Load the demixing matrix, compute and plot the ICs as a function of time

load matrixW_Exercise3.txt 
W=matrixW_Exercise3;
A=inv(W); % mixing matrix A obtained by inverting the demixing matrix W
Y=W*X;  % Y contains the estimated independent components (n x m)

labels_IC=cell(1,size(Y,1)); % 1 x n
for i=1:size(Y,1)
    labels_IC{i}=['IC',num2str(i)];
end

% I plot 30 seconds 

start=1;
stop=30*srate; 

delta=20;

figure
for i = 1:n
    plot(t(start:stop), Y(i,start:stop)-delta*(i-1), 'k','linewidth',1);
    hold on
end
xlim([t(start) t(stop)])
ylim([-delta*n delta])
xlabel('time (s)')
ylabel('\muV')
title('estimated independent components')
set(gca,'ytick',[-delta*(n-1):delta:0])
set(gca,'yticklabel',fliplr(labels_IC))
set(gca,'fontsize',11)
grid

%% Exercise 3 Point 6 - compute and plot the power spectral density of the estimated ICs

%same parameter setting as for EEG signals (X)
window=5*srate; 
NFFT=2*window; 
[PSD_IC,f]=pwelch(Y',window,[],NFFT,srate);

figure
for i = 1:n
    subplot(4,5,i)
    plot(f, PSD_IC(:,i),'k','linewidth',1);
    title(labels_IC{i})
    xlim([0.5 50])
    xlabel('Hz')
    ylabel('{\muV}^2/Hz')
    grid
end
sgtitle('PSD of estimated independent components')

%% Exercise 3 Point 7 - Identification of artifact components via exploration of time pattern, PSD, topographical map
%%you can also open  the figure of the topographical maps created using
%%EEGLAB (uncomment the following instruction)
%openfig('mapICs_Exercise3.fig');

%%I use the next istruction to better explore some ICs (IMPORTANT: since
%%this function uses the topoplot function of EEGLAB toolbox, you need
%%first to launch EEGLAB (then you can close the EEGLAB GUI). In general,
%%it is useful to inspect all the ICs using the function plot_IC.m. 
index_IC=[1,2,19];
plot_IC(index_IC,A,Y,PSD_IC,f,'Standard-10-20-Cap19.locs',srate,t(1),t(end))

%%IC1 blinking artifact
%%IC2 ECG artifact
%%the first two ICs are the most evident artifact components 
%%IC19 appears as small lateral eye movements associated to blinking 
%%(IC19 has small variance)

%% Exercise 3 Point 8 - Removal of the main artifact components, reconstruction of cleaned EEG, time pattern and PSD of the cleaned EEG

Snew=Y;
Snew([1 2 19],:)=0; % I zero the ICs identified as artifact components

Xnew=A*Snew; % these are the EEG signals cleaned from the identified artifact components

delta=100;

start=1;
stop=30*srate;

figure
for i = 1:n
    plot(t(start:stop), Xnew(i,start:stop)-delta*(i-1), 'k','linewidth',1);
    hold on
end
xlim([t(start) t(stop)])
ylim([-delta*n delta])
xlabel('time (s)')
ylabel('\muV')
title('EEG signals (after artifact correction)')
set(gca,'ytick',[-delta*(n-1):delta:0])
set(gca,'ytickLabel',fliplr(ch_names))
set(gca,'fontsize',11)
grid
% compare the figure 'EEG signals (after artifact correction)' vs 'EEG signals (before artifact correction)'

window=srate*5;
NFFY=2*window; 

[PSDnew,f]=pwelch(Xnew',window,[],NFFT,srate); 

figure
for i = 1:n
    subplot(4,5,i)
    plot(f, PSDnew(:,i),'r','linewidth',1);
    title(ch_names{i})
    xlim([0.5 50])
    xlabel('Hz')
    ylabel('{\muV}^2/Hz')
end
sgtitle('PSD of EEG signals (after artifact correction)')
% compare the figure 'PSD of EEG signals (after artifact correction)' vs s'PSD of EEG signals (before artifact correction)'

% overlapping between PSD of EEG signals before and after artifact
figure
for i = 1:n
    subplot(4,5,i)
    plot(f, PSD(:,i),'k','linewidth',1);
    hold on
    plot(f, PSDnew(:,i),'r','linewidth',1);
    title(ch_names{i})
    xlim([0.5 50])
    xlabel('Hz')
    ylabel('{\muV}^2/Hz')
end
sgtitle('PSD of EEG signals (before vs after artifact correction)')






