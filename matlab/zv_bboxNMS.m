function filteredIdx = zv_bboxNMS(bboxes, varargin)
% ZV_BBOXNMS performs bbox non maximum supression
%   ZV_BBOXNMS(bboxes) examines a collection 
%   of bounding boxes `bboxes`, and for each pairwise 
%   comparison of boxes in the set, removes the box 
%   with the lower score if the pair have a greater 
%   intersection over union score than the specified 
%   threshold.  
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
opts = zv_argParse(varargin, opts) ;

% keep track of "surviving" bboxes with indices
filteredIdx = [1:size(bboxes, 1)]' ;

% apply min score filter (if set)
if opts.minScoreThreshold
    [~, filteredIdx] = find(bboxes(:,5) >= opts.minScoreThreshold) ;
    bboxes = bboxes(passingBoxes, :) ;
end

% sort bounding bboxes by score (in descending order)
[~, sortedIdx] = sortrows(bboxes(filteredIdx, :), -5) ;
filteredIdx = filteredIdx(sortedIdx) ;

% apply topK filter (if set)
if opts.topK && numel(filteredIdx) > opts.topK
    filteredIdx = filteredIdx(1:opts.topK) ;
end

% use an array of indicator variables to keep track of
% the NMS survivors 
keep = logical(zeros(size(filteredIdx))) ;

% add the highest rank bbox
keep(1) = 1 ;

overlaps = [];
% loop over the remaining sorted boxes
for i = 2:numel(filteredIdx)
    queryBox = bboxes(sortedIdx(i), :) ;
    existingBoxes = bboxes(sortedIdx(keep), :) ;
    overlap = jaccardOverlap(queryBox, existingBoxes) ;
    overlaps = [ overlaps ; overlap ] ;
    if overlap <= opts.overlapThreshold
        keep(i) = 1 ;
    end
end

filteredIdx = filteredIdx(keep) ;

%-------------------------------------------------------------
function overlap = jaccardOverlap(queryBox, existingBoxes)
%-------------------------------------------------------------

intersectWidths = bsxfun(@min, queryBox(3), existingBoxes(:,3)) - ...
                    bsxfun(@max, queryBox(1), existingBoxes(:,1)) ;
intersectHeights = bsxfun(@min, queryBox(4), existingBoxes(:,4)) - ...
                    bsxfun(@max, queryBox(2), existingBoxes(:,2)) ;

% remove negative overlaps
intersectWidths(intersectWidths < 0) = 0 ;
intersectHeights(intersectHeights < 0) = 0 ;

% find box areas
queryBoxArea = (queryBox(3) - queryBox(1)) * (queryBox(4) - queryBox(2)) ;
existingBoxAreas = (existingBoxes(:,3) - existingBoxes(:,1)) .* ...
                       (existingBoxes(:,4) - existingBoxes(:,2)) ;

% compute max intersection over union
intersectAreas = intersectWidths .* intersectHeights ;
unionAreas = bsxfun(@plus, queryBoxArea, existingBoxAreas) - intersectAreas ;
overlap = max(intersectAreas ./ unionAreas) ;
