function im_names = zs_getImgsInSubdirs(path, suffix)
%ZS_GETIMGSINSUBDIRS loads cell array of image paths
%   IM_NAMES = ZS_GETIMGSINSUBDIRS(PATH, SUFFIX) recursively searches
%   for images with the given suffix, starting from the directory
%   found at path 'path'. For example, the suffix could be 'jpg'.
%
%   RETURNS:
%       nx1 cell array of paths.
%
% Copyright (C) 2016 Samuel Albanie
% Licensed under The MIT License [see LICENSE.md for details]

  % create a cell array of all subdirectories
  subdirs = strsplit(genpath(path), ':')' ;

  % extract the images in each of these subdirectories
  imgs = cellfun(@(x) {zs_getImgsInDir(x, suffix)}, subdirs) ;
  im_names = vertcat(imgs{:}) ;
