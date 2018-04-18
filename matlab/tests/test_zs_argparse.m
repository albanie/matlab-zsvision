classdef test_zs_argparse < matlab.unittest.TestCase

  methods (Test)
    function testNoArgs(testCase)
      opts = zs_argparse() ;
      expected = struct() ;
      testCase.verifyEqual(opts, expected) ;
    end
  end
end
