//
//  TextReaderTests.swift
//  IIQMTests
//
//  Created by Ike Mattice on 2/20/21.
//  Copyright © 2021 Dexcom. All rights reserved.
//

import XCTest
@testable import IIQM

class TextReaderTests: XCTestCase {
    
    func testNumericValuesFromFileName() {
        let rawData = try? TextReader().numericValues(from: "data")
        let rawData20k = try? TextReader().numericValues(from: "data-20k")
        
        guard let data = rawData, let data20k = rawData20k
        else { XCTFail(); return }
        
        XCTAssertEqual(data[0...3],                         [301, 286, 287, 292],   "First 4 values read from 'data.txt' are incorrect")
        XCTAssertEqual(data[data.count-4...data.count-1],   [102, 69, 74, 75],      "Last 4 values read from 'data.txt' are incorrect")
        
        XCTAssertEqual(data20k[0...3],                         [301, 286, 287, 292],   "First 4 values read from 'data-20k.txt' are incorrect")
        XCTAssertEqual(data20k[data20k.count-4...data20k.count-1],   [522, 515, 505, 496],   "Last 4 values read from 'data-20k.txt' are incorrect")
    }

}
