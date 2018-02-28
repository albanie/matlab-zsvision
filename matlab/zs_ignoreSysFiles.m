function files = zs_ignoreSysFiles(files)
% ZS_IGNORESYSFILES removes system files
%   ZS_IGNORESYSFILES removes files produced by the operating
%   system from the cell array of file names contained in files.name
%
%   Example usage:
%   f = zs_ignoreSysFiles(dir(fullfile('dir', '*'))) ;
%
%   Copyright (C) 2016 Samuel Albanie
%   All rights reserved.

  ignoreIdx = cellfun(@(x) isIgnored(x), {files.name}, 'Uni', true) ;
  files(ignoreIdx) = [] ;

% -------------------------
function ignore = isIgnored(name)
% -------------------------
  systemFiles = {'.', '..', '.DS_Store'} ;
  sysPrefix = '._' ;
  ignore = ismember(name, systemFiles) || strcmp(name(1:2), sysPrefix) ;
