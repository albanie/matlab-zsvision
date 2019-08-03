classdef utargparse < matlab.unittest.TestCase
  methods (Test)
    function testNoArgs(testCase)
      opts = zs_argparse(struct()) ;
      expected = struct() ;
      testCase.verifyEqual(opts, expected) ;
    end

    function testOneArgs(testCase)
      opts.hello = 1 ;
      opts = zs_argparse(opts, 'hello', 2) ;
      expected.hello = 2 ;
      testCase.verifyEqual(opts, expected) ;
    end

    function testTwoArgs(testCase)
      opts.hello = 1 ; opts.bye = 2 ;
      opts = zs_argparse(opts, 'hello', 2, 'bye', 3) ;
      expected.hello = 2 ;
      expected.bye = 3 ;
      testCase.verifyEqual(opts, expected) ;
    end

    function testUnknownArg(testCase)
      opts.hello = 1 ;
      [opts, varargin] = zs_argparse(opts, 'unknown', 2) ;
      expectedOpts.hello = 1 ;
      expectedVarargin = {'unknown', 2} ;
      testCase.verifyEqual(opts, expectedOpts) ;
      testCase.verifyEqual(varargin, expectedVarargin) ;
    end
  end
end
