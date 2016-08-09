function flatX = zv_flattenCell(X)
%%ZV_FLATTENCELL flattens a cell array into one dim
%   ZV_FLATTENCELL recursively extracts elements 
%   from a nested cell array and collects them 
%   into a single dimensional cell array
%
%   zv_flattenCell is based on the flatten function by 
%   Manu Raghavan
%
%   Copyright (C) 2016 Samuel Albanie
%   All rights reserved.
 
flatX = {};

% flatten by recursion
for i = 1:numel(X)  

    % store any non-cell elements 
    if(~iscell(X{i}))
        flatX = horzcat(flatX, X{i});
    else
       tmp = zv_flattenCell(X{i});
       flatX = horzcat(flatX, tmp{:});
    end
end
