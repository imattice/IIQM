//
//  ViewController.swift
//  IIQM
//
//  Created by Ryan Arana on 6/15/18.
//  Copyright © 2018 Dexcom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let calculator = try? IIQMCalculator(filename: "data-20k")
        else { showDataFailureAlert(); return }
        
   //     calculator.calculateFromHashMap()
       // calculator.arrayExtension()
//        calculator.progressiveSum()
        
        //deprecated method
//        let iiqm = IIQM()
//         iiqm.calculate(path: Bundle.main.path(forResource: "data-20k", ofType: "txt")!)
    }
    
    func showDataFailureAlert() {
        print("calculator intiialization failed; showing UIAlertController")
        //here is some code to show a UIAlert when the calculator cannot be initialized
    }
}
