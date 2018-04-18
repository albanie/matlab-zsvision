classdef utargparse < matlab.unittest.TestCase
  methods (Test)
    function testNoArgs(testCase)
      opts = zs_argparse(struct()) ;
      expected = struct() ;
      testCase.verifyEqual(opts, expected) ;
    end

    function testOneArgs(testCase)
      opts = zs_argparse(struct(), 'hello', 2) ;
      expected.hello = 2 ;
      testCase.verifyEqual(opts, expected) ;
    end

    function testTwoArgs(testCase)
      opts = zs_argparse(struct(), 'hello', 2, 'bye', 3) ;
      expected.hello = 2 ;
      expected.bye = 3 ;
      testCase.verifyEqual(opts, expected) ;
    end
  end
end
