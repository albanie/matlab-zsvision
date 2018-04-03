function flatX = zs_flattenCell(X)
%ZS_FLATTENCELL flattens a cell array into one dim
%   ZS_FLATTENCELL recursively extracts elements from a nested cell array
%   and collects them into a single dimensional cell array.
%
%   zs_flattenCell is based on the flatten function by Manu Raghavan.
%
% Copyright (C) 2016 Samuel Albanie
% Licensed under The MIT License [see LICENSE.md for details]

  flatX = {} ;
  for i = 1:numel(X) % flatten by recursion

    % store any non-cell elements
    if (~iscell(X{i}))
      flatX = horzcat(flatX, X{i}) ;
    else
      tmp = zs_flattenCell(X{i}) ;
      flatX = horzcat(flatX, tmp{:}) ;
    end
  end
