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
    @IBInspectable var isRoundCorner:Bool = false
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
    @IBInspectable var isForgotPass:Bool = false
    @IBInspectable var isShareOrderDetails:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isRoundCorner {
            self.layer.cornerRadius = self.frame.size.height / 2
        }
        self.titleLabel?.font = CustomFont.NexaBold.returnFont(18)
        
        
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
            self.titleLabel?.font = CustomFont.NexaBold.returnFont(18)
            self.setTitleColor(colors.appOrangeColor.value, for: .normal)
        //    self.setunderlineWithUIColor(title: self.titleLabel?.text ?? "", color: underlineColor ?? UIColor.clear , font: (self.titleLabel?.font)!)
        } else if isBold{
            self.backgroundColor = .clear
            self.titleLabel?.font = CustomFont.NexaBold.returnFont(14)
            self.setTitleColor(colors.appOrangeColor.value, for: .normal)
           // self.setunderlineWithUIColor(title: self.titleLabel?.text ?? "", color: underlineColor ?? UIColor.clear , font: (self.titleLabel?.font)!)
        } else if isEditAccount {
            self.backgroundColor = .clear
            self.titleLabel?.font = CustomFont.NexaRegular.returnFont(14)
            self.setTitleColor(colors.appOrangeColor.value, for: .normal)
        } else if isForgotPass {
            self.backgroundColor = .clear
            self.titleLabel?.font = CustomFont.NexaRegular.returnFont(12)
            self.setTitleColor(colors.forgotpassGreyColor.value, for: .normal)
        } else if isShareOrderDetails {
            self.backgroundColor = .clear
            self.titleLabel?.font = CustomFont.NexaBold.returnFont(12)
        }
        if isUnderline {
            self.setunderlineWithUIColor(title: self.titleLabel?.text ?? "", color: underlineColor ?? UIColor.clear , font: (self.titleLabel?.font)!)
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

class collectionVwFilterBtns: UIButton {
    
    @IBInspectable var isCornerRadius:Bool = false
    @IBInspectable var isCategoryBtn: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isCategoryBtn {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        self.titleLabel?.font = CustomFont.NexaRegular.returnFont(14)
        self.setTitleColor(colors.black.value, for: .selected)
        
        self.backgroundColor = colors.clearCol.value //colors.selectedFilterBtn.value
        if isCornerRadius {
            self.layer.cornerRadius = self.frame.size.height / 2
            self.clipsToBounds = true
        }
    }
}

@IBDesignable class CustomButton: UIButton{

@IBInspectable var borderWidth: CGFloat = 0.0 {
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


class myOrdersBtn: UIButton {
    
    @IBInspectable var isCancelOrder:Bool = false
    @IBInspectable var isReorder:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isCancelOrder {
            self.setTitleColor(colors.appRedColor.value, for: .normal)
        } else if isReorder {
            self.setTitleColor(colors.appGreenColor.value, for: .normal)
        }
        self.titleLabel?.font = CustomFont.NexaBold.returnFont(11)
    }
}

class orderDetailsButton: UIButton {
    
    @IBInspectable var isCancel:Bool = false
    @IBInspectable var isRateOrder:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isCancel {
            self.setTitleColor(colors.appRedColor.value, for: .normal)
        } else if isRateOrder {
            self.setTitleColor(colors.appOrangeColor.value, for: .normal)
        }
        self.titleLabel?.font = CustomFont.NexaBold.returnFont(16)
    }
}

class editProfileBtn : UIButton {
    override func awakeFromNib() {
        self.setTitleColor(UIColor(hexString: "#E34A25"), for: .normal)
        self.titleLabel?.font = CustomFont.NexaRegular.returnFont(14)
        self.titleLabel?.textAlignment = .center
        
        
    }
}
class checkoutButton : UIButton {
     @IBInspectable var isChangeLocation : Bool = false
      @IBInspectable var isApplyPromocode : Bool = false
    @IBInspectable var isSeeMenu : Bool = false
     @IBInspectable var isReadPolicy : Bool = false
    
    //.double.rawValue, .thick.rawValue
    override func awakeFromNib() {
        if isChangeLocation {
            let yourAttributes: [NSAttributedString.Key: Any] = [
                .font: CustomFont.NexaBold.returnFont(10),
                .foregroundColor: UIColor(hexString: "#E34A25"),
                .underlineStyle: NSUnderlineStyle.single.rawValue]
            let attributeString = NSMutableAttributedString(string: (self.titleLabel?.text)!,
                                                            attributes: yourAttributes)
            self.setAttributedTitle(attributeString, for: .normal)
        } else if isApplyPromocode {
            self.titleLabel?.font = CustomFont.NexaBold.returnFont(14)
            self.setTitleColor(UIColor(hexString: "#E34A25"), for: .normal)
            
        } else if isSeeMenu {
            let yourAttributes: [NSAttributedString.Key: Any] = [
                .font: CustomFont.NexaBold.returnFont(12),
                .foregroundColor: UIColor(hexString: "#E34A25"),
                .underlineStyle: NSUnderlineStyle.single.rawValue]
            let attributeString = NSMutableAttributedString(string: (self.titleLabel?.text)!,
                                                            attributes: yourAttributes)
            self.setAttributedTitle(attributeString, for: .normal)
        } else if isReadPolicy {
            let yourAttributes: [NSAttributedString.Key: Any] = [
                .font: CustomFont.NexaRegular.returnFont(14),
                .foregroundColor: UIColor(hexString: "#E34A25"),
                .underlineStyle: NSUnderlineStyle.single.rawValue]
            let attributeString = NSMutableAttributedString(string: (self.titleLabel?.text ?? ""),
                                                            attributes: yourAttributes)
            self.setAttributedTitle(attributeString, for: .normal)
        } else {
            self.setTitleColor(UIColor(hexString: "#E34A25"), for: .normal)
            self.titleLabel?.font = CustomFont.NexaBold.returnFont(16)
        }
        
    }
    
    
    
}

class underLineButton : UIButton {
    @IBInspectable var isUnderline:Bool = false
    @IBInspectable var underlineColor:UIColor?
    override func awakeFromNib() {
        self.titleLabel?.font = CustomFont.NexaRegular.returnFont(12)
        if isUnderline {
            self.setunderlineWithUIColor(title: self.titleLabel?.text ?? "", color: underlineColor ?? UIColor.clear , font: (self.titleLabel?.font)!)
        }
    }
}

class applyPromoCodeButtton : UIButton {
    @IBInspectable var isCancle:Bool = false
    override func awakeFromNib() {
           self.setTitleColor(colors.white.value, for: .normal)
             self.titleLabel?.font = CustomFont.NexaBold.returnFont(14)
             self.titleLabel?.textAlignment = .center
        self.backgroundColor = colors.appGreenColor.value
        if isCancle {
             self.backgroundColor = colors.appRedColor.value
        }
    }
}
