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
    let intermittentData: [Int]
    let initialData = intermittentData[0...3]

    
    init(filename: String) throws {
        do {
            self.intermittentData = try TextReader().numericValues(from: filename)
        }
        catch FileError.invalidFileName {
            self.intermittentData = [Int]()
            throw FileError.invalidFileName
        }
    }
    
    func progressiveSum() {
        //Since we know we start with 4 values, we can calculate the initial sum from that part of the array
        var medianSum: Int = intermittentData[1...2].reduce(0, {$0 + $1})
        var recievedData = intermittentData[0...3]
                
        for (index, value) in intermittentData.enumerated() {
            //ignore the first 4 values since the array is starting with those
            if index < 4 { continue }

            //insert the new value into the array so that it stays sorted
            var insertIndex = initialData.count //- 1//value >= initialData[initialData.count / 2] ? initialData.count / 2 : initialData.count - 1
           

            
            
            //TODO: - Test if building out a search tree would improve performance here
            while insertIndex > 0 && value < initialData[insertIndex - 1] {
                insertIndex -= 1
            }
            initialData.insert(value, at: insertIndex)
            
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
            let q1i = Int(initialData.count*1/4)
            ///The index at the end of the third quartile
            let q3i = Int(initialData.count*3/4)
            ///The sum of the q2 and q3 quartiles
            let medianQ = initialData[q1i...q3i]
            
            
            //This may be incorrect.  I'd want to study the pattern a bit more before settling on this
            //the quartiles are recalculated on the even indexes
            if index % 2 == 0 {
                //if the value is in the median quartile, we can just add it to the sum
                if value >= initialData[q1i] && value <= initialData[q3i] {
                    medianSum  += value
                }
                
                //the new value pushes the median towards q3
                else if value < initialData[q1i] {
                    medianSum -= initialData[q1i]
                }
                
                //the new value pushes the median towards q1
                else if value > initialData[q3i] {
                    medianSum -= initialData[q1i]
                }
            }
            
            //return the middle value of the medianSum, which should represent the middle value of the median quartile
            var interquartileMean: Double = Double(medianSum) / 2

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
    
    ///Calculates the Intermittent Interquartile Mean using aggregated data and batches
    //This may be illegal based on point 3 in the optimization challenge brief: "still calculates the Incremental Interquartile Mean after each value is read"
    //this gives us inaccurate data and does not speed up the calculation significantly.
    //enabling this function requires the Array extension to include Double values instead of/including Int
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
