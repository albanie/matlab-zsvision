function test_zsvision
%TEST_ZSVISION - run tests for zsvision toolbox
%
%   Copyright (C) 2018 Samuel Albanie
%   Licensed under The MIT License [see LICENSE.md for details]

  % add tests to path
  addpath(fullfile(fileparts(mfilename('fullpath')), 'xtest')) ;
  addpath(fullfile(zs_root, 'matlab/xtest/suite')) ;

  % test utils
  run_zsvision_tests('command', 'ut') ;
