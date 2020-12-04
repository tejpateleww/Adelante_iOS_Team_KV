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
    
    @IBInspectable public var isChat: Bool = false
    @IBInspectable public var isComplaintView: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.font = CustomFont.NexaRegular.returnFont(15)
//        if isChat {
//            self.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
//            self.layer.cornerRadius = self.frame.height / 2
//            self.clipsToBounds = true
//            self.minHeight = 98
//        } else if isComplaintView {
//            self.backgroundColor = .clear
//            self.minHeight = 134
//            self.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
//            let strMain = "The main complaint (300 characters)"
//            let rangeSmall = NSString(string: strMain).range(of: "(300 characters)")
//            let rangeLarge = NSString(string: strMain).range(of: "The main complaint ")
//            let attributedSting = NSMutableAttributedString(string: strMain)
//            attributedSting.addAttributes([NSAttributedString.Key.font: CustomFont.NexaRegular.returnFont(10), NSAttributedString.Key.foregroundColor:colors.black.value], range: rangeSmall)
//            attributedSting.addAttributes([NSAttributedString.Key.font: CustomFont.NexaRegular.returnFont(14), NSAttributedString.Key.foregroundColor: colors.black.value], range: rangeLarge)
//            self.attributedPlaceholder = attributedSting
//        } else {
            //self.layer.cornerRadius = self.frame.height / 2
           // self.clipsToBounds = true
            self.minHeight = 98
            self.textContainerInset = UIEdgeInsets(top: 13, left: 13, bottom: 16, right: 13)
        //}
    }
}
