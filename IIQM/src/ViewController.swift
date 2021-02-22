//
//  ViewController.swift
//  IIQM
//
//  Created by Ryan Arana on 6/15/18.
//  Copyright © 2018 Dexcom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var data = [Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let data = try? TextReader().numericValues(from: "data-20k")
        else { showDataFailureAlert(); return }
        
        self.data = data
        
//        IIQM().calculate(path: "data-20k")
        
        progressiveSum()
    }
    
    func showDataFailureAlert() {
        //here is some code to show a UIAlert when the data is unavailable
    }
    
//    PROBLEM - iterating over a long list of values takes too long
//        - This appears to be because the methods used to get the IQ mean are initializing new arrays from array subslices and generating new arrays during sort
//
//    SOLUTIONS -
//
//    1) Update and sort in batches
//            This method reduces the number of calculations, but in the end doesn't save that much time. We lose the granularity of each iteration
//
//    2) Value aggregation
//              We can reduce the size of the array by replacing the values with aggregate values.  This tradees off speed for accuracy.  This also still relies on sorting arrays after the aggregation occurs, which appears to be taking up most of the time.  If we are looking for exact, testable matches, this wouldn't be a good approach
//
//    3) Store calculations as an index : mean key value pair, and then look up the value
//              Would not scale well
//
//    4) Progressive Sum
//              We just keep track of the sum of the median quartile, which we can then use to find the mean value we are after
//              This would also mean that we would only be adding/subtracting at most 3 values at a time from the sum, avoiding having to sum up the entire median quartile over and over
//              We will still need to track the values in the q1 and q3 in case the median quartile shifts in those directions, so keeping another array to hold each of those values would be necessary.  To avoid calling .sorted() each time a new value is added, we need to figure out at what index in our current array to insert the new values so that it stays sorted without (exessive?) looping or creating a new array.  Maybe some kind of search tree?
    
    
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
    func averageBatch() {
        let batchSize: Int = 1000
        var currentData = Array(data[0...3])
        
        for (index, value) in data.enumerated() {
            if index < 4 { continue }
            
            currentData.append(value)

//            //if the current data has gotten bigger than our batch size, aggregate the median values down to the mean
            if currentData.count > batchSize {
                //set the current data to the current q1, q3, and mean
                currentData = [currentData[Int(currentData.count*1/4)],  currentData[Int(currentData.count*3/4)], currentData.interquartileMean()]
            }
            
            let mean = currentData.interquartileMean()
            let meanString = String(format: "%.2f", mean)
            
            print("Index => \(index), Mean => \(meanString)")
        }
    }
}
