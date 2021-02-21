//
//  Array.swift
//  IIQM
//
//  Created by Ike Mattice on 2/20/21.
//  Copyright © 2021 Dexcom. All rights reserved.
//

import Foundation

extension Array where Element == Double {
    ///Returns the average value of the array using standard rounding
    public func mean() -> Double {
        guard !self.isEmpty else { return 0 }
        return self.reduce(0) { $0 + $1 } / Double(self.count)
    }
    
    ///Returns the average value of the middle 50% of the array
    public func interquartileMean() -> Double {
//        var midQ = self
//            midQ.removeInterquartileBounds()
        return medianQuartileValues().mean()
    }
    
    ///Removes the highest and lowest 25% of values
    func medianQuartileValues() -> [Double] {
        let lowerIndex = Int(count*1/4)
        let upperIndex = Int(count*3/4)
        
        return Array(self.sorted()[lowerIndex...upperIndex])
    }

    
//    ///Removes the highest and lowest 25% of values
//    mutating func removeInterquartileBounds() {
//        self.sort()
//        let lowerIndex = Int(count*1/4)
//        let upperIndex = Int(count*3/4)
//
//        self = Array(self[lowerIndex...upperIndex])
//    }
    
}
