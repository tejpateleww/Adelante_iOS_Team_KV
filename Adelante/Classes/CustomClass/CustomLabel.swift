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
            self.font = CustomFont.NexaRegular.returnFont(41)
            self.textAlignment = .left
            self.numberOfLines = 2
            self.lineBreakMode = .byTruncatingTail
        }
    }
}
