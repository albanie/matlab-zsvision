function filteredBoxes = zv_bboxNMS(bboxes, opts)
% ZV_BBOXNMS performs bbox non maximum supression
%   ZV_BBOXNMS(bboxes) examines a collection 
%   of bounding boxes `bboxes`, and for each pairwise 
%   comparison of boxes in the set, removes the box 
%   with the lower score if the pair have a greater 
%   intersection over union score than the specified 
%   threshold.
% 
%   `bboxes` is an N x 5 array, where N is the number
%   of bounding boxes and each row has the format:
%       [ xMin yMin xMax yMax score ] 
%   
%   bboxNM(bboxes, 'option', value, ...) accepts the 
%   following options:
%   
%   `threshold` :: 0.5
%    set the overlap threshold at which non maximum 
%    supression will occur
%
%   Copyright (C) 2016 Samuel Albanie
%   All rights reserved.

opts.threshold = 0.5 ;
opts = zv_argParse(opts) ;

keyboard ;
