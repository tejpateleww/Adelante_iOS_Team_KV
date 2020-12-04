//
//  customView.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import Foundation
import UIKit

class customImageView: UIImageView {
    
    @IBInspectable  var isCornerRadius:Bool = false
    @IBInspectable var cornerRadiusValue: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentMode = .scaleAspectFill
        
        if isCornerRadius {
            self.layer.cornerRadius = cornerRadiusValue
            self.clipsToBounds = true
        }
    }
}

class customView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//class GradientView: UIView {
//
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        if isVertical {
//            let gradient = CAGradientLayer()
//            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
//            gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
//            let whiteColor = UIColor.white
//            gradient.colors = [whiteColor.withAlphaComponent(0.2).cgColor, whiteColor.withAlphaComponent(0.5).cgColor, whiteColor.withAlphaComponent(0.2).cgColor, whiteColor.withAlphaComponent(0.9).cgColor]
//            gradient.locations = [NSNumber(value: 0.0),NSNumber(value: 0.1),NSNumber(value: 0.75), NSNumber(value: 0.9)]
//            gradient.frame = self.frame
//            self.layer.mask = gradient
//        } else {
//            self.backgroundColor = .clear
//        }
//    }
//}
