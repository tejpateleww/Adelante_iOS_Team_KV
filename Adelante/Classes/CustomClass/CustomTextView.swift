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
