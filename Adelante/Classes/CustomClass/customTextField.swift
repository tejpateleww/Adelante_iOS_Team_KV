//
//  customTextField.swift
//  CoreSound
//
//  Created by EWW083 on 03/02/20.
//  Copyright © 2020 EWW083. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class addCarddetailsTextField : UITextField {
    override func awakeFromNib() {
       
        self.font = CustomFont.NexaRegular.returnFont(15)
        self.textColor = UIColor(hexString: "#222B45")
        self.textAlignment = .left
        
        
    }
}
class customTextField: UITextField {
    
    private let defaultUnderlineColor = UIColor.gray
    private let bottomLine = UIView()
    @IBInspectable var isSearchBar:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()

        borderStyle = .none
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = defaultUnderlineColor

        self.addSubview(bottomLine)
        bottomLine.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 1).isActive = true
        bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        if isSearchBar {
            self.font = CustomFont.NexaRegular.returnFont(15)
            bottomLine.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
                   bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                   bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                   bottomLine.heightAnchor.constraint(equalToConstant: 0).isActive = true
            //self.bottomLine.frame.size.height = 0
        }
    }

    public func setUnderlineColor(color: UIColor = .red) {
        bottomLine.backgroundColor = color
    }

    public func setDefaultUnderlineColor() {
        bottomLine.backgroundColor = defaultUnderlineColor
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
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))  // w:22, h: 22
                imageView.image = image
                imageView.tintColor = tintColor
                let view = UIView(frame : CGRect(x: 0, y: 0, width: 35, height: 22))
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
        
//        self.lineColor = colors.forgotpassGreyColor.value
//        self.titleColor = colors.textFieldColor.value
//
//        self.selectedTitleColor = colors.textFieldColor.value
//        self.selectedLineColor = colors.textFieldColor.value
//
//        self.textColor = colors.black.value
//        self.titleFormatter = { $0 }
        self.titleColor = colors.forgotpassGreyColor.value
        self.lineHeight = 0.0
        self.selectedLineHeight = 0.0
        self.selectedTitleColor = colors.forgotpassGreyColor.value
        self.lineColor = colors.forgotpassGreyColor.value
        self.selectedLineColor = colors.forgotpassGreyColor.value
        self.textColor = colors.textFieldColor.value
        self.titleFormatter = { $0 }
        
        self.titleFont = CustomFont.NexaRegular.returnFont(10)
        self.font = CustomFont.NexaRegular.returnFont(16)
        
        if isEditProfile {
            self.titleFont = CustomFont.NexaBold.returnFont(18)
            self.font = CustomFont.NexaRegular.returnFont(16)
        }
    }
}
