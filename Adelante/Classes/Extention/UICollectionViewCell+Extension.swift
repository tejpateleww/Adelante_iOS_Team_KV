//
//  UICollectionViewCell+Extension.swift
//  HC Pro Patient
//
//  Created by Shraddha Parmar on 21/09/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
