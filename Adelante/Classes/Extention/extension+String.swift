//
//  extension+String.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 02/10/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
        let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
        return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
            }.joined().dropFirst())
    }
    
    func isEmptyOrWhitespace() -> Bool {
        
        return self.trimmingCharacters(in: (.whitespaces)).isEmpty
    }
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    /// - Returns: formatted phone number or original value
    public func toPhoneNumber() -> String {
        let digits = self.digitsOnly
        if digits.count == 10 {
            return digits.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1)-$2-$3", options: .regularExpression, range: nil)
        }
        else if digits.count == 11 {
            return digits.replacingOccurrences(of: "(\\d{1})(\\d{3})(\\d{3})(\\d+)", with: "$1($2)-$3-$4", options: .regularExpression, range: nil)
        }
        else {
            return self
        }
    }
    
    func encodeUTF8() -> String? {
        
        //If I can create an NSURL out of the string nothing is wrong with it
        if let _ = URL(string: self) {
            
            return self
        }
        
        //Get the last component from the string this will return subSequence
        let optionalLastComponent = self.split { $0 == "/" }.last
        
        
        if let lastComponent = optionalLastComponent {
            
            //Get the string from the sub sequence by mapping the characters to [String] then reduce the array to String
            let lastComponentAsString = lastComponent.map { String($0) }.reduce("", +)
            
            
            //Get the range of the last component
            if let rangeOfLastComponent = self.range(of: lastComponentAsString) {
                //Get the string without its last component
                let stringWithoutLastComponent = self.substring(to: rangeOfLastComponent.lowerBound)
                
                //Encode the last component
                if let lastComponentEncoded = lastComponentAsString.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) {
                    
                    
                    //Finally append the original string (without its last component) to the encoded part (encoded last component)
                    let encodedString = stringWithoutLastComponent + lastComponentEncoded
                    
                    //Return the string (original string/encoded string)
                    return encodedString
                }
            }
        }
        
        return nil;
    }
}

extension StringProtocol {
    
    /// Returns the string with only [0-9], all other characters are filtered out
    var digitsOnly: String {
        return String(filter(("0"..."9").contains))
    }
}
extension URL {

    mutating func appendQueryItem(name: String, value: String?) {

        guard var urlComponents = URLComponents(string: absoluteString) else { return }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: name, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        self = urlComponents.url!
    }
    
   
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
    
}
extension Date {
    func currentTimeZoneDate() -> String {
        let dtf = DateFormatter()
        dtf.timeZone = TimeZone.current
        dtf.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dtf.string(from: self)
    }
}
