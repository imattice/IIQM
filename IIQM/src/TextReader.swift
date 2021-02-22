//
//  TextReader.swift
//  IIQM
//
//  Created by Ike Mattice on 2/20/21.
//  Copyright © 2021 Dexcom. All rights reserved.
//

import Foundation

///Used to simulate asynchronus data from a text file
class TextReader {
    func numericValues(from filename: String) throws -> [Int] {
        do {
            //locate the file in the app bundle
            guard let url = Bundle.main.url(forResource: filename, withExtension: "txt")
            else { throw FileError.invalidFileName }
           
            //retrieve and format the contents of the file
            let contents = try String(contentsOf: url, encoding: .ascii).trimmingCharacters(in: .whitespacesAndNewlines)
            
            //convert the file from a String to an array of Int
            let lines = contents.components(separatedBy: .newlines).map { Int($0)! }
            
            return lines
            
        } catch FileError.invalidFileName {
            print("Unable to read file: \(filename).txt")
            throw FileError.invalidFileName
        } catch {
            print(error)
            return [Int]()
        }
        
    }
}

enum FileError: Error {
    case invalidFileName
}
