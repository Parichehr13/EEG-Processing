clear all;close all;clc
%rng('default')
%% STAGE I: DATA LOADING AND PRE-PROCESSING (IF NECESSARY)
% Point 1
eeglab_path = '/Users/prometheus/Documents/MATLAB/eeglab2021.1';
sbj_fpath = './BCI_IV2a/sub-008.mat';
valid_ratio = 0.2; % random 20% of the training set held out as validation set
[x_train, y_train, x_test, y_test, x_valid, y_valid, ch_locs, conditions] = ...
    load_bci_iv2a(sbj_fpath, valid_ratio, eeglab_path);
% Histogram of labels for all sets (train, valid and test)
figure()
subplot(311)
histogram(y_train, 'BarWidth', 0.5)
ylim([0, 80])
title('Training set')
ylabel('# examples')
subplot(312)
histogram(y_valid, 'BarWidth', 0.5)
ylim([0, 80])
title('Validation set')
ylabel('# examples')
subplot(313)
histogram(y_test, 'BarWidth', 0.5)
ylim([0, 80])
xlabel('Condition')
ylabel('# examples')
title('Test set')

ads1 = arrayDatastore(x_train, 'IterationDimension', 4);
ads2 = arrayDatastore(y_train);
trainds = combine(ads1,ads2);

ads1 = arrayDatastore(x_valid, 'IterationDimension', 4);
ads2 = arrayDatastore(y_valid);
validds = combine(ads1,ads2);
%% STAGE II: MODEL DESIGN
% Point 2
% Input specifications
C = 22;
T = 256;
% Output specifications
n_classes = 4;
% Defining default EEGNet structure
layers = EEGNet(T, C, n_classes);
% Analyze CNN (please note that the number of learnables is not shown by
% deafult, you should activate the option in the GUI)
analyzeNetwork(layers)
%% STAGE III: MODEL OPTIMIZATION
% Point 3

% in this directory 'checkpoints' (i.e., training and optimization
% parameters) at each epoch will be saved, with unique filenames

% Definition of some optimization hyper-parameters
optimizer = 'adam'; 
lr = 0.001;
mini_bs = 32;
max_epochs = 200;
l2_reg_par = 0.001;

% Definition of baseline trainingOptions with your hyper-parameters
checkpoint_dir = './checkpoints_cnn_bci_iv2a';
if ~isdir(checkpoint_dir)
    mkdir(checkpoint_dir)
end
n_batches_per_epoch = floor(length(y_train)/mini_bs);
%%{x_valid,y_valid}, ...
options = trainingOptions(optimizer, ...
    'InitialLearnRate',lr, ...
    'L2Regularization', l2_reg_par,...
    'MaxEpochs',max_epochs, ...
    'MiniBatchSize',mini_bs, ...
    'Shuffle','every-epoch',...
    'VerboseFrequency',n_batches_per_epoch, ...
    'ValidationData',validds, ...
    'ValidationFrequency',n_batches_per_epoch, ...
    'CheckpointPath', checkpoint_dir,...
    'ExecutionEnvironment', 'cpu');

% if using stochastic gradient descent with momentum: 'Momentum', 0.9
% if using batch normalization: 'BatchNormalizationStatistics', 'moving'
[net, info] = trainNetwork(trainds,layers,options); %trainNetwork(x_train,y_train,layers,options);
% Loss and evaluation metric visualization 
train_loss = info.TrainingLoss;
valid_loss = info.ValidationLoss;

train_acc = info.TrainingAccuracy;
valid_acc = info.ValidationAccuracy;


[~, target_iteration_earlystop] = max(valid_acc, [], 'omitnan');
fprintf('Maximum validation accuracy at epoch: %d;iteration: %d \n',...
    target_iteration_earlystop/n_batches_per_epoch,target_iteration_earlystop) 

save(fullfile(checkpoint_dir, 'tracked_metrics.mat'), ...
    'train_loss', 'valid_loss','train_acc','valid_acc')

iterations = 1:length(train_acc);
figure('Units','normalized','Position',[0 0 .5 1])
subplot(211)
plot(iterations, train_loss,'b')
hold on
plot(iterations, valid_loss,'ro')
ylabel('loss')
xlabel('iterations')
legend({'train', 'valid'})

subplot(212)
plot(iterations, train_acc,'b')
hold on
plot(iterations, valid_acc,'ro')
ylabel('accuracy')
xlabel('iterations')
legend({'train', 'valid'})

clear net info
%% STAGE IV: MODEL TESTING 
% Point 4
% Select and load the best model on the validation set (e.g., for the validation acc)
checkpoint_dir = './checkpoints_cnn_bci_iv2a';
load(fullfile(checkpoint_dir, 'tracked_metrics.mat'))

target_fname = 'net_checkpoint__952__2021_12_17__09_06_17.mat';
load(fullfile(checkpoint_dir,target_fname));
% Evaluate on the test set
[y_test_pred, probs_test] = classify(net,x_test);
test_acc = mean(y_test_pred==y_test);
fprintf('Test set accuracy: %1.4f\n',...
    test_acc)

figure()
test_cm = confusionchart(y_test, y_test_pred);
%% VISUALIZATION OF THE SPATIAL FILTERS
% Point 5
close all
Wconv1 = net.Layers(3).Weights;
Wconv1 = process_spatial_filters(Wconv1);

nfilters = size(Wconv1, 1);

% plot absolute spatial filters, normalized between 0,1
figure('Units','normalized','Position',[0 0 1 1])
for i=1:nfilters
    subplot(4,4,i)
    tmp_w = Wconv1(i,:);
    tmp_w = abs(tmp_w);
    tmp_w = tmp_w/max(tmp_w);
    
    plot_spatial_filters(tmp_w, ch_locs)
    colorbar;
end
sgtitle('Absolute spatial filters (normalized)')