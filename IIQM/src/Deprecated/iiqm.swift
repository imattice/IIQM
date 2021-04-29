//
//  iiqm.swift
//  IIQM
//
//  Created by Shaun Winters on 9/21/17.
//  Copyright © 2017 Dexcom. All rights reserved.
//

import Foundation

//REFACTORING
//PROBLEM: IIQM lacks readability and clairity.
//1) The name IIQM does not convey what the class is used for.  We can either get rid of it, or rename it.
//2) The two functions contained are a bit unrelated and don't necessarily need to be grouped together in the same class.
//3) The calculate:path method is very difficult to understand.  Variables are excessive and poorly named, there are no comments or descriptions, and it relies on the readFile:path method, which I don't think is necessary.

//SOLUTIONS:
//1) Move the calculate:path method to an Array<Int> extension.  This will allow us to act on the data directly, which will improve readability as well as give this functionality to any Array<Int> in the app without having to call a custom class.
//2) Create a class that is designated for reading the text file.  That is a unique behavior that should be in its own class.  This also leaves open the potential to expand it if in the future we need to read other files.
//3) Use proper naming conventions and add definitions to all classes, methods, and properties so that it is clear what they are used for.
//4) Both the Array<Int> extension and the TextReader class can be easily tested.  We can develop these using TDD.
//5) Deprecate the old IIQM class so that future developers do not use it. This also sets it up to be permanently removed in the future

@available(*, deprecated, message: "Use IIQMCalculator instead")
class IIQM {
    @available(*, deprecated, message: "Use Array<Double>.interquartileMean() instead")
    func calculate(path: String) -> Double {
        let lines = readFile(path: path)
        var data: [Int] = []
        var mean: Double = 0.0
        for line in lines {
            let value: Int = Int(line)!
            data.append(value)
            data.sort()
            
            if (data.count >= 4) {
                let q: Double = Double(data.count) / 4.0
                let i: Int = Int(q.rounded(.up)) - 1
                let c: Int = Int((q*3).rounded(.down)) - i + 1
                let ys = data[i...(i+c-1)]
                let factor: Double = q - ((Double(ys.count) / 2.0) - 1)
                var sum = 0
                
                var j = 0
                for listEnumerator in ys {
                    if (j == 0) {
                        j += 1
                        continue;
                    }
                    else if (j == (ys.count - 1)) {
                        break;
                    }
                    
                    sum += listEnumerator
                    j += 1
                }
                
                mean = (Double(sum) + Double(ys.first! + ys.last!) * factor) / (2.0 * q)
                let meanString = String(format:"%.2f", mean)
                print("Index => \(data.count), Mean => \(meanString)")
            }
        }
        return mean
    }
    @available(*, deprecated, message: "Use TextReader().numericValues(from filename) instead")
    func readFile(path: String) -> Array<String> {
        do {
            let contents:NSString = try NSString(contentsOfFile: path, encoding: String.Encoding.ascii.rawValue)
            let trimmed:String = contents.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            let lines:Array<String> =  NSString(string: trimmed).components(separatedBy: NSCharacterSet.newlines)
            return lines
        } catch {
            print("Unable to read file: \(path)")
            return [String]()
        }
    }
}
