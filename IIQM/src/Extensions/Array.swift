//
//  Array.swift
//  IIQM
//
//  Created by Ike Mattice on 2/20/21.
//  Copyright © 2021 Dexcom. All rights reserved.
//

import Foundation

extension Array where Element == Int {
    ///Returns the average value of the array using standard rounding
    public func mean() -> Double {
        //return 0 if the array is empty
        //-this could also return nil or throw an error, depending on how we would want to handle an empty case
        guard !self.isEmpty else { return 0 }
        //add up all values of the array and divide by the count
        return Double(self.reduce(0) { $0 + $1 }) / Double(self.count)
    }
    
    ///Returns the average value of the middle 50% of the array
    public func interquartileMean() -> Double {
        //get the middle 50% of values
        let midQ = self.sorted()[(count*1/4)...(count*3/4)]
        //add up all values of the array and divide by the count
        return Double(midQ.reduce(0) { $0 + $1 }) / Double(midQ.count)
    }
    
    
    //- Originally, I thought it would be neccessary to use a method to remove the q1 and q3.  I first used a mutating method, but it didn't read as well as I had hoped, and it was a bit clumsy to use.  I then opted for a method that just returned another array, but while optimizing, I found that creating so many arrays (both in sorting and in returning an array) that this was causing significant slowdown.  This function is not particularly useful to Array<Int> anyway, so I moved this functionality to the interquartileMean function and just removed this extra step
    
//    ///Removes the highest and lowest 25% of values
//    func medianQuartileValues() -> [Double] {
//        let lowerIndex = Int(count*1/4)
//        let upperIndex = Int(count*3/4)
//
//        return Array(self.sorted()[lowerIndex...upperIndex])
//    }

    
//    ///Removes the highest and lowest 25% of values
//    mutating func removeInterquartileBounds() {
//        self.sort()
//        let lowerIndex = Int(count*1/4)
//        let upperIndex = Int(count*3/4)
//
//        self = Array(self[lowerIndex...upperIndex])
//    }
    
}
