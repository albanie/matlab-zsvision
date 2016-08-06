function rootPath = zv_root()
%ZV_ROOT returns the path to the root folder
%   ZV_ROOT returns the filepath of the root
%   directory of the z-vision toolbox 
%
%   Copyright (C) 2016 Samuel Albanie
%   All rights reserved.

rootPath = fileparts(fileparts(mfilename('fullpath'))) ;
