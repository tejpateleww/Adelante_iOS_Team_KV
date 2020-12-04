//
//  UITableViewCell+Extension.swift
//  Qwnched-Delivery
//
//  Created by EWW074 - Sj's iMAC on 31/08/20.
//  Copyright © 2020 EWW074. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
