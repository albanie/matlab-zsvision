function img_names = getImgsInSubdirs(path, suffix)
%GETIMGSINSUBDIRS loads cell array of image paths
%   GETIMGSINSUBDIRS recursively searches for images
%   with the given suffix, starting from the directory
%   found at path 'path'. 
%
%   RETURNS:
%       nx1 cell array of paths.

% create a cell array of all subdirectories
subdirs = strsplit(genpath(path), ':')';

% extract the images in each of these subdirectories
pngs = cellfun(@(x) getImgsInDir(x, suffix), ...
                    subdirs, 'UniformOutput', false);

% flatten the cell array
img_names = vertcat(pngs{:});


