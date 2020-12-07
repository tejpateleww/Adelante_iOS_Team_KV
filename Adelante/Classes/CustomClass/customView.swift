//
//  customView.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import Foundation
import UIKit
import BetterSegmentedControl

class customImageView: UIImageView {
    
    @IBInspectable  var isCornerRadius:Bool = false
    @IBInspectable var cornerRadiusValue: CGFloat = 0
    @IBInspectable var hasShadow: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentMode = .scaleAspectFill
        
        if isCornerRadius {
            self.layer.cornerRadius = cornerRadiusValue
            self.clipsToBounds = true
        }
        
        if hasShadow {
            self.layer.masksToBounds = false
            self.layer.shadowColor = colors.submitButtonShadow.value.cgColor
            self.layer.shadowOffset = CGSize(width: -1, height: 4.0)
            self.layer.shadowOpacity = 0.17
            self.layer.shadowRadius = 5.0
        }
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

class myOrdersSegmentControl: BetterSegmentedControl {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.segments = LabelSegment.segments(withTitles: ["Past orders", "Upcoming"], numberOfLines: 1, normalBackgroundColor: colors.segmentDeselectedColor.value, normalFont: CustomFont.NexaRegular.returnFont(16), normalTextColor: colors.black.value.withAlphaComponent(0.29), selectedBackgroundColor: colors.segmentSelectedColor.value, selectedFont: CustomFont.NexaRegular.returnFont(16), selectedTextColor: colors.black.value)
        self.indicatorViewBorderColor = colors.segmentSelectedColor.value
        self.indicatorViewBackgroundColor = colors.segmentSelectedColor.value
        self.backgroundColor = colors.segmentDeselectedColor.value
        self.animationSpringDamping = 1.0
    }
}

class seperatorView: UIView {
    @IBInspectable var isDarkLine:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = colors.seperatorColor.value
        if isDarkLine {
            self.backgroundColor = colors.darkSeperatorColor.value
        }
    }
}

class viewWithClearBG : UIView {
    override func awakeFromNib() {
        self.backgroundColor = .clear
        
    }
}


class myAccountView : UIView {
     @IBInspectable var isProfile : Bool = false
    override func awakeFromNib() {
        if isProfile {
            self.clipsToBounds = true
                   self.layer.cornerRadius = self.frame.height / 2
        }
       
       // self.layer.borderWidth = 2
        //self.layer.borderColor = UIColor(hexString: "#707070").withAlphaComponent(0.6).cgColor
    }
}


class checkoutView : UIView {
     @IBInspectable var isMapView : Bool = false
    override func awakeFromNib() {
        self.layer.cornerRadius = 14
        self.layer.borderColor = UIColor(hexString: "#707070").withAlphaComponent(0.2).cgColor
        self.layer.borderWidth = 1
        if isMapView {
            self.layer.cornerRadius = 7
            self.clipsToBounds = true
        }
    }
}

class PaymentView : UIView {
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
         self.clipsToBounds = true
        
        self.layer.masksToBounds = false
        
        self.layer.shadowColor = colors.black.value.cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 4.0)
        self.layer.shadowOpacity = 0.16
        self.layer.shadowRadius = 5.0
    }
}

class addCardDetailsView : UIView {
    override func awakeFromNib() {
        self.layer.cornerRadius = 7
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hexString: "#707070").withAlphaComponent(0.2).cgColor
       
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
