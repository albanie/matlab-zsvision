function x = zs_conjgrad(func, x0, varargin)
%ZS_CONJGRAD - conjugate gradients optimiser
%   ZS_CONJGRAD(FUNC, X0) applies the method of conjugate gradients
%   to minimise the function `FUNC`, starting the search from the initial
%   point X0.

  opts.
  opts = vl_argparse(opts, varargin) ;

