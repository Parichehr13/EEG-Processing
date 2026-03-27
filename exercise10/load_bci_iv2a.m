function [x_train, y_train, x_test, y_test, x_valid, y_valid, locs, conditions] = ...
    load_bci_iv2a(sbj_fpath, valid_ratio, eeglab_path)
% Load and prepare sets (train, valid, test sets) of BCI_IV2a dataset. It
% returns them into 6 separate variables (x: TxCx1xN_examples, double; 
% y: N_examplesx1, categorical). T=time samples, C=number of channels.
% Furthermore, it returns the EEGLAB channel locations and an array
% containning the events in the order as contained in the labels of the
% dataset.
% 
% Arguments
% ---------
% sbj_fpath: string
%       Filepath of the subject-specific dataset.
% valid_ratio: float
%       Ratio (between 0 and 1) of the validation set to extract from the training set 
%       keeping the same balance between classes as in the training set. 
%       Suggested: 0.2.
% eeglab_path: string
%       Filepath of EEGLAB.
%
% Author
% ------
% Davide Borra, 2021

addpath(genpath(eeglab_path))

rng('default')
ds = load(sbj_fpath);
x = ds.x;
% (epochs, C, T)
[e, c, t] = size(x);
x = reshape(x, [e, c, t, 1]);
x = permute(x, [3, 2, 4, 1]);
y = ds.y;
ch_names = ds.channels;
session = ds.session;
conditions = ds.events;

idx_train = find(strcmp(session, 'session_T'));
idx_test = find(strcmp(session, 'session_E'));

x_train = x(:, :, :, idx_train);
y_train = y(idx_train)';

x_test = x(:, :, :, idx_test);
y_test = y(idx_test)';

x_valid = [];
y_valid = [];
if valid_ratio<1
    idx_valid = [];
    unique_classes = unique(y_train);
    
    % keeping a fraction of the training set as validation set, equally
    % sampling each class
    for i=1:length(unique_classes)
        c = unique_classes(i);
        idx_c = find(y_train==c);
        tmp_idx_valid = datasample(idx_c, round(valid_ratio*length(idx_c)),...
            'Replace', false);
        idx_valid = cat(1, idx_valid, tmp_idx_valid);
    end
    x_valid = x_train(:, :, :, idx_valid);
    y_valid = y_train(idx_valid);
    
    idx_train = setdiff(1:length(y_train), idx_valid);
    x_train = x_train(:, :, :, idx_train);
    y_train = y_train(idx_train);
end

y_train = categorical(y_train);
y_test = categorical(y_test);
y_valid = categorical(y_valid);


default_locs = readlocs(fullfile(eeglab_path, '/sample_locs/Standard-10-20-Cap81.locs'));
ch_names_in_locs={default_locs(:).labels};
idx=zeros(1,length(ch_names));
for i=1:length(ch_names)
    idx(i)=find(strcmp(ch_names_in_locs,ch_names{i}));
end
locs = default_locs(idx);
end