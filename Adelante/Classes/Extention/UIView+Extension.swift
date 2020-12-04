//
//  UIView+Extension.swift
//  CoreSound
//
//  Created by EWW083 on 04/02/20.
//  Copyright © 2020 EWW083. All rights reserved.
//
import Foundation
import UIKit

extension UIView {

@IBInspectable
var cornerRadius: CGFloat {
get {
    return layer.cornerRadius
}
set {
    layer.cornerRadius = newValue
}
}
    func setUpAutomaticRadius(){
        layer.cornerRadius = layer.frame.height/2
    }
    
    public func setGradientView(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
         let gradientLayer = CAGradientLayer()
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = self.frame.height/2
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
    
    public func setTransparentGradientView() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        let whiteColor = UIColor.red
        gradient.colors = [UIColor.clear.cgColor, whiteColor.cgColor, whiteColor.cgColor, UIColor.clear.cgColor]
        gradient.locations = [NSNumber(value: 0.0),NSNumber(value: 0.1),NSNumber(value: 0.9),NSNumber(value: 1.0)]
        self.frame = self.bounds
        self.layer.mask = gradient
    }
    
    func setBorderColor(bcolor:colors){
          self.layer.borderColor  = bcolor.value.cgColor
          self.layer.borderWidth = 1
      }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


