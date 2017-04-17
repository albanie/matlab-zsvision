function zs_setup
%ZS_SETUP adds paths to the zs-vision toolbox
%   ZS_SETUP adds each of the directories of 
%   the zs-vision toolbox to the path
%
%   Copyright (C) 2016 Samuel Albanie
%   All rights reserved.

root = zs_root() ;
addpath(fullfile(root, 'matlab')) ;
addpath(fullfile(root, 'matlab', 'utils')) ;
