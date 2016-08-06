function opts = argParse( varargin )
%ARGPARSE parses the argument pairs into a struct
%   ARGPARSE reads the name, value pairs passed 
%   as inputs to this function.  The last argument
%   can be a struct defining additional options.
%
%   Copyright (C) 2016 Samuel Albanie
%   All rights reserved.


% first check to see if a struct of options 
% was supplied as the final argument 
lastArg = varargin{end} ;
if isa(lastArg, 'struct')
    opts = lastArg ;
    varargin(end) = [] ;
else
    opts = struct() ;
end

% sanity check on inputs
assert(mod(numel(varargin), 2) == 0, ...
        strcat('There must be an even number of', ...
                'inputs that define name-value pairs')) ;

% add name-value pair arguments to the options 
% structure
for i = 1:2:nargin
    property = varargin{i} ;
    value = varargin{ i + 1 } ;
    opts.(property) = value ;
end
