//
//  Array.swift
//  IIQM
//
//  Created by Ike Mattice on 2/20/21.
//  Copyright © 2021 Dexcom. All rights reserved.
//

import Foundation

//TODO: - return double
//TODO: - can also extend to doubles?
extension Array where Element == Int {
    ///Returns the average value of the array using standard rounding
    public func mean() -> Int {
        guard !self.isEmpty else { return 0 }
        return self.reduce(0) { $0 + $1 } / self.count
    }
    
    ///Returns the average value of the middle 50% of the array
    public func interquartileMean() -> Int {
        var midQ = self
            midQ.removeInterquartileBounds()
        return midQ.mean()
    }
    
    //TODO: Remove mutating function to prevent the interquartile method from needing to be mutating
    ///Removes the highest and lowest 25% of values
    mutating func removeInterquartileBounds() {
        self.sort()
        let lowerIndex = Int(count*1/4)
        let upperIndex = Int(count*3/4)
        
        self = Array(self[lowerIndex...upperIndex])
    }
    
}
