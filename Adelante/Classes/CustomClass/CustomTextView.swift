//
//  CustomTextView.swift
//  Adelante
//
//  Created by baps on 04/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import GrowingTextView

class CustomTextView: UITextView {
    
}
class themeTextView: GrowingTextView {
    @IBInspectable var isBorder: Bool = false
    @IBInspectable var isFeedback:Bool = false
    @IBInspectable var isCornerRadius:Bool = false
    @IBInspectable var RadiusValue:CGFloat = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        if isFeedback{
            self.font = CustomFont.NexaRegular.returnFont(16)
            self.textColor = colors.textFieldColor.value
            self.minHeight = 79
            self.maxHeight = 79
            self.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        }else{
            self.font = CustomFont.NexaRegular.returnFont(15)
            self.minHeight = 134
            self.textContainerInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        }
        if isBorder{
            self.layer.borderColor = UIColor(hexString: "#707070").withAlphaComponent(0.2).cgColor
            self.layer.borderWidth = 1
        }
        if isCornerRadius{
            self.layer.cornerRadius = RadiusValue
            self.clipsToBounds = true
        }
    }
}

