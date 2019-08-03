function [opts,unused] = zs_argparse(opts, varargin)
% ZS_ARGPARSE parses the argument pairs into a struct
%   OPTS = ZS_ARGPARSE(OPTS, VARARGIN) reads the name-value pairs passed
%   as inputs to this function. Every The last argument can be a struct
%   defining additional options. Every name given in VARARGIN must be a field
%   name in OPTS, otherwise an error is raised.
%
%   [OPTS,UNUSED] = ZS_ARGPARSE(OPTS, VARARGIN) updates the fields of OPTS
%   with the name-value pairs given in varargin.  If a name-value pair does
%   not appear in OPTS, it is returned in UNUSED ;
%
%   This function is based on vl_argparse by Andrea Vedaldi and vl_argparsepos
%   by Joao F. Henriques.
%
%   Copyright (C) 2016 Samuel Albanie
%   All rights reserved.

  % first check to see if a struct of options was supplied as the final arg
  unused = {} ;
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

  fnames = fieldnames(opts) ;
  keys = varargin(1:2:end) ;
  if nargout == 1
    for ii = 1:numel(keys)
      assert(ismember(keys{ii}, fnames), ...
             sprintf('unrecognised option %s\n', keys{ii})) ;
    end
  else % remove unused name-value pairs
    remove = ~ismember(keys, fnames) ;
    for ii = numel(remove):-1:1 % remove in reverse order
      k = remove(ii) * 2 - 1 ; v = remove(ii) * 2 ;
      unused(end+1:end+2) = varargin([k, v]) ;
      varargin([k, v]) = [] ;
    end
  end

  % add name-value pair arguments to the options structure
  for ii = 1:2:numel(varargin)
    property = varargin{ii} ;
    value = varargin{ii + 1} ;
    opts = setfield(opts, property, value) ; %#ok - dynamic fields have issues
  end
