//
//  UITextField+Extension.swift
//  CoreSound
//
//  Created by EWW083 on 03/02/20.
//  Copyright © 2020 EWW083. All rights reserved.
//

import UIKit
extension UITextField{
    //MARK:- Placeholder Color
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    func setBoarderColor(bcolor:colors){
        self.layer.borderColor  = bcolor.value.cgColor
        self.layer.borderWidth = 1
    }
    
    func validatedText(validationType: ValidatorType) -> (Bool,String) {
          let validator = VaildatorFactory.validatorFor(type: validationType)
          return validator.validated(self.text!)
      }
}
