classdef test_zs_bboxNMS < matlab.unittest.TestCase

    methods (Test)
        function testSingleBox(testCase)
            % for an input of a single bbox, zs_bboxNMS
            % should simply return an index of 1
            bboxes = [ 2 4 20 21 0.3 ] ;
            nmsIdx = zs_bboxNMS(bboxes) ;
            expIdx = 1 ;
            testCase.verifyEqual(nmsIdx, expIdx) ;
        end

        function testTwoIntersectingBoxes(testCase)
            % for an input of a two intesecting bboxes,
            % zs_bboxNMS should return the index of the
            % one with the higher score
            bboxes = [ 2 4 20 21 0.3 ;
                       3 5 21 22 0.4 ] ;
            nmsIdx = zs_bboxNMS(bboxes) ;
            expIdx = 2 ;
            testCase.verifyEqual(nmsIdx, expIdx) ;
        end

        function testTwoNonIntersectingBoxes(testCase)
            % for an input of a two non intesecting bboxes,
            % zs_bboxNMS should return the index of
            % both of them
            bboxes = [ 2 4 5 6 0.3 ;
                       12 14 21 22 0.4 ] ;
            nmsIdx = zs_bboxNMS(bboxes) ;
            % sort indices so that they are in ascending order
            % for comparison
            nmsIdx = sort(nmsIdx) ;
            expIdx = [1 ; 2] ;
            testCase.verifyEqual(nmsIdx, expIdx) ;
        end

        function testIntersectingBoxes(testCase)
            % for an input of some intesecting bboxes,
            % zs_bboxNMS should return the correct index
            bboxes = [ 2 4 5 6 0.3 ;
                       3 5 6 9 0.5 ;
                       3 5 6 9 0.7 ;
                       11 13 20 20 0.5 ;
                       12 14 21 22 0.4 ] ;
            nmsIdx = zs_bboxNMS(bboxes) ;
            % sort indices so that they are in ascending order
            % for comparison
            nmsIdx = sort(nmsIdx) ;
            expIdx = [3 ; 4] ;
            testCase.verifyEqual(nmsIdx, expIdx) ;
        end
    end
end
