//
//  customButton.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import Foundation
import UIKit


class submitButton: UIButton {
    
    @IBInspectable var isAppOrangeBg:Bool = false
    @IBInspectable var isAppGreenBg:Bool = false
    @IBInspectable var isWhiteBg:Bool = false
    @IBInspectable var isCornerRadius:Bool = false
    @IBInspectable var hasShadow:Bool = false
    @IBInspectable var isSkipButton:Bool = false
    @IBInspectable var isUnderline:Bool = false
    @IBInspectable var underlineColor:UIColor?
    @IBInspectable var isBold:Bool = false
    @IBInspectable var isEditAccount:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel?.font = CustomFont.NexaBold.returnFont(18)
        
        if isUnderline {
                   self.setunderlineWithUIColor(title: self.titleLabel?.text ?? "", color: underlineColor ?? UIColor.clear , font: (self.titleLabel?.font)!)
               }
        if isAppOrangeBg {
            self.backgroundColor = colors.appOrangeColor.value
            self.setTitleColor(colors.white.value, for: .normal)
        } else if isAppGreenBg {
            self.backgroundColor = colors.appGreenColor.value
            self.setTitleColor(colors.white.value, for: .normal)
        } else if isWhiteBg {
            self.backgroundColor = colors.white.value
            self.setTitleColor(colors.black.value, for: .normal)
        } else if isSkipButton {
            self.backgroundColor = .clear
            self.titleLabel?.font = CustomFont.NexaRegular.returnFont(18)
            self.setTitleColor(colors.appOrangeColor.value, for: .normal)
        }else if isBold{
            self.backgroundColor = .clear
            self.titleLabel?.font = CustomFont.NexaBold.returnFont(14)
            self.setTitleColor(colors.appOrangeColor.value, for: .normal)
            self.setunderlineWithUIColor(title: self.titleLabel?.text ?? "", color: underlineColor ?? UIColor.clear , font: (self.titleLabel?.font)!)
        }else if isEditAccount {
            self.backgroundColor = .clear
            self.titleLabel?.font = CustomFont.NexaRegular.returnFont(14)
            self.setTitleColor(colors.appOrangeColor.value, for: .normal)
        }
        
        
        if isCornerRadius {
            self.layer.cornerRadius = self.frame.size.height / 2
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
class CustomButton: UIButton{

@IBInspectable var borderWidth: CGFloat = 0.0{
    didSet{
        self.layer.borderWidth = borderWidth
    }
}
//@IBInspectable var borderColor: UIColor = UIColor.clear {
//    didSet {
//        self.layer.borderColor = borderColor.cgColor
//    }
//}
override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
}
}
