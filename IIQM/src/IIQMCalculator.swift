//
//  IIQMCalculator.swift
//  IIQM
//
//  Created by Ike Mattice on 2/21/21.
//  Copyright © 2021 Dexcom. All rights reserved.
//

import Foundation

///Used to calculate the Intermittent Interquartile Mean for a given file name
class IIQMCalculator {
    let data: [Int]
    
    init(filename: String) {
        do {
            self.data = try TextReader().numericValues(from: filename)
        }
        catch {
            print(error)
            self.data = [Int]()
        }
    }
    
    
    
}
