//
//  ArrayTests.swift
//  IIQMTests
//
//  Created by Ike Mattice on 2/20/21.
//  Copyright © 2021 Dexcom. All rights reserved.
//

import XCTest

@testable import IIQM

//simple test cases include 5 values between 1 - 25
//complex test cases include 25 values between 1 - 600
//Number generation and calculations by https://www.calculatorsoup.com/calculators/statistics/quartile-calculator.php

class ArrayTests: XCTestCase {

    func testMean() {
        let empty = [Int]()
        let zero = [0, 0, 0]
        let single = [5]
        let negative = [-10, -5, -5, -4, -4, -10]
        let simple = [10, 9, 6, 10, 2]
        let complex = [181, 270, 221, 232, 1, 129, 477, 140, 356, 95, 1, 1, 248, 292, 337, 273, 166, 509, 434, 223, 274, 282, 511, 309, 167]
        
        XCTAssertEqual(empty.mean(),        0,      "Mean of empty array is invalid")
        XCTAssertEqual(zero.mean(),         0,      "Mean of an array of zeros is incorrect")
        XCTAssertEqual(single.mean(),       5,      "Mean of a single item array is incorrect")
        XCTAssertEqual(negative.mean(),     -19/3,
                       "Mean of an array of negative values is incorrect")
        XCTAssertEqual(simple.mean(),       7.4,      "Mean of a simple values is incorrect")
        XCTAssertEqual(complex.mean(),      245.16,    "Mean of large values is incorrect")
    }
    
    func testInterquartileMean() {
        let sorted = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let simple = [14,  6,  4,  2,  17]
        let complex = [335,  320,  28,  364,  485,  190,  592,  200,  264,  368,  439,  140,  259,  382,  493,  120,  294,  395,  406,  433,  95,  462,  173,  505,  325]
        
        XCTAssertEqual(sorted.interquartileMean(),  5.5,      "Could not calculate interquartile mean for sorted array")
        XCTAssertEqual(simple.interquartileMean(),  8,      "Could not calculate interquartile mean for simple array")
        XCTAssertEqual(complex.interquartileMean(), 334.2307692307692,    "Could not calculate interquartile mean for complex array")
    }
//    removed this test since we are no longer using this method
//    func testRemoveInterquartileBounds() {
//        let zero = [0.0, 0, 0]
//
//        XCTAssertEqual(zero.medianQuartileValues(), [0, 0, 0], "Failed to remove interquartile bounds of empty array")
//
//        let sorted = [1.0, 2, 3, 4, 5, 6, 7, 8, 9, 10]
//
//        XCTAssertEqual(sorted.medianQuartileValues(), [3, 4, 5, 6, 7, 8], "Failed to remove interquartile bounds of sorted array")
//
//
//        let simple = [10.0,  8,  2,  3,  1]
//
//        XCTAssertEqual(simple.medianQuartileValues(), [2, 3, 8], "Failed to remove interquartile bounds of simple array")
//
//
//        let complex = [93.0,  291,  205,  572,  175,  484,  456,  569,  33,  192,  245,  331,  126,  340,  424,  238,  156,  564,  516,  345,  195,  422,  10,  433,  112]
//
//        XCTAssertEqual(complex.medianQuartileValues(), [175, 192, 195, 205, 238, 245, 291, 331, 340, 345, 422, 424, 433], "Failed to remove interquartile bounds of complex array")
//    }
}
