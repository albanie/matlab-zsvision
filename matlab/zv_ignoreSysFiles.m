function files = zv_ignoreSysFiles(files)
% ZV_IGNORESYSFILES removes system files
%   ZV_IGNORESYSFILES removes files produced by the operating 
%   system from the cell array of file names contained in files.name
%
%   Copyright (C) 2016 Samuel Albanie
%   All rights reserved.

systemFiles = {'.', '..', '.DS_Store'};
ignoreIdx = cellfun(@(x) ismember(x, systemFiles), {files.name}, ...
                                        'UniformOutput', true);
files(ignoreIdx) = [];
