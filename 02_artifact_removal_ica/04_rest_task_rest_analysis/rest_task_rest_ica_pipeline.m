%% SOLUTION OF EXERCISE 6 - Suggestion: run one section at a time

%% Exercise 6 Point 1 - Load the file and plot the 13 EEG signals in time

clear
close all
clc

load REST_TASK_REST.mat

[n,m] = size(X); % n channels, m time samples

t=[0:1:m-1]/srate; % time axis in seconds


%%uncomment the following to plot the entire tracing 
start=1;  
stop=m;  

%%uncomment the following to plot 30 seconds of the tracing 
% start=135*srate;  
% stop=165*srate;  

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

%% Exercise 6 Point 2 - Compute and plot the power spectral density of the 13 EEG signals (before artifact correction)

window=srate*5;  %use sections of 5 seconds (number of points per section = 5*srate=5*128)
NFFT=2*window; %number of points used for estimation of PSD = 10*srate-->zero-padding to increase
% frequency resolution to 0.1 Hz  (freq res = srate/NFFT = srate/(10*srate)=0.1 Hz)
[PSD,f]=pwelch(X',window,[],NFFT,srate); %each column of PSD contains the power spectral
% density of the corresponding column of X'; f has size nf x 1 (nf = (NFFT/2)+1=641) and PSD has size nf x n 

figure
for i = 1:n
    subplot(4,4,i)
    plot(f, PSD(:,i),'color',[0 0 0],'linewidth',1);
    title(ch_names{i})
    xlim([0.5 40])
    ylim([0 50])   
    xlabel('Hz');
    ylabel('{\muV}^2/Hz')  
end
sgtitle('PSD of EEG signals (before artifact correction)')

%% Exercise 6 Point 3 - Save the EEG data X for their use in EEGLAB
% comment the following instruction after the first usage
%save dataExercise6.mat X

%% Exercise 6 Point 4  - Perform ICA and obtain the demixing matrix (using the GUI of EEGLAB)
% Follow the instructions in the text of Exercise 6 (in eeglab, import dataExercise6.mat, compute and export the demixing
% matrix (here saved in matrixW_Exercise6.txt), plot the topographical maps and save them in a .fig file (here
% mapICs_Exercise6.fig)

%% Exercise 6 Point 5 - Load the demixing matrix, compute and plot the ICs as a function of time

load matrixW_Exercise6.txt 
W=matrixW_Exercise6;
A=inv(W); % mixing matrix A obtained by inverting the demixing matrix W
Y=W*X;  % Y contains the estimated independent components (n x m)

%create the labels of IC
labels_IC=cell(1,size(Y,1)); % 1 x n
for i=1:size(Y,1)
    labels_IC{i}=['IC',num2str(i)];
end
    
%plot the ICs over the entire duration (or over 30 seconds)
start=1; %135*srate; %
stop=size(Y,2); %165*srate; %

delta=50;

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

%% Exercise 6 Point 6 - Compute and plot the power spectral density of the estimated ICs

%same parameter setting as for EEG signals (X)
window=5*srate; 
NFFT=2*window; 
[PSD_IC,f]=pwelch(Y',window,[],NFFT,srate);  %f has size nf x 1 (nf = (NFFT/2)+1=641) and PSD_IC has size nf x n 

figure
for i = 1:n
    subplot(4,4,i)
    plot(f, PSD_IC(:,i),'k','linewidth',1);
    title(labels_IC{i})
    xlim([0.5 40])
    xlabel('Hz')
    ylabel('{\muV}^2/Hz')
    grid
end
sgtitle('PSD of estimated independent components')

%% Exercise 6 Point 7 - Identification of artifact components via exploration of time pattern, PSD, topographical map
%%you can also open  the figure of the topographical maps created using
%%EEGLAB (uncomment the following instruction)
%openfig('mapICs_Exercise6.fig');

%%I use the next istruction to better explore some ICs (IMPORTANT: since
%%this function uses the topoplot function of EEGLAB toolbox, you need
%%first to launch EEGLAB (then you can close the EEGLAB GUI). 
plot_IC([1,2,3,4,8],A,Y,PSD_IC,f,'Standard-10-20-Cap13.locs',srate,t(1),t(end))
plot_IC([9 10 11],A,Y,PSD_IC,f,'Standard-10-20-Cap13.locs',srate,t(1),t(end))

% IC1 ECG artifact + other slow artifacts (the subject moved during the
% recording?)
% IC2 blinking artifact
% IC3 may reflect lateral eye movement artifact
% IC4 spectrum mainly limited to very low frequencies + large artifact as in
% indep comp 1 around 300 s
% IC8 strange spectrum with high frequencies content and large artifact
% around 300 s
% Also IC9, IC10 and IC11 seem to contain some artifact activity, but I
% prefer to mantain them as they also contain alpha power


%% Exercise 6 Point 8 - Removal of the main artifact components, reconstruction of cleaned EEG, time pattern and PSD of the cleaned EEG

Snew=Y;
Snew([1 2 3 4 8],:)=0; % I cancel the ICs identified as artifact components

Xnew=A*Snew; % these are the EEG signals cleaned from the identified artifact components

delta=100;

%%uncomment the following to plot the entire tracing 
start=1;  
stop=m;  

%%uncomment the following to plot 30 seconds of the tracing 
% start=135*srate;  
% stop=165*srate;  

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
    subplot(4,4,i)
    plot(f, PSDnew(:,i),'r','linewidth',1);
    title(ch_names{i})
    xlim([0.5 40])
    ylim([0 50])   
    xlabel('Hz')
    ylabel('{\muV}^2/Hz')
end
sgtitle('PSD of EEG signals (after artifact correction)')
% compare the figure 'PSD of EEG signals (after artifact correction)' vs s'PSD of EEG signals (before artifact correction)'

% overlapping between PSD of EEG signals before and after artifact
figure
for i = 1:n
    subplot(4,4,i)
    plot(f, PSD(:,i),'k','linewidth',1);
    hold on
    plot(f, PSDnew(:,i),'r','linewidth',1);
    title(ch_names{i})
    xlim([0.5 40])
    ylim([0 50])   
    xlabel('Hz')
    ylabel('{\muV}^2/Hz')
end
sgtitle('PSD of EEG signals (before vs after artifact correction)')

%% Exercise 6 Point 9 - Computation of PSD of the cleaned EEG separately in different phases (R1, T, R2)

close all

start_r1=1;            % first sample of phase RELAX 1
stop_r1=5*60*srate;    % last sample of phase RELAX 1

start_t=5*60*srate+1;  % first sample of phase TASK
stop_t=10*60*srate;    % last sample of phase TASK

start_r2=10*60*srate+1;% first sample of phase RELAX 2
stop_r2=15*60*srate;   % last sample of phase RELAX 2

window=srate*5;
NFFT=2*window;

[PSD_r1,f]=pwelch(Xnew(:,start_r1:stop_r1)',window,[],NFFT,srate); %f has size nf x 1 (nf = (NFFT/2)+1=641) and PSD_r1 has size nf x n 
[PSD_t,f]=pwelch(Xnew(:,start_t:stop_t)',window,[],NFFT,srate); %f has size nf x 1 (nf = (NFFT/2)+1=641) and PSD_t has size nf x n 
[PSD_r2,f]=pwelch(Xnew(:,start_r2:stop_r2)',window,[],NFFT,srate); %f has size nf x 1 (nf = (NFFT/2)+1=641) and PSD_r2 has size nf x n 

h1=figure;
for i=1:size(Xnew,1)
    subplot(4,4,i)
    plot(f,PSD_r1(:,i),'k','linewidth',1)
    xlim([0.5 40])
    ylim([0 50])
    ylabel('{\muV}^2/Hz')
    xlabel('Hz')
    title(ch_names{i}) 
    grid
end
sgtitle('PSD of EEG signals during RELAX R1')
set(h1,'name','PHASE RELAX R1') 

h2=figure;
for i=1:size(Xnew,1)
    subplot(4,4,i)
    plot(f,PSD_t(:,i),'k','linewidth',1)
    xlim([0.5 40])
    ylim([0 50])   
    ylabel('{\muV}^2/Hz')
    xlabel('Hz')
    title(ch_names{i})
    grid
end
sgtitle('PSD of EEG signals during TASK T')
set(h2,'name','PHASE TASK T') 

h3=figure;
for i=1:size(Xnew,1)
    subplot(4,4,i)
    plot(f,PSD_r2(:,i),'k','linewidth',1)
    xlim([0.5 40])
    ylim([0 50])   
    ylabel('{\muV}^2/Hz')
    xlabel('Hz')
    title(ch_names{i})
    grid
end
sgtitle('PSD of EEG signals during RELAX R2')
set(h1,'name','PHASE RELAX R2') 


%% Exercise 6 Point 10 - Average of PSD over frontal, temporo-central, parieto-occipital channels, and plot (3 subplots)

index_F = [1,2];
index_CT = [3:7];
index_PO = [8:13];

% average PSD in each phase (R1, T, R2) over the frontal chans
PSD_F_r1 = mean(PSD_r1(:,index_F),2);  %  nf x 1
PSD_F_t = mean(PSD_t(:,index_F),2);    %  nf x 1 
PSD_F_r2 = mean(PSD_r2(:,index_F),2);  %  nf x 1

% average PSD in each phase (R1, T, R2) over the temporo-central chans
PSD_CT_r1 = mean(PSD_r1(:,index_CT),2); %  nf x 1
PSD_CT_t = mean(PSD_t(:,index_CT),2);   %  nf x 1
PSD_CT_r2 = mean(PSD_r2(:,index_CT),2); %  nf x 1

% average PSD in each phase (R1, T, R2) over the parieto-occipital chans
PSD_PO_r1 = mean(PSD_r1(:,index_PO),2); %  nf x 1
PSD_PO_t = mean(PSD_t(:,index_PO),2);   %  nf x 1
PSD_PO_r2 = mean(PSD_r2(:,index_PO),2); %  nf x 1

figure

subplot(3,1,1)
plot(f,PSD_F_r1,'b','linewidth',2)
hold on
plot(f,PSD_F_t,'r','linewidth',2)
plot(f,PSD_F_r2,'g','linewidth',2)
xlim([0.5 40])
ylim([0 50])
ylabel('{\muV}^2/Hz')
xlabel('Hz')
title('PSD over frontal channels')
grid
legend('relax-R1','task-T','relax-R2')

subplot(3,1,2)
plot(f,PSD_CT_r1,'b','linewidth',2)
hold on
plot(f,PSD_CT_t,'r','linewidth',2)
plot(f,PSD_CT_r2,'g','linewidth',2)
xlim([0.5 40])
ylim([0 50])
ylabel('{\muV}^2/Hz')
xlabel('Hz')
title('PSD over temporal-central channels')
grid
legend('relax-R1','task-T','relax-R2')

subplot(3,1,3)
plot(f,PSD_PO_r1,'b','linewidth',2)
hold on
plot(f,PSD_PO_t,'r','linewidth',2)
plot(f,PSD_PO_r2,'g','linewidth',2)
xlim([0.5 40])
ylim([0 50])
ylabel('{\muV}^2/Hz')
xlabel('Hz')
title('PSD over parietal-occipital channels')
grid
legend('relax-R1','task-T','relax-R2')

%% Exercise 6 Point 11 - Compute the alpha power in each scalp region and for each phase, and plot

imin=find(f==8); 
imax=find(f==14); 

% alpha power in each phase (R1, T, R2) at the frontal chans
alpha_F_r1=trapz(f(imin:imax),PSD_F_r1(imin:imax)); % 1 x 1
alpha_F_t=trapz(f(imin:imax),PSD_F_t(imin:imax)); % 1 x 1
alpha_F_r2=trapz(f(imin:imax),PSD_F_r2(imin:imax)); % 1 x 1

% alpha power in each phase (R1, T, R2) at the temporo-central chans
alpha_CT_r1=trapz(f(imin:imax),PSD_CT_r1(imin:imax)); % 1 x 1
alpha_CT_t=trapz(f(imin:imax),PSD_CT_t(imin:imax)); % 1 x 1
alpha_CT_r2=trapz(f(imin:imax),PSD_CT_r2(imin:imax)); % 1 x 1

% alpha power in each phase (R1, T, R2) at the parieto-occipital chans
alpha_PO_r1=trapz(f(imin:imax),PSD_PO_r1(imin:imax)); % 1 x 1
alpha_PO_t=trapz(f(imin:imax),PSD_PO_t(imin:imax)); % 1 x 1
alpha_PO_r2=trapz(f(imin:imax),PSD_PO_r2(imin:imax)); % 1 x 1

alpha_F=[alpha_F_r1, alpha_F_t, alpha_F_r2];
alpha_CT=[alpha_CT_r1, alpha_CT_t, alpha_CT_r2];
alpha_PO=[alpha_PO_r1, alpha_PO_t, alpha_PO_r2];
    
figure
plot([1,2,3],alpha_F,'o-','linewidth',2)
hold on
plot([1,2,3],alpha_CT,'o-','linewidth',2)
plot([1,2,3],alpha_PO,'o-','linewidth',2)
xlim([0.5 3.5])
ylim([0 60])
ylabel('{\muV}^2')
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel',{'R1','T','R2'})
title('Alpha Power')
grid
l=legend({'Frontal','Temporo-Central','Parieto-Occipital'});
set(l,'location','northwest')



