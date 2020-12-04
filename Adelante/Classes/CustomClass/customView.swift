//
//  customView.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import Foundation
import UIKit

class customView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
@IBDesignable
class CustomView: UIView{

@IBInspectable var borderWidth: CGFloat = 0.0{
    didSet{
        self.layer.borderWidth = borderWidth
    }
}
@IBInspectable var borderColor: UIColor = UIColor.clear {
    didSet {
        self.layer.borderColor = borderColor.cgColor
    }
}
override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
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
