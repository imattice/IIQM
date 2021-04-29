//
//  IIQMCalculator.swift
//  IIQM
//
//  Created by Ike Mattice on 2/21/21.
//  Copyright © 2021 Dexcom. All rights reserved.
//

//OPTIMIZATION
//    PROBLEM: iterating over a long list of values takes too long
//        - A large portion of time is used by initializing new arrays from array subslices and generating new arrays during sort.  We could significantly reduce the time by eliminating/reducing the use of sort and avoid creating as many arrays as possible
//
//    SOLUTIONS:
//    1) Update and sort in batches
//            This method reduces the number of calculations, but in the end doesn't save that much time. We lose the granularity of each iteration
//    2) Value aggregation
//              We can reduce the size of the array by replacing the values with aggregate values.  It would be much faster to sort an array of only 4 values.  However, this tradees off speed for accuracy.  This also still relies on sorting arrays after the aggregation occurs, which may not cut down on that much time if it runs millions of times.  If we are looking for exact, testable matches, this wouldn't be a good approach.
//    3) Store calculations as an index : mean key value pair, and then look up the value
//              Does not really address the issue of the mean calculation taking a long time.
//    4) Progressive Sum
//              We just keep track of the sum of the median quartile rather than all the individual values. We can then divide that sum by half to find the mean of the median quartile
//              This would also mean that we would only be adding/subtracting at most 3 values at a time from the sum, avoiding having to sum up the entire median quartile over and over
//              There would still be a cost associated with keeping track of the q1 and q3 values in case the median quartile shifts in those directions.  These values would also need to stay sorted.
//              To avoid calling .sorted() each time a new value is added, we need to figure out at what index in our current array to insert the new values so that it stays sorted without (exessive?) looping or creating a new array.  Maybe some kind of search tree?
//   5) Hash Map
//  The bounds of the data (0-600) can be used as indicies of an array and the values of the array can be used to count the instances of those values as new data comes in.  This limits the size of the array we need to work with to a maximum size of 600 integers.  This should significantly improve the speed at which the calculation can be run on extremely large data sets.

import Foundation

///Used to calculate the Intermittent Interquartile Mean for a given file name
class IIQMCalculator {
    let intermittentData: [Int]
    
    ///An array of counts where the index represent the value and the element represent the number of occurances in the data set
    var hashMap = Array(repeating: 0, count: 601)
    
    var dictMap = [Int : Int]()

    
    init(filename: String) throws {
        do {
            self.intermittentData = try TextReader().numericValues(from: filename)
            for value in intermittentData {
            addToHashMap(value: value)
            }
        }
        catch FileError.invalidFileName {
            self.intermittentData = [Int]()
            throw FileError.invalidFileName
        }
    }
    
    init(dataSet: [Int]) {
        print(dataSet)
        self.intermittentData = dataSet
        for value in dataSet {
        addToHashMap(value: value)
        }
    }
    
    
    ///Calculates the Intermittent Interquartile Mean using extensions from Array<Double>
    func arrayExtension() {
        for (index, _) in intermittentData.enumerated() {
            let mean = Array(intermittentData[0...index]).interquartileMean()
            
            let meanString = String(format: "%.2f", mean)
            print("Index => \(index), Mean => \(meanString)")

        }
    }
    
    
    //TODO: - Green test on cases where data set is not divisible by 4
    //TODO: - Green test for cases where there are multiple values around the quartile
    //TODO: - Refactor out repetitive code
    //TODO: - Update challenge answers
    
    
    func calculateFromHashMap() -> Double {
        ///The number of objects in each quartile
        let qSize: Double = Double(hashMap.filter { $0 != 0 }.reduce(0, +)) / 4.0
        print("qSize: \(qSize)")
        ///tracks the current iteration of values with counts
        var iterationIndex: Double = 0
        ///the sum of the values in the interquartile
        var sum: Double = 0.0
        ///The index of the inclusive lower bound of the interquartile
        let lowerBound = floor(qSize)
        ///The index of the inclusive upper bound of the interquartile
        let upperBound = floor(qSize*3)
        ///Tracks if the lower bound has been reached while iterating through the data set
        var foundLowerBound = false
        ///Tracks if the upper bound has been reached while iterating through the data set
        var foundUpperbound = false
        
        //loop through the values in the hash map
        //(O(1) as there will be 600 values in the worst case)
        for (value, count) in hashMap.enumerated() {
            //ignore the values that are not in the array
            guard count != 0 else { continue }
            
            
            //increase the index as we look at each value with an associated count by that count
            iterationIndex += Double(count)
            
            //determine if the next count will bring the index into the fourth quartile
            if iterationIndex >= upperBound && !foundUpperbound {

                let iqCount = (iterationIndex - upperBound) + 1
                print("upperBound value: \(value)");
                print("index quartile difference: \(iqCount)");
              
                sum += Double(value)*iqCount
                
                //add any fractional value to the sum
                
                foundUpperbound = true
                continue
            }
            
            //determine if the next count will bring the index into the interquartile
            if iterationIndex > lowerBound && !foundLowerBound {
                //determine how many of the count belong to the interquartile
                let iqCount = iterationIndex - lowerBound
                print("lowerBound value: \(value)");
                print("index quartile difference: \(iqCount)");

                sum += Double(value)*iqCount

                //add any fractional value to the sum
                
                foundLowerBound = true
                continue
            }
            
            //ignore the values in the q1 and q4
            if iterationIndex <= lowerBound || iterationIndex > upperBound {
                print("ignored: \(value)"); continue }
            
            //if the value not at the ends of the interquartile, just add them to the sum
            sum +=  Double(value)
            
            print(value)
        }
        
        
        return Double(sum) / (qSize * 2.0)
    }
    
    func calculateFromDict() -> Double {
        let sum = 0.0
        
        let sorted = dictMap.sorted { $0.key < $1.key }
        
        print(sorted)
        
        return sum
    }
    
    func addToHashMap(value: Int) {
        hashMap[value] += 1
        
        dictMap[value] = (dictMap[value] ?? 0) + 1
    }
}
