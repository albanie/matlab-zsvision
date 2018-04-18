function zs_setup
%ZS_SETUP adds paths to the zsvision toolbox
%   ZS_SETUP adds each of the directories of the zsvision
%   toolbox to the path
%
%   Copyright (C) 2016 Samuel Albanie
%   All rights reserved.

  root = zs_root() ;
  addpath([root, '/matlab'], [root, '/matlab/utils']) ;
  addpath([root, '/matlab/tests']) ;
