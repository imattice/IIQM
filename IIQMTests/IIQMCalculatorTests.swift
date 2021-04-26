//
//  IIQMCalculatorTests.swift
//  IIQMTests
//
//  Created by Ike Mattice on 4/24/21.
//  Copyright © 2021 Dexcom. All rights reserved.
//

import XCTest

@testable import IIQM

class IIQMCalculatorTests: XCTestCase {

    func testHashMapCalculation() {
        let firstDozen = IIQMCalculator(dataSet: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
            .calculateFromHashMap()
        let simple = IIQMCalculator(dataSet: [14,  6,  4,  2])
            .calculateFromHashMap()
        let variableValues = IIQMCalculator(dataSet: [3, 4, 4, 5, 6, 9, 10, 10])
            .calculateFromHashMap()
        let multipleValuesAtQuartileEdge = IIQMCalculator(dataSet: [3, 4, 4, 4, 10, 10, 10, 10])
            .calculateFromHashMap()
        let oddNumberOfValues = IIQMCalculator(dataSet: [335,  320,  28,  364,  485,  190,  592,  200,  264,  368,  439,  140,  259,  382,  493,  120,  294,  395,  406,  433,  95,  462,  173,  505,  325]).calculateFromHashMap()
       
        XCTAssertEqual(firstDozen,  6.5,      "Could not calculate interquartile mean for values 1 - 12")
        XCTAssertEqual(simple,  5,      "Could not calculate interquartile mean for simple array")
        XCTAssertEqual(variableValues,  6,      "Could not calculate interquartile mean for variable values")
        XCTAssertEqual(multipleValuesAtQuartileEdge,  7,      "Could not calculate interquartile mean for a variable values")

        XCTAssertEqual(oddNumberOfValues, 334.94,    "Could not calculate interquartile mean for array with odd number of values")
    }
    
    func testOriginalValue() {
        let data20k = 413.15
        let data = 458.81
        
        let hash20K = try? IIQMCalculator(filename: "data-20k")
            .calculateFromHashMap()
        print(hash20K)
        let hash = try? IIQMCalculator(filename: "data")
            .calculateFromHashMap()

        XCTAssertEqual(data20k, hash, "Hash Method did not produce the correct result for test file 'data-20k.txt'")
        XCTAssertEqual(data, hash, "Hash Method did not produce the correct result for test file 'data.txt'")
    }

    
    func testHashMapAndDeprecatedMethodComparison() {
        let deprecatedMethod = IIQM().calculate(path: Bundle.main.path(forResource: "data", ofType: "txt")!)
        let hashMethod = try? IIQMCalculator(filename: "data-20k").calculateFromHashMap()

        XCTAssertNotNil(hashMethod)
        XCTAssertEqual(deprecatedMethod, hashMethod, "Hash method does not produce the same results as 'IIQM().caculate:path:forResource'")
    }

}
