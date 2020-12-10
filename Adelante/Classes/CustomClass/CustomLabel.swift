//
//  CustomLabel.swift
//  Adelante
//
//  Created by apple on 01/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import Foundation
import UIKit

//MARK: -new
//MARK: -views

class myaccountLabel : UILabel {
    @IBInspectable var isUserName : Bool = false
    @IBInspectable var isSubDetails : Bool = false
  
    override func awakeFromNib() {
        if isUserName {
            self.textAlignment = .left
            self.font = CustomFont.NexaBold.returnFont(18)
            self.textColor = colors.black.value
        } else if isSubDetails {
            self.textAlignment = .left
            self.font = CustomFont.NexaRegular.returnFont(14)
            self.textColor = colors.black.value
        }
        
    }
}



class CheckOutLabel : UILabel {
     @IBInspectable var isUserName : Bool = false
     @IBInspectable var isAddress : Bool = false
     @IBInspectable var isYourOrder : Bool = false
    @IBInspectable var isYourOrderSubTitle : Bool = false
     @IBInspectable var isYourOrderPrice : Bool = false
    @IBInspectable var isYourOrderTotalTitle : Bool = false
       @IBInspectable var isYourOrderTotalPrice : Bool = false
     @IBInspectable var isCancellationPolicy: Bool = false
     @IBInspectable var isTotalQuantity: Bool = false
     @IBInspectable var isProductName: Bool = false
    @IBInspectable var isProductTotalPrice: Bool = false
    override func drawText(in rect: CGRect) {
      
        if isUserName || isAddress {
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
                   super.drawText(in: rect.inset(by: insets))
        } else {
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                  super.drawText(in: rect.inset(by: insets))
        }
       
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        if isUserName || isAddress {
            
            return CGSize(width: size.width + 0 + 0,
                          height: size.height + 0 + 5)
        }
        return CGSize(width: size.width, height: size.height)
    }

    override var bounds: CGRect {
        didSet {
            if isUserName || isAddress {
                preferredMaxLayoutWidth = bounds.width - (0 + 0)
            }
        }
       
        
    }
    override func awakeFromNib() {
        if isUserName {
            self.font = CustomFont.NexaBold.returnFont(20)
            self.textColor = colors.black.value
            self.textAlignment = .left
        } else if isAddress {
            self.font = CustomFont.NexaRegular.returnFont(13)
            self.textColor = colors.black.value
            self.textAlignment = .left
        } else if isYourOrder {
            self.font = CustomFont.NexaBold.returnFont(18)
            self.textColor = colors.black.value
            self.textAlignment = .left
        } else if isYourOrderSubTitle {
            self.font = CustomFont.NexaRegular.returnFont(15)
            self.textColor = colors.black.value
            self.textAlignment = .left
        } else if isYourOrderPrice {
            self.font = CustomFont.NexaBold.returnFont(15)
            self.textColor = colors.black.value
            self.textAlignment = .right
        } else if isYourOrderTotalTitle {
            self.font = CustomFont.NexaBold.returnFont(15)
            self.textColor = colors.black.value
            self.textAlignment = .left
        } else if isYourOrderTotalPrice {
            self.font = CustomFont.NexaBold.returnFont(20)
            self.textColor = colors.black.value
            self.textAlignment = .right
        } else if isCancellationPolicy {
            self.font = CustomFont.NexaRegular.returnFont(14)
            self.textColor = UIColor(hexString: "#636455")
            self.textAlignment = .left
            
        } else if isTotalQuantity {
            self.font = CustomFont.NexaRegular.returnFont(12)
            self.textColor = colors.black.value
            self.textAlignment = .center
        } else if isProductName {
            self.font = CustomFont.NexaBold.returnFont(14)
            self.textColor = colors.black.value
            self.textAlignment = .left
        }
        else if isProductTotalPrice {
            self.font = CustomFont.NexaRegular.returnFont(14)
            self.textColor = colors.black.value
            self.textAlignment = .right
        }
        
        
        
    }
}


class addPaymentlable : UILabel {
    @IBInspectable var isWallet : Bool = false
    @IBInspectable var isCardNumber : Bool = false
    @IBInspectable var isExpires : Bool = false
    override func awakeFromNib() {
        if isWallet {
            self.font = CustomFont.NexaBold.returnFont(18)
            self.textColor = colors.black.value
            self.textAlignment = .left
        }  else if isCardNumber {
            self.font = CustomFont.NexaBold.returnFont(18)
            self.textColor = UIColor(hexString: "#222B45")
            self.textAlignment = .left
        } else if isExpires {
            self.font = CustomFont.NexaLight.returnFont(13)
            self.textColor = UIColor(hexString: "#222B45")
            self.textAlignment = .left
        }
        
    }
}



class addCardLabel : UILabel {
    @IBInspectable var isDetailsTitle : Bool = false
    override func awakeFromNib() {
        self.font = CustomFont.NexaRegular.returnFont(11)
        self.textColor = UIColor(hexString: "#ACB1C0")
        self.textAlignment = .left
        if isDetailsTitle {
            self.font = CustomFont.NexaRegular.returnFont(12)
            self.textColor = colors.black.value
            self.textAlignment = .left
        }
        
    }
}


class bffComboLabel : UILabel {
    @IBInspectable var isDetailsTitle : Bool = false
    override func awakeFromNib() {
        self.textColor = colors.white.value
        self.font = CustomFont.NexaRegular.returnFont(16)
       
        if isDetailsTitle {
            self.textColor = colors.black.value
            self.font = CustomFont.NexaRegular.returnFont(15)
        }
       
    }
}
class sortPopUPLabel : UILabel {
    @IBInspectable var isTitle : Bool = false
    override func awakeFromNib() {
       self.textColor = colors.black.value
       self.font = CustomFont.NexaRegular.returnFont(18)
       
        if isTitle {
            self.textColor = colors.black.value
                   self.font = CustomFont.NexaBold.returnFont(25)
            
        }
       
    }
}
class commonPopUPLabel : UILabel {
     @IBInspectable var isTitle : Bool = false
    override func awakeFromNib() {
        self.textAlignment = .center
        self.textColor = UIColor(hexString: "#1E1E1E")
        self.font = CustomFont.NexaRegular.returnFont(20)
        
        if isTitle {
            self.textAlignment = .center
            self.textColor = UIColor(hexString: "#1E1E1E")
            self.font = CustomFont.NexaBold.returnFont(25)
        }
    }
}

class commonPopupButton : UIButton {
    override func awakeFromNib() {
        self.setTitleColor(colors.white.value, for: .normal)
        self.titleLabel?.font = CustomFont.NexaBold.returnFont(14)
        self.titleLabel?.textAlignment = .center
    }
}


//MARK: -old

class titleLabel : UILabel {
    
    @IBInspectable var isWelcomeTitle:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isWelcomeTitle {
            self.font = CustomFont.NexaRegular.returnFont(41)
            self.textAlignment = .left
            self.numberOfLines = 2
            self.lineBreakMode = .byTruncatingTail
        }
    }
}

class myLocationLabel : UILabel {
    
    @IBInspectable var isHeader:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isHeader {
            self.textColor = colors.myLocTitleHome.value.withAlphaComponent(0.8)
            self.font = CustomFont.NexaBold.returnFont(16)
        } else {
            self.textColor = colors.myLocValueHome.value
            self.font = CustomFont.NexaRegular.returnFont(14)
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
    @IBInspectable var isYourFavTitle:Bool = false
    @IBInspectable var isBoldLabel:Bool = false
    @IBInspectable var isRegularLabel:Bool = false
    @IBInspectable var isRestorentDescription:Bool = false
     @IBInspectable var isNotificatioTitle:Bool = false
    @IBInspectable var isNotificatioDescription:Bool = false
override func awakeFromNib() {
super.awakeFromNib()
 self.textColor = LabelColor
    if isUnderline {
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        attributedString.addAttributes([NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor:underLineColor ?? UIColor.clear], range: NSMakeRange(0, attributedString.length))
    } else if isBold{
        self.backgroundColor = .clear
        self.font = CustomFont.NexaBold.returnFont(18)
    } else if isChangePassword{
        self.backgroundColor = .clear
        self.font = CustomFont.NexaBold.returnFont(26)
    } else if isSignin{
        self.backgroundColor = .clear
        self.font = CustomFont.NexaBold.returnFont(30)
    } else if isCreateAccount {
        self.backgroundColor = .clear
        self.font = CustomFont.NexaBold.returnFont(28)
    } else if isForgotPassword {
        self.backgroundColor = .clear
        self.font = CustomFont.NexaBold.returnFont(26)
    } else if isVerified{
        self.font = CustomFont.NexaBold.returnFont(12)
    } else if isItemName{
        self.font = CustomFont.NexaBold.returnFont(20)
    } else if isReviewName{
        self.font = CustomFont.NexaBold.returnFont(15)
    } else if isAddress{
        self.font = CustomFont.NexaRegular.returnFont(14)
    } else if isdescription{
        self.font = CustomFont.NexaRegular.returnFont(12)
    } else if isYourFavTitle{
           self.font = CustomFont.NexaBold.returnFont(20)
    }else if isBoldLabel{
        self.font = CustomFont.NexaBold.returnFont(16)
    }else if isRegularLabel{
        self.font = CustomFont.NexaRegular.returnFont(16)
    } else if isRestorentDescription {
       self.font = CustomFont.NexaRegular.returnFont(13)
    } else if isNotificatioTitle {
        self.font = CustomFont.NexaRegular.returnFont(17)
        self.textColor = UIColor(hexString: "#242E42")
    } else if isNotificatioDescription {
        self.font = CustomFont.NexaRegular.returnFont(17)
               self.textColor = UIColor(hexString: "#242E42")
    }
   
    
}
}

class CustomLabel:UILabel{
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
    @IBInspectable var isdescription:Bool = false
    
    override func drawText(in rect: CGRect) {
      
        if isdescription {
            let insets = UIEdgeInsets(top: 7, left: 11, bottom: 6, right: 11)
                   super.drawText(in: rect.inset(by: insets))
        } else {
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                  super.drawText(in: rect.inset(by: insets))
        }
       
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        if isdescription {
            
            return CGSize(width: size.width + 11 + 11,
                          height: size.height + 7 + 6)
        }
        return CGSize(width: size.width, height: size.height)
    }

    override var bounds: CGRect {
        didSet {
            if isdescription {
                preferredMaxLayoutWidth = bounds.width - (11 + 11)
            }
        }
       
        
    }
    
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


class colVwRestaurantLabel: UILabel {
    
    @IBInspectable var isRestaurantTitle:Bool = false
    @IBInspectable var isRestaurantDesc:Bool = false
    
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 4.0
    @IBInspectable var rightInset: CGFloat = 4.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isRestaurantTitle {
            self.font = CustomFont.NexaBold.returnFont(23)
            self.backgroundColor = colors.appOrangeColor.value.withAlphaComponent(0.78)
            self.layer.cornerRadius = 5
           // self.roundCorners(corners: [.topRight, .bottomRight, .bottomLeft , .topLeft], radius: 5)
            self.textColor = colors.white.value
            self.numberOfLines = 1
            self.lineBreakMode = .byTruncatingTail
        } else if isRestaurantDesc {
            self.font = CustomFont.NexaRegular.returnFont(14)
            self.backgroundColor = UIColor(hexString: "#1C1C1C").withAlphaComponent(0.78)
            self.layer.cornerRadius = 5
          //  self.roundCorners(corners: [.topRight, .bottomRight, .bottomLeft , .topLeft], radius: 5)
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
    @IBInspectable var isDistance:Bool = false
    
    
      @IBInspectable var topInset: CGFloat = 0.0
      @IBInspectable var bottomInset: CGFloat = 0.0
      @IBInspectable var leftInset: CGFloat = 0.0
      @IBInspectable var rightInset: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = colors.black.value
        if isRestaurantName {
            self.font = CustomFont.NexaRegular.returnFont(15)
        } else if isPrice {
            self.font = CustomFont.NexaBold.returnFont(13)
        } else if isDistance {
            self.font = CustomFont.NexaBold.returnFont(12)
            self.textAlignment = .right
        }  else if isRating {
            self.font = CustomFont.NexaRegular.returnFont(9)
            self.textAlignment = .right
        }
    }
    override func drawText(in rect: CGRect) {
        if isRating {
            let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: rect.inset(by: insets))
        } else if isRestaurantName {
           let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: rect.inset(by: insets))
        } else {
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            super.drawText(in: rect.inset(by: insets))
        }
          
      }

      override var intrinsicContentSize: CGSize {
        if isRating {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + leftInset + rightInset,
                          height: size.height + topInset + bottomInset)
        } else if isRestaurantName {
           let size = super.intrinsicContentSize
                       return CGSize(width: size.width + leftInset + rightInset,
                                     height: size.height + topInset + bottomInset)
        } else {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + 0 + 0,
                          height: size.height + 0 + 0)
        }
          
      }

      override var bounds: CGRect {
          didSet {
            if isRating {
                 preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
            } else if isRestaurantName {
                preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
            } else {
                 preferredMaxLayoutWidth = bounds.width - (0 + 0)
            }
              // ensures this works within stack views if multi-line
             
          }
      }
}

class tblMyOrdersLabel: UILabel {
    
    @IBInspectable var isTitle:Bool = false
    @IBInspectable var isLocation:Bool = false
    @IBInspectable var isPrice:Bool = false
    @IBInspectable var isItem:Bool = false
    @IBInspectable var isDateTime:Bool = false
    @IBInspectable var isDescription:Bool = false
    
    @IBInspectable var isItemName:Bool = false
    @IBInspectable var isItemSize:Bool = false
    @IBInspectable var isItemPrice:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textColor = colors.black.value
        if isTitle {
            self.font = CustomFont.NexaBold.returnFont(21)
        } else if isLocation {
            self.font = CustomFont.NexaRegular.returnFont(12)
        } else if isPrice {
            self.font = CustomFont.NexaBold.returnFont(14)
        } else if isItem {
            self.font = CustomFont.NexaBold.returnFont(12)
        } else if isDateTime {
            self.font = CustomFont.NexaRegular.returnFont(10)
        } else if isDescription {
            self.font = CustomFont.NexaRegular.returnFont(10)
        } else if isItemName {
            self.font = CustomFont.NexaRegular.returnFont(14)
        } else if isItemSize {
            self.font = CustomFont.NexaRegular.returnFont(12)
            self.textColor = UIColor(hexString: "#000000").withAlphaComponent(0.33)
        } else if isItemPrice {
            self.font = CustomFont.NexaBold.returnFont(12)
        }
    }
}

class orderDetailsLabel:UILabel {
    
    @IBInspectable var isOrderId:Bool = false
    @IBInspectable var isNoOfItems:Bool = false
    @IBInspectable var isRestName:Bool = false
    @IBInspectable var isLocation:Bool = false
    @IBInspectable var isAddress:Bool = false
    @IBInspectable var isTblItem:Bool = false
    @IBInspectable var isTblDtTime:Bool = false
    @IBInspectable var isYourOrderTitle:Bool = false
    @IBInspectable var isTotalTitle:Bool = false
    @IBInspectable var isTotal:Bool = false
    @IBInspectable var isAmountTitle:Bool = false
    @IBInspectable var isAmountValue:Bool = false
    @IBInspectable var isSharedFrom:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = colors.black.value
        self.textAlignment = .left
        
        if isOrderId {
            self.font = CustomFont.NexaBold.returnFont(13)
        } else if isNoOfItems {
            self.font = CustomFont.NexaRegular.returnFont(15)
        } else if isRestName {
            self.font = CustomFont.NexaBold.returnFont(24)
        } else if isLocation {
            self.font = CustomFont.NexaRegular.returnFont(14)
        } else if isAddress {
            self.font = CustomFont.NexaRegular.returnFont(13)
        } else if isTblItem {
            self.font = CustomFont.NexaBold.returnFont(14)
        } else if isTblDtTime {
            self.font = CustomFont.NexaRegular.returnFont(12)
        } else if isYourOrderTitle {
            self.font = CustomFont.NexaBold.returnFont(18)
        } else if isTotalTitle {
             self.font = CustomFont.NexaBold.returnFont(15)
        } else if isTotal {
            self.font = CustomFont.NexaBold.returnFont(20)
            self.textAlignment = .right
        } else if isAmountTitle {
            self.font = CustomFont.NexaRegular.returnFont(15)
        } else if isAmountValue {
            self.font = CustomFont.NexaBold.returnFont(15)
            self.textAlignment = .right
        } else if isSharedFrom {
            self.font = CustomFont.NexaBold.returnFont(16)
            self.textColor = colors.appOrangeColor.value
            self.textAlignment = .right
        }
    }
}

