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
        
//        simulateDataFlow()
        
    }
    
    func showDataFailureAlert() {
        //here is some code to show a UIAlert when the data is unavailable
    }
    
    // Can we use recusion when new data is added?
    func simulateDataFlow() {
        //start with the interquartile mean for the first 4 values
        var currentMean = Array(data[0...3]).interquartileMean()
        
        for (index, _) in data.enumerated() {
            //ignore the first 4 values
            if index < 4 { continue }
            
            //crunch the interquartile mean up until the current index
            currentMean = Array(data[0...index]).interquartileMean()
            
            let meanString = String(currentMean)
            
            print("Index => \(index), Mean => \(meanString)")
        }
    }
}
