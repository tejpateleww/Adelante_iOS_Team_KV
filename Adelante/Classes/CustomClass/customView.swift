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

class viewWithClearBG : UIView {
    override func awakeFromNib() {
        self.backgroundColor = .clear
        
    }
}
class BorderView : UIView {
    override func awakeFromNib() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = colors.black.value.withAlphaComponent(0.30).cgColor
        self.clipsToBounds = true
    }
}

class myAccountView : UIView {
    @IBInspectable var isProfile : Bool = false
    override func awakeFromNib() {
        if isProfile {
            self.clipsToBounds = true
            self.layer.cornerRadius = self.layer.bounds.height / 2
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
        self.layer.shadowOffset = CGSize(width: -1, height: 1.0)
        self.layer.shadowOpacity = 0.16
        self.layer.shadowRadius = 3.0
    }
}
class addCardDetailsView : UIView {
    override func awakeFromNib() {
        self.layer.cornerRadius = 7
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hexString: "#707070").withAlphaComponent(0.2).cgColor
        
    }
}
class bffComboView : UIView {
    override func awakeFromNib() {
        self.backgroundColor = colors.appGreenColor.value
        
        
    }
}
class homeBlockView : UIView {
    
    @IBInspectable var isPopUpBlock: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(hexString: "#004080").cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 4.0)
        self.layer.shadowOpacity = 0.16
        self.layer.shadowRadius = 5.0
        
        if isPopUpBlock {
            self.layer.borderColor = colors.black.value.withAlphaComponent(0.06).cgColor
            self.layer.borderWidth = 3
        }
    }
}


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
class customImagewithShadow: UIImageView {
    @IBInspectable var isViewRadius : Bool = false
    @IBInspectable var isShadow : Bool = false
    override func awakeFromNib() {
        if isViewRadius{
            self.layer.cornerRadius = 8
        }else if isShadow{
            self.layer.cornerRadius = 5
            self.clipsToBounds = false
            self.layer.masksToBounds = true;
            self.backgroundColor = UIColor.clear
            self.layer.shadowColor = colors.submitButtonShadow.value.cgColor
            self.layer.shadowOpacity = 0.50
            self.layer.shadowOffset = CGSize(width: -4.0, height: 4.0)
            self.layer.shadowRadius = 4.0
            self.layer.masksToBounds = false
        }
    }
}
class CustomviewRadius:UIView{
    @IBInspectable var isCornerRadius:Bool = false
    @IBInspectable var hasShadow:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isCornerRadius {
            self.layer.cornerRadius = self.layer.bounds.height/2
            self.clipsToBounds = true
        }
        if hasShadow {
            self.layer.masksToBounds = false
            self.layer.shadowColor = colors.submitButtonShadow.value.cgColor
            self.layer.shadowOffset = CGSize(width: -1, height: 4.0)
            self.layer.shadowOpacity = 0.5
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
        self.segments = LabelSegment.segments(withTitles: ["MyOrderVC_lblPastOrders".Localized(), "MyOrderVC_lblUpcomingOrders".Localized()], numberOfLines: 1, normalBackgroundColor: colors.segmentDeselectedColor.value, normalFont: CustomFont.NexaRegular.returnFont(16), normalTextColor: colors.black.value.withAlphaComponent(0.29), selectedBackgroundColor: colors.segmentSelectedColor.value, selectedFont: CustomFont.NexaRegular.returnFont(16), selectedTextColor: colors.black.value)
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
class viewRestorentRatingView : UIView
{
    override func awakeFromNib() {
        self.backgroundColor = UIColor(hexString: "#D9D9D9")
        self.layer.cornerRadius = self.frame.size.height / 2
    }
}
class RectangularDashedView: UIView {
    
    @IBInspectable var ViewCornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}
