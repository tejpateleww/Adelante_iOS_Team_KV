//
//  customTextField.swift
//  CoreSound
//
//  Created by EWW083 on 03/02/20.
//  Copyright © 2020 EWW083. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class customTextField: UITextField {
    
    private let defaultUnderlineColor = UIColor.gray

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    //MARK:- LeftImage Set
    @IBInspectable var leftImage : UIImage? {
        didSet {
            if let image = leftImage{
                leftViewMode = .always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
                imageView.image = image
                imageView.tintColor = tintColor
                let view = UIView(frame : CGRect(x: 0, y: 0, width: 30, height: 22))
                view.addSubview(imageView)
                leftView = view
            }else {
                leftViewMode = .never
            }

        }
    }
    @IBInspectable var rightImage: UIImage? {
        didSet {
            if let image = rightImage {
                rightViewMode = .always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
                imageView.image = image
                imageView.tintColor = tintColor
                let view = UIView(frame : CGRect(x: 0, y: 0, width: 30, height: 22))
                view.addSubview(imageView)
                rightView = view
            }else{
                rightViewMode = .never
            }
        }
    }
    //MARK:- valid
    func valid(){
        self.textColor = .white
           //self.isValid = true
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
          // self.isHighlightedField = false
           self.layoutSubviews()
       }
       //MARK:- TextField Invalid
       func invalid(){
           //rightImage = #imageLiteral(resourceName: "invalid_field")
         
           textColor = UIColor.red
         //  self.isValid = false
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: colors.red.value])
          // isHighlightedField = true
           self.layoutSubviews()
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            self.textColor = .white
              // self.rightImage = nil
               //self.isValid = true
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
           //    self.isHighlightedField = false
               self.layoutSubviews()
           }
       }
}

class floatTextField: SkyFloatingLabelTextField {
    @IBInspectable var isEditProfile:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = CustomFont.NexaRegular.returnFont(16)
        self.selectedTitleColor = colors.titleColor.value
        self.lineColor = colors.textFieldColor.value
        self.lineHeight = 1.0
        if isEditProfile{
            self.selectedTitleColor = colors.titleColor.value
        }
    }
}
