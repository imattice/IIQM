//
//  ViewController.swift
//  IIQM
//
//  Created by Ryan Arana on 6/15/18.
//  Copyright © 2018 Dexcom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var data = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let data = try? TextReader().numericValues(from: "data-20k")
        else { showDataFailureAlert(); return }
        
        self.data = data
                
//        IIQM().calculate(path: "data-20k")
        
//        progressiveSum()
//        arrayExtension()
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
    
    

}
