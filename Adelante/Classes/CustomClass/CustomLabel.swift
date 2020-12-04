//
//  CustomLabel.swift
//  Adelante
//
//  Created by apple on 01/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import Foundation
import UIKit

class titleLabel : UILabel {

@IBInspectable var isWelcomeTitle:Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
            if isWelcomeTitle {
                self.font = CustomFont.NexaBold.returnFont(41)
                self.textAlignment = .left
                self.numberOfLines = 2
                self.lineBreakMode = .byTruncatingTail
            }
        }
}
class themeLabel: UILabel {

    @IBInspectable var isUnderline:Bool = false
    @IBInspectable var underLineColor: UIColor?
    @IBInspectable var LabelColor:UIColor?
    @IBInspectable var isBold:Bool = false
    @IBInspectable var isChangePassword:Bool = false
    @IBInspectable var isSignin:Bool = false
    @IBInspectable var isCreateAccount:Bool = false
    @IBInspectable var isForgotPassword:Bool = false
    @IBInspectable var isVerified:Bool = false
    @IBInspectable var isItemName:Bool = false
    @IBInspectable var isReviewName:Bool = false
    @IBInspectable var isAddress:Bool = false
    @IBInspectable var isdescription:Bool = false
override func awakeFromNib() {
super.awakeFromNib()

    if isUnderline {
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        attributedString.addAttributes([NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor:underLineColor ?? UIColor.clear], range: NSMakeRange(0, attributedString.length))
    }else if isBold{
        self.backgroundColor = .clear
        self.font = CustomFont.NexaBold.returnFont(18)
    }else if isChangePassword{
        self.backgroundColor = .clear
        self.font = CustomFont.NexaBold.returnFont(26)
    }else if isSignin{
        self.backgroundColor = .clear
        self.font = CustomFont.NexaBold.returnFont(30)
    }else if isCreateAccount{
        self.backgroundColor = .clear
        self.font = CustomFont.NexaBold.returnFont(28)
    }else if isForgotPassword{
        self.backgroundColor = .clear
        self.font = CustomFont.NexaBold.returnFont(26)
    }else if isVerified{
        self.font = CustomFont.NexaBold.returnFont(12)
    }else if isItemName{
        self.font = CustomFont.NexaBold.returnFont(20)
    }else if isReviewName{
        self.font = CustomFont.NexaBold.returnFont(15)
    }else if isAddress{
        self.font = CustomFont.NexaRegular.returnFont(14)
    }else if isdescription{
        self.font = CustomFont.NexaRegular.returnFont(12)
    }
    self.textColor = LabelColor
    
}
}
class CustomLabel:UILabel{
    @IBInspectable var isdescription:Bool = false
    override func awakeFromNib() {
    super.awakeFromNib()

        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
        if isdescription{
            self.font = CustomFont.NexaRegular.returnFont(12)
        }
    }
}
