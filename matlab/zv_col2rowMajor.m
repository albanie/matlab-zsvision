function Y = zv_col2rowMajor(X, useGpu)
%ZV_COL2ROWMAJOR column to row major order
%   Y = COL2ROWMAJOR(X) transforms the array X to from the column
%   major layout to row major layout (it does not change the dimensions)
%
%   `useGpu` takes a boolean value which determines whether the
%    transformation should take place on the gpu.
%
%   Notes:
%   Languages such as MATLAB, FORTRAN, Julia and R store arrays in
%   column major order, meaning that consecutive columns of each array 
%   are contiguous in memory This function can be useful when working 
%   with code written in row major order languages such as C, C++ and
%   Mathematica where each consecutive row is contiguous in memory. 
%
%   Copyright (C) 2016 Samuel Albanie
%   All rights reserved.

% determine gpu usage
if nargin == 1
    useGpu = false ;
end

% flatten the values of X into a column vector
valuesX = X(:);

% create vector that will be filled with values of X
% in row major order
valuesY = zeros(size(valuesX));

% move to gpu if needed
if useGpu 
    valuesY = gpuArray(valuesY) ;
end

% determine the number of dimensions of Y
dimIndexes = cell(1, ndims(X));

% loop over all the elements of X
for i = 1:numel(valuesX)
    % find index
    [dimIndexes{:}] = ind2sub(size(X), i);
    
    % compute row order linear index equivalent
    j = rowOrderIndex(dimIndexes, size(X));
    
    % fill in Y with value at new index
    valuesY(i) = valuesX(j);
end

% put the rearranged values back into the correct shape
Y = reshape(valuesY, size(X));

function index = rowOrderIndex(dimIndexes, sz)
% rowOrderIndex computes the linear index for row order array
%
%   For a d-dimensional array with dimensions N_1, N_2, ...N_d,
%   an element with index n_1, ..., n_{d-1}, n_d has a row major 
%   order linear index of 
%       n_d + N_d ( n_{d-1} - 1 + N_{d-1} ( ...
%                 n_{d-2} - 1 + N_{d-2} (..( N_2 ( n_1 - 1 )) ..)

% initialize with the first dimension
index = dimIndexes{1} - 1;

% loop over remaining dimensions
for i = 2:numel(dimIndexes)
    index = dimIndexes{i} - 1 + (sz(i) * index);
end

% complete with the final dimension
index = index + 1;
