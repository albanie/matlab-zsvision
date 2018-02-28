function img_names = zs_getImgsInSubdirs(path, suffix)
%ZS_GETIMGSINSUBDIRS loads cell array of image paths
%   ZS_GETIMGSINSUBDIRS recursively searches for images
%   with the given suffix, starting from the directory
%   found at path 'path'.
%
%   RETURNS:
%       nx1 cell array of paths.
%
% Copyright (C) 2016 Samuel Albanie
% Licensed under The MIT License [see LICENSE.md for details]

% create a cell array of all subdirectories
subdirs = strsplit(genpath(path), ':')' ;

% extract the images in each of these subdirectories
imgs = cellfun(@(x) zs_getImgsInDir(x, suffix), ...
                    subdirs, 'UniformOutput', false) ;

% flatten the cell array
img_names = vertcat(imgs{:}) ;
