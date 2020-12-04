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
<<<<<<< HEAD
        
        if isWelcomeTitle {
            self.font = CustomFont.NexaBold.returnFont(41)
            self.textAlignment = .left
            self.numberOfLines = 2
            self.lineBreakMode = .byTruncatingTail
=======
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
>>>>>>> d54e4d40b838dd1d54ee3d2e20c953490db17001
        }
    }
}

class myLocationLabel : UILabel {
    
    @IBInspectable var isHeader:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isHeader {
            self.textColor = colors.myLocTitleHome.value.withAlphaComponent(0.8)
            self.font = CustomFont.NexaRegular.returnFont(16)
        } else {
            self.textColor = colors.myLocValueHome.value
            self.font = CustomFont.NexaRegular.returnFont(14)
        }
    }
}

class themeLabel: UILabel {
    
    @IBInspectable var isUnderline:Bool = false
    @IBInspectable var underLineColor: UIColor?
    @IBInspectable var labelColor: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isUnderline {
            let attributedString = NSMutableAttributedString(string: self.text ?? "")
            attributedString.addAttributes([NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor:underLineColor ?? UIColor.clear], range: NSMakeRange(0, attributedString.length))
        }
        self.textColor = labelColor
    }
}

class colVwRestaurantLabel: UILabel {
    
    @IBInspectable var isRestaurantTitle:Bool = false
    @IBInspectable var isRestaurantDesc:Bool = false
    
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isRestaurantTitle {
            self.font = CustomFont.NexaBold.returnFont(23)
            self.backgroundColor = colors.appOrangeColor.value.withAlphaComponent(0.78)
            self.roundCorners(corners: [.topRight, .bottomRight], radius: 5)
            self.textColor = colors.white.value
            self.numberOfLines = 1
            self.lineBreakMode = .byTruncatingTail
        } else if isRestaurantDesc {
            self.font = CustomFont.NexaRegular.returnFont(14)
            self.backgroundColor = UIColor(hexString: "#1C1C1C").withAlphaComponent(0.78)
            self.roundCorners(corners: [.topRight, .bottomRight], radius: 5)
            self.textColor = colors.white.value
            self.numberOfLines = 1
            self.lineBreakMode = .byTruncatingTail
        }
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}

class tblHomeLabels: UILabel {
    
    @IBInspectable var isRestaurantName:Bool = false
    @IBInspectable var isPrice:Bool = false
    @IBInspectable var isRating:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = colors.black.value
        if isRestaurantName {
            self.font = CustomFont.NexaRegular.returnFont(15)
        } else if isPrice {
            self.font = CustomFont.NexaBold.returnFont(13)
        } else if isRating {
            self.font = CustomFont.NexaRegular.returnFont(9)
            self.textAlignment = .center
        }
    }
}
