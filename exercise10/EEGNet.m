function layers = EEGNet(T, C, n_classes)
% Define EEGNet with default hyper-parameters
% 
% Arguments
% ---------
% T: int
%       Number of time samples in the input EEG trial
% C: int
%       Number of channels in the input EEG trial
% n_classes: int
%       Number of conditions to classify
%
% Author
% ------
% Davide Borra, 2021
%% Single layer definitions
% Main hyper-parameters
K0 = 8;
D1 = 2;
F0 = [65,1];
F2 = [17,1];
p_drop = 0.25;
use_bnorm = false;
% Input layer
input = imageInputLayer([T,C,1], "Name","input", "Normalization",'zscore');
% Block 1: tempo-spatial feature extractor
conv0 = convolution2dLayer(F0,K0,'Padding',[32,32,0,0],'Name','conv0');
bnorm0 = batchNormalizationLayer('Name','bnorm0');

conv1 = groupedConvolution2dLayer([1,C],D1,K0,'Name','conv1'); % missing kernel max-norm constraint @1.(MATLAB issue...)
bnorm1 = batchNormalizationLayer('Name','bnorm1');
act0 = eluLayer('Name','act0');
pool0 = averagePooling2dLayer([4,1],'Stride',[4,1],'Name','pool0');
dropout0 = dropoutLayer(p_drop,'Name','dropout0');
% Block 2: temporal feature extractor
conv2 = groupedConvolution2dLayer(F2,1,K0*D1,'Padding','same','Name','conv2');
conv3 = convolution2dLayer([1,1],16,'Name','conv3');
bnorm2 = batchNormalizationLayer('Name','bnorm2');
act1 = eluLayer('Name','act1');
pool1 = averagePooling2dLayer([8,1],'Stride',[8,1],'Name','pool1');
dropout1 = dropoutLayer(p_drop,'Name','dropout1');

% Block 3: classification
fc_out = fullyConnectedLayer(n_classes,"Name","fc_out");% missing kernel max-norm constraint @0.25 (MATLAB issue...)

act_out=softmaxLayer("Name","act_out");
% Cross-entropy loss function
loss = classificationLayer("Name","loss");
%% EEGNet design
if use_bnorm
    layers=[input
        % block 1
        conv0
        bnorm0
        conv1
        bnorm1
        act0
        pool0
        dropout0
        block 2
        conv2
        conv3
        bnorm2
        act1
        pool1
        dropout1
        block 3
        fc_out
        act_out
    
        loss];
else
    layers=[input
        % block 1
        conv0
        conv1
        act0
        pool0
        dropout0
        % block 2
        conv2
        conv3
        act1
        pool1
        dropout1
        % block 3
        fc_out
        act_out
    
        loss];
end

end