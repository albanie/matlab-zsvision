testCase = test_zv_bboxNMS ;
res1 = run(testCase,'testSingleBox') ;
res1 = run(testCase,'testTwoIntersectingBoxes') ;
res1 = run(testCase,'testTwoNonIntersectingBoxes') ;
