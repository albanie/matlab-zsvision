function filteredIdx = zs_bboxMS(bboxes, varargin)
% ZS_BBOXNMS performs bbox non maximum supression
%   ZS_BBOXNMS(bboxes) examines a collection 
%   of bounding boxes `bboxes`, and for each pairwise 
%   comparison of boxes in the set, removes the box 
%   with the lower score if the pair have a greater 
%   intersection over union score than the specified 
%   threshold.  This "fast" version of nms is based
%   on the nms.m funciton by Tomasz Malisiewicz.
%
%   `bboxes` is an N x 5 array, where N is the number
%    of bounding boxes and each row has the format:
%       [ xMin yMin xMax yMax score ] 
%
%   bboxNM(bboxes, 'option', value, ...) accepts the 
%   following options:
%   
%   `overlapThreshold` :: 0.5
%    set the overlap threshold at which non maximum 
%    supression will occur
%
%   `minScoreThreshold` :: 0.0
%    set the minimum score that every bounding box must
%    have. This filter is applied before boxes and scores
%    are fed into NMS. This option can save a lot of 
%    computation when performing NMS on a collection of 
%    bounding boxes whose scores are mostly zero.
%
%   `topK` :: false
%    set the maximum number of bboxes to be passed into the
%    NMS algorithm, arranged in descending score order.   
%
%   RETURNS
%   `filteredIdx`, an N x 1 array of indices
%    of boxes that should be kept
%
%   Copyright (C) 2016 Samuel Albanie
%   All rights reserved.

assert(nargin > 0, 'bboxes must be provided as input') ;
assert(size(bboxes, 2) == 5, 'bboxes must be an Nx5 array') ; 

opts.overlapThreshold = 0.5 ;
opts.minScoreThreshold = 0.0 ;
opts.topK = false ;
opts = zs_argParse(varargin, opts) ;

% keep track of "surviving" bboxes with indices
filteredIdx = [1:size(bboxes, 1)]' ;

% apply min score filter (if set)
if opts.minScoreThreshold
    [~, filteredIdx] = find(bboxes(:,5) >= opts.minScoreThreshold) ;
    bboxes = bboxes(passingBoxes, :) ;
end

% sort bounding bboxes by score (in descending order)
[~, sortedIdx] = sortrows(bboxes(filteredIdx, :), 5) ;
filteredIdx = filteredIdx(sortedIdx) ;

% apply topK filter (if set)
if opts.topK && numel(filteredIdx) > opts.topK
    filteredIdx = filteredIdx(end - opts.topK: end) ;
end

x1 = bboxes(:, 1) ;
y1 = bboxes(:, 2) ;
x2 = bboxes(:, 3) ;
y2 = bboxes(:, 4) ;
area = (x2 - x1) .* (y2 - y1) ;

pick = filteredIdx * 0 ;
counter = 1 ;

while ~isempty(filteredIdx)
  last = length(filteredIdx);
  i = filteredIdx(last);
  pick(counter) = i;
  counter = counter + 1;

  xx1 = max(x1(i), x1(filteredIdx(1:last-1)));
  yy1 = max(y1(i), y1(filteredIdx(1:last-1)));
  xx2 = min(x2(i), x2(filteredIdx(1:last-1)));
  yy2 = min(y2(i), y2(filteredIdx(1:last-1)));

  w = max(0.0, xx2 - xx1);
  h = max(0.0, yy2 - yy1);

  inter = w.*h;
  o = inter ./ (area(i) + area(filteredIdx(1:last-1)) - inter);

  filteredIdx = filteredIdx(find(o <= opts.overlapThreshold));
end
