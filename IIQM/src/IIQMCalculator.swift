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
    
    func progressiveSum() {
        let test = [1.0, 2, 3, 4, 1, 6, 30, 28, 12, 2, 3]
        var interquartileMean: Double = 0
        //Since we know we start with 4 values, we can calculate the initial sum from that part of the array
//        var medianSum: Double = data[1...2].reduce(0, {$0 + $1})
        var initialData = [800.0]//data[0...3]
                
        for (index, value) in test.enumerated() { //data.enumerated() {
            //ignore the first 4 values
//            if index < 4 { continue }

            //insert the new value into the array so that it stays sorted
            var insertIndex = initialData.count //- 1//value >= initialData[initialData.count / 2] ? initialData.count / 2 : initialData.count - 1
           
//            Search Tree Iteration
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
            
            
            //TODO: - Test if building out a search tree would improve performance here
            while insertIndex > 0 && value < initialData[insertIndex - 1] {
                insertIndex -= 1
            }
            initialData.insert(value, at: insertIndex)
            
            dump(initialData)
            
            
            ///The index at the end of the first quartile
            let q1i = Int(initialData.count*1/4)
            ///The index at the end of the third quartile
            let q3i = Int(initialData.count*3/4)
            ///The sum of the q2 and q3 quartiles
            let medianQ = initialData[q1i...q3i]
            
            
            

            
//            let mean = initialData[(initialData.count*1/4)...(initialData.count*3/4)].reduce(0) { $0 + $1 } / Double(initialData.count)
            
//            if value > data[index / 4] || value < data[(3*index) / 4] {
//
//            }
            //if the index is odd and the value is in the median, then nothing changes
            //add to the sum
            
            
            
            //if the index is even, we need to recalculate the bounds of the quartile
//            if index % 2 == 0 {
//                ///The values of the data array up to the current iterative index
//                let arr = data[0...index].sorted()
//                ///The index at the end of the first quartile
//                let q1i = Int(arr.count*1/4)
//                ///The index at the end of the third quartile
//                let q3i = Int(arr.count*3/4)
//                ///The sum of the q2 and q3 quartiles
//                let medianQ = arr[q1i...q3i]
//
//                //if the value is not in the q1 or q4, then we need to recalcualte the interquartileMean
//                if value > arr[q1i] || value < arr[q3i] {
//                    interquartileMean = arr.interquartileMean() //medianQ.reduce(0, {$0 + $1} ) / Double(medianQ.count)
//                }
//            }
            

            let meanString = String(format: "%.2f", interquartileMean)
            print("Index => \(index), Mean => \(meanString)")
        }
        

    }
    
    func arrayExtension() {
        for (index, _) in data.enumerated() {
            let mean = Array(data[0...index]).interquartileMean()
            
            let meanString = String(format: "%.2f", mean)
            print("Index => \(index), Mean => \(meanString)")

        }
    }
    
    ///A  calculation for optimizing the calculation of Interquartile Mean
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
