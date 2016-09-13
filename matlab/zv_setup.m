function zv_setup
%ZV_SETUP adds paths to the z-vision toolbox
%   ZV_SETUP adds each of the directories of 
%   the z-vision toolbox to the path
%
%   Copyright (C) 2016 Samuel Albanie
%   All rights reserved.

root = zv_root() ;
addpath(fullfile(root, 'matlab')) ;
addpath(fullfile(root, 'matlab', 'utils')) ;
