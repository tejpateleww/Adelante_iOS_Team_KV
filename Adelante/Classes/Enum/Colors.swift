//
//  Colors.swift
//  CoreSound
//
//  Created by EWW083 on 04/02/20.
//  Copyright © 2020 EWW083. All rights reserved.
//

import Foundation
import  UIKit

enum colors{
    case white, black, red, appOrangeColor, appGreenColor, appRedColor, badgeColor, segmentSelectedColor, segmentDeselectedColor, searchBarBg, submitButtonShadow, textFieldColor, myLocTitleHome, myLocValueHome, selectedFilterBtn, normalFilterBtn, clearCol, forgotpassGreyColor, seperatorColor, darkSeperatorColor
    
    var value:UIColor{
        switch self {
        case .white:
            return UIColor.white
        case .black:
            return UIColor.black
        case .red:
            return UIColor.red
        case .appOrangeColor:
            return UIColor(hexString: "#E34A25")
        case .appGreenColor:
            return UIColor(hexString: "#209413")
        case .badgeColor:
            return UIColor(hexString: "#DFB23C")
        case .segmentSelectedColor:
            return UIColor(hexString: "#D3D8DF")
        case .segmentDeselectedColor:
            return UIColor(hexString: "#F3F5F9")
        case .searchBarBg:
            return UIColor(hexString: "#CFD5E5")
        case .submitButtonShadow:
            return UIColor(hexString: "#3E1F43")
        case .textFieldColor:
            return UIColor(hexString: "#9597A8")
        case .myLocTitleHome:
            return UIColor(hexString: "#697782")
        case .myLocValueHome:
            return UIColor(hexString: "#353535")
        case .selectedFilterBtn:
            return UIColor(hexString: "#D3D8DF")
        case .normalFilterBtn:
            return UIColor(hexString: "#F3F5F9")
        case .clearCol:
            return UIColor.clear
        case .forgotpassGreyColor:
            return UIColor(hexString: "#9597A8")
        case .seperatorColor:
            return UIColor(hexString: "#707070").withAlphaComponent(0.08)
        case .appRedColor:
            return UIColor(hexString:"#FF172F")
        case .darkSeperatorColor:
            return colors.black.value
        }
    }
}

