function Wconv1 = process_spatial_filters(Wconv1)
% Process spatial filters of EEGNet extracted from the depthwise 
% convolutional layer. 
% Returns a matrix containing spatial filters (x: CxN_filters, double).
% C=number of channels.
% 
% Arguments
% ---------
% Wconv1: array 
%       Filters extracted from the spatial depthwise convolutional layer.
% 
% Author
% ------
% Davide Borra, 2021

Wconv1 = squeeze(Wconv1);
[m,n,k] = size(Wconv1);
Wconv1 = reshape(Wconv1, [m, n*k]);
end

