//
//  CustomTextView.swift
//  Adelante
//
//  Created by baps on 04/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import GrowingTextView
import JVFloatLabeledTextField
class CustomTextView: UITextView {
    
}
class themeTextView: GrowingTextView {
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.font = CustomFont.NexaRegular.returnFont(15)
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.borderColor = UIColor(hexString: "#707070").withAlphaComponent(0.2).cgColor
        self.layer.borderWidth = 1
        self.minHeight = 134
        self.textContainerInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
    }
}
class floatTextView: JVFloatLabeledTextView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.lineColor = colors.forgotpassGreyColor.value
//        self.titleColor = colors.textFieldColor.value
//
//        self.selectedTitleColor = colors.textFieldColor.value
//        self.selectedLineColor = colors.textFieldColor.value
//
//        self.textColor = colors.black.value
//        self.titleFormatter = { $0 }
//        self.titleColor = colors.black.value
//        self.lineHeight = 0.0
//        self.selectedLineHeight = 0.0
//        self.selectedTitleColor = colors.black.value
//        self.lineColor = colors.forgotpassGreyColor.value
//        self.selectedLineColor = colors.forgotpassGreyColor.value
//        self.textColor = colors.textFieldColor.value
//        self.titleFormatter = { $0 }
//        
//        self.titleFont = CustomFont.NexaBold.returnFont(18)
//        self.font = CustomFont.NexaRegular.returnFont(16)
//        
//        if isEditProfile {
//            self.titleFont = CustomFont.NexaBold.returnFont(18)
//            self.font = CustomFont.NexaRegular.returnFont(16)
//        }
    }
}
