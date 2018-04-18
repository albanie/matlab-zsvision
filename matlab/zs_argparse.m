function opts = zs_argparse(opts, varargin)
% ZS_ARGPARSE parses the argument pairs into a struct
%   ZS_ARGPARSE reads the name, value pairs passed as inputs to this function.
%   The last argument can be a struct defining additional options.
%
%   This function is based on vl_argparse by Andrea Vedaldi and vl_argparsepos
%   by Joao F. Henriques.
%
%   Copyright (C) 2016 Samuel Albanie
%   All rights reserved.

  % first check to see if a struct of options was supplied as the final arg
  if ~isempty(varargin)
    lastArg = varargin{end} ;
    if isa(lastArg, 'struct')
      varargin(end) = [] ;
      fnames = fieldnames(lastArg) ;
      extraArgs = cell(1, numel(fnames) * 2) ;
      for ii = 1:numel(fnames)
        extraArgs{ii * 2 - 1} = fnames{ii} ;
        extraArgs{ii * 2} = lastArg.(fnames{ii}) ;
      end
      varargin = horzcat(varargin, extraArgs) ;
    end
  end

  % return if remaining argument is an empty cell
  if numel(varargin) == 1
    varargin = zs_flattenCell(varargin) ;
    if isempty(varargin)
      return ;
    end
  end

  % sanity check on inputs
  assert(mod(numel(varargin), 2) == 0, ...
      strcat('There must be an even number of', ...
          'inputs that define name-value pairs')) ;

  % add name-value pair arguments to the options structure
  for ii = 1:2:numel(varargin)
    property = varargin{ii} ;
    value = varargin{ii + 1} ;
    opts = setfield(opts, property, value) ; %#ok - dynamic fields have issues
  end
