testCase = test_zs_bboxNMS ;
res1 = run(testCase,'testSingleBox') ;
res2 = run(testCase,'testTwoIntersectingBoxes') ;
res3 = run(testCase,'testTwoNonIntersectingBoxes') ;

testCase = test_zs_argparse ;
