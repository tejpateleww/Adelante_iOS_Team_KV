//
//  UILabel+Extension.swift
//  CoreSound
//
//  Created by EWW083 on 04/02/20.
//  Copyright © 2020 EWW083. All rights reserved.
//

import Foundation
import UIKit
extension UILabel{
    //MARK:- color font
   func setTitleColorFont(color:colors,font:UIFont){
    self.textColor = color.value
          self.font = font
      }
}
