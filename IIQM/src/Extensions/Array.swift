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
    public func mean() -> Int {
        //depending on what would be best for the application, we could, and probably should, return nil here
        //not sure if I want this function to be optional just to handle the case of an empty array
        //could also throw an error
        guard !self.isEmpty else { return 0 }
        return self.reduce(0) { $0 + $1 } / self.count    }
}
