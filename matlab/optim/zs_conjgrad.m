function [xx,fx,iters] = zs_conjgrad(func, xx, varargin)
%ZS_CONJGRAD - conjugate gradients optimiser
%   ZS_CONJGRAD(FUNC, X0) applies the method of conjugate gradients
%   to minimise the function `FUNC`, starting the search from the initial
%   point X0.
%
%   ZS_CONJGRAD(..., 'option', value, ...) takes the following options:
%
%   `maxIters` :: 20
%    The maximum number of line searches to be performed during the
%    optimization.
%
%   `maxEvalsPerSearch` :: 1.25 * maxIters
%    The maximum number of evaluations per line-search.
%    TODO(samuel): review this default setting.
%
%   `reduce`:: 1
%    Applies a scaling factor of `reduce` to (only) the first line-search
%    in the minimization procedure.
%
%   `conjMethod` :: 'PR'
%    When applying nonlinear conjugate gradients, there are several ways to
%    compute the conjugate Gram Schmidt coefficients.  Empirically, the
%    general consensus is that the PR (Polak-Ribiere) approach seems to work
%    best, but there may be cases in which the FR (Fletcher-Reeves) method
%    is superior, so both are supported.
%
%   `lineSearch` :: 'cubic'
%    There are many ways to perform the line-search for the best step size
%    at each CG iteration.  If second order derivatives of the function
%    are cheap to compute (rare), then Newton-Rhapson is the preferred method.
%    If first order derivatives can be computed cheaply, then the Secant method
%    is good.  Otherwise, evaluating the function at three points (default
%    approach) and fitting a cubic is the easiest method, since it can be
%    computed with only zero-th order information.
%
%    `maxExtrapolate` :: 3
%     The upper limit of extrapolation from the current step size
%
%    `minBracketStep` :: 0.1
%     Prevent the line-search from falling within `minBracketStep` of the
%     previous bracket size - i.e. prevent additional function evaluations
%     taking place too close to current previous points.
%
%   The following options determine the Wolfe-Powell used for line-searches.
%
%    `wpSigma` :: 0.5
%     This value is used to determine the maximum allowable absolute ratio
%     between the previous slope and the next slope, referred to as the
%     "curvature condition" in  'Numerical Optimization' by Nocedal and Wright.
%
%    `wpRho` :: 0.01
%     This value represents the minimum allowable fraction of the expected
%     function value reduction that would be achieved by a first order Taylor
%     expansion in the given descent direction (sometimes referred to as the
%     "Armijo condition".
%
%   Carl Rasmussen notes in his original `minimize.m` implementation that
%   tuning wpSigma may have an effect on the speed of the optimization, but
%   it is probably not worth playing around much with wpRho (he sets wpRho
%   to 0.05 by default).
%
%   NOTES:
%   ----------------------------------------------------------------------
%
%   The variable notation for conjugate gradients follows the description
%   given in:
%
%      ```
%      Shewchuk, J. R. (1994). An introduction to the conjugate gradient
%      method without the agonizing pain.
%      ```
%
%   This function is heavily based on the `minimize` function by
%   Carl Edward Rasmussen. Many of the default options are based on the cg.lua
%   function included in torch by Koray Kavukcuoglu.
%
% Copyright (C) 2018 Samuel Albanie
% Licensed under The MIT License [see LICENSE.md for details]

  opts.reduce = 1 ;
  opts.maxExtrapolate = 3 ;
  opts.wpRho = 0.5 ;
  opts.wpSigma = 0.1 ;
  opts.conjMethod = 'RP' ;
  opts.lineSearch = 'cubic' ;
  opts.maxIters = 20 ;
  opts.precondition = false ; % TODO(samuel)
  opts.maxEvalsPerSearch = 1.25 * opts.maxIters ;
  [opts, varargin] = zs_argparse(opts, varargin) ;

  % get initial function vals & ders
  [f0, df0] = feval(func, xx, varargin{:}) ;

  % intialise primary optimization variables
  iters = 0 ;
  ss = -df0 ; % initial search direction (i.e. follow steepest descent)
  d0 = -ss'*ss ; % directional derivative (projection of gradient along step)
  args = varargin ; % cache extra arguments to pass to FUNC on each evaluation

  % compute scale for first line-search step length (follow Rasmussen here)
  a3 = opts.reduce * 1 / (1 - d0) ; % a3 is the current step length

  while iters < opts.maxIters
    evalCount = 0 ;
    iters = iters + 1 ;
    [x_, f_, df_] = assign(xx, f0, df0) ; % cache best current values

    while true % continue to extrapolate until break occurs
      [a2, f2, f3, d2, df3] = assign(0, f0, f0, d0, df0) ;
      % try to find a valid step length via bisection
      [a3, evalCount] = findValidAlpha(func, xx, ss, a3, a2, ...
                                                evalCount, args, opts) ;
      d3 = df3' * ss ; % update directional derivative
      if f3 < f_ % update best current values
        [x_, f_, df_] = assign(xx + a3 * ss, f3, df3) ;
      end
      if lineSearchFail(d0, f0, d3, f3, a3, evalCount, opts)
        break ;
      end
      [a1, f1, d1] = assign(a2, f2, d2) ; % point 2 -> point 1
      [a2, f2, d2] = assign(a3, f3, d3) ; % point 3 -> point 2
      a3 = cubicLineSearch(a1, a2, f1, f2, d1, d2) ;
      a3 = ensureValidStep(a3, a2, a1, opts) ;
    end
    % interpolate next step length until the strong Wolfe conditions are met, or
    % we hit the maximum number of evaluations for the current line-search
    while ~strongWolfe(d0, d3, f3, a3, opts) && evalCount < opts.maxEvalsPerSearch
      % choose subinterval based on the current directional derivative
      if d3 > 0 || f3 > f0 + a3 * opts.wpRho * d0
        [a4, f4, d4] = assign(a3, f3, d3) ;  % point 3 -> point 4
      else
        [a2, f2, d2] = assign(a3, f3, d3) ;  % point 3 -> point 2
        keyboard
      end
      if f4 > f0
        % if f4 is larger than f0, we can consider it "less trustworthy", and
        % therefore we do not use the derivative of the function at this point
        % to interpolate a better step-size. The quadratic line-search uses
        % only one derivative (in contrast to the cubic line-search, which uses
        % a derivative at both a2 and a4).
        a3 = quadraticLineSearch(a2, a4, f2, f4, d2) ;
      else
        a3 = cubicLineSearch(a2, a4, f2, f4, d2, d4) ;
      end

    end

      keyboard

    end
end

% -------------------------------------------------------------------------------
function [alpha, evalCount] = findValidAlpha(func, xx, ss, alpha, prevAlpha, ...
                                                         evalCount, args, opts)
% -------------------------------------------------------------------------------
%FINDVALIDALPHA - find a valid step length
%   [ALPHA, EVALCOUNT] = FINDVALIDALPHA(FUNC, XX, SS, ALPHA, PREVALPHA, ARGS, OPTS)
%   uses a simple bisection search to find a step length ALPHA that produces a
%   numerically valid function value and corresponding derivative at the
%   point XX + ALPHA * SS.

  acceptedStep = false ;
  while ~acceptedStep && evalCount < opts.maxEvalsPerSearch
    try
      evalCount = evalCount + 1 ;
      [f3, df3] = feval(func, xx + alpha * ss, args{:}) ;
      % check numerical validity of f3 (scalar) and df3 (vector)
      if isnan(f3) || isinf(f3) || any(isnan(df3) + isinf(df3))
        error('numerical failure') ;
      end
      acceptedStep = true ;
    catch % catch nans and inf failures
      alpha = (prevAlpha + alpha) / 2 ; % bisect alpha and try again
    end
  end
end

% ----------------------------------------------------------------
function accept = strongWolfe(d0, d3, f3, a3, opts)
% ----------------------------------------------------------------
  armijo = f3 < f0 + a3 * opts.wpRho * d0 ; % ensure sufficient decrease
  flatEnough = abs(d3) < opts.wpSigma * d0 ;
  accept = armijo && flatEnough ;
end


% --------------------------------------------------------------------------
function alpha = ensureValidStep(alpha, prevAlpha, prevPrevAlpha, opts)
% --------------------------------------------------------------------------
  if ~isreal(alpha) || isnan(alpha) || isinf(alpha) || alpha < 0
    % invalid alpha, so simply extrapolate the maximum allowable distance using
    % previous step length.
    alpha = prevAlpha * opts.maxExtrapolate ;
  elseif alpha  > prevAlpha * opts.maxExtrapolate
    % alpha has been set beyond the extrapolation limit, so clip to lie within
    % acceptable range.
    alpha = prevAlpha * opts.maxExtrapolate ;
  elseif alpha < prevAlpha + (prevAlpha - prevPrevAlpha) * opts.minBracketStep
    % prevent selection of a step length that will cause a function evaluation
    % that is "too close" to the previous evaluation points.
    alpha = prevAlpha + opts.minBracketStep * (prevAlpha - prevPrevAlpha) ;
  end
end

% --------------------------------------------------------------------------
function y = quadraticLineSearch(a, b, fa, fb, dfa) ;
% --------------------------------------------------------------------------
%QUADRATICLINESEARCH - line-search by fitting a quadratic to find minima
%  Y = CUBICLINESEARCH(A, B, FA, FB, DFA) approximates the minimum
%  point of a scalar function F given a pair of (domain,range) points (A, FA)
%  and (B, FB) and the derivative DFA by fitting a quadratic Q(X).
%
% 

% --------------------------------------------------------------------------
function y = cubicLineSearch(a, b, fa, fb, dfa, dfb)
% --------------------------------------------------------------------------
%CUBICLINESEARCH - line-search by fitting a cubic to find minima
%  Y = CUBICLINESEARCH(A, B, FA, FB, DFA, DFB) approximates the minimum
%  point of a scalar function F given a pair of (domain,range) points (A, FA)
%  and (B, FB) and their repsective derivatives DFA and DFB by fitting a
%  cubic C(X).
%
%  The interpolation formula is slightly convoluted - we require an efficient
%  way to find a value Y such that the first derivative of the fitted cubic
%  at Y is zero and the second is positive i.e. C'(Y) = 0 and C''(Y) > 0.
%
%  A discussion and derivation is given in the following text:
%
%    Sun, Wenyu, and Ya-Xiang Yuan. Optimization theory and methods:
%    nonlinear programming. Sec. 2.4.2 Cubic Interpolation Method, pp98,
%    Vol. 1. Springer Science & Business Media, 2006.
%
%  Alternative Rasmussen interpolation formula
%    A = 6*(fa - fb) + 3*(dfb + dfa) * (b - a) ;
%    B = 3*(fb - fa) - (2*dfa + dfb) * (b - a) ;
%    y1 = a - dfa * (b - a)^2 / (B + sqrt(B*B - A*dfa*(b - a))) ;

  % follow the notation in the "Optimization theory and methods" text:
  S = 3 * (fb - fa) / (b - a) ;
  Z = S - dfa - dfb ;
  W = sqrt(Z^2 - dfa * dfb) ;
  y = a + (b - a) * (W - dfa - Z) / (dfb - dfa + 2 * W) ;
end

% --------------------------------------------------------------------------
function fail = lineSearchFail(d0, f0, d3, f3, a3, evalCount, opts)
% --------------------------------------------------------------------------
%LINESEARCHFAIL - TODO(samuel) explain this function logic
  increasingFunc = f3 > f0 + a3 * opts.wpRho * d0 ;
  overAggressiveGradient = d3 > opts.wpSigma * d0 ;
  outOfTries = evalCount == opts.maxEvalsPerSearch ;
  fail = increasingFunc || overAggressiveGradient || outOfTries ;
end

% -----------------------------------------
function varargout = assign(varargin)
% -----------------------------------------
%ASSIGN - assign multiple variables
%  ASSIGN - assigns a set of input variables to a set of output variables.
%  It is a helper function designed to make the optimisation code easier to
%  read (otherwise, the code has vast numbers of equals signs everywhere).
  assert(nargin == nargout, 'number of inputs must match number of outputs') ;
  varargout = varargin ;
end
