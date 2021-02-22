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

import Foundation

///Used to calculate the Intermittent Interquartile Mean for a given file name
class IIQMCalculator {
    let intermittentData: [Int]
    
    init(filename: String) throws {
        do {
            self.intermittentData = try TextReader().numericValues(from: filename)
        }
        catch FileError.invalidFileName {
            self.intermittentData = [Int]()
            throw FileError.invalidFileName
        }
    }
    ///Calculates the Intermittent Interquartile Mean by keeping track of the sum of the median quartile
    func progressiveSum() {
        //Since we know we start with 4 values, we can calculate the initial sum from that part of the array
        var medianSum: Int = intermittentData[1...2].reduce(0, {$0 + $1})
        var recievedData = intermittentData[0...3]
                
        for (index, value) in intermittentData.enumerated() {
            //ignore the first 4 values since the array is starting with those
            if index < 4 { continue }

            //insert the new value into the array so that it stays sorted
            var insertIndex = recievedData.count
        
            //TODO: - Test if building out a search tree would improve performance here
            while insertIndex > 0 && value < recievedData[insertIndex - 1] {
                insertIndex -= 1
            }
            recievedData.insert(value, at: insertIndex)
            
            //            Search Tree Iteration - unfinished
            //            while insertIndex > 0 && value < initialData[insertIndex - 1] {
            //                if value < initialData[insertIndex] {
            //                    insertIndex = insertIndex / 2
            //                }
            //                else {
            //                    insertIndex = insertIndex
            //                }
            //                insertIndex = insertIndex / 2
            //
            //                insertIndex -= 1
            //            }
            
            ///The index at the end of the first quartile
            let q1i = Int(recievedData.count*1/4)
            ///The index at the end of the third quartile
            let q3i = Int(recievedData.count*3/4)

            //TODO: Test and verify the intended behavior here
            //The following block is likely incorrect.  The goal is to update the median sum with the new value, as well as determine if anything needs to be subtracted from the median sum if the median quartile shifts towards q1 or q3.

            //if the value is in the median quartile, we can just add it to the sum
            if value >= recievedData[q1i] && value <= recievedData[q3i] {
                medianSum  += value
            }
            
            //the new value pushes the median towards q3
            else if value < recievedData[q1i] {
                medianSum -= recievedData[q1i]
            }
            
            //the new value pushes the median towards q1
            else if value > recievedData[q3i] {
                medianSum -= recievedData[q1i]
            }
            
            //return the middle value of the medianSum
            let interquartileMean: Double = Double(medianSum) / 2

            let meanString = String(format: "%.2f", interquartileMean)
            print("Index => \(index), Mean => \(meanString)")
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
    
    //I don't think that this method fits the optimization challenge brief: "still calculates the Incremental Interquartile Mean after each value is read"
    //this gives us inaccurate data and does not speed up the calculation significantly.
    //enabling this function requires the Array extension to include Double values instead of/including Int
//    ///Calculates the Intermittent Interquartile Mean using aggregated data and batches
//    func averageBatch() {
//        let batchSize: Int = 1000
//        var currentData = Array(data[0...3])
//
//        for (index, value) in data.enumerated() {
//            if index < 4 { continue }
//
//            currentData.append(value)
//
////            //if the current data has gotten bigger than our batch size, aggregate the median values down to the mean
//            if currentData.count > batchSize {
//                //set the current data to the current q1, q3, and mean
//                currentData = [currentData[Int(currentData.count*1/4)],  currentData[Int(currentData.count*3/4)], currentData.interquartileMean()]
//            }
//
//            let mean = currentData.interquartileMean()
//            let meanString = String(format: "%.2f", mean)
//
//            print("Index => \(index), Mean => \(meanString)")
//        }
//    }
}
