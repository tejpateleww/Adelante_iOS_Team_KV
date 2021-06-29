//
//  CustomSearchBar.swift
//  Adelante
//
//  Created by baps on 17/03/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift

class searchBarHome : UISearchBar {
    
    @IBInspectable var IsLocationSearchBar: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        if #available(iOS 13.0, *) {
                   // self.searchTextField.font = CustomFont.medium.returnFont(13)
                    self.searchTextField.backgroundColor = .clear
                } else {
                    for view in (self.subviews[0]).subviews {
                        if let textField = view as? UITextField {
                           // textField.font = CustomFont.medium.returnFont(13)
                           // textField.placeHolderColor = colors.white.value.withAlphaComponent(0.2)
                            textField.backgroundColor = .clear
                        }
                    }
                }
//        self.set(textColor: colors.blueTextColor.value.withAlphaComponent(0.2))
        
        self.backgroundImage = UIImage()
        self.backgroundColor = UIColor.white
        if IsLocationSearchBar{
            let lable = UILabel()
            lable.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width - 15, height: 1)
            lable.backgroundColor = .gray
            self.addSubview(lable)
            UISearchBar.appearance().searchTextPositionAdjustment = UIOffset(horizontal: -30, vertical: 0)
            if #available(iOS 13.0, *) {
                self.searchTextField.leftViewMode = UITextField.ViewMode.never
            } else {
                // Fallback on earlier versions
            }
            
        }
        else{
        
            self.setBorderColor(bcolor: colors.forgotpassGreyColor)
        }
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = colors.black.value.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 8.0)
//        self.layer.shadowOpacity = 0.16
//        self.layer.shadowRadius = 9.0
    }
}
