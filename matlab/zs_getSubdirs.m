function subdirs = zs_getSubdirs(path)
% ZS_GETSUBDIRS gets names of subdirectories
%   ZS_GETSUBDIRS returns a cell array of subdirectories 
%   contained in the directory that exists at `path`.  
%   System files such as '.' and '..' are not included
%   in this list of subdirectories
%
% Copyright (C) 2016 Samuel Albanie
% All rights reserved.

allSubdirs = dir(path) ;
subdirs = zs_ignoreSysFiles(allSubdirs) ;
subdirs = fullfile(path, {subdirs.name}) ;
