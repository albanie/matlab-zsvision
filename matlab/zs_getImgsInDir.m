function imgNames = zs_getImgsInDir(path, suffix)
%ZS_GETIMGSINDIR loads cell array of image paths
%   ZS_GETIMGSINDIR(path, suffix) recursively searches 
%   the for images with the given suffix, starting from 
%   the directory found at path 'path'. 
%
%   Copyright (C) 2016 Samuel Albanie
%   All rights reserved.

% List all files in the given directory with given suffix
imgFiles = dir(fullfile(path, sprintf('*.%s', suffix)));

% create a cell array of the full paths to each image
imgNames = {imgFiles.name}';

% ignore OS created backup files
imgNames = imgNames(~strncmpi(imgNames, '._', 2));

paths = repmat({path}, size(imgNames));
imgNames = strcat(paths, filesep, imgNames);
