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
        
        simulateDataFlow()
    }
    
    func showDataFailureAlert() {
        //here is some code to show a UIAlert when the data is unavailable
    }
    
    // Can we use recusion when new data is added?
    func simulateDataFlow() {
        //start with the interquartile mean for the first 4 values
//        var currentMean = Array(data[0...3]).interquartileMean()
//        var q1 = data[Int(data.count*1/4)]
//        var q2 = data.mean()
//        var q3 = data[Int(data.count*3/4)]
        
        
//        Looking for patterns as data is added
//        sample data set of 10 random numbers between 1-10
//        [9 9 3 2 5 4 6 6 8 1]
//
        
//        //look for pattern in quartiles as new numbers are added
//        [9, 9, 3, 2].sorted = [2, 3, 9, 9]
//        q1 = 2.5, q2=6, q3 = 9
//        //add 5
//        [2, 3, 5, 9, 9]
//        q1 = 2.5, q2=5, q3 = 9
//        Note: the count is odd and the new value is in the median quartile, so the q1 & q3 do not change
//        //add 4
//        [2, 3, 4, 5, 9, 9]
//        q1 = 3, q2=4.5, q3 = 9
//        Note: the value is between q1 and q2, so those are recalculated.  q3 stays the same
//        add 6
//        [2, 3, 4, 5, 6, 9, 9]
//        q1 = 3, q2=5, q3 = 9
//        Note: the count is odd and the new value is in the median quartile, so the q1 &q3 do not change
//        add 6
//        [2, 3, 4, 5, 6, 6, 9, 9]
//        q1 = 3.5, q2=5.5, q3 = 7.5
//        Note: the count is even and all values changed
//        add 8
//        [2, 3, 4, 5, 6, 6, 8, 9, 9]
//        q1 = 3.5, q2=6, q3 = 8.5
//        add 1
//        [1, 2, 3, 4, 5, 6, 6, 8, 9, 9]
//        q1 = 3, q2=5.5, q3 = 8
//        //it doesn't look like there is a pattern we can exploit by just calculating q1, q2, and q3 and the new number
//        //the points at which the values stay the same don't seem reliable with such a small data set

        
//        //only recalculate on the odd count?
//        //this would be kind of difficult to understand without a lot of payoff.  When we get to the millions of values, the median will still be too large to calculate quickly

        
//        //aggregate numbers?
//        [1, 2, 9, 10]
//        q1 = 1.5, q3 = 9.5, m = 5.5
//        [1, 5.5, 10]
//        //add 7
//        [1, 5.5, 7, 10]
//        [1, 6.25, 10]
//        //the values are lost over time.  This would likely be fast and also trend accurate over time, but if we are looking for exact, testable matches, this wouldn't be a good approach

        
//        //just return the average of q1 & q3?
//        //very fast but not accurate.  Doesn't account for weight of values in the middle quartile
        
        
        
        //Results
        //we can limit recalculating q1 and q3 to every other value
        //if the new value is below q1 or above q3, then we should recalculate that value and then recalculate the mean
        //We could reduce the size of the median quartile
        //We could reduce the number of calculations
            //batched data?
        
        
        
        for (index, _) in data.enumerated() {
            //ignore the first 4 values
            if index < 4 { continue }
//            var arr = data[0...index]
//            var q1 = arr[Int(arr.count*1/4)]
//            var q2 = data.mean()
//            var q3 = arr[Int(arr.count*3/4)]
            
            //crunch the interquartile mean up until the current index
            let mean = Array(data[0...index]).interquartileMean()
            
            let meanString = String(format: "%.2f", mean)
            
            print("Index => \(index), Mean => \(meanString)")
        }
    }
    
    ///A test calculation for optimizing the calculation of Interquartile Mean
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
