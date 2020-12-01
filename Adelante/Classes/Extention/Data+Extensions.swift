//
//  Data+Extensions.swift
//  CoreSound
//
//  Created by EWW083 on 04/02/20.
//  Copyright © 2020 EWW083. All rights reserved.
//

import Foundation
import UIKit
extension Data {
    mutating func appendString(string: String) {
        let data = string.data(using: .utf8, allowLossyConversion: true)
        append(data!)
    }
    
    func toString() -> String
    {
        return String(data: self, encoding: .utf8)!
    }
}
